module omega(output z, input x, input state);

assign z = (~x && ~state) || (x && state);

endmodule