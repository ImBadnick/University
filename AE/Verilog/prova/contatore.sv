module contatore(output z, input x, input state, input clock);

wire outsigma;
wire outreg;

sigma sg(outsigma,x,outreg);
register rg(outreg,outsigma,clock,1'b1);
omega om(z,x,outreg);

endmodule