module pow2(output z, input [7:0]x);

  assign
    #2 z=(~x[0]&~x[3]&~x[4]&~x[5]&~x[6]&~x[7]) | (~x[0]&~x[1]&~x[2]&~x[5]&~x[6]&~x[7])
      | (~x[0]&~x[1]&~x[2]&~x[3]&~x[4]&~x[7]) | (~x[1]&~x[2]&~x[3]&~x[4]&~x[5]&~x[6]);

endmodule
