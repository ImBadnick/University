module mul4(output [N:0]z, input [N:0]x, input clock);

  parameter N=8;

  wire [N:0] mul2int;
  wire [N:0] outreg;
  reg  [N:0] in;

  mul2 #(N) m1(mul2int,x);
  mul2 #(N) m2(z,mul2int);

  

endmodule // mul4
