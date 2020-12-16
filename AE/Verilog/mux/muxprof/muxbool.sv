module mux(output logic z, input logic x, y, ic);

   assign
     z = ((~ic) & x) | (ic & y);
   
endmodule
