# Manycore

Face Detection과 Convolution Filtering을 할 수 있는 프로그램입니다.

TestImage가 제공되어 있고 (man.jpg)

verilog을 기반으로 한 emacs(v파일)과  python의 opencv을 통해 Visualization할 수 있습니다.
 
Linux 기반 manycore 이용시 
해당 모듈들과 Testbench, Image에 대한 txt을 업로딩한 뒤,

터미널에서 해당 모듈과 파일이 있는 공간에서 코드를 실행시키면 됩니다.

> iverilog -o integral_img_tb.vvp integral_img_tb.v

> vvp integral_img_tb.vvp

> gtkwave integral_img_tb.vcd

또한 결과로 -ls 문법을 통해 저장된 Detection 결과를 확인할 수 있습니다.

Window에서도 동일하게 실행가능합니다. 
