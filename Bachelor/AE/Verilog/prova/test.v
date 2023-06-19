module test();

wire z;
reg x,state,clock;

integer i;

confrontatore conf(z,x,state,clock); 

always
    begin 
        #1 clock=0;
        #3 clock=1;
    end

initial
    begin
    $dumpfile("test.vcd");
    $dumpvars;
    
    x=0;
    state=0;

    for (i=0;i<10;i++)
        #4 x=~x;

    $finish;
    end


endmodule