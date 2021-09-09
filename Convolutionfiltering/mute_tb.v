`timescale 1ns/1ns
`include "mute_convol.v"
`include "mute_acc.v"
`include "mute_core.v"
`include "mute_memory.v"
`include "mute_cpu.v"

module mute_tb;
   reg clk,reset;
   reg [16:0] row,column;
   wire       end_cpu;
   wire [16:0] next_row,next_column;


   mute_cpu i0(clk,reset,row,column,end_cpu,next_row,next_column);

   always
     begin
	#1 clk=~clk;
     end
   

   initial
     begin
	$dumpfile("mute_tb.vcd");
	$dumpvars(0,mute_tb);

	clk = 0;
	reset = 1;
	row = 210;


	column = 240;

	#13

	  reset = 0;

	#300000 $finish;
     end // initial begin
endmodule // mute_tb
