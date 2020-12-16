module test();

reg [1:0]x;
reg clock;
wire z;

ver v(z,x,clock);

initial
  clock=0;

always
  begin
    #2 clock = 1;
    #1 clock = 0;
  end

initial
 begin
  $dumpfile("test.vcd");
  $dumpvars;

  x=2'b00;
  #4 x=2'b01;
  #5 x=2'b01;
  #2 x=2'b00;
  end
endmodule
