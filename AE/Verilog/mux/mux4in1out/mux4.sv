module mux4(output z, input [1:0]x, input [1:0]y, input [1:0]ic);

wire out1;
wire out2;

mux m1(out1,x[0],x[1],ic[1]);
mux m2(out2,y[0],y[1],ic[1]);
mux m3(z,out1,out2,ic[0]);

endmodule
