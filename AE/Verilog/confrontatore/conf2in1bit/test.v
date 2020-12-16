module test();


reg [0:1]x;
wire z;

conf myconf(z,x);

  initial
    begin
    $dumpfile("test.vcd");
    $dumpvars;

    x[0]=0; x[1]=0;

    #5
    x[0]=1;

    #5
    x[0]=1; x[1]=1;

    #5 $finish;

  end
endmodule
