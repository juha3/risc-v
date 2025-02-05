`timescale 1ns / 1ps

module testbench_top;

	// Inputs
	reg clk;
	reg rst;
	reg pin_rx;

	wire led;
	wire pin_tx;
	reg [7:0] byte;

	top uut (
        .clk(clk),
        .led(led),
        //.rst(!rst),
        .tx(pin_tx),
        .rx(pin_rx)
    );

    //parameter clock_period = 83.3333;
    parameter clock_period = 10;
    reg[31:0] app[0:256];

	initial begin
		$readmemh("progmem2.mem", app);
    end

    initial begin
        clk = 0;
        rst = 1;
        pin_rx = 1;

        // Wait 100 ns for global reset to finish
        #100;
        // Add stimulus here
        rst = 0;
        #5000;


        #11800000;
        $display("done.");
        $finish;
    end

    initial begin
        forever #(clock_period/2) clk = (clk == 1) ? 0 : 1;
    end

    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0, testbench_top);
    end

    task send_and_wait;
        input [7:0] b;
        begin
            byte = 0;
            $display("sending byte 0x%x", b);
            uart_send_byte(b);
            wait(byte == b);
            #100;
        end
    endtask

    task uart_send_byte;
        input [7:0] byte;
        reg [3:0] i;
        begin
            @(negedge clk);
            #1311;

            /* start bit */
            pin_rx = 0;
            #8681;
            for (i = 0; i < 8; i = i + 1)
            begin
                pin_rx = byte[i];
                $display("bit %d : %d", i, pin_rx);
                #8681;
            end
            /* stop bit */
            pin_rx = 1;
            #8681;

        end
    endtask
    integer i;

    reg [7:0] temp_byte;
    /* uart receiver (115200 bps) */
    initial forever begin
        $display("waiting for byte...");
        @(negedge pin_tx)
    #4340; /* half bit */
    if (pin_tx == 0) begin
        for (i = 0; i < 9; i++) begin
            #8681; /* full bit */
            temp_byte[i] = pin_tx;
        end
        //#8681;
        //i=10;
        if (pin_tx == 0)
            $display("frame error");
        else begin
            byte = temp_byte;
            $display("UART: received byte %x", byte);
        end

    end

end		

endmodule


