module test();

reg [7:0] x;
wire z;
integer i;


pow2 mypow(z,x);

initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;

    x[0]=0;
    x[1]=1;
    for (i=2;i<9;i++)
     begin
      x[i]=0;
     end

    #5
    x[6]=1;

    #5
    x[1]=0;

    #5
    x[7]=1;
      
    #5
    x[7]=0;
    x[0]=1;
    x[6]=0;    
 
    #5
    x[0]=0;
    #20 $finish;

  end
endmodule
