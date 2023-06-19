module test ();

parameter N=6;

reg [N:0] x;
wire [N:0] z;
reg enable;
reg clock;

mul4 #(N) m4(z,x,clock);

always begin
  #1 clock=1;
  #2 clock=0;
end

initial begin
  $dumpfile("test.vcd");
  $dumpvars;
  enable=1;
  clock=0;
  x=2;
  #3
  x=4;
  #3
  x=8;
  #3
  $finish;
end

endmodule // test
