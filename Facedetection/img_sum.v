module img_sum(clk, reset, size, in_signal, out_signal);

   input clk, reset;
   input in_signal;
   input [31:0] size;
   output reg 	out_signal;
   
   reg 		mem_img[0:999999];
   reg 		map1 [0:99999];
   reg 		map2 [0:99999];
   reg 		map3 [0:99999];
   reg 		map4 [0:99999];
   reg 		map5 [0:99999];
   reg 		map6 [0:99999];
   reg 		map7 [0:99999];
   reg 		map8 [0:99999];
   reg 		map9 [0:99999];
   reg 		map10 [0:99999];
   reg 		map11 [0:99999];
   reg 		map12 [0:99999];
   reg 		map13 [0:99999];
   reg 		map14 [0:99999];
   reg 		map15 [0:99999];
   reg 		map16 [0:99999];
   reg 		map17 [0:99999];
   reg 		map18 [0:99999];
   reg 		map19 [0:99999];
   reg 		map20 [0:99999];
   reg 		map21 [0:99999];
   reg 		map22 [0:99999];
   reg 		map23 [0:99999];
   reg 		map24 [0:99999];
   reg 		map25 [0:99999];
   reg 		map26 [0:99999];
   reg 		map27 [0:99999];
   reg 		map28 [0:99999];
   reg 		map29 [0:99999];
   reg 		map30 [0:99999];
   reg 		map31 [0:99999];
   reg 		map32 [0:99999];
   reg 		map33 [0:99999];
   reg 		map34 [0:99999];
   reg 		map35 [0:99999];
   reg 		map36 [0:99999];
   reg 		mode1;
   reg 		mode2;
   
   reg [31:0] 	unit_size,w;
   reg [31:0] 	rw,cl;
   integer 	pad;
   
   always@(posedge clk)
     begin
	if(reset)
	  begin
	     out_signal <=0;
	     mode1 <=1;
	     mode2 <=1;
   	     unit_size <= 1;
	     rw <=0;
	     cl <=0;
	     pad <=1;
	  end
	else
	  begin
	     if(in_signal)
	       begin
		  if(pad==1)
		    begin
		       unit_size = size/8;
		       for(w = 0; w<1000000; w++)
			 begin
			    mem_img[w]=0;    //먼저 모든 영역의 메모리 공간에 0으로 채워넣는다. 
			 end
		       pad = 0;
		    end
		  else
		    begin
		       if(mode1)
			 begin
			    $readmemh("core1_out.txt",map1,0, (3*unit_size)*(3*unit_size)-1);  //face라고 detection된 1과 나머지 0으로 된 
			    $readmemh("core2_out.txt",map2,0, (3*unit_size)*(3*unit_size)-1);  //각 core의 output을 받는다.
			    $readmemh("core3_out.txt",map3,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core4_out.txt",map4,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core5_out.txt",map5,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core6_out.txt",map6,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core7_out.txt",map7,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core8_out.txt",map8,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core9_out.txt",map9,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core10_out.txt",map10,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core11_out.txt",map11,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core12_out.txt",map12,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core13_out.txt",map13,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core14_out.txt",map14,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core15_out.txt",map15,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core16_out.txt",map16,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core17_out.txt",map17,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core18_out.txt",map18,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core19_out.txt",map19,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core20_out.txt",map20,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core21_out.txt",map21,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core22_out.txt",map22,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core23_out.txt",map23,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core24_out.txt",map24,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core25_out.txt",map25,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core26_out.txt",map26,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core27_out.txt",map27,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core28_out.txt",map28,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core29_out.txt",map29,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core30_out.txt",map30,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core31_out.txt",map31,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core32_out.txt",map32,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core33_out.txt",map33,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core34_out.txt",map34,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core35_out.txt",map35,0, (3*unit_size)*(3*unit_size)-1);
			    $readmemh("core36_out.txt",map36,0, (3*unit_size)*(3*unit_size)-1);
			    
			    mode1=0;   
			 end // if (mode)
		       else
			 begin
			    if(cl<(3*unit_size))          //0과 1로된 36개의 output들을 기존의 padding된 이미지 공간에 겹쳐서 0과 1을 채운다. (OR 문법사용)
			      begin
				 for(rw=0;rw<(3*unit_size);rw++)
				   begin
				      mem_img[rw+(unit_size*0)+(size*(unit_size*0))+(cl*size)] = mem_img[rw+(unit_size*0)+(size*(unit_size*0))+(cl*size)]|| map1[rw+(3*unit_size*cl)];  //겹쳐서 넣을때 index에 있어서 기존의 사이즈에 맞춰
				      mem_img[rw+(unit_size*1)+(size*(unit_size*0))+(cl*size)] = mem_img[rw+(unit_size*1)+(size*(unit_size*0))+(cl*size)]|| map2[rw+(3*unit_size*cl)];	//array 넘버링을 해준다. (가로, 세로 동일)	      
				      mem_img[rw+(unit_size*2)+(size*(unit_size*0))+(cl*size)] = mem_img[rw+(unit_size*2)+(size*(unit_size*0))+(cl*size)]|| map3[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*3)+(size*(unit_size*0))+(cl*size)] = mem_img[rw+(unit_size*3)+(size*(unit_size*0))+(cl*size)]|| map4[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*4)+(size*(unit_size*0))+(cl*size)] = mem_img[rw+(unit_size*4)+(size*(unit_size*0))+(cl*size)]|| map5[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*5)+(size*(unit_size*0))+(cl*size)] = mem_img[rw+(unit_size*5)+(size*(unit_size*0))+(cl*size)]|| map6[rw+(3*unit_size*cl)];
				      
				      mem_img[rw+(unit_size*0)+(size*(unit_size*1))+(cl*size)] = mem_img[rw+(unit_size*0)+(size*(unit_size*1))+(cl*size)]|| map7[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*1)+(size*(unit_size*1))+(cl*size)] = mem_img[rw+(unit_size*1)+(size*(unit_size*1))+(cl*size)]|| map8[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*2)+(size*(unit_size*1))+(cl*size)] = mem_img[rw+(unit_size*2)+(size*(unit_size*1))+(cl*size)]|| map9[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*3)+(size*(unit_size*1))+(cl*size)] = mem_img[rw+(unit_size*3)+(size*(unit_size*1))+(cl*size)]|| map10[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*4)+(size*(unit_size*1))+(cl*size)] = mem_img[rw+(unit_size*4)+(size*(unit_size*1))+(cl*size)]|| map11[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*5)+(size*(unit_size*1))+(cl*size)] = mem_img[rw+(unit_size*5)+(size*(unit_size*1))+(cl*size)]|| map12[rw+(3*unit_size*cl)];
				      
				      mem_img[rw+(unit_size*0)+(size*(unit_size*2))+(cl*size)] = mem_img[rw+(unit_size*0)+(size*(unit_size*2))+(cl*size)]|| map13[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*1)+(size*(unit_size*2))+(cl*size)] = mem_img[rw+(unit_size*1)+(size*(unit_size*2))+(cl*size)]|| map14[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*2)+(size*(unit_size*2))+(cl*size)] = mem_img[rw+(unit_size*2)+(size*(unit_size*2))+(cl*size)]|| map15[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*3)+(size*(unit_size*2))+(cl*size)] = mem_img[rw+(unit_size*3)+(size*(unit_size*2))+(cl*size)]|| map16[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*4)+(size*(unit_size*2))+(cl*size)] = mem_img[rw+(unit_size*4)+(size*(unit_size*2))+(cl*size)]|| map17[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*5)+(size*(unit_size*2))+(cl*size)] = mem_img[rw+(unit_size*5)+(size*(unit_size*2))+(cl*size)]|| map18[rw+(3*unit_size*cl)];
				      
				      mem_img[rw+(unit_size*0)+(size*(unit_size*3))+(cl*size)] = mem_img[rw+(unit_size*0)+(size*(unit_size*3))+(cl*size)]|| map19[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*1)+(size*(unit_size*3))+(cl*size)] = mem_img[rw+(unit_size*1)+(size*(unit_size*3))+(cl*size)]|| map20[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*2)+(size*(unit_size*3))+(cl*size)] = mem_img[rw+(unit_size*2)+(size*(unit_size*3))+(cl*size)]|| map21[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*3)+(size*(unit_size*3))+(cl*size)] = mem_img[rw+(unit_size*3)+(size*(unit_size*3))+(cl*size)]|| map22[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*4)+(size*(unit_size*3))+(cl*size)] = mem_img[rw+(unit_size*4)+(size*(unit_size*3))+(cl*size)]|| map23[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*5)+(size*(unit_size*3))+(cl*size)] = mem_img[rw+(unit_size*5)+(size*(unit_size*3))+(cl*size)]|| map24[rw+(3*unit_size*cl)];
				      
				      mem_img[rw+(unit_size*0)+(size*(unit_size*4))+(cl*size)] = mem_img[rw+(unit_size*0)+(size*(unit_size*4))+(cl*size)]|| map25[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*1)+(size*(unit_size*4))+(cl*size)] = mem_img[rw+(unit_size*1)+(size*(unit_size*4))+(cl*size)]|| map26[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*2)+(size*(unit_size*4))+(cl*size)] = mem_img[rw+(unit_size*2)+(size*(unit_size*4))+(cl*size)]|| map27[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*3)+(size*(unit_size*4))+(cl*size)] = mem_img[rw+(unit_size*3)+(size*(unit_size*4))+(cl*size)]|| map28[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*4)+(size*(unit_size*4))+(cl*size)] = mem_img[rw+(unit_size*4)+(size*(unit_size*4))+(cl*size)]|| map29[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*5)+(size*(unit_size*4))+(cl*size)] = mem_img[rw+(unit_size*5)+(size*(unit_size*4))+(cl*size)]|| map30[rw+(3*unit_size*cl)];

				      mem_img[rw+(unit_size*0)+(size*(unit_size*5))+(cl*size)] = mem_img[rw+(unit_size*0)+(size*(unit_size*5))+(cl*size)]|| map31[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*1)+(size*(unit_size*5))+(cl*size)] = mem_img[rw+(unit_size*1)+(size*(unit_size*5))+(cl*size)]|| map32[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*2)+(size*(unit_size*5))+(cl*size)] = mem_img[rw+(unit_size*2)+(size*(unit_size*5))+(cl*size)]|| map33[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*3)+(size*(unit_size*5))+(cl*size)] = mem_img[rw+(unit_size*3)+(size*(unit_size*5))+(cl*size)]|| map34[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*4)+(size*(unit_size*5))+(cl*size)] = mem_img[rw+(unit_size*4)+(size*(unit_size*5))+(cl*size)]|| map35[rw+(3*unit_size*cl)];
				      mem_img[rw+(unit_size*5)+(size*(unit_size*5))+(cl*size)] = mem_img[rw+(unit_size*5)+(size*(unit_size*5))+(cl*size)]|| map36[rw+(3*unit_size*cl)];
				      
				   end // for (rw=0;rw<3;rw++)
				 rw=0;
				 cl++;
			      end // if (cl<(3*unit_size))
			    else
			      begin
				 if(mode2)      //이제 원본 이미지에 0과 1로된 것들을 다시 output으로 내보내 bbbox에서 기존의 픽셀값들과 비교하여 boxing을 할 것이다.
				   begin
				      $writememh("testing.txt",mem_img,0,(size*size)-1);
				      mode2=0;
				      out_signal = 1;
				   end
			      end // else: !if(cl<(3*unit_size))
			 end // else: !if(mode)
		    end // else: !if(padrow<64)
	       end // if (in_signal)
	  end // else: !if(reset)
     end // always@ (posedge clk)
endmodule // img_sum
