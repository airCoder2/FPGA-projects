module mux8to1 (W, S, f);
    input [0:7] W;
    input [3:0] S;
    output reg f;
    always @(W, S)
        if (S == 0)
            f = W[0];
        else if (S == 1)
            f = W[1];
        else if (S == 2)
            f = W[2];
        else if (S == 3)
            f = W[3];
        else if (S == 4)
            f = W[4];
        else if (S == 5)
            f = W[5];
        else if (S == 6)
            f = W[6];
        else 
            f = W[7];
endmodule