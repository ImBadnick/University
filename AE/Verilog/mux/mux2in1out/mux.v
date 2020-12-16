module mux (output z, input x, input y,input ic);

  assign
        z=(~ic & x ) | (ic & y);

endmodule
