module mul2 (output [N:0]z, input [N:0]x);
  parameter N=8;

  assign #2 z=x*2;
endmodule
