module state_machine(
    input clock, reset, input_signal,
    output reg [4:0] DATA
);

reg [3:0] state;
reg [3:0] next_state;

parameter IDLE = 4'b0000;
parameter S1   = 4'b0001;
parameter S2   = 4'b0010;
parameter S3   = 4'b0100;
parameter S4   = 4'b1000;

// next state Logic depends on current state, and input
always @* begin
        case(state)
            IDLE:
                if (input_signal == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;

            S1:
                if (input_signal == 1'b1)
                    next_state = S2;
                else
                    next_state = S1;

            S2:
                if (input_signal == 1'b1)
                    next_state = S3;
                else
                    next_state = S2;

            S3:
                if (input_signal == 1'b1)
                    next_state = S4;
                else
                    next_state = S3;

            S4: 
                if (input_signal == 1'b1)
                    next_state = IDLE;
                else
                    next_state = S4;
        endcase
end


// output
always @* begin
        case(state)
            IDLE:
                DATA = 5'b1_1111;

            S1:
                DATA = 5'b0_0001;

            S2:
                DATA = 5'b0_0011;

            S3:
                DATA = 5'b0_0111;

            S4: 
                DATA = 5'b0_1111;
        endcase
end



// sequential posedge
always @(posedge clock or posedge reset) begin

    if (reset == 1'b1)
        state <= IDLE;
    else
        state <= next_state;
end




endmodule