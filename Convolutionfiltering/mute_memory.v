module mute_memory(clk, reset, bicount,core_turn, memory_turn,row,column,cpu_change); //row = 행 , columnn = 열

   input clk, reset, core_turn;
   input [16:0] row, column;
   output memory_turn;
   output reg cpu_change;
   reg 	  rg_memory_turn;
   inout [127:0] bicount;
   wire [127:0]  out;
   wire [127:0]  in;
   reg [127:0] 	 bi_out;
   reg [15:0] 	 counter;
   reg 		 setting;

   reg [15:0] 	 image_memory[0:999999]; //원본 이미지를 저장시킬 공간(1000*1000)크기 이미지 까지 가능
   reg [15:0] 	 filter_memory [0:24];  //필터공간 5x5
   reg [15:0] 	 convol_image[0:999999]; //convolution filtering 된 이미지를 저장시킬 공간
   reg [8:0] 	 over; 
   integer  change_row; 
   integer  i,k,q,t,w,a,b,c,d,e;         //연산을 위한 변수들
   reg 		 rest_one_cycle,first;   


   assign bicount = (core_turn == 0)? out:128'bz;  // core_turn이 0일때 즉 memory turn(이 모듈 차례)일 때 out에 저장된 data들이 data bus(bicount)를 타고 넘어간다.
   assign in = (core_turn == 1)? bicount:128'bz;   // core_turn이 1일 때 즉 core에서 data bus(bicount)를 통해 값을 전달해 주고 있을때 들어온 값들을 in으로 받아온다.
   assign out = bi_out;				   // out에는 bi_out이라는 register에 존재하는 값들이 저장된다.
   assign memory_turn = (counter == 0)? rg_memory_turn:(core_turn == 1)?0:1; // memory_turn은 core_turn의 반대이다.

   
   always@ (posedge clk or posedge reset)
     begin
	if (reset)
	  begin
	     i <= 0;                             // image 보내는 변수
	     k <= 0;                             // filter 보내는 변수
	     q <= 0;                             // convol image 저장하는 변수(1)
	     t <= 0;                             // convol image 저장하는 변수(2)
	     w <= 0;
	     a <= 0;                             // 8의 배수인지 4의 배수인지 판별
	     b <= 0;                             // image_memory 공간
	     c <= 0;                             // convol_image 공간
	     d <= 0;                             // change row가 몇개 필요한지 판별
	     e <= 0;
	     change_row <= 0;
	     bi_out <= 0;
	     counter <= 0;
	     rg_memory_turn <= 1;                //처음에 시작하자마자 memory_turn을 1로 만들기 위해
	     setting <= 1;
	     rest_one_cycle <=1;
	     first <= 0;
	     over <= 1;
	     cpu_change <=0;
	  end

	else
	  begin
	     if(over!=(row-3))
	       begin
		  if(setting)
		    begin
		       setting = 0;
		       $readmemh("man_out(hex).txt", image_memory, 0, (row*column)-1);  //원본 이미지를 image_memory에 저장시킨다.
		       for(w=0; w<25; w++) // filter 준비 시키기 (엣지필터) filter_memory에 사용할 필터를 저장시킨다.
			 begin
			    filter_memory[w] = -1;
			    if(w==12)
			      begin
				 filter_memory[w]=25;
			      end
			 end
		    end
		  else
		    begin
		       if(memory_turn)
			 begin
			    a = (column-4)%8;
			    b = row*column;
			    c = (row-4)*(column-4);
			    d = (column-4)/8;
			    if(counter<6) // filter_memory에 저장된 필터를 core로 먼저 보내준다.(5clk 소요)
			      begin
				 bi_out[15:0] = filter_memory[24-k];
				 bi_out[31:16] = filter_memory[23-k];
				 bi_out[47:32] = filter_memory[22-k];
				 bi_out[63:48] = filter_memory[21-k];
				 bi_out[79:64] = filter_memory[20-k];
				 k = k+5;
			      end
			    
			    else 	// filter를 모두 보냈으면 이제 이미지 pixel값들을 보내준다.
			    begin
			       if(rest_one_cycle == 1)
				 begin
				    rest_one_cycle = 0;
				 end
			       else	// 한번에 5개 pixel값씩 보내준다.
				 begin
				    bi_out[15:0] = image_memory[b-1-i];
				    bi_out[31:16] = image_memory[b-1-i-column];
				    bi_out[47:32] = image_memory[b-1-i-(column*2)];
				    bi_out[63:48] = image_memory[b-1-i-(column*3)];
				    bi_out[79:64] = image_memory[b-1-i-(column*4)];
				    i = i+1;
				    if(counter==20)  //convolution 결과 값을 한 번에 8개씩 받아온다. 이를 convol_image에 저장 시킨다. 
				      begin
					 if(change_row < d)      //맨 밑에 줄이 아직 완성이 안되었을 때는 들어온 값을 오른쪽->왼쪽으로 계속 값을 쌓아준다.
					   begin

					      change_row = change_row+1;  //chage_row초기값=1
					      counter = 11;
					      #1 convol_image[c-1-q] = in[127:112];
					      convol_image[c-2-q] = in[111:96];
					      convol_image[c-3-q] = in[95:80];
					      convol_image[c-4-q] = in[79:64];
					      convol_image[c-5-q] = in[63:48];
					      convol_image[c-6-q] = in[47:32];
					      convol_image[c-7-q] = in[31:16];
					      convol_image[c-8-q] = in[15:0];
					      q = q+8;
					      
					   end
					 
					 else if (change_row== d)     // 맨 밑에줄이 모두 쌓였다면, over를 하나 증가시켜 주고, 다음 줄의 주소로 올려준다. (원본이미지의 가로가 4의 배수일 때와 8의 배수일 때 들어온 값을 받는 방법이 다르다.)
					   begin		 
					      
					      over = over+1;  //한줄끝났다.
					      counter = 11;
					      case(a)
						0: // 8의 배수 일 때
						  begin
						     if(first == 0)
						       begin
							  first = 1;
							  change_row = 1;
							  q = q+4;
							  #1 convol_image[c-1-(8*d)-t] = in[63:48];
							  convol_image[c-2-(8*d)-t] = in[47:32];
							  convol_image[c-3-(8*d)-t] = in[31:16];
							  convol_image[c-4-(8*d)-t] = in[15:0]; 
							  t = t+column-4-4;
						       end
						     else if(first == 1)
						       begin
							  first = 0;
							  change_row = 0;
							  q = q+4;
							  #1 convol_image[c-1-(8*d)-t] = in[127:112];
							  convol_image[c-2-(8*d)-t] = in[111:96];
							  convol_image[c-3-(8*d)-t] = in[95:80];
							  convol_image[c-4-(8*d)-t] = in[79:64];  
							  t = t+column-4+4;
						       end
						  end // case: 0						
					
						4: // 4의 배수 일 때
						  begin
						     change_row = 0;
						     q = q+4;
						     #1 convol_image[c-1-(8*d)-t] = in[127:112];
						     convol_image[c-2-(8*d)-t] = in[111:96];
						     convol_image[c-3-(8*d)-t] = in[95:80];
						     convol_image[c-4-(8*d)-t] = in[79:64];  //왼쪽4개의 값을 넣는것
						     t = t+column-4;
						  end
						
					      endcase	 
					      
					   end 					 
				      end 				    				    
				 end 			       			       
			    end 			    
			 end 		       
		    end 
		  
		  counter = counter+1;

	       end 
	     
	     if(over==(row-3)&& e==0) 	// 모든 convolution filter가 모두 완료 되었다면 결과를 txt로 저장시킨다.
	       begin
		  e = 1;
		  $writememh("filter_1.txt",convol_image,0,(row-4)*(column-4)-1);
		  cpu_change = 1; 	// convolution filter가 완성이 되었다는 signal을 보낸다.
	       end
	  end 
     end 
endmodule // mute_memory

