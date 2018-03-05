/*************************************************************
File name   :mii_mdc.v
Function    :generate the clock signal for MDC
Author      :tongqing
Version     :V1.0
**************************************************************/	
module mii_mdc
(input wire i_clk,
 input wire i_rst_n,
 input [6:0] i_divider,
 //input wire i_mdc_en,
 output reg o_mdc
);

reg [5:0] count;
wire [6:0] count_resetNum;
/********************************
set the reset value of  counter
********************************/
assign count_resetNum = (i_divider>>1);

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        count <= 6'h1; 
    end
    else if(count < count_resetNum)
    begin
        count <= count + 1'b1;
    end
    else 
    begin
        count <= 6'h1;
    end
end
/***********************************************
generate the MDC according to the count_resetNum
************************************************/
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        o_mdc <= 1'b0;
    end
    else if (count == count_resetNum)
    begin
        o_mdc <= ~o_mdc;
    end
end

endmodule

