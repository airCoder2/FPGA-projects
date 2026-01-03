module state_machine(
    input clock, reset, input_signal, // is 1.4 hz
    input clock_47hz, // 47hz
    input real_clock,
    output reg [7:0] DATA,
    output reg LCD_RW, output reg LCD_RS, output reg LCD_EN, output LCD_ON
);


reg [5:0] state;
reg [7:0] counter;
reg [7:0] next_count;
reg stop_counter;
reg [15:0] enable_active_timer;

assign LCD_EN = ~(enable_active_timer != 0);

always @(posedge real_clock) begin
    if(reset)
        enable_active_timer <= 0;
    else begin
        if (enable_active_timer != 0)
            enable_active_timer <= enable_active_timer - 1;
        else if (activate_enable)
            enable_active_timer <= 3000;
    end

end


parameter IDLE = 4'b0000;
parameter S1   = 4'b0001;
parameter S2   = 4'b0010;
parameter S3   = 4'b0100;
parameter S4   = 4'b1000;
parameter S5   = 4'b1001;
parameter S6   = 4'b1010;


assign LCD_ON = 1'b1;


always @(posedge clock_47hz or posedge stop_counter or posedge clock) begin 
    if (stop_counter == 1'b1)
        counter <= counter;
    else
        counter <= counter + 1'b1;

    if (clock == 1'b1) // reset when a new main clock pulse is recieved
        counter <= 1'b0;
end




// output
always @* begin
        LCD_RW = 1'b0;
        case(state)
            IDLE:
                begin
                    DATA = 8'b0000_0001;
                    LCD_RS = 1'b0;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end

                end
            S1:
                begin
                    DATA = 8'b0000_0001;
                    LCD_RS = 1'b0;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end

                end

            S2:
                begin
                    DATA = 8'b0000_0110;
                    LCD_RS = 1'b0;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end
                end

            S3:
                begin
                    DATA = 8'b0000_1111;
                    LCD_RS = 1'b0;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end
                end

            S4:
                begin
                    DATA = 8'b0011_1111;
                    LCD_RS = 1'b0;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end
                end

            S5: 
                begin
                    DATA = 8'b0100_1000;
                    LCD_RS = 1'b1;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end
                end
            S6: 
                begin
                    DATA = 8'b0100_1001;
                    LCD_RS = 1'b1;
                    if (counter < 8'd10) begin
                        LCD_EN = 1'b1;
                        stop_counter = 1'b0;
                    end
                    else begin
                        LCD_EN = 1'b0;
                        stop_counter = 1'b1;
                    end
                end
        endcase
end

// sequential posedge
always @(posedge clock or posedge reset) begin

    if (reset == 1'b1)
        state <= IDLE;
    else begin
        case(state)
            IDLE:
                if (input_signal == 1'b1)
                    state <= S1;
            S1:
                if (input_signal == 1'b1)
                    state <= S2;
            S2:
                if (input_signal == 1'b1)
                    state <= S3;
            S3:
                if (input_signal == 1'b1)
                    state <= S4;
            S4: 
                if (input_signal == 1'b1)
                    state <= S5;
            S5: 
                if (input_signal == 1'b1)
                    state <= S6;
            S6: 
                if (input_signal == 1'b1)
                    state <= IDLE;
        endcase
    end
end
endmodule