module alu(output [7:0]z, input [7:0]x, input inalu, input ic);


  assign
  #2  z= (ic==1 ? x+inalu : x);

endmodule
