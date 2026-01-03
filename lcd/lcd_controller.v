module lcd_controler (
    input clock, reset,
    input data_from_fifo[7:0],
    input fifo_full,
    input fifo_empty,
    output fifo_data_read,
    output reg [0..7] DATA,
    output LCD_EN, LCD_ON, LCD_RS, LCD_RW   
);

reg [21:0] cnt_reg; // the count for controlling the E signal
reg [7:0] input_count; // the count of how many times DATA has been written, I reset after initialization
reg [7:0] fsm_data_out; // the output of the FSM that goes to mux 
reg [1:0] state_reg; // the state of the FSM, (lcd_idle, lcd_init, lcd_print)
reg [1:0] s1, s2; // the mux control signals (s1 -> DATA path mux, s2 -> cnt_reg mux)


assign LCD_RW = 0; // ground RW because we only write and never read, too much headache to deal with the busy flag


localparam [2:0]      idle          = 0,
					  lcd_init      = 1,
					  lcd_print     = 2,
                      lcd_new_line  = 3,
                      lcd_backspace = 4;

					  

//State Machine, Next State Logic
always@(posedge clock) begin
    if(reset)
		state_reg <= idle;

	case(state_reg)
        idle: begin // idle state
			if(start)
				state_reg <= lcd_init;
			else
				state_reg <= idle;
        end
				
        lcd_init: begin // initialization step
			if(input_count == 3 && cnt_reg == 3550000)
				state_reg <= lcd_print;
			else 
				state_reg <= lcd_init;
		end	
        
        lcd_print: begin 

            // if I reach the end of two lines, then start over
            if(input_count == 32)
                state_reg <= lcd_init;

            // whenever I get a new line from fifo, or I reach end of the lcd
            // line, I transiton to a state that takes care of making a new
            // line
            else if(data_from_fifo == 8'hXX or input_count == 16)
                state_reg <= lcd_new_line;

            // if the data from fifo was a backspace, I go to state that takes
            // care of that and transitions back
            else if(data_from_fifo == 8'hXX)
                state_reg <= lcd_backspace;

            // if none were true, then stay in the current state
            else
                state_reg <= lcd_print;
        end

        lcd_new_line: begin
			if(cnt_reg == 3550000) // this state only needs one instruction, so when counter reaches that, should be good
				state_reg <= lcd_print;
			else 
				state_reg <= lcd_new_line;
        end

        lcd_backspace: begin
            // TODO
        end

		 default:
				state_reg <= idle;
		endcase
end



//Output Logic oc the state machine, (ONLY LCD_INIT IS DONE UP TO NOW)
always @*
begin
		case(state_reg)
            idle: begin
                s1 = 0;
                s2 = 2;
                RS = 0;
                E = 0;
                fifo_data_read = 0;
            end

            lcd_init: begin
                case(input_count)
                    0:
                        fsm_data_out = 8'h38; 
                    1:
                        fsm_data_out = 8'06; 
                    2: 
                        fsm_data_out = 8'h0C; 
                    3: 
                        fsm_data_out = 8'h01; 
                endcase

                s1 = 0; // in initialization, make the data come through FSM not FIFO
                s2 = 1; // increase the counter by 1, each clock cycle
                RS = 0; // set RS to 0, since this is an instruction
                E = 0;  // set the enable pin to 0 initially
                fifo_data_read = 0; // do not read any data from fifo when initializing 

                if (cnt_reg >= 500000) // after some time passes, make E = HIGH
                    E = 1;
                else if (cnt_reg >= 3400000) // after the another time passes, make E = LOW
                    E = 0;
                else if (cnt_reg == 3550000) begin // when timer reaches this number, reset the counter
                    input_count = input_count + 1; // input_count is the count of how many different DATA has been registered
                    s2 = 2; // reset the counter
                end
            end

            lcd_print: begin

                s1 = 1; // in print mode, data comes from FIFO
                s2 = 1; // increase the counter by one
                RS = 1; // set RS to 1, since this is a character
                E = 0;  // set the enable pin to 0 initially
                fifo_data_read = 0; // initially set it to 0 

                if (fifo_empty == 1)
                    s2 = 0; // if fifo is empty do not increase the counter 
                if (cnt_reg >= 500000) // after some time passes, make E = HIGH
                    E = 1;
                else if (cnt_reg >= 3400000) // after the another time passes, make E = LOW
                    E = 0;
                else if (cnt_reg == 3550000) begin // when timer reaches this number, counter is reset below
                    // input_count is the count of how many different DATA has been registered
                    fifo_data_read = 1; // get to the next data in fifo
                    s2 = 2; // reset the counter after each letter, to start a new cycle
            end

            lcd_new_line: begin
                s1 = 0; // when making a new line mode, data comes from FSM
                s2 = 1; // increase the counter by one
                RS = 0; // set RS to 0, since this is an instruction
                E = 0;  // set the enable pin to 0 initially
                fifo_data_read = 0; // initially set it to 0 
                fsm_data_out = 8'hXX; // TODO Instruction for the new line

                if (cnt_reg >= 500000) // after some time passes, make E = HIGH
                    E = 1;
                else if (cnt_reg >= 3400000) // after the another time passes, make E = LOW
                    E = 0;
                else if (cnt_reg == 3550000) begin
                    s2 = 2; // reset the counter after after the instruction

            end
		endcase
end

always@(posedge clock) begin
    if (cnt_reg == 3550000) begin
        case(state_reg)
            lcd_init: begin
                input_count <= input_count + 1;
                if (input_count == 3) // this is weird, if it does not work you can suspect from this if block
                    input_count <= 0;
            end

            lcd_print: input_count = input_count + 1;
            lcd_new_line: input_count = 20; // it was 19 before the new line, with enter it is 20
            lcd_backspace: 
    end
end



// the MUX for the counter
always @(posedge clock) begin
    if (reset)
        cnt_reg = 0;
    case(s2)
        0:
            cnt_reg = cnt_reg;
        1:
            cnt_reg = cnt_reg + 1;
        2:
            cnt_reg = 0;
    endcase
end

// the MUX for the data path
always @* begin
    if     (s1 == 0)
        DATA = fsm_data_out;
    else if(s1 == 1)
        DATA = data_from_fifo;
end
