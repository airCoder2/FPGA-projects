module nor_latch(input set, reset, output out, not_out);


    assign not_out = ~(set | out);
    assign out = ~(reset | not_out);
    
endmodule


    