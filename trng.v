/*

	entropy extractor

	      +----+       +---+
	------| xor|-------|D Q|-+-----------
	   +--|    |     +-|>  | |
	   |  +----+     | +---+ |
	   |             |       |
	   +-------------|-------+
                     |


	- current output is (odd) parity bit of all previous bits

	always@(posedge clk)
		out <= out ^ in;

	de-biaser


	input | output 
	------|------------
	 00   |  -
	 01   |  0
	 10   |  1
	 11   |  -

	- if 1 is not equally likely as 0, there is bias in random data.
	- de-biaser fixes this because 01 is as equal as 10. (ie. 0.9 * 0.1 == 0.1 * 0.9)


	    +--------+
	    | +---+  |     +---+         +---+
	    +-|D Q|--+-----| & |---+   +-|D Q|----
	   +--|>  |     +--|   |   |   | |>  |
	   |  +---+     |  +---+   +---|-|E  |
	   |            |              | +---+
	   |            +-----------+  |
	                            |  |
	   +-------------+          |  |
	   |  +---+      |  +---+   |  |
	 --+--|D Q|--+   +--|xor|---+  |
	    +-|>  |  +---+--|   |      |
	    | +---+      |  +---+      |
	                 |             |
	                 +-------------+

	always@(posedge clk)
		en <= !en;
	always@(posedge clk)
		in2 <= in;
 
	always@(posedge clk)
		if (en & (in ^ in2))
			out <= in2];

	=========================================================================

	PLL-based true random generator for FPGAs

	Random numbers are collected from phase noise of PLL block.
	
	Randomness is extracted by using two rationally related clock signals.
	Every once in a while clock edges align so that jitter of PLL output frequency
	causes sampled bit to be random

	       v
	       |
	       | clk1 (12 MHz)
	   +---------+
	   |  PLL    |
	   +---------+
	       |
	       | clk2 (47.25 MHz)
		   |
	       |     +------+    +-----+   +-----------+   +------------+
	       +---->|      |--->|     |-->|           |-->|   von      |
	             | DFF  |    | DFF |   |   XOR     |   |  Neumann   |--> random bits
	           +-|>     |  +-|>    |   | decimator |   | randomness |
	           | +------+  | +-----+   |           |   | extractor  |
	           |           |           +-----------+   +------------+
        clk1   |           |                 |                |
	   --------+-----------+-----------------+----------------+

	parameter DEC_LEN adjusts decimation coefficient. Default is 1:128, 
	which means that 128 samples are fed to XOR decimator for one output bit.
	Decimator is XORing new input with old output and effectively calculating 
	parity (has there been even or odd amount of ones)

	Von Neumann randomness extractor extracts uniformly random bits and
	outputs 

	Output rate 
	
		12 MHz / (128 * 2 * 8) = ~5.8 kbytes / s

*/


module trng # (
	parameter DEC_LEN = 15,
	parameter DEC_MATCH = ((1 << DEC_LEN) - 1)) (
	input clk,
	input clk2,
	input en,
	input clr,
	output reg [7:0] out = 0,
	output rdy
);
//	wire clk2;
//	reg x1 = 0;
	reg [1:0] x2 = 0;
	reg x3 = 0;
	reg [1:0] x4 = 0;
	reg [2:0] cnt1 = 0;
	reg [DEC_LEN - 1:0] cnt2 = 0;	
	reg bit_rdy = 0;
	reg ext_rdy = 0;
	reg dec_rdy = 0;
	reg [2:0] cnt3 = 0;

	//assign out = x4[0];
	assign rdy = cnt3 == 7;

	always@(posedge clk)
		cnt2 <= cnt2 + 1;

//	/* square wave clocked by jittery clk2 */
//	always@(posedge clk2)
//		x1 <= x1 ? 0 : 1;

	/* synchronizer to catch metastable bits */
	always@(posedge clk)
		x2 <= {x2[0], clk2};
	
	/* XOR decimator calculates amount of ones (parity) */
	always@(posedge clk)
		x3 <= x3 ^ x2[1];

	/* von Neumann randomness extractor removes possible bias
		00 => no output
		01 => 0
		10 => 1
		11 => no output
	*/

	always@(posedge clk) begin
		dec_rdy <= 1'b0;
		if (cnt2[DEC_LEN - 1:0] == DEC_MATCH) begin
			x4 <= {x4[0], x3};
			dec_rdy <= 1'b1;
		end
	end
	
	always@(posedge clk) begin 
		if (dec_rdy)
			ext_rdy <= ext_rdy ? 1'b0 : 1'b1;
	end

	always@(posedge clk) begin
		bit_rdy <= 1'b0;
		if ((dec_rdy & ext_rdy) && (x4[0] ^ x4[1]))
			bit_rdy <= 1'b1;		
	end
				
	always@(posedge clk) begin
		if (bit_rdy && cnt3 != 7)
			out <= {out[6:0], x4[0]}; 
	end

	always@(posedge clk) begin
		if (clr)
			cnt3 <= 0;
		else if (bit_rdy && cnt3 != 7)
			cnt3 <= cnt3 + 1;
	end


	
endmodule




