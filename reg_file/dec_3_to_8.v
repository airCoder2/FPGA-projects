module dec_3_to_8 (W, En, Y);
    input [2:0] W;
    input En;
    output reg [7:0] Y;
    always @(W, En)
    begin
        if (En == 0)
            Y = 8'b00000000;
        else
            case (W)
                0: Y = 8'b00000001;
                1: Y = 8'b00000010;
                2: Y = 8'b00000100;
                3: Y = 8'b00001000;
                4: Y = 8'b00010000;
                5: Y = 8'b00100000;
                6: Y = 8'b01000000;
                7: Y = 8'b10000000;
            endcase
    end
endmodule