module mute_convol(clk,reset,ain,bin,aout,bout,cout_image,memory_turn);
   input clk,reset,memory_turn;                       // clk reset mode process_turn
   input [15:0] ain,bin;                        // 들어오는 숫자
   output [15:0] aout,bout;                     // 들어온 신호를 그대로 옆으로 가져다 주는것
   output [31:0] cout_image;     

   wire signed [15:0] ain, bin;                 // 들어온 input 그대로 넘겨주는 wire
   reg signed [15:0]  aout, bout;               // 그 다음으로 보내줄 out 저장 register
   reg signed [31:0]  cout_image;
   wire 	      reset_one_cycle;
   reg [16:0] 	      counter;       //


   assign rest_one_cycle = (memory_turn ==0)? 1:0;



   always@ (posedge clk)
     begin
	if (reset)
	  begin
	     cout_image <= 0;
	     aout <= 0;
	     bout <= 0;
	     counter <= 0;             //
	  end

	else
	  begin
	     if(rest_one_cycle == 1);
	     else
	       begin
		  #1 aout = ain;
		  bout = bin;
		  cout_image = ain*bin;        
		  counter = counter+1;
	       end // else: !if(reset)
	  end // always@ (posedge clk1)
     end // always@ (posedge clk)

   
endmodule // poject_module


	     

	
	
	
