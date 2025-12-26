module state_machine(
    input clock, reset, input_signal,
    input clock_47hz,
    output reg [4:0] DATA,
    output reg another_output
);

reg [3:0] state;
reg [3:0] next_state;

reg [7:0] counter;

parameter IDLE = 4'b0000;
parameter S1   = 4'b0001;
parameter S2   = 4'b0010;
parameter S3   = 4'b0100;
parameter S4   = 4'b1000;

// make a counter with the 47hz clock, and use it to blink an ledwithin states
always @(posedge clock_47hz or posedge reset) begin
    if (reset == 1'b1)
        counter <= 0;
    else
        begin
            counter <= counter + 1'b1;
            if(counter == 8'd15)
                counter <= 0;
        end
end



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
                begin
                    DATA = 5'b1_1111;
                    another_output = 1'b0;
                end

            S1:
                begin
                    DATA = 5'b0_0001;
                    another_output = (counter > 8'd10) ? 1'b1 : 1'b0;
                end

            S2:
                begin
                    DATA = 5'b0_0011;
                    another_output = (counter > 8'd10) ? 1'b1 : 1'b0;
                end

            S3:
                begin
                    DATA = 5'b0_0111;
                    another_output = (counter > 8'd10) ? 1'b1 : 1'b0;
                end

            S4: 
                begin
                    DATA = 5'b0_1111;
                    another_output = (counter > 8'd10) ? 1'b1 : 1'b0;
                end
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