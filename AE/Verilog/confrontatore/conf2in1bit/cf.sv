module conf(output z, input [0:1]x);

  assign
    z=(~x[0] & ~x[1]) | (x[0] & x[1]);

endmodule
