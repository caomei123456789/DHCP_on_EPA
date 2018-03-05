module led_control
		(
			input wire i_clk,
			input wire i_rst_n,
			input [7:0] i_divider,
			input wire i_led_on,
			input wire i_led_flash,
			output reg o_led
		);

reg [31:0] cnt;

reg [7:0] count;
reg  clk_divider;

parameter  COUNTER = 32'd312500; 
/********************************
set the reset value of  counter
********************************/


always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
        count <= 8'h0; 
		  clk_divider <= 1'b0;
    end
    else if(count < i_divider)
    begin
        count <= count + 1'b1;
    end
    else 
    begin
        count <=  8'h0; 
		  clk_divider <= !clk_divider;
    end
end





always @ (posedge clk_divider,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        cnt <= 32'h0; 
    end
    else if(cnt < COUNTER)
    begin
        cnt <= cnt + 1'b1;
    end
    else 
    begin
        cnt <= 32'h0;
    end
end

always @ (posedge clk_divider,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
		  o_led <= 1'b0;
    end
    else if((i_led_flash)&&(cnt >= COUNTER))
    begin
		  o_led <= !o_led;
    end
	 else if(i_led_on && !i_led_flash)
	 begin
			o_led <= 1'b1;
	 end
	 else if(!i_led_flash && !i_led_on)
	 begin
			o_led <= 1'b0;
	 end
end





endmodule 