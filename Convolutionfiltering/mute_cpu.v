module mute_cpu(clk,reset,row,column,end_cpu,next_row,next_column); // memory와 core를 하나로 묶은 모듈

   input clk,reset;
   input [16:0] row,column;           	// 이미지의 행과 열
   output	end_cpu;             	// convolution filtering이 완료 되었다고 알려주는 signal
   output [16:0] next_row,next_column;	// filtering된 결과를 한 번 더 filtering하고 싶을때 다음 단계의 row, column은 4씩 줄어든 값이다.
   wire 	 cpu_change;
   wire [127:0]  bicount;               // memory와 core간의 양방향 통신
   wire 	 memory_turn,core_turn;	// memory와 core는 양방향 통신을 하기 때문에 동시에 값을 보낼 수가 없다. 서로 번갈아 가면서 값을 주고 받을수 있게 memory와 core가 통신하는 signal

   mute_memory i0(clk,reset,bicount,core_turn,memory_turn,row,column,cpu_change);// memory(이미지 원본, filter, filtering 결과물이 저장되는 memory)
   mute_core i1(clk,reset,bicount,memory_turn,core_turn,row,column); 		 // core(이미지 원본 픽셀값이 들어와 filtering이 이루어 지는 곳)

   assign next_row = row-4;                  // 5X5 기준 다음 단계의 행과 열은 4개씩 줄어든다(filtering을 하면 이미지의 행-4, 열-4로 결과가 나온다.)
   assign next_column = column-4;
   assign end_cpu = (cpu_change == 0)? 1:0;  // filtering이 완료되어 memory에서 cpu를 change하라는 signal이 나오면 cpu의 할 일이 끝났다고 값을 변환한다.

endmodule // mute_cpu


