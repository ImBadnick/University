module confrontatore(output z, input [2:0]x, input [2:0]y);

  assign
  #2 z= (x==y ? 1 : 0);

endmodule
