module omega(output z, input [1:0]x, input [1:0]s);

assign
  z=(s[1] & ~s[0]) | (~x[1] & ~x[0]);

endmodule
