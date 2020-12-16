module test ();

parameter N=8;

reg [N:0] x;
wire [N:0] z;
reg clock;

mul4 #(N) m4(z,x,clock);

always begin
  clock=1;
  #2 clock=0;
end

initial begin
  $dumpfile("test.vcd");
  $dumpvars;

  x=2;
  #4
  x=4;
  #4
  x=8;
  #4
  $finish;
end

endmodule // test
