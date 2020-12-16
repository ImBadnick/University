module mux4(output logic z,
	    input logic [3:0] x,
	    input logic [0:1] ic);

   logic 		      k12k3;
   logic 		      k22k3;

   mux k1(k12k3,x[0],x[1],ic[0]);
   mux k2(k22k3,x[2],x[3],ic[0]);
   mux k3(z,k12k3,k22k3,ic[1]);
   
endmodule
