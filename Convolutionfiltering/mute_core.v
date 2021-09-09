module mute_core(clk, reset, bicount, memory_turn, core_turn,row,column);

   input clk, reset, memory_turn;
   input [16:0] row,column;
   output reg core_turn;
   inout [127:0] bicount;
   wire [127:0]  out;
   wire [127:0]  in;
   wire 	 memory_turn;
   reg [127:0] 	 bi_out;
   reg [15:0] 	 counter;
   reg [8:0] 	 change_row;
   reg [8:0] 	 over;          
   reg [15:0] 	 ain1,ain2,ain3,ain4,ain5,bin1,bin2,bin3,bin4,bin5;
   wire signed [31:0] c_out;
   
   mute_acc i10(clk,reset,ain1,ain2,ain3,ain4,ain5,bin1,bin2,bin3,bin4,bin5,memory_turn,c_out);
   reg 		      rest_one_cycle;
   
   assign bicount = (memory_turn == 0)? out:128'bz;      // mute_memory와 같은 방식으로 동작한다.
   assign in = (memory_turn == 1)? bicount:128'bz;
   assign out = bi_out;


   always@ (posedge clk or posedge reset)
     begin
	if (reset)
	  begin
	     bi_out <= 0;
	     counter <= 0;
	     ain1 <= 0;
	     ain2 <= 0;
	     ain3 <= 0;
	     ain4 <= 0;
	     ain5 <= 0;
	     bin1 <= 0;
	     bin2 <= 0;
	     bin3 <= 0;
	     bin4 <= 0;
	     bin5 <= 0;
	     core_turn <= 0;
	     change_row <= 0;
	     over <= 1;                
	     rest_one_cycle <= 1;
	  end
	else
	  begin		  
	     if(over != (row-3))             
	       begin
		  if(counter < 7)       //5clk동안 filter를 만들어 준다.
		    begin
		       bin5 = in[15:0];
		       bin4 = in[31:16];
		       bin3 = in[47:32];
		       bin2 = in[63:48];
		       bin1 = in[79:64];
		    end
		  else     // filter완성하면
		    begin
		       if(rest_one_cycle == 1)
			 begin
			    rest_one_cycle = 0;
			 end
		       else
			 begin
			    core_turn = 0;
			    ain5 = in[15:0];
			    ain4 = in[31:16];
			    ain3 = in[47:32];
			    ain2 = in[63:48];
			    ain1 = in[79:64];
			    if(counter > 11)  //cout이 출력 될때 (네모값들 나올때)
			      begin
				 core_turn = 0;
				 bi_out[127:112] = bi_out[111:96];
				 bi_out[111:96] = bi_out[95:80];
				 bi_out[95:80] = bi_out[79:64];
				 bi_out[79:64] = bi_out[63:48];
				 bi_out[63:48] = bi_out[47:32];
				 bi_out[47:32] = bi_out[31:16];
				 bi_out[31:16] = bi_out[15:0];
				 bi_out[15:0] = c_out[15:0];        //32bit로 받았지만 끝에 값만 가져온다.
				 if(counter == 20) //8개가 다 쌓였다면
				   begin
				      core_turn = 1; //내차례임을 알린다.
				      counter = 11;//다시 반복하게 만들기       일단은 여기까지
				      change_row = change_row+1;					  
				      if(change_row == column/8)
					begin
					   core_turn = 1;
					   counter = 11;
					   #1 change_row = 0;     //또 8칸을 만들기 위한 노력.
					   over = over+1;      //over은 현재 몇번째 줄임을 알려줌.
					   if(over == row-2)       //만약 사진을 끝까지 만들었다면?
					     counter = -1;       // 필터부터 다시 받아
				        end
				   end // if (counter == 20)
			      end // if (counter > 11)
			 end // else: !if(rest_one_cycle == 1)
		    end // else: !if(counter < 5)
		  counter = counter+1;
	       end // if (mode == 0)
	  end // else: !if(reset)
     end // always@ (posedge clk or posedge reset)
endmodule // project_acc_final
