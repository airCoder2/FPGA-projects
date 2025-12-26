module fifo #(parameter fifo_depth = 16) (
    input clock,
    input reset, // active high
    input fifo_in_valid, // the fifo_in data is valid and is suppose to be entered into the fifo when this is active
    input [7:0] fifo_in, // enter into the fifo when fifo_in_valid
    input fifo_out_read, // consume fifo_out data
    output [7:0] fifo_out,
    output fifo_full,
    output fifo_empty // fifo is empty and the data is not valid
);

reg [7:0] fifo_storage [($clog(fifo_depth) - 1):0];
reg [($clog(fifo_depth) - 1):0] word_counter = 0;

integer i;

assign fifo_out = fifo_storage[0];

assign fifo_full = (word_counter == 15) ? 1 : 0;
assign fifo_empty = !(word_counter) ? 1 : 0;



always @(posedge clock, or posedge reset) begin

    if (reset) begin
        for (i = 0; i < word_counter; i = i + 1)
            fifo_storage[i] = 0; // reset everything
            
        // reset the counter as well.
        word_counter <= 0; 
    end

    else begin
        if (fifo_in_valid and !fifo_full) begin
            // take the data and put it to the last 
            fifo_storage[word_counter] = fifo_in;
            word_counter <= word_counter + 1;
        end


        if (fifo_out_read and !fifo_empty) begin
            // shift everything from up to one below using a for loop
            for (i = 0; i < word_counter - 1; i = i + 1)
                fifo_storage[i] = fifo_storage[i + 1];

            word_counter <= word_counter - 1;
        end

    end
end





endmodule;
