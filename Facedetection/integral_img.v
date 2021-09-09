module integral_img(clk, reset, width, height, size, mode);
   
   input clk, reset;
   input [31:0] width, height;  //기존의 이미지 사이즈
   output reg [31:0] 	size;   //정사각형으로 된 이미지
   output reg 		mode;
   
   reg [31:0] 	mem_image[0:999][0:999];  //기존의 이미지 메모리(2D)
   reg [31:0] 	mem_img[0:999999];       //기존의 이미지 메모리(1D)
   reg [31:0] 	int_img[0:999999];       //Integral 이미지 (1D)

   integer 	x;
   integer 	p,j;
   integer 	s1,n;
   integer 	k1,l;
   integer 	padrow,padcol;
   integer 	data_file;
   integer 	scan_file;
   
   reg [31:0] 	pad_height, height_fin, pad_width, width_fin;  
   reg [31:0] 	num;
   reg [31:0] 	row, column;

   
   reg 		fnl,col1,row1;
   reg [31:0] 	unit_size,y,i,q,w,k,s;
   reg [31:0] 	cl,rw;	      
   reg [31:0] 	u;
   
   reg [31:0] 	image1 [0:99999];    //각 manycore으로 들어갈 부분의 이미지 공간(2D지만 실제로는 1D로 담김)
   reg [31:0] 	image2 [0:99999];
   reg [31:0] 	image3 [0:99999];
   reg [31:0] 	image4 [0:99999];
   reg [31:0] 	image5 [0:99999];
   reg [31:0] 	image6 [0:99999];
   reg [31:0] 	image7 [0:99999];
   reg [31:0] 	image8 [0:99999];
   reg [31:0] 	image9 [0:99999];
   reg [31:0] 	image10 [0:99999];
   reg [31:0] 	image11 [0:99999];
   reg [31:0] 	image12 [0:99999];
   reg [31:0] 	image13 [0:99999];
   reg [31:0] 	image14 [0:99999];
   reg [31:0] 	image15 [0:99999];
   reg [31:0] 	image16 [0:99999];
   reg [31:0] 	image17 [0:99999];
   reg [31:0] 	image18 [0:99999];
   reg [31:0] 	image19 [0:99999];
   reg [31:0] 	image20 [0:99999];
   reg [31:0] 	image21 [0:99999];
   reg [31:0] 	image22 [0:99999];
   reg [31:0] 	image23 [0:99999];
   reg [31:0] 	image24 [0:99999];
   reg [31:0] 	image25 [0:99999];
   reg [31:0] 	image26 [0:99999];
   reg [31:0] 	image27 [0:99999];
   reg [31:0] 	image28 [0:99999];
   reg [31:0] 	image29 [0:99999];
   reg [31:0] 	image30 [0:99999];
   reg [31:0] 	image31 [0:99999];
   reg [31:0] 	image32 [0:99999];
   reg [31:0] 	image33 [0:99999];
   reg [31:0] 	image34 [0:99999];
   reg [31:0] 	image35 [0:99999];
   reg [31:0] 	image36 [0:99999];

   initial
     begin
	p=0;
	j=0;
	s1=0;
	n= width;
	k1= height;
	l = 0;
	pad_height=0;
	height_fin=0;
	pad_width=0;
	width_fin=0;
	data_file = $fopen("man_out(hex).txt", "r");
	padrow=0;
	padcol=0;
     end // initial begin
   

   always@ (posedge clk or posedge reset)
     begin
	if (reset)
	  begin
	     i <= 1;
	     k <= 1;
	     q <= 1;
	     s <= 0;
	     w <= 1;
	     y <= 0;
	     unit_size <= 0;
	     fnl <=0;
	     col1 <=0;
	     row1 <=1;
	     mode<=1;
	     cl<=0;
	     rw<=0;
	     column = 0;
	     row = 0;
	     num = 0;
	     u=0;
	     size=0;
	  end
	else
	  begin
	     if((height%8) != 0) //Padding을 하기위한 연산(8의 배수로 만들기)
	       begin
		  pad_height= height %8;
		  height_fin = 8-pad_height;
	       end
	     else
	       begin
		  height_fin = 0;
	       end
	     if((width%8) !=0)
	       begin
		  pad_width = width %8;
		  width_fin = 8-pad_width;
	       end	
	     else
	       begin
		  width_fin = 0;
	       end
	     if(padrow<1000)  //기존의 이미지을 담을 빈공간을 255으로 채워넣는다. 
	       begin
		  for(padcol=0;padcol<1000;padcol++)
		    begin
		       mem_image[padrow][padcol]=255;
		    end
		  padrow++;
		  padcol=0;
	       end
	     else
	       begin
		  if(p < height)
		    begin
		       for(j =0; j<width; j= j+1) //실제 이미지 txt를 기존의 이미지 공간에 담는다.
			 begin
			    scan_file = $fscanf(data_file, "%x", x);
			    mem_image[p][j] = x;
			 end
		       p++;
		       j = 0;
		    end
		  else
		    begin
		       if((width+width_fin)>(height+height_fin))  //정사각형 size에 맞춰서 가로 세로 설정
			 begin
			    size = width+width_fin;  //n*n
			 end
		       else
			 begin
			    size = height+height_fin;  //n*n
			 end      
		       if(row <size)
			 begin
			    for(column=0;column<size;column++)    //Basing을 통해 픽셀값들을 변경
			      begin
				 mem_img[num] = mem_image[row][column];
				 if(mem_img[num] <= 135 )  //135이하는 0으로, 135초과는 255로 변경
				   begin
				      mem_img[num] = 0;
				   end
				 else
				   begin
				      mem_img[num] = 255;
				   end
				 num++;
			      end
			    row++;
			 end
		       else
			 begin  
			    if(row1)   //1행에 대한 integral 만들기
			      begin
				 int_img[0] = mem_img[0];  
				 for(i=1;i<size+1;i++)  
				   begin
				      int_img[i] = int_img[i-1]+mem_img[i];				  
				   end
				 row1=0;
				 col1=1;
			      end
			    else
			      begin
				 if(col1)
				   begin 
				      if(q<size+1)    //1열에 대한 integral 만들기
					begin
					   int_img[size*q] = int_img[size*(q-1)]+mem_img[size*q];
					   q++;
					end
				      else
					begin
					   col1=0;
					   fnl=1;
					end
				   end  //첫열완료
				 else if(fnl)
				   begin
				      if(w<size+1)
					begin
					   if(k<size)       //전체 이미지 사이즈에 대해 모든 부분의 integral 이미지 만든다.
					     begin
						int_img[k+(size*w)] = mem_img[k+(size*w)] +   //해당 인테그랄이미지 픽셀값을 위한 알고리즘(PT 설명)
								    int_img[k-1+(size*w)] + 
								  int_img[k+(size*(w-1))] - 
								int_img[k-1+(size*(w-1))];
						k++;
					     end
					   else
					     begin
						k=1;
						w++;
					     end // else: !if(k<width)
					end // if (w<(height-1))
				      else
					begin
					   fnl=0;
					end // else: !if(w<(height-1))
				   end // if (fnl)
				 else
				   begin
				      if(mode)
					begin
					   unit_size = size/8;  // unit_size는 각 코어로 나뉘어 들어갈 사이즈를 위해 조정값
					   if(cl<(3*unit_size))  //c1은 0부터 3unit_size-1까지 들어간다.
					     begin
						for(rw=0;rw<3*unit_size;rw++)  //각 코어에 들어갈 image1~36에 차곡차곡 넣어준다. 
						  begin
						     image1 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*0)+(cl*size)];
						     image2 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*1)+(cl*size)];
						     image3 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*2)+(cl*size)];
						     image4 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*3)+(cl*size)];
						     image5 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*4)+(cl*size)];
						     image6 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*5)+(cl*size)];

						     image7 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*0)+(size*(unit_size*1))+(cl*size)];
						     image8 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*1)+(size*(unit_size*1))+(cl*size)];
						     image9 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*2)+(size*(unit_size*1))+(cl*size)];
						     image10 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*3)+(size*(unit_size*1))+(cl*size)];
						     image11 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*4)+(size*(unit_size*1))+(cl*size)];
						     image12 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*5)+(size*(unit_size*1))+(cl*size)];

						     image13 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*0)+(size*(unit_size*2))+(cl*size)];
						     image14 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*1)+(size*(unit_size*2))+(cl*size)];
						     image15 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*2)+(size*(unit_size*2))+(cl*size)];
						     image16 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*3)+(size*(unit_size*2))+(cl*size)];
						     image17 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*4)+(size*(unit_size*2))+(cl*size)];
						     image18 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*5)+(size*(unit_size*2))+(cl*size)];

						     image19 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*0)+(size*(unit_size*3))+(cl*size)];
						     image20 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*1)+(size*(unit_size*3))+(cl*size)];
						     image21 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*2)+(size*(unit_size*3))+(cl*size)];
						     image22 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*3)+(size*(unit_size*3))+(cl*size)];
						     image23 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*4)+(size*(unit_size*3))+(cl*size)];
						     image24 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*5)+(size*(unit_size*3))+(cl*size)];

						     image25 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*0)+(size*(unit_size*4))+(cl*size)];
						     image26 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*1)+(size*(unit_size*4))+(cl*size)];
						     image27 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*2)+(size*(unit_size*4))+(cl*size)];
						     image28 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*3)+(size*(unit_size*4))+(cl*size)];
						     image29 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*4)+(size*(unit_size*4))+(cl*size)];
						     image30 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*5)+(size*(unit_size*4))+(cl*size)];

						     image31 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*0)+(size*(unit_size*5))+(cl*size)];
						     image32 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*1)+(size*(unit_size*5))+(cl*size)];
						     image33 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*2)+(size*(unit_size*5))+(cl*size)];
						     image34 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*3)+(size*(unit_size*5))+(cl*size)];
						     image35 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*4)+(size*(unit_size*5))+(cl*size)];
						     image36 [rw+(3*unit_size*cl)] = int_img [rw+(unit_size*5)+(size*(unit_size*5))+(cl*size)];
						  end
						rw=0;
						cl++;
					     end 
					   else
					     begin     //차곡차곡 쌓인 image1~36을 각 코어로 넣어준다. (txt생성)
						$writememh("mem_image.txt",mem_img,0,(size)*(size)-1);
						$writememh("int_img.txt",int_img,0,(size)*(size)-1);
						$writememh("core1.txt",image1,0,(3*unit_size)*(3*unit_size)-1);   
						$writememh("core2.txt",image2,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core3.txt",image3,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core4.txt",image4,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core5.txt",image5,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core6.txt",image6,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core7.txt",image7,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core8.txt",image8,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core9.txt",image9,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core10.txt",image10,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core11.txt",image11,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core12.txt",image12,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core13.txt",image13,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core14.txt",image14,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core15.txt",image15,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core16.txt",image16,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core17.txt",image17,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core18.txt",image18,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core19.txt",image19,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core20.txt",image20,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core21.txt",image21,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core22.txt",image22,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core23.txt",image23,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core24.txt",image24,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core25.txt",image25,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core26.txt",image26,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core27.txt",image27,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core28.txt",image28,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core29.txt",image29,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core30.txt",image30,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core31.txt",image31,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core32.txt",image32,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core33.txt",image33,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core34.txt",image34,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core35.txt",image35,0,(3*unit_size)*(3*unit_size)-1);
						$writememh("core36.txt",image36,0,(3*unit_size)*(3*unit_size)-1);
						mode=0;
					     end 
					end 
				   end
			      end
			 end 
		    end 
	       end 
	  end 
     end 
endmodule 

					  
