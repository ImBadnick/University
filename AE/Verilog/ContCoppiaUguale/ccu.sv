module ccu(output [7:0]z, input [2:0]x,input [2:0]y, input clk);


  wire [7:0] outreg;
  wire [7:0] inreg;
  wire inalu;
  wire [7:0] confalu;


  confrontatore myconf(inalu, x, y);
  registro #(0) s2 (confalu, inalu, clk, 1'b1);
  alu somm(inreg, outreg, inalu, 1'b1);
  registro #(7) s (outreg, inreg,clk,1'b1);
  omega om(z,outreg);


endmodule
