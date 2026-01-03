module delay_test (
    input clock, output led_out
);

    // clock frequency: 50/2^20 = 47.68

`define CLOCK_FREQ 47
`define TIME_DELAY 1

reg [31:0] count=0;

assign led_out = 1 && (count==`CLOCK_FREQ*`TIME_DELAY);

always @(posedge clock)
begin
   count <= count + 1'b1;
   if (count == (32'd47 * 32'd2)) begin
        count <= 1'b0;
   end
end
    
endmodule