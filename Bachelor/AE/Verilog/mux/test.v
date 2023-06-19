module test();

reg [1:0] in;
reg ic;
wire out;

mux mymux(out,in[0],in[1],ic);

initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;

    in[0]=1;
    in[1]=0;
    ic=0;

    #5 $finish;
  end
endmodule
