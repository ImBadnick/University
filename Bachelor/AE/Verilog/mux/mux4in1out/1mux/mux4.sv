module mux4(output out, input x,input y,input z,input w, input [1:0]ic);

  assign
    out=(~ic[0]&~ic[1]&x) | (~ic[0] & ic[1] & y) | (ic[0] & ~ic[1] & z) | (ic[0] & ic[1] & w);

endmodule
