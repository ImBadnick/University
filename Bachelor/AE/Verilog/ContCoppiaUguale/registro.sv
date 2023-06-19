module registro(output [7:0]s1, input [N:0]x, input clk, input enable);

  parameter N=2;

  reg [7:0] registroN;

  initial
    begin
      registroN=0;
    end

  always@(posedge clk)
    begin
      if(enable)
        registroN=x;
    end
  assign
    s1=registroN;
endmodule
