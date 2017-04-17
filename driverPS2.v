module driverPS2(clk_board, data, instruction, clk, new_instruction, ready);
	input clk_board, data, clk, ready;
	output reg [1:0]instruction;
	output reg new_instruction;
		
	reg start, stop, parity;
	reg [3:0] counter;
	reg [4:0] counter2;
	reg [4:0] counter3;
	reg [7:0] bte;
	reg [31:0] queue;
	
	initial 
	begin	
		new_instruction = 0;
		instruction = 2'b000; 
		stop = 0; 
		start = data; 
		counter = 0; 
		counter2 = 0; 
		counter3 = 0;
	end
		
	always @(posedge clk_board)
	begin

		if(start) 
			start = data; 
		
		if(!start) 
		begin
			
			counter = counter + 1;
			
			if(counter < 10 && counter > 1) 
			begin
				bte[counter - 2] = data;
			end
			
			if(counter == 10) 
			begin
				parity = data;
			end
			
			if(counter > 10) 
			begin			
				if(counter2 == 32 && !new_instruction) 
					counter2 = 0;	
					
				start = data; 
				counter = 0; 
				stop = 1; 
				
				if(counter2 != 32)
				begin
				
					case(bte) 
						
						8'h66: //clear (DELETE)
						begin
							queue[counter2] = 0;
							queue[counter2 + 1] = 0;
							
							counter2 = counter2 + 2;
						end
						
						8'h79: //sum (+)
						begin						
							queue[counter2] = 1;
							queue[counter2 + 1] = 0;
							
							counter2 = counter2 + 2; 
						end
						
						8'h5A: //disp (ENTER)
						begin
							queue[counter2] = 0;
							queue[counter2 + 1] = 1;
							
							counter2 = counter2 + 2; 
						end	
						
						8'h29: //load (BACKSPACE)	
						begin
							queue[counter2] = 1;
							queue[counter2 + 1] = 1;
							
							counter2 = counter2 + 2; 			
						end
						
					endcase
											
				end
					
			end		
		end	
	end
	
	always @(posedge clk) //enviar instru??o
	begin
	
		if(counter3 != counter2) //tem algo para receber
		begin
		
			new_instruction = 1;
			
			if(ready) //pode receber
			begin
			
				instruction[0] = queue[counter3];
				instruction[1] = queue[counter3 + 1];
				
				counter3 = counter3 + 2;
				
				if(counter3 == 32)	counter3 = 0;
			end
		
		end

		if(counter3 == counter2)
			new_instruction = 0;
		
	end

endmodule
