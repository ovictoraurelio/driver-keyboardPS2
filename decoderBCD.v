module displayBCD(in, display);
	input [9:0] in;
	output reg [6:0] display;

	always @(*)
	begin
		case (in)
			10'd0: begin  display = 7'b1000000; end
			10'd1: begin  display = 7'b1111001; end
			10'd2: begin  display = 7'b0100100; end
			10'd3: begin  display = 7'b0110000; end
			10'd4: begin  display = 7'b0011001; end
			10'd5: begin  display = 7'b0010010; end
			10'd6: begin  display = 7'b0000010; end
			10'd7: begin  display = 7'b1111000; end
			10'd8: begin  display = 7'b0000000; end
			10'd9: begin  display = 7'b0010000; end
			10'd10: begin display = 7'b0000110; end // E
			10'd11: begin display = 7'b0101111; end // r
			10'd12: begin display = 7'b0100011; end // o
			10'd13: begin display = 7'b0111111; end // -
		endcase
	end
endmodule 


module decoderBCD(value, display0, display1, display2, display3);//uma das formas é adicionar mais argumentos para essa função...

	input [13:0] value;	
	output [6:0]display0;
	output [6:0]display1;
	output [6:0]display2;
	output [6:0]display3;
	
	
	reg [9:0] centena;
	reg [9:0] dezena;
	reg [9:0] unidade;
	reg [9:0] milhar;
	
	always@(*) begin
	
		unidade = value%10;
		dezena = ((value%100)-unidade)/10;
		centena = ((value%1000)-dezena)/100;
		milhar = ((value%10000)-centena)/1000;
		if(value == 14'd10002) begin
			unidade = 10'd12;
			dezena = 10'd11;
			centena = 10'd11;
			milhar = 10'd10;
		end
		if(value == 14'd10001) begin
			unidade = 10'd13;
			dezena = 10'd13;
		end
		
		/*unidade = (value%10);		
		dezena = ((value - unidade) / 10);				
		centena = ( (value - (value%100)) / 100);
		milhar = value / 1000;*/
	end
	
	displayBCD n0 (
		.in(unidade), 
		.display(display0)
	);
	
	displayBCD n1 (
		.in(dezena), 
		.display(display1)
	);
	
	displayBCD n2 (
		.in(centena), 
		.display(display2)
	);
	
	
	displayBCD n3 (
		.in(milhar), 
		.display(display3)
	);	
endmodule 