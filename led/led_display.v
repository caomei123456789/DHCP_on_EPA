module  led_display(
			input wire i_clk,
			input wire i_rst_n,
			input wire i_work_rdt,
			input wire i_dpram_valid,
			input wire i_csme_en,
			input wire i_cpu_err,
			output wire  LED_RUN,
			output wire LED_ERR,
			output wire LED_RDT
);


reg led_err_on,led_run_on ,led_rdt_on,led_err_flash,led_run_flash ,led_rdt_flash ;
reg [7:0] led_err_divider,led_run_divider,led_rdt_divider;






always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
			led_err_flash <= 1'b0;
			led_err_on <= 1'b0;
			led_err_divider <= 8'h1;
		end
		else if(i_cpu_err && i_dpram_valid)
		begin
			led_err_divider <= 8'd2;
			led_err_flash <= 1'b1;
			led_err_on <= 1'b0;
		end
		else if(!i_dpram_valid)
		begin
			led_err_divider <= 8'h1;
			led_err_flash <= 1'b0;
			led_err_on <= 1'b1;
		end
		else 
		begin
			led_err_divider <= 8'h1;
			led_err_flash <= 1'b0;
			led_err_on <= 1'b0;
		end
end



always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
			led_run_on <= 1'b0;
			led_run_divider <= 8'h1;
			led_run_flash <= 1'b1;
		end
		else if(i_csme_en)
		begin
			led_run_divider <= 8'd30;
			led_run_flash <= 1'b1;
			led_run_on <= 1'b0;
		end
		else
		begin
			led_run_divider <= 8'h1;
			led_run_on <= 1'b1;
			led_run_flash <= 1'b0;
		end
end


always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
			led_rdt_on <= 1'b0;
			led_rdt_flash <= 1'b0;
			led_rdt_divider <= 8'h1;
		end
		else if(!i_dpram_valid)
		begin
			led_rdt_divider <= 8'h2;
			led_rdt_on <= 1'b0;
			led_rdt_flash <= 1'b1;
		end
		else if(i_work_rdt)
		begin
			led_rdt_divider <= 8'd1;
			led_rdt_on <= 1'b1;
			led_rdt_flash <= 1'b0;
		end
		else
		begin
			led_rdt_divider <= 8'h15;
			led_rdt_on <= 1'b0;
			led_rdt_flash <= 1'b1;
		end		
end



led_control led_run
		(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_divider(led_run_divider),
			.i_led_on(led_run_on),
			.i_led_flash(led_run_flash),
			.o_led(LED_RUN)
		);


		
led_control led_err
		(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_divider(led_err_divider),
			.i_led_on(led_err_on),
			.i_led_flash(led_err_flash),
			.o_led(LED_ERR)
		);
		
		
led_control led_rdt
		(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_divider(led_rdt_divider),
			.i_led_on(led_rdt_on),
			.i_led_flash(led_rdt_flash),
			.o_led(LED_RDT)
		);


		
endmodule 