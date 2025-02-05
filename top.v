`timescale 1 ns / 1 ps
	

module top(
    input clk,
    input rx,
    inout btnc,
    inout btnu,
    inout btnd,
    inout btnr,
    inout btnl,
    inout [15:0] sw,
    output tx,
    inout [15:0] led,
    inout [7:0]sevenseg,
    inout [3:0] anode
);
    parameter integer MEM_WORDS = 1024;
    parameter [31:0] STACKADDR = (4*MEM_WORDS);       // end of memory
    reg ram_ready = 0;
    reg [7:0] rst_cnt = 0;
    wire mem_valid;
    wire mem_instr;
    wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;
    wire [31:0] ram_rdata;
    wire [31:0] uart1_rdata;
    wire [31:0] rng1_rdata;
    wire [31:0] gpio1_rdata;
    wire rng1_ready;
    wire rng1_valid;
    wire gpio1_ready;
    wire gpio1_valid;
    wire uart1_ready;
    wire uart1_valid;
    wire rst;
    wire p1_ready;
    wire p1_valid;
    wire [31:0] p1_rdata;
    wire clk2;
    //wire irq;

    //assign irq = btnc;
    assign rst = &rst_cnt;
    assign p1_valid = mem_valid;
    assign uart1_valid = mem_valid;
    assign rng1_valid = mem_valid;
    assign gpio1_valid = mem_valid;

    assign mem_ready = p1_ready || ram_ready || uart1_ready || rng1_ready || gpio1_ready;
    assign mem_rdata = (p1_valid && p1_ready) ? p1_rdata : (uart1_valid && uart1_ready) ? uart1_rdata : (rng1_valid && rng1_ready) ? rng1_rdata : (gpio1_valid && gpio1_ready) ? gpio1_rdata : ram_ready ? ram_rdata : 32'h 0000_0000;

    always @(posedge clk)
	//rst_cnt <= {rst_cnt[6:0], 1'b1};
	rst_cnt <= {rst_cnt[6:0], !btnc};

    always @(posedge clk)
	ram_ready <= mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS;

    always@(posedge clk)
	if (ram_ready) $display("[0x%x] = 0x%x", mem_addr, mem_rdata);

    picorv32 #(
	.STACKADDR(STACKADDR),
	//.PROGADDR_RESET(PROGADDR_RESET),
	//.PROGADDR_IRQ(PROGADDR_IRQ),
	//.BARREL_SHIFTER(BARREL_SHIFTER),
	.COMPRESSED_ISA(1),
	//.ENABLE_COUNTERS(ENABLE_COUNTERS),
	//.ENABLE_MUL(ENABLE_MUL),
	//.ENABLE_DIV(ENABLE_DIV),
	//.ENABLE_FAST_MUL(ENABLE_FAST_MUL),
	.ENABLE_IRQ(1),
	.ENABLE_IRQ_QREGS(1),
	.PROGADDR_RESET(32'h0000_0f00)
	) core1 (
	    .clk(clk),
	    .resetn(rst),
	    .mem_valid(mem_valid),
	    .mem_instr(mem_instr),
	    .mem_ready(mem_ready),
	    .mem_addr(mem_addr),
	    .mem_wdata(mem_wdata),
	    .mem_wstrb(mem_wstrb),
	    //.irq({irq, 3'b0}),
	    .mem_rdata(mem_rdata)
    );

    picosoc_mem mem1 (
	.clk(clk),
	.wen((mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS) ? mem_wstrb : 4'b0),
	.addr(mem_addr[23:2]),
	.wdata(mem_wdata),
	.rdata(ram_rdata)
    );

    test_periph p1(
	.clk(clk),
	.addr(mem_addr),
	.wdata(mem_wdata),
	.rdata(p1_rdata),
	.valid(mem_valid),
	.wen(mem_wstrb),
	.rdy(p1_ready)
    );	

    uart_periph uart1(
	.clk(clk),
	.addr(mem_addr),
	.wdata(mem_wdata),
	.rdata(uart1_rdata),
	.valid(mem_valid),
	.wen(mem_wstrb),
	.rdy(uart1_ready),
    .tx(tx),
    .rx(rx)
    );	

    rng_periph rng1(
	.clk(clk),
	.clk2(clk2),
	.addr(mem_addr),
	.wdata(mem_wdata),
	.rdata(rng1_rdata),
	.valid(mem_valid),
	.wen(mem_wstrb),
	.rdy(rng1_ready)
    );	

    gpio_periph gpio1(
	.clk(clk),
	.port0({sw, led}),
	.port1({sevenseg, anode, btnc, btnu, btnr, btnl, btnd}),
	.addr(mem_addr),
	.wdata(mem_wdata),
	.rdata(gpio1_rdata),
	.valid(mem_valid),
	.wen(mem_wstrb),
	.rdy(gpio1_ready)
    );	
	
    pll pll1 (
	.clk(clk),
	.clk_out(clk2)
    );

endmodule

/*
     GPIO 

     DATA0 R/W 0x0300 3000
     DATA1 R/W 0x0300 3004
     PIN0  R   0x0300 3010
     PIN1  R   0x0300 3014
     DIR0  R/W 0x0300 3030
     DIR1  R/W 0x0300 3034
 */

module gpio_periph(
    input clk,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata,
    input valid,
    input [3:0] wen,
    output rdy,
    inout [31:0] port0,
    inout [31:0] port1
);
    reg [31:0] data[0:1];
    reg [31:0] dir[0:1];
    
    reg en = 0;
    reg[31:0] rdata1 = 0;
    reg rdy1 = 0;

    wire [31:0] pin[0:1];

    initial begin
        data[0] = 0;
        data[1] = 0;
        dir[0] = 0;
        dir[1] = 0;
    end

    assign rdy = rdy1;
    assign rdata = rdata1;

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin
        assign port0[i] = dir[0][i] ? data[0][i] : 1'bZ;
        assign port1[i] = dir[1][i] ? data[1][i] : 1'bZ;
    end
    endgenerate


    assign pin[0] = port0;
    assign pin[1] = port1;

	always @(posedge clk) begin
	    rdy1 <= 0;
	    if (valid && !rdy && addr[31:4] == 28'h0300_300) begin
		    rdy1 <= 1;
		    if (wen[0]) data[addr[2]][7: 0] <= wdata[ 7: 0];
		    if (wen[1]) data[addr[2]][15: 8] <= wdata[15: 8];
		    if (wen[2]) data[addr[2]][23: 16] <= wdata[23: 16];
		    if (wen[3]) data[addr[2]][31: 24] <= wdata[31: 24];
		    rdata1 <= data[addr[2]];
	    end
	    if (valid && !rdy && addr[31:4] == 28'h0300_303) begin
		    rdy1 <= 1;
		    if (wen[0]) dir[addr[2]][7: 0] <= wdata[ 7: 0];
		    if (wen[1]) dir[addr[2]][15: 8] <= wdata[15: 8];
		    if (wen[2]) dir[addr[2]][23: 16] <= wdata[23: 16];
		    if (wen[3]) dir[addr[2]][31: 24] <= wdata[31: 24];
		    rdata1 <= dir[addr[2]];
	    end
	    if (valid && !rdy && addr[31:4] == 28'h0300_301) begin
            rdy1 <= 1;
            rdata1 <= pin[addr[2]];
        end
    end
    endmodule

    /* register map for RNG peripheral

    * 0x0300 2000 [7:0]  RNG_OUT
    * 0x0300 2004 [7:0]  STATUS
    *   bit 0 data ready
    * 0x0300 2004 [7:0]  CTRL
    *	bit 0 enable
    */

   module rng_periph(
       input clk,
       input clk2,
       input [31:0] addr,
       input [31:0] wdata,
       output [31:0] rdata,
       input valid,
       input [3:0] wen,
       output rdy
       //output tx,
       //input rx
   );
   wire [7:0] rng_data;
   wire rng_rdy;

   reg en = 0;
   reg clr_flags = 0;
   reg[31:0] rdata1 = 0;
   reg rdy1 = 0;

   assign rdy = rdy1;
   assign rdata = rdata1;

   always @(posedge clk) begin
       rdy1 <= 0;
       clr_flags <= 0;
       if (valid && !rdy && addr[31:0] == 32'h0300_2000) begin
           rdy1 <= 1;
           rdata1 <= {24'h000000, rng_data};
           clr_flags <= 1;
           if (wen == 0) $display("read [0x0300_2000] = 0x%x", rng_data);
       end
   if (valid && !rdy && addr[31:0] == 32'h0300_2004) begin
       rdy1 <= 1;
       rdata1 <= {28'h0000000, 3'b000, rng_rdy};
       if (wen == 0) $display("read [0x0300_2004] = 0x%x", rng_rdy);
   end
        if (valid && !rdy && addr[31:0] == 32'h0300_2008) begin
            if (wen == 4'hf) begin
                en <= wdata[0];
                $display("write [0x0300_2008] = 0x%x", wdata);
            end
            rdy1 <= 1;
            rdata1 <= {28'h0000000, 3'b000, en};
            if (wen == 0) $display("read [0x0300_2008] = 0x%x", en);
        end
end

`ifdef SIM
    trng #(.DEC_LEN(3)) trng1 (
