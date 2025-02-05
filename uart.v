`timescale 1ns / 1ps

module uart(
	input clk,
	input [7:0] tx,
	input [31:0] ctrl,
	output reg [7:0] rx,
	output [31:0] status,
	input pin_rx,
	input start,
	input clear_flags,
	output pin_tx
);

	/* receiver */
	reg [11:0] div1 = 0;
	reg [3:0] s_rx = 0;
	reg [4:0] state = 0;
	reg [9:0] rx_bits = 0;
	reg data_rdy = 0;
	reg overflow = 0;

	reg rd_strobe = 0;

	wire hflag;

	assign hflag = div1 == ctrl[10:1];
	//assign rx = rx_bits[8:1];

	assign status = {28'h0, 1'b0, overflow, data_rdy, busy};

	initial rx = 0;

	always@(posedge clk) begin
		rd_strobe <= 0;
		if (state == 19 && hflag)
			rd_strobe <= 1;
	end
	always@(posedge clk)
		if (rd_strobe)
			rx <= rx_bits[8:1];

	/* synchronizer */
	always@(posedge clk)
		s_rx <= {s_rx[2:0], pin_rx};

	always@(posedge clk) begin
		if (clear_flags) begin
			data_rdy <= 0;
			overflow <= 0;
		end
		else if (state == 19 && hflag) begin
			if (data_rdy) overflow <= 1;
			data_rdy <= 1;
		end
	end

	always@(posedge clk)
		if (state == 0 || hflag)
			div1 <= 0;
		else
			div1 <= div1 + 1;

	always@(posedge clk)
		if (state[0] && hflag)
			rx_bits <= {s_rx[3], rx_bits[9:1]};

	always@(posedge clk)
	case(state)
		0: if (s_rx[3] && !s_rx[2]) state <= 1;
		1: if (hflag) state <= 2;
		2: if (hflag) state <= 3;
		3: if (hflag) state <= 4;
		4: if (hflag) state <= 5;
		5: if (hflag) state <= 6;
		6: if (hflag) state <= 7;
		7: if (hflag) state <= 8;
		8: if (hflag) state <= 9;
		9: if (hflag) state <= 10;
		10: if (hflag) state <= 11;
		11: if (hflag) state <= 12;
		12: if (hflag) state <= 13;
		13: if (hflag) state <= 14;
		14: if (hflag) state <= 15;
		15: if (hflag) state <= 16;
		16: if (hflag) state <= 17;
		17: if (hflag) state <= 18;
		18: if (hflag) state <= 19;
		19: if (hflag) state <= 0; //20;
		//20: if (hflag) state <= 0;
		default: state <= 0;
	endcase



	/* transmiter */
	wire bit_flag;
	assign bit_flag = div2 == ctrl[10:0];
	assign pin_tx = busy ? tx_byte[0] : 1'b1;

	reg [11:0] div2 = 0;
	reg tx_en = 0;
	reg [3:0] state2 = 0;
	reg [9:0] tx_byte = 0;
	reg busy = 0;

	always@(posedge clk)
		if (state2 == 0 || bit_flag)
			div2 <= 0;
		else
			div2 <= div2 + 1;

	always@(posedge clk)
	case(state2)
		0: if (start) state2 <= 1;
		1: if (bit_flag) state2 <= 2;
		2: if (bit_flag) state2 <= 3;
		3: if (bit_flag) state2 <= 4;
		4: if (bit_flag) state2 <= 5;
		5: if (bit_flag) state2 <= 6;
		6: if (bit_flag) state2 <= 7;
		7: if (bit_flag) state2 <= 8;
		8: if (bit_flag) state2 <= 9;
		9: if (bit_flag) state2 <= 10;
		10: if (bit_flag) state2 <= 0;
		default: state2 <= 0;
	endcase

	always@(posedge clk) begin
		if (start)
			busy <= 1;
		if (state2 == 10 && bit_flag)
			busy <= 0;
	end

	always@(posedge clk) begin
		if (start)
				tx_byte <= {1'b1, tx, 1'b0};
		else if (bit_flag)
			tx_byte <= {1'b1, tx_byte[9:1]};

	end

endmodule

