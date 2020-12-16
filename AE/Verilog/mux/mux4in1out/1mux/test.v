module test();

reg x,y,z,w;
reg [1:0]ic;

wire out;

mux4 mymux(out,x,y,z,w,ic);

initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;

    x=1; y=0; z=0; w=0; ic[0]=0; ic[1]=0;

    #5
    x=0; y=0; z=1; w=0; ic[0]=1; ic[1]=1;
    #5
    w=1;

    #3 $finish;
  end
endmodule
