module registro(output reg[1:0] stato, input [1:0] inval, input enable, input clock);
initial
  begin
    stato=0;
  end

  always @(posedge clock)
    begin
      if(enable)
        stato<=inval;
    end
endmodule
