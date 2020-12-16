module test();

reg [2:0] x;
reg [2:0] y;
reg clk;
wire [7:0] z;

ccu myccu(z,x,y,clk);

initial
  clk=0;
    always
      begin
        #7 clk=1;
        #1 clk=0;
      end
    initial
      begin
        $dumpfile("test.vcd");
        $dumpvars;

        x[0]=0; x[1]=1; x[2]=0;
        y[0]=0; y[1]=1; y[2]=0;

      #7
        x[0]=1; x[1]=1; x[2]=0;
        y[0]=1; y[1]=1; y[2]=0;

      #5
          x[0]=1; x[1]=0; x[2]=0;
          y[0]=1; y[1]=1; y[2]=0;

      #7
      x[0]=1; x[1]=1; x[2]=0;
      y[0]=1; y[1]=1; y[2]=0;

      #7
        x[0]=0; x[1]=1; x[2]=0;
        y[0]=1; y[1]=1; y[2]=0;

        #7
          x[0]=1; x[1]=1; x[2]=0;
          y[0]=1; y[1]=1; y[2]=0;

      #10 $finish;
     end
endmodule
