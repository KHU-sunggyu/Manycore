module mute_acc(clk,reset,ain1,ain2,ain3,ain4,ain5,bin1,bin2,bin3,bin4,bin5,memory_turn,
		c_out);
   input clk,reset,memory_turn;           // 모드
   input [15:0] ain1,ain2,ain3,ain4,ain5,bin1,bin2,bin3,bin4,bin5;
   output signed [31:0] c_out;

   wire signed [15:0] 	ain1,ain2,ain3,ain4,ain5,bin1,bin2,bin3,bin4,bin5;
   wire 		mode, memory_turn;

   wire signed [31:0] 	cout_img11,cout_img12,cout_img13,cout_img14,cout_img15,
	                cout_img21,cout_img22,cout_img23,cout_img24,cout_img25,
	                cout_img31,cout_img32,cout_img33,cout_img34,cout_img35,
	                cout_img41,cout_img42,cout_img43,cout_img44,cout_img45,
	                cout_img51,cout_img52,cout_img53,cout_img54,cout_img55;
   
   wire signed [15:0] 	ain11,ain12,ain13,ain14, ain21,ain22,ain23,ain24,
	ain31,ain32,ain33,ain34, ain41,ain42,ain43,ain44, ain51,ain52,ain53,ain54,
        bin11,bin21,bin31,bin41, bin12,bin22,bin32,bin42, bin13,bin23,bin33,bin43,
	bin14,bin24,bin34,bin44, bin15,bin25,bin35,bin45;
   reg [15:0] 		ra_11,ra_12,ra_13,ra_14,ra_21,ra_22,ra_23,ra_24,
			ra_31,ra_32,ra_33,ra_34,
			ra_41,ra_42,ra_43,ra_44,ra_51,ra_52,ra_53,ra_54,
		    
			rb_11,rb_21,rb_31,rb_41,rb_12,rb_22,rb_32,rb_42,
			rb_13,rb_23,rb_33,rb_43,
			rb_14,rb_24,rb_34,rb_44,rb_15,rb_25,rb_35,rb_45;
   
   reg [64:0] 		counter;

   reg 			lock, first;
   reg signed [31:0] 	r_cout_img;
   wire 		rest_one_cycle;

   
   mute_convol i11(clk,reset,ain1, bin1,ain11,bin11,cout_img11,memory_turn);
   mute_convol i12(clk,reset,ra_11,bin2,ain12,bin12,cout_img12,memory_turn);
   mute_convol i13(clk,reset,ra_12,bin3,ain13,bin13,cout_img13,memory_turn);
   mute_convol i14(clk,reset,ra_13,bin4,ain14,bin14,cout_img14,memory_turn);
   mute_convol i15(clk,reset,ra_14,bin5,     ,bin15,cout_img15,memory_turn);

   mute_convol i21(clk,reset,ain2, rb_11,ain21,bin21,cout_img21,memory_turn);
   mute_convol i22(clk,reset,ra_21,rb_12,ain22,bin22,cout_img22,memory_turn);
   mute_convol i23(clk,reset,ra_22,rb_13,ain23,bin23,cout_img23,memory_turn);
   mute_convol i24(clk,reset,ra_23,rb_14,ain24,bin24,cout_img24,memory_turn);
   mute_convol i25(clk,reset,ra_24,rb_15,     ,bin25,cout_img25,memory_turn);

   mute_convol i31(clk,reset,ain3, rb_21,ain31,bin31,cout_img31,memory_turn);
   mute_convol i32(clk,reset,ra_31,rb_22,ain32,bin32,cout_img32,memory_turn);
   mute_convol i33(clk,reset,ra_32,rb_23,ain33,bin33,cout_img33,memory_turn);
   mute_convol i34(clk,reset,ra_33,rb_24,ain34,bin34,cout_img34,memory_turn);
   mute_convol i35(clk,reset,ra_34,rb_25,     ,bin35,cout_img35,memory_turn);

   mute_convol i41(clk,reset,ain4, rb_31,ain41,bin41,cout_img41,memory_turn);
   mute_convol i42(clk,reset,ra_41,rb_32,ain42,bin42,cout_img42,memory_turn);
   mute_convol i43(clk,reset,ra_42,rb_33,ain43,bin43,cout_img43,memory_turn);
   mute_convol i44(clk,reset,ra_43,rb_34,ain44,bin44,cout_img44,memory_turn);
   mute_convol i45(clk,reset,ra_44,rb_35,     ,bin45,cout_img45,memory_turn);
   
   mute_convol i51(clk,reset,ain5, rb_41,ain51,     ,cout_img51,memory_turn);
   mute_convol i52(clk,reset,ra_51,rb_42,ain52,     ,cout_img52,memory_turn);
   mute_convol i53(clk,reset,ra_52,rb_43,ain53,     ,cout_img53,memory_turn);
   mute_convol i54(clk,reset,ra_53,rb_44,ain54,     ,cout_img54,memory_turn);
   mute_convol i55(clk,reset,ra_54,rb_45,     ,     ,cout_img55,memory_turn);

   assign rest_one_cycle = (memory_turn==0)? 1:0;
   assign c_out = r_cout_img;
   
   always @ (negedge clk )
     begin
	if (reset)
	  begin
	     ra_11 <= 0;
	     ra_12 <= 0;
	     ra_13 <= 0;
	     ra_14 <= 0;
	     ra_21 <= 0;
	     ra_22 <= 0;
	     ra_23 <= 0;
	     ra_24 <= 0;
	     ra_31 <= 0;
	     ra_32 <= 0;
	     ra_33 <= 0;
	     ra_34 <= 0;         
	     ra_41 <= 0;
	     ra_42 <= 0;
	     ra_43 <= 0;
	     ra_44 <= 0;
	     ra_51 <= 0;
	     ra_52 <= 0;
	     ra_53 <= 0;
	     ra_54 <= 0;             
	     rb_11 <= 0;
	     rb_21 <= 0;
	     rb_31 <= 0;
	     rb_41 <= 0;
	     rb_12 <= 0;
	     rb_22 <= 0;
	     rb_32 <= 0;
	     rb_42 <= 0;
	     rb_13 <= 0;
	     rb_23 <= 0;
	     rb_33 <= 0;
	     rb_43 <= 0;             
	     rb_14 <= 0;
	     rb_24 <= 0;
	     rb_34 <= 0;
	     rb_44 <= 0;
	     rb_15 <= 0;
	     rb_25 <= 0;
	     rb_35 <= 0;
	     rb_45 <= 0;
	     counter <= 0;            
	     lock <= 0;
	     first <= 1;

	  end
	else
	  begin

	     if(rest_one_cycle == 1)
	       begin
		  ;
	       end
	     
	     else                  //이미지의 초반 5clk, 또는 행렬연산할때는  lock = 0;
	       begin
		  if(lock == 0)    //아직 필터값이 다 안들어왔을때.
		    begin
		       ra_54 = ra_53;
		       rb_45 = rb_35;

		       ra_53 = ra_52;
		       rb_44 = rb_34;

		       ra_44 = ra_43;
		       rb_35 = rb_25;

		       ra_52 = ra_51;
		       rb_43 = rb_33;

		       ra_43 = ra_42;
		       rb_34 = rb_24;

		       ra_34 = ra_33;
		       rb_25 = rb_15;


		       ra_51 = ain51;
		       rb_42 = rb_32;

		       ra_42 = ra_41;
		       rb_33 = rb_23;

		       ra_33 = ra_32;
		       rb_24 = rb_14;

		       ra_24 = ra_23;
		       rb_15 = bin15;

		       ra_41 = ain41;
		       rb_41 = rb_31;

		       ra_32 = ra_31;
		       rb_32 = rb_22;

		       ra_23 = ra_22;
		       rb_23 = rb_13;

		       ra_14 = ra_13;
		       rb_14 = bin14;

		       ra_31 = ain31;
		       rb_31 = rb_21;

		       ra_22 = ra_21;
		       rb_22 = rb_12;

		       ra_13 = ra_12;
		       rb_13 = bin13;

		       ra_21 = ain21;
		       rb_21 = rb_11;

		       ra_12 = ra_11;
		       rb_12 = bin12;

		       ra_11 = ain11;
		       rb_11 = bin11;
		    end // if (lock == 0)
		  else if (lock == 1)  //filter가 다 들어왔으면 lock 5clk이후임 b를 고정시킨다.
		    begin
		       
		       ra_54 = ra_53;
		       ra_53 = ra_52;
		       ra_44 = ra_43;
		       ra_52 = ra_51;
		       ra_43 = ra_42;
		       ra_34 = ra_33;
		       ra_51 = ain51;
		       ra_42 = ra_41;
		       ra_33 = ra_32;
		       ra_24 = ra_23;
		       ra_41 = ain41;
		       ra_32 = ra_31;
		       ra_23 = ra_22;
		       ra_14 = ra_13;
		       ra_31 = ain31;
		       ra_22 = ra_21;
		       ra_13 = ra_12;
		       ra_21 = ain21;
		       ra_12 = ra_11;
		       ra_11 = ain11;
		       
		    end
		  

		       if(counter>10)
			 begin
			    r_cout_img = cout_img11 + cout_img12 + cout_img13 + cout_img14 + cout_img15+
					  cout_img21 + cout_img22 + cout_img23 + cout_img24 + cout_img25+
					  cout_img31 + cout_img32 + cout_img33 + cout_img34 + cout_img35+
					  cout_img41 + cout_img42 + cout_img43 + cout_img44 + cout_img45+
					  cout_img51 + cout_img52 + cout_img53 + cout_img54 + cout_img55;
			    if(r_cout_img < 0)
			       
			      r_cout_img = 0;
			    
			    else if(r_cout_img > 255)
			       
			      r_cout_img = 255;
			    
			    
			 end
		       counter <= counter+1;
		       if(rb_41 != 0)
			 lock <= 1;

	       end // else: !if(rest_one_cycle == 1)
	  end // else: !if(reset)
     end // always @ (negedge clk)
endmodule // mute_acc