`else
        trng #(.DEC_LEN(12)) trng1 (
`endif
        .clk(clk),
            .clk2(clk2),
            .en(en),
            .clr(clr_flags),
            .out(rng_data),
            .rdy(rng_rdy)
        );

endmodule

        /* register map for UART

        * 0x0300 1000 [7:0]  TX_DATA
        * 0x0300 1004 [7:0]  RX_DATA
        * 0x0300 1008 [11:0] CTRL
        * 0x0300 100c [2:0]  STATUS
        *   bit 2 overflow
        *   bit 1 data ready
        *   bit 0 busy
        */

       module uart_periph(
           input clk,
           input [31:0] addr,
           input [31:0] wdata,
           output [31:0] rdata,
           input valid,
           input [3:0] wen,
           output rdy,
           output tx,
           input rx
       );
       wire[7:0] rx_data;
       wire[31:0] status;

       reg start = 0;
       reg clr_flags = 0;
       reg[31:0] rdata1 = 0;
       reg[7:0] reg_tx_data = 0;
       reg[31:0] reg_ctrl = 0;
       reg rdy1 = 0;

       assign rdy = rdy1;
       assign rdata = rdata1;

       always @(posedge clk) begin
           rdy1 <= 0;
           start <= 0;
           clr_flags <= 0;
           if (valid && !rdy && addr[31:0] == 32'h0300_1000) begin
               if (wen == 4'hf) begin
                   reg_tx_data <= wdata[7:0];
                   start <= 1;
                   $display("write [0x0300_1000] = 0x%x", wdata);
               end
               rdy1 <= 1;
               rdata1 <= {24'h000000, reg_tx_data[7:0]};
               if (wen == 0) $display("read [0x0300_1000] = 0x%x", reg_tx_data);
           end
       else if (valid && !rdy && addr[31:0] == 32'h0300_1004) begin
           rdy1 <= 1;
           rdata1 <= {24'h000000, rx_data};
           clr_flags <= 1;
           $display("read [0x0300_1004] = value 0x%x", rx_data);
       end
       else if (valid && !rdy && addr[31:0] == 32'h0300_1008) begin
           if (wen == 4'hf) begin
               reg_ctrl <= wdata;
               $display("write [0x0300_1008] = 0x%x", wdata);
           end
           rdy1 <= 1;
           rdata1 <= {20'h00000, reg_ctrl[11:0]};
           if (wen == 0) $display("read [0x0300_1008] = 0x%x", reg_ctrl);
       end
   else if (valid && !rdy && addr[31:0] == 32'h0300_100c) begin
       rdy1 <= 1;
       rdata1 <= status;
       $display("read [0x0300_100c] = 0x%x", status);
   end
    end

    uart uart1 (
        .clk(clk),
        .tx(reg_tx_data),
        .ctrl(reg_ctrl),
        //.ctrl        (32'd868     ), /* 115200 @ 100 MHz */
        //.ctrl        (32'd110     ), /* 912600 @ 100 MHz */
        .rx(rx_data),
        .status(status),
        .pin_rx(rx),
        .start(start),
        .clear_flags(clr_flags),
        .pin_tx(tx)
    );

    endmodule

    module test_periph(
        input clk,
        input [31:0] addr,
        input [31:0] wdata,
        output [31:0] rdata,
        input valid,
        input [3:0] wen,
        output rdy,
        output led
    );

    reg rdy1 = 0;
    reg [31:0] rdata1 = 0;
    reg [31:0] reg0 = 0;
    reg [31:0] reg1 = 0;

    assign rdy = rdy1;
    assign rdata = rdata1;
    assign led = reg1[31];

    always @(posedge clk) begin
        rdy1 <= 0;
        if (valid && !rdy && addr[31:0] == 32'h0300_0004) begin
            if (wen == 4'hf) begin
                reg0 <= wdata;
                $display("write [0x0300_0004] = 0x%x", wdata);
                if (wdata == 32'h000000aa) $finish;
            end
        rdy1 <= 1;
        `ifdef SIM
            rdata1 <= {reg0[31:1], 1'b1};
            if (wen == 0) $display("read [0x0300_0004] = 0x%x", {reg0[31:1],1'b1});
        `else
    rdata1 <= {reg0[31:1], 1'b0};
    if (wen == 0) $display("read [0x0300_0004] = 0x%x", {reg0[31:01], 1'b0});
`endif
    end

    if (valid && !rdy && addr[31:0] == 32'h0300_0008) begin
        if (wen == 4'hf) begin
            reg1 <= wdata;
            $display("write [0x0300_0008] = 0x%x (%d)", wdata, wdata);
        end
        rdy1 <= 1;
        rdata1 <= reg1;
        if (wen == 0) $display("read [0x0300_0008] = 0x%x", reg1);
    end
    end
    endmodule


    module picosoc_mem #(
        parameter integer WORDS = 1024
    ) (
        input clk,
        input [3:0] wen,
        input [21:0] addr,
        input [31:0] wdata,
        output reg [31:0] rdata
    );
    reg [31:0] mem [0:WORDS-1];

    //    `ifdef SIM
    initial begin
        $readmemh("progmem.mem", mem);
    end
    //  `endif

    always @(posedge clk) begin
        rdata <= mem[addr];
        if (wen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
        if (wen[1]) mem[addr][15: 8] <= wdata[15: 8];
        if (wen[2]) mem[addr][23:16] <= wdata[23:16];
        if (wen[3]) mem[addr][31:24] <= wdata[31:24];
    end
endmodule



