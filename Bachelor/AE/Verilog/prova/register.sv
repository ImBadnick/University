module register(output out, input x, input clock, input enable);

reg outreg;

initial begin
    outreg = 0;
end

always @(posedge clock)
    begin
        if (enable) outreg<=x;
    end

assign out=outreg;

endmodule