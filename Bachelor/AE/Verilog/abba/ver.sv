module ver(output z, input [1:0]x, input clock);

wire [1:0]out1;
wire [1:0]out2;

sigma sig(out1, x, out2);
registro s(out2,out1, 1'b1, clock);
omega omg(z, x, out2);

endmodule
