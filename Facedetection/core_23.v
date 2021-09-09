module core_23(clk, reset, size, mode);
   
   input clk, reset, mode;
   input [31:0] size;
   reg [31:0] 	image[0:99999];
   reg 		face_address[0:99999];
   reg [31:0] 	unit_size,core_size,next_row,
		filter_height,filter_width,eye_size; // filter, core size 관련 변수
   reg [31:0] 	a,b,c;   // filter 이동 변수
   reg [31:0] 	v,p,w;   // for문 변수
   reg [3:0] 	filter;  // filter size 변화 ex) filter == 1 제일 작은 filter, 
   //                     filter == 6 제일 큰 filter
   reg 		start;
   reg 		setting;
   reg signed [31:0] eye,cheek, nose, eye_1, eye_2, mouth;
   
   always@(posedge clk or posedge reset)
     begin	
	if(reset)
	  begin
	     unit_size <= 0;
	     core_size <= 0;
	     next_row <= 0;
	     filter_height <= 0;
	     filter_width <= 0;
	     eye_size <= 0;   
	     
	     a <= 0;
	     b <= 0;
	     c <= 0;

	     w <= 0;
	     v <= 0;
	     p <= 1;
	     
	     setting <= 0;
	     filter <= 0;
	     start <= 0;
	     
	     eye <= 0;
	     cheek <= 0;
	     nose <= 0;
	     eye_1 <= 0;
	     eye_2 <= 0;
	     mouth <= 0;
	  end 	
	else
	  begin
	     if(mode == 0)
	       begin
		  unit_size = size/8;                          // unit_size = 1개의 core에는 9개의 unit들이 3X3형태로 들어오고 이 unit의 한변의 길이이다.
		  if (setting == 0)                            // setting == 0은 아직 필터링을 하기 위한 setting이 안된 것이다.
		    begin		       
		       core_size = 9*(unit_size)*(unit_size);  // core_size = 1개의 core에는 한 변의 길이가 unit_size인 unit이 9개가 들어와서 형성하므로 (3*unit_size)*(3*unit_size) 가 core_size이다.
		       next_row = 3*unit_size;                 // 이미지 주소값에 3*unit_size를 곱하면 다음 행의 위치를 가리킨다.    ex) image[3]의 주소에서 아래로 3칸을 내려가고 싶으면 image[3*next_row]
		       filter_width = 2*unit_size/3;               // filter == 1일 때(가장 작은 filter일때) filter의 가로 길이는 unit_size의 변의 길이를 2/3곱한 값과 같다. 
		       filter_height = filter_width/6;            // filter의 세로 길이는 filter의 가로 길이를 6으로 나눈것이다.  (filter의 비율 6:1)
		       eye_size = filter_width/5;                 // 눈과 콧대 검출을 위한 변수로 filter를 가로로 5등분 하여 2:1:2 비율로 눈과 콧대를 검출한다.
		       
		       filter = 1;                             // 맨 처음은 이미지 필터링은 filter == 1인 가장 작은 filter를 사용한다.
		       start = 1;                              // start == 1이어야 이미지 필터링을 시작한다. start == 0이면 필터링을 하지 않는다.
		       setting = 1;                            // setting == 1로 만들어 이미지 필터링을 위한 setting이 완료되었음을 알린다.		      
		       $readmemh("core23.txt", image, 0, core_size-1); // core로 할당된 이미지 파일을 읽어와 레지스터에 저장 시킨다.
		       
		       for(w = 0; w < core_size; w++)           // 얼굴 검출 register에 모든 값을 0으로 채운다. (default)
			 begin
			    face_address[w] = 0;                   
			 end
		    end 		  
		  else
		    begin
		       if(start == 1)
			 begin			    
			    eye = ( image[a+(2*unit_size/3)+(next_row*(filter_height+b))] 
				    - image[c+(next_row*(filter_height+b))] 
				    - image[a+(2*unit_size/3)+(next_row*b)] 
				    + image[c+(next_row*b)] )/(filter_height*filter_width); // 눈 (어두운 부분)
			    
			    cheek = ( image[a+(2*unit_size/3)+(next_row*((2*filter_height)+b))] 
				      - image[c+(next_row*((2*filter_height)+b))] 
				      - image[a+(2*unit_size/3)+(next_row*(filter_height+b))] 
				      + image[c+next_row*(filter_height+b)])/(filter_height*filter_width);  // 볼 (밝은 부분)
			    
			    
			    if (eye < 212 && eye > 110 && cheek > 237)    // 눈 필터의 평균 픽셀값이 212보다 어둡고, 볼 필터의 평균 픽셀값이 237보다 밝으면 콧대 검출을 시작한다.
			      begin				 
				 nose = ( image[a+(2*unit_size/3)-(2*eye_size)+(next_row*(filter_height+b))] 
					  - image[c+(2*eye_size)+(next_row*(filter_height+b))] 
					  - image[a+(2*unit_size/3)-(2*eye_size)+(next_row*b)] 
					  + image[c+(2*eye_size)+(next_row*b)])/(filter_height*(filter_width-4*eye_size)); // 콧대 (밝은 부분)
				 
				 eye_1 = ( image[a+(2*unit_size/3)+(next_row*(filter_height+b))] 
					   + image[a+(2*unit_size/3)-(2*eye_size)+(next_row*b)] 
					   - image[a+(2*unit_size/3)+(next_row*b)] 
					   - image[a+(2*unit_size/3)-(2*eye_size)+(next_row*(filter_height+b))])/(filter_height*2*eye_size);  // 눈1 (어두운 부분)
				 
				 eye_2 = ( image[c+(2*eye_size)+(next_row*(filter_height+b))] 
					   + image[c+(next_row*b)] 
					   - image[c+(2*eye_size)+(next_row*b)] 
					   - image[c+(next_row*(filter_height+b))])/(filter_height*2*eye_size); // 눈2 (어두운 부분)
				 
				 
				 if(nose > 237 && eye_1 < 196 && eye_2 < 196)  // 콧대 부분의 평균 픽셀값이 237보다 밝고, 양쪽 눈의 평균 픽셀값이 196보다 어둡다면 입 검출을 시작한다.
				   begin				      
				      mouth = ( image[a+(2*unit_size/3)-(2*eye_size)+(next_row*(b+3*filter_height))] 
						- image[c+(2*eye_size)+(next_row*(b+3*filter_height))] 
						- image[a+(2*unit_size/3)-(2*eye_size)+(next_row*(b+2*filter_height))] 
						+ image[c+(2*eye_size)+(next_row*(b+2*filter_height))])/(filter_height*(filter_width-4*eye_size)); // 입
				      
				      if(mouth > 206) // 위의 자리에서 입이 검출이 안됐다면, 입이 더 아래에 있을 경우를 생각하여 더 내려서 검출을 해본다.
					mouth = ( image[a+(2*unit_size/3)-(2*eye_size)+(next_row*(4*filter_height+b))] 
						  - image[c+(2*eye_size)+(next_row*(4*filter_height+b))] 
						  - image[a+(2*unit_size/3)-(2*eye_size)+(next_row*(3*filter_height+b))] 
						  + image[c+(2*eye_size)+(next_row*(3*filter_height+b))])/(filter_height*(filter_width-4*eye_size)); // 입
				      
				      if(mouth <= 206) // 위 두가지 경우에 한 번이라도 입이 검출됐다면 얼굴이라고 판단하고 0으로만 채워진 face_address를 얼굴이 있는 부분의 둘레를 1로 채운다. 모든 필터링이 끝나면 얼굴이 있는 부분에만 1로 사각형이 그려져 있을 것이다.
					begin					   
					   for(v = 0; v<filter_width+1; v++)
					     begin
						face_address[v+c+(next_row*b)] = 1;
						face_address[v+c+(next_row*(4*filter_height+b))] = 1;
					     end
					   
					   for(p = 1; p<4*filter_height+1; p++)
					     begin
						face_address[c+(next_row*(b+p))] = 1;
						face_address[(2*unit_size/3)+a+(next_row*(b+p))] = 1;
					     end					   
					end 
				   end 
			      end 
			    
			    
			    a++;
			    c++;                  	// 하나의 자리에서 필터링이 끝났다면 변수 a와 c를 하나씩 증가시켜 오른쪽으로 한 칸 이동시킨다. (필터링 방향 왼쪽 -> 오른쪽) 
			    if(filter == 1)       	// 1번 크기의 filter일 때
			      begin
				 if(a == (7*unit_size)/3) 	// 필터링이 이미지의 오른쪽 끝에 도달했다면 a와 c를 0으로 초기화 시키고 b를 증가시켜 그 다음 줄로 넘어가게 한다. 즉 2번째 줄의 왼쪽 -> 오른쪽으로 다시 필터링을 하는 것이다.
				   begin
				      a = 0;
				      c = 0;
				      b++;
				      
				      if(b == (3*unit_size - 2*filter_height)) // 필터가 맨 아랫줄의 오른쪽 끝에 도달했다면 필터 사이즈를 키운다. (1번 filter -> 2번 filter) 그 후 다시 맨 윗줄의 왼쪽 부터 필터링을 시작한다.
					begin
					   a = unit_size/3;
					   b = 0;
					   filter_width = filter_width*3/2;
					   filter_height = filter_width/6;
					   eye_size = filter_width/5;
					   filter = 2;
					end				      
				   end
			      end 
			    
			    else if(filter == 2)  	// 2번 size의 filter일 때
			      begin
				 if(a == (7*unit_size)/3)   // 필터링이 이미지 오른쪽 끝에 도달하면 다음 줄의 맨 왼쪽으로 필터를 보내준다.
				   begin
				      a = unit_size/3;
				      c = 0;
				      b++;
				      
				      if(b == (3*unit_size - 2*filter_height)) // 필터가 이미지의 끝에 도달하면 필터 사이즈를 키운다. (2번 filter -> 3번 filter) 그 후 다시 맨 처음 단계부터 필터링을 시작한다.
					begin
					   a = unit_size*5/6;
					   b = 0;
					   filter_width = filter_width*3/2;
					   filter_height = filter_width/6;
					   eye_size = filter_width/5;
					   filter = 3;
					end				      
				   end 
			      end
			    
			    else if(filter == 3)	// 3번 size의 filter일 때
			      begin
				 if(a == (7*unit_size)/3) // 필터가 이미지 오른쪽 끝에 도달하면 다음 줄의 맨 왼쪽으로 필터를 보내준다.
				   begin
				      a = unit_size*5/6;
				      c = 0;
				      b++;

				      if(b == (3*unit_size - 2*filter_height)) // 필터가 이미지의 끝에 도달하면 필터 사이즈를 키운다. (3번 filter -> 4번 filter)
					begin
					   a = (4*unit_size)/3;
					   b = 0;
		       			   filter_width = filter_width*4/3;
					   filter_height = filter_width/6;
					   eye_size = filter_width/5;
					   filter = 4;
					end
				   end 
			      end 

			    else if(filter == 4)   	//4번 size의 filter일 때
			      begin
				 if(a == (7*unit_size)/3)  // 오른쪽 끝에 도달하면 다음 줄의 맨 왼쪽으로 보낸다.
				   begin
				      a = (4*unit_size)/3;
				      c = 0;
				      b++;

				      if(b == (3*unit_size - 2*filter_height)) // 필터가 이미지의 끝에 도달하면 필터 사이즈를 키운다. (4번 filter -> 5번 filter)
					begin
					   a = (11*unit_size)/6;
					   b = 0;
		        		   filter_width = filter_width*5/4;
					   filter_height = filter_width/6;
					   eye_size = filter_width/5;
					   filter = 5;
					end
				   end 
			      end 

			    else if(filter == 5)   	//5번 size의 filter일 때
			      begin
				 if(a == (7*unit_size)/3)   // 오른쪽 끝에 도달하면 다음 줄의 맨 왼쪽으로 보낸다.
				   begin
				      a = (11*unit_size)/6;
				      c = 0;
				      b++;

				      if(b == (3*unit_size - 2*filter_height))	// 필터가 이미지 끝에 도달하면 필터 사이즈를 키운다. (5번 filter -> 5번 filter)
					begin
					   a = (7*unit_size)/3 -1;
					   b = 0;
					   filter_width = filter_width*6/5 -1;
					   filter_height = filter_width/6;
					   eye_size = filter_width/5;
					   filter = 6;
					end
				   end 
			      end 

			    else if(filter == 6)		// 6번 size의 filter일 때 가장 큰 사이즈의 filter는 가로의 길이가 코어의 한 변의 길이와 같아서 오른쪽으로 움직이지 않고, 아래 방향으로 한 칸 씩 내려간다.
			      begin
				 if(a == (7*unit_size)/3)
				   begin
				      a = (7*unit_size)/3 -1;
				      c = 0;
				      b++;
				      
				      if(b == (3*unit_size - 2*filter_height)) 	// 필터가 이미지의 맨 끝에 도달했다면 모든 필터링을 완료한 것이다.
					begin
					   start = 0;				// start = 0으로 만들어 필터링을 그만한다.
					   $writememh("core23_out.txt",face_address,0,core_size-1); // 얼굴이 검출 된 부분만 1로 표시한 face_address를 txt에 저장하여 내보낸다. 이후 단계에서 "core_out.txt"를 가지고 1로 채워진 부분만 픽셀값을 255로 바꿔서 흰색 사각형을 만들어 낼 것이다.
					end				      
				   end
			      end 
			 end 
		    end 
	       end 
	  end 
     end 
endmodule 
