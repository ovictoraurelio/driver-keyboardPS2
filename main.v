`include "driverPS2.v"
`include "decoderBCD.v"

module main(clk_keyboard, data, clk, instruction, new_instruction, entrada, bcdX0,bcdX1,bcdY0,bcdY1,dontInUSE,dontInUSE2,bcdZ0,bcdZ1,bcdZ2,bcdZ3);

	input clk_keyboard;
	input data;
	input clk;	
	input [6:0] entrada;

	output [1:0] instruction;
	output new_instruction;	
	
	output [6:0]bcdX0;
	output [6:0]bcdX1;
	output [6:0]dontInUSE;
	output [6:0]dontInUSE2;
	output [6:0]bcdY0;
	output [6:0]bcdY1;
	output [6:0]bcdZ0;
	output [6:0]bcdZ1;
	output [6:0]bcdZ2;
	output [6:0]bcdZ3;

	reg ready;
	reg [9:0]x;
	reg [13:0]y;
	reg [13:0]z;
	reg [31:0]c;
	
	initial begin
		x = 10'd0;
		y = 14'd0;
		z = 14'd0;
		c = 32'd0;
		ready = 1'b1;
	end
		
	always @(posedge clk_keyboard) 
		begin	
				
				//if(new_instruction) y = 14'd7;
			
				ready = 1'b1;
				
				case(instruction)
					2'b000:
						begin			
							x = 10'd0;
							y = 14'd0;
							z = 14'd0;
						end
					2'b001:
						begin
							if(y < 14'd10000) begin
								y = y + x;
								z = y; // for testing
							end else begin
								y = 14'd10001;
								z = 14'd10002;
							end
						end
					2'b010:
						begin						
							//z = y;
						end
					2'b011:
						begin
							x = entrada;
						end
				endcase				
						
		end

	decoderBCD DecoderX (
		.value(x),
		.display0(bcdX0),
		.display1(bcdX1),
		.display2(null),.display3(null)
	);
	
	/* y > 14'd99 ? 14'd0 : y */
	
	decoderBCD DecoderY (
		.value(y),
		.display0 (bcdY0),
		.display1(bcdY1),
		.display2(null),.display3(null)
	);
	
	
	decoderBCD DecoderZ (
		.value(z),
		.display0 (bcdZ0),
		.display1(bcdZ1),
		.display2(bcdZ2),
		.display3(bcdZ3)
	);
	/* clk_board, data, instruction, clk, new_instruction, ready */
	driverPS2 driver(
		.clk_board (clk_keyboard),
		.data (data),
		.instruction (instruction),
		.clk (clk),
		.new_instruction (new_instruction),
		.ready (ready)
	);


endmodule 