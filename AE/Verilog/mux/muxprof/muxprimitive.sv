primitive mux(output  z, 
              input x,
	      input y, input ic);

   table
      1 ? 0 : 1;
      0 ? 0 : 0;
      ? 0 1 : 0;
      ? 1 1 : 1;
   endtable
   
      
   
endprimitive // mux

