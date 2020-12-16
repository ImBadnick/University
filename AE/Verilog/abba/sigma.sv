module sigma (output [1:0]w, input [1:0]x, input [1:0]s);

  assign
    w[0]=(s[1] & ~x[0] & x[1]);
  assign
  w[1]=(~s[0] & x[1]) | (~s[0] & s[1] & ~x[0]) | (s[1] & ~x[1]);

endmodule
