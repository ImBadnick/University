module register(output reg [N:0] out, input [N:0] in, input clock);

parameter N=8;


always @ (posedge clock)
  begin
     out<=in;
  end


endmodule // registeoutput
