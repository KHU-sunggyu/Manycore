module bbbox(reset, clk, height, width,in_signal);
   input reset, clk;
   input [31:0] width, height;//input image의 가로(width), 세로(height)
   input 	in_signal;//on/off signal



   reg [31:0] 	memory_1d[0:999999];  //연산 결과를 받을 1d array
   reg [31:0] 	original_1d[0:999999];
   reg [31:0] 	mem_output[0:999999]; //bounding box와 결과 이미지를 받을 1d array
   integer 	i;
   reg [31:0] 	pad_height, height_fin, pad_width, width_fin; //image 8의 배수크기의 정사각형으로 만들기 logic을 위한 reg
   reg [31:0] 	size;//정사각형 size
   reg 		cal_signal_A;//최초 1번만 수행하도록 1bit signal reg
   reg 		cal_signal_B;//위와 동일
   reg 		setting;//위와 동
  //indexing
   reg [31:0] 	num1,num2;
   reg 		who;
   reg [31:0] 	count;
   reg 		set;
   reg 		mode3;
   


   always@(posedge clk)
     begin
	if(reset)
	  begin
	     i =0; 
	     cal_signal_A=1;
	     cal_signal_B=1;
	     pad_height= 0;
	     height_fin=0;
	     pad_width=0;
	     width_fin=0;
	     size=0;
	     num1 =0;
	     num2 =0;
	     who =0;
	     count=0;
	     setting=1;
	     set =1;
	     mode3 = 1;
	  end // if (reset)
	else
	  begin
	     if(in_signal)
	       begin
		  if(cal_signal_A==1) //최초 cal_signal_A =1일 때, 수행하도록 if문
		    begin//input이미지를 8의 배수 정사각형으로 만들기위해 size 계산
		       if((height%8) !=0)//8로 나머지 연산->height이 8의 배수가 아니면
			 begin
			    pad_height= height%8; 
			    height_fin = 8-pad_height;//height+height_fin은 8의 배수
			 end
		       else
			 begin
			    height_fin = 0; //height_fin = 0: height은 8의 배수
			 end
		       if((width%8) !=0)//8로 나머지 연산-> width가 8의 배수가 아니면
			 begin
			    pad_width= width%8;
			    width_fin = 8-pad_width;//width+width_fin은 8의 배수
			 end
		       else
			 begin
			    width_fin=0; //width_fin =0: width는 8의 배수
			 end
		       
		       cal_signal_A = 0; //최초 수행후 다시는 현재 if문 수행하지 않도록
		    end // if (cal_signal==1)
		  if(cal_signal_B ==1)
		    begin//8의 배수로 정의한 가로, 세로 크기 비교 -> 정사각형 만들기
		       if((height+height_fin)>= (width+width_fin))//세로가 큰 경우	  			
			 begin
			    size = height+height_fin; //size 정의
			    who = 0;//state register
			 end
		       else//가로가 큰 경우
			 begin
			    size = width+width_fin;
			    who = 1;
			 end
		       cal_signal_B=0;//최초 수행 후 다시는 현재 if문 수행하지 않도록
		    end // if (cal_signal_B ==1)
		  
		  if(setting)//최초 setting =1 
		    begin
		       $readmemh("testing.txt", memory_1d, 0, (size*size)-1); //연산결과 이미지 받는다(8의 배수 size 정사각형)
		       $readmemh("man_out(hex).txt", mem_output, 0, (width*height)-1);//원본이미지 받는다(크기 weight*height -1)
		       setting=0;//다음 clk에서는 else문으로 들어가 수행하도록
		    end
		  else
		    begin
		       if(num2<height)//최초 num2 =0 가로:width, 세로 height 일때, num2는 세로(이미지의 열) indexing
			 begin 
			    for(num1=0;num1<width;num1++)	 
			      begin     
				 if(memory_1d[num1+(num2*size)])//정사각형 image에서 num2*size로 열을 뛰어넘는다.(num1은 행 indexing)
				   begin
				      mem_output[num1+(num2*width)]=255;//1일 경우 mem_output pixel값을 255로 저장
				   end     
			      end
			    num2++;//위의 과정 거친후에 +1 수행
			 end
		       else
			 begin
			    if(mode3)//최초 mode3=1
			      begin
				 $writememh("man_out(hex)_detect.txt",mem_output,0,(width*height)-1);//결과를 원본 image 크기로 저장
				 mode3 = 0;
			      end
			 end // else: !if(num2<height)
		    end // else: !if(setting)
	       end // if (in_signal)
	  end // else: !if(reset)
     end // always@ (posedge clk)
endmodule // bbbox








