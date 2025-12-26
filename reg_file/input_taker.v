module input_taker (
    input clock, store,
    output reg write_enable, 
    output reg [2:0] write_register
);

reg [4:0] state;

parameter IDLE = 
parameter S1   = 
parameter S2   = 
parameter S3   = 
parameter S4   = 
parameter S5   = 
parameter S6   = 
parameter S7   = 
parameter S8   = 

// output block
always @* begin

    out_data <= in_data;

    case(state)
        IDLE: 
        S1: 
        S2:
        S3:
        S4:
        S5:
        S6:
        S7:
        S8:
end



// state updater block
always @(posedge clock or posedge reset) begin
    if (reset)
        state <= IDLE;
    else begin
        case(state)
            IDLE:
                if(store)
                    state <= S1;
            S1:
                if(store)
                    state <= S2;
            S2:
                if(store)
                    state <= S3;
            S3:
                if(store)
                    state <= S3;
            S4:
                if(store)
                    state <= S4;
            S5:
                if(store)
                    state <= S5;
            S6:
                if(store)
                    state <= S6;
            S7:
                if(store)
                    state <= S7;
            S8:
                if(store)
                    state <= IDLE;
        endcase
    end
end


// state machine that takes inputs and stores them as posedge of store is detected

endmodule