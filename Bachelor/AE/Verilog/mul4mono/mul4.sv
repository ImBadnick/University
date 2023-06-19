module mul4(output [N:0]z, input [N:0]x, input clock);

  parameter N=8;

  wire [N:0] mul2int;
  reg  [N:0] in;

  mul2 #(N) m1(mul2int,in);
  mul2 #(N) m2(z,mul2int);

  always @ (posedge clock)
  begin
    in<=x;
  end
endmodule // mul
