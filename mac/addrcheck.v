/*******************************************************************************
File name   :addrcheck.v
Function    :judge the MAC address,it is support unicast,Broadcast,and Multicast.
Author      :tongqing
Version     :V1.0
*******************************************************************************/	
module addrcheck
(input wire i_clk,
 input wire i_rst_n, 
 input wire [15:0] i_rx_data,
 input wire [9:0] i_wordNum,
 input wire i_recvDn,
 input wire i_data_valid,
 input wire i_csme_en,
 output wire o_recv_keep,
// input wire i_main_clock_lost,
// input wire i_main_clock_state,
// input wire i_start_en
input wire [47:0]i_local_node_mac
);

wire [47:0] frt_mac_n;
wire [47:0] frt_mac;
reg MulticastOK_FRT;

reg main_clock_state_dly;
reg start_en_dly;
//assign o_recv_keep = (i_wordNum < 10'h4) ? 1'b1 : (i_csme_en ? ((dst_mac == frt_mac) ? 1'b0 : 1'b1) : ((dst_mac == frt_mac_n) || (dst_mac == 48'hffffffffffff)? 1'b1 : 1'b0 ));
//assign frt_mac_n = 48'h01005e000182;	
//assign frt_mac = 48'h01005e000181;
assign o_recv_keep = 1'b1;//(i_wordNum < 10'h4)? 1'b1 : ( (dst_mac == i_local_node_mac) || (dst_mac == frt_mac) || (dst_mac == frt_mac_n )|| (dst_mac == 48'hffffffffffff)? 1'b1 : 1'b0 );
//assign frt_mac = (!i_csme_en || i_main_clock_lost)? 48'h01005e000181 : 48'h01005e000182;

//always @ (posedge i_clk , negedge i_rst_n)
//begin
//   if (!i_rst_n)
//   begin	
//		main_clock_state_dly <= 1'b0;
//		start_en_dly			<= 1'b0;
//	end
//	else
//	begin
//		main_clock_state_dly <= i_main_clock_state;
//		start_en_dly			<= i_start_en;
//	end
//end
//
//always @ (posedge i_clk , negedge i_rst_n)
//begin
//   if (!i_rst_n)
//		frt_mac <= 48'h01005e000181;
//	else if(i_start_en && !start_en_dly)
//		frt_mac <= 48'hffffffffffff;
//	else if(i_main_clock_lost && !i_main_clock_state)
//		frt_mac <= 48'h01005e000181;
//	else if(!i_main_clock_state && main_clock_state_dly)
//		frt_mac <= 48'h01005e000181;
//	else if(i_main_clock_state && !main_clock_state_dly)
//		frt_mac <= 48'hffffffffffff;
//end

/************************************************
				FRT
judge if the package's MAC address is Multicast 
**************************************************/
//always @ (posedge i_clk , negedge i_rst_n)
//begin
//    if (!i_rst_n)
//    begin
//        MulticastOK_FRT <= 1'b0;
//    end
//    else if ((i_wordNum == 10'h1) && i_data_valid )
//    begin 
//        MulticastOK_FRT <= (i_rx_data == frt_mac[47:32]);
//    end
//	    else if ((i_wordNum == 10'h2) && i_data_valid )
//    begin
//        MulticastOK_FRT <= (i_rx_data == frt_mac[31:16]) && MulticastOK_FRT;
//    end
//    else if ((i_wordNum == 10'h3) && i_data_valid )
//    begin
//        MulticastOK_FRT <= (i_rx_data == frt_mac[15:0]) && MulticastOK_FRT;
//    end
//    else if (i_recvDn)
//    begin
//        MulticastOK_FRT <= 1'b0;
//    end
//end
//
//endmodule


//
reg [47:0]dst_mac;
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        dst_mac <= 48'b0;
    end
    else if ((i_wordNum == 10'h1) && i_data_valid )
    begin 
        dst_mac[47:32] <= i_rx_data ;
    end
	    else if ((i_wordNum == 10'h2) && i_data_valid )
    begin
        dst_mac[31:16] <= i_rx_data ;
    end
    else if ((i_wordNum == 10'h3) && i_data_valid )
    begin
        dst_mac[15:0] <= i_rx_data ;
    end

end

endmodule
