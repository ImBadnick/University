module test();

reg [1:0] x;
reg [1:0] y;
reg [1:0] ic;
wire out;

mux4 mymux(out,x,y,ic);

initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;

    x[0]=1; x[1]=0; y[0]=0; y[1]=0;
    ic[0]=0; ic[1]=0;

    #5 ic[1]=1;

    #5 $finish;
  end
endmodule
