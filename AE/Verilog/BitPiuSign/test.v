module test();

reg [7:0] x;
wire [2:0] z;

integer i;

bitsign mybit(z,x);

initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;

    for (i=1;i<8;i++)
      begin
        x[i]=0;
      end
      x[0]=1;

    #5
      x[5]=1;
      x[4]=1;

    #5
      x[5]=0;

    #5
      x[7]=1;

   #10 $finish;
  end
endmodule
