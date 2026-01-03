
//State Machine, Next State Logic
always@(posedge clock) begin
    case(state_reg)
        lcd_init: begin // initialization step
			if(input_count == 3)
				state_reg <= lcd_print;
end


always@(posedge clock) begin
    if (cnt_reg == 3550000) 
        input_count <= input_count + 1;
    if (input_count == 3)
        input_count <= 0;
end
