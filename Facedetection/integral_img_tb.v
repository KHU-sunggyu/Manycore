`timescale 1ns/1ns
`include "integral_img.v"
`include "core_1.v"
`include "core_2.v"
`include "core_3.v"
`include "core_4.v"
`include "core_5.v"
`include "core_6.v"
`include "core_7.v"
`include "core_8.v"
`include "core_9.v"
`include "core_10.v"
`include "core_11.v"
`include "core_12.v"
`include "core_13.v"
`include "core_14.v"
`include "core_15.v"
`include "core_16.v"
`include "core_17.v"
`include "core_18.v"
`include "core_19.v"
`include "core_20.v"
`include "core_21.v"
`include "core_22.v"
`include "core_23.v"
`include "core_24.v"
`include "core_25.v"
`include "core_26.v"
`include "core_27.v"
`include "core_28.v"
`include "core_29.v"
`include "core_30.v"
`include "core_31.v"
`include "core_32.v"
`include "core_33.v"
`include "core_34.v"
`include "core_35.v"
`include "core_36.v"
`include "img_sum.v"
`include "bbbox.v"

module integral_img_tb;
   
   reg clk,reset;
   reg [31:0] width, height;
   wire [31:0] size;
   wire        mode, out_signal, out_signal_2;
 

   integral_img i0(clk,reset, width, height, size, mode);
   core_1 i1(clk,reset, size, mode);
   core_2 i2(clk,reset, size, mode);
   core_3 i3(clk,reset, size, mode);
   core_4 i4(clk,reset, size, mode);
   core_5 i5(clk,reset, size, mode);
   core_6 i6(clk,reset, size, mode);
   core_7 i7(clk,reset, size, mode);
   core_8 i8(clk,reset, size, mode);
   core_9 i9(clk,reset, size, mode);
   core_10 i10(clk,reset, size, mode);
   core_11 i11(clk,reset, size, mode);
   core_12 i12(clk,reset, size, mode);
   core_13 i13(clk,reset, size, mode);
   core_14 i14(clk,reset, size, mode);
   core_15 i15(clk,reset, size, mode);
   core_16 i16(clk,reset, size, mode);
   core_17 i17(clk,reset, size, mode);
   core_18 i18(clk,reset, size, mode);
   core_19 i19(clk,reset, size, mode);
   core_20 i20(clk,reset, size, mode);
   core_21 i21(clk,reset, size, mode);
   core_22 i22(clk,reset, size, mode);
   core_23 i23(clk,reset, size, mode);
   core_24 i24(clk,reset, size, mode);
   core_25 i25(clk,reset, size, mode);
   core_26 i26(clk,reset, size, mode);
   core_27 i27(clk,reset, size, mode);   
   core_28 i28(clk,reset, size, mode);
   core_29 i29(clk,reset, size, mode);
   core_30 i30(clk,reset, size, mode);
   core_31 i31(clk,reset, size, mode);
   core_32 i32(clk,reset, size, mode);
   core_33 i33(clk,reset, size, mode);
   core_34 i34(clk,reset, size, mode);
   core_35 i35(clk,reset, size, mode);
   core_36 i36(clk,reset, size, mode, out_signal);

   img_sum z(clk, reset, size, out_signal,out_signal_2);
   bbbox b(reset, clk, height, width, out_signal_2);

   always	
     begin	
	#1 clk=~clk;
     end	
   initial
     begin
	$dumpfile("integral_img_tb.vcd");
	$dumpvars(0,integral_img_tb);
	
	clk=0;
	reset=1;
	width=240;
	height=210;
	
	#10
	  reset = 0;

	#1000000
	  $finish;
     end // initial beg
endmodule // integral_img_tb
