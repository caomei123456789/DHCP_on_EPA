
/*******************************************************************
File name   			:	bus_convert.v
Function    			:	send select;
 
Version maintenance	:	caogang
Version     			:	V1.0
data        			:	2011-02-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
module  bus_convert(
			input wire i_clk,
			input wire i_rst_n,
			
			//wangkai0351 for DHCP
			input wire	i_DHCP_irq,
			input wire [9:0] i_DHCP_len,
			output wire o_DHCP_nxt_pkg,
			input wire [15:0]i_DHCP_data,
			output reg [9:0]o_DHCP_rd_addr,
			input wire [2:0]i_DHCP_port_select,
			
			//mcc
			input wire	i_mcc_irq,
			input wire [9:0] i_mcc_len,
			output wire o_mcc_nxt_pkg,
			input wire [15:0]i_mcc_data,
			output reg [9:0]o_mcc_rd_addr,
			input wire [2:0]i_mcc_port_select,
			
			//frt
			input wire	i_frt_irq,
			input wire [9:0] i_frt_len,
			output wire o_frt_nxt_pkg,
			input wire [15:0]i_frt_data,
			output reg [9:0]o_frt_rd_addr,
			input wire [2:0]i_frt_port_select,
			
			input wire	i_nfrt_irq,
			input wire [9:0] i_nfrt_len,
			input wire [15:0]i_nfrt_data,
			output reg [9:0]o_nfrt_rd_addr,
			//ptp_A
			input wire	i_ptp_irq_A,                     //Modified by SYF 2014.5.27
			input wire [9:0] i_ptp_len_A,                //Modified by SYF 2014.5.27
			output wire o_ptp_nxt_pkg_A,                 //Modified by SYF 2014.5.27
			input wire [15:0]i_ptp_data_A,               //Modified by SYF 2014.5.27
			output reg [9:0]o_ptp_rd_addr_A,             //Modified by SYF 2014.5.27
			input wire [2:0]i_ptp_port_select,
			
			//ptp_B
			input wire	i_ptp_irq_B,
			input wire [9:0] i_ptp_len_B,
			output wire o_ptp_nxt_pkg_B,
			input wire [15:0]i_ptp_data_B,
			output reg [9:0]o_ptp_rd_addr_B,
		
			//ptp_C
			input wire	i_ptp_irq_C,
			input wire [9:0] i_ptp_len_C,
			output wire o_ptp_nxt_pkg_C,
			input wire [15:0]i_ptp_data_C,
			output reg [9:0]o_ptp_rd_addr_C,

			//mm
			input wire	i_mm_irq,
			input wire [9:0] i_mm_len,
			output wire o_mm_nxt_pkg,
			input wire [15:0]i_mm_data,
			output reg [9:0]o_mm_rd_addr,
			input wire [2:0]i_mm_port_select,			
			
			
			//mac
			output reg o_mac_irq_A,                       //Modified by SYF 2014.5.27
			output reg [9:0]o_mac_len_A,                  //Modified by SYF 2014.5.27
			input wire i_mac_nxt_pkg_A,                   //Modified by SYF 2014.5.27
			output reg [15:0]o_mac_data_A,                //Modified by SYF 2014.5.27
			input wire [9:0]i_mac_rd_addr_A,              //Modified by SYF 2014.5.27
			output reg [2:0] o_mac_port_select,
			
			
			output reg o_mac_irq_B,
			output reg [9:0]o_mac_len_B,
			input wire i_mac_nxt_pkg_B,
			output reg [15:0]o_mac_data_B,
			input wire [9:0]i_mac_rd_addr_B,		
			
			output reg o_mac_irq_C,
			output reg [9:0]o_mac_len_C,
			input wire i_mac_nxt_pkg_C,
			output reg [15:0]o_mac_data_C,
			input wire [9:0]i_mac_rd_addr_C,		
			
			//sjj Nov_19th
			output reg sending_frt,
			output reg sending_mm,
			output reg sending_frt_B,
			output reg sending_mm_B,			
			output reg sending_ptp_A,             //Modified by SYF 2014.5.27
			output reg sending_ptp_B,
			output reg sending_mcc,
			output reg sending_mcc_B,              //Modified by SYF 2014.5.27
			output reg sending_DHCP,//wangkai0351 for DHCP
			output reg sending_DHCP_B//wangkai0351 for DHCP
			
			
			
					);
					
					
 
reg sending_nfrt_A;
reg sending_nfrt_B;
reg sending_nfrt_C;
	
reg sending_frt_C;
reg sending_ptp_C;
reg sending_mcc_C;
reg sending_DHCP_C;//wangkai0351 for DHCP

assign o_frt_nxt_pkg = i_mac_nxt_pkg_A;                  //Modified by SYF 2014.5.27
assign o_ptp_nxt_pkg_A = i_mac_nxt_pkg_A;                //Modified by SYF 2014.5.27
assign o_mm_nxt_pkg  = i_mac_nxt_pkg_A;                  //Modified by SYF 2014.5.27
assign o_arp_nxt_pkg  = i_mac_nxt_pkg_A;                 //Modified by SYF 2014.5.27
assign o_mcc_nxt_pkg  = i_mac_nxt_pkg_A;                 //Modified by SYF 2014.5.27
assign o_config_nxt_pkg  = i_mac_nxt_pkg_A;		         //Modified by SYF 2014.5.27
assign o_ptp_nxt_pkg_B = i_mac_nxt_pkg_B;
assign o_ptp_nxt_pkg_C = i_mac_nxt_pkg_C;
assign o_DHCP_nxt_pkg = i_mac_nxt_pkg_A;//wangkai0351 for DHCP

//cou shixu wangkai0351 for DHCP
// i_DHCP_data_backup;
//assign i_DHCP_data_backup = i_DHCP_data;
				
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
	end
/////////////////////////////////////////////////////////////////////////////////////////////
	else if(i_DHCP_irq)
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b1;//wangkai0351 for DHCP

		sending_DHCP_B<= 1'b1;
		sending_DHCP_C<= 1'b1;
		
	end
///////////////////////////////////////////////////////////////////////////////////////////////
	else if(i_frt_irq)
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b1;  
		sending_frt_B <= 1'b1;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b1;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end
	else if(i_nfrt_irq)
	begin	
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b1;
		sending_nfrt_B <= 1'b1;	
		
		sending_nfrt_C <= 1'b1;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end
	else if(i_ptp_irq_A)            //Modified by SYF 2014.5.27
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b1;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end	
	else if(i_ptp_irq_B)            //Modified by SYF 2014.5.27
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b1;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end
	else if(i_ptp_irq_C)            //Modified by SYF 2014.5.27
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b1;	
		sending_mcc_C <= 1'b0;

		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end
	else if(i_mm_irq)
	begin
		sending_mm  <= 1'b1;
		sending_mm_B  <= 1'b1;
		sending_mcc <= 1'b0;
		sending_mcc_B <= 1'b0;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end
	else if(i_mcc_irq)
	begin
		sending_mm  <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_mcc <= 1'b1;
		sending_mcc_B <= 1'b1;
		sending_ptp_A <= 1'b0;  
		sending_ptp_B <= 1'b0;
		sending_frt <= 1'b0;  
		sending_frt_B <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;	
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b1;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
		
	end
	
	else if(i_mac_nxt_pkg_A)              //Modified by SYF 2014.5.27
	begin
		sending_frt <= 1'b0;
		sending_ptp_A <= 1'b0;             //Modified by SYF 2014.5.27
		sending_mm  <= 1'b0;
		sending_mcc <= 1'b0;
		
		sending_frt_B <= 1'b0;
		sending_mm_B  <= 1'b0;
		sending_nfrt_A <= 1'b0;
		sending_nfrt_B <= 1'b0;
		
		sending_nfrt_C <= 1'b0;
		sending_frt_C <= 1'b0;
		sending_ptp_C <= 1'b0;	
		sending_mcc_C <= 1'b0;
		
		sending_DHCP <= 1'b0;//wangkai0351 for DHCP
		sending_DHCP_B<= 1'b0;
		sending_DHCP_C<= 1'b0;
		
	end	
end
			

			
always @(*)
begin
	if(!i_rst_n)
		begin
			o_mac_irq_A = 1'b0;             //Modified by SYF 2014.5.27
			o_mac_len_A = 10'h0;            //Modified by SYF 2014.5.27
			o_mac_data_A = 16'h0;           //Modified by SYF 2014.5.27
			
			o_mac_irq_B = 1'b0;
			o_mac_len_B = 10'h0;
			o_mac_data_B = 16'h0;			
			
			o_mac_port_select = 3'b0;
			o_frt_rd_addr = 10'h0;
			o_ptp_rd_addr_A = 10'h0;          //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;			
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP
			
		end
	
//////////////////////////////////////////////////////////////////////////
else if(sending_DHCP || sending_DHCP_B)
		begin
			o_mac_irq_A = i_DHCP_irq;           //
			o_mac_len_A = i_DHCP_len;           //
			o_mac_data_A = i_DHCP_data;         //
			
			o_mac_irq_B = i_DHCP_irq;           //
			o_mac_len_B = i_DHCP_len;           //
			o_mac_data_B = i_DHCP_data;			  //
		
			o_mac_irq_C = i_DHCP_irq;          
			o_mac_len_C = i_DHCP_len;           
			o_mac_data_C = i_DHCP_data;			  
			
			o_mac_port_select = i_DHCP_port_select;
			o_mcc_rd_addr = 10'h0;   //Modified by SYF 2014.5.27
			o_mm_rd_addr  = 10'h0;
			o_frt_rd_addr = 10'h0;
			o_ptp_rd_addr_A = 10'h0;           //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;
			o_DHCP_rd_addr = i_mac_rd_addr_A;//wangkai0351 for DHCP

		end	
//////////////////////////////////////////////////////////////////////////
	else if(sending_frt || sending_frt_B || sending_frt_C)
		begin
			o_mac_irq_A = i_frt_irq;                 //Modified by SYF 2014.5.27
			o_mac_len_A = i_frt_len;                 //Modified by SYF 2014.5.27
			o_mac_data_A = i_frt_data;               //Modified by SYF 2014.5.27
			
			o_mac_irq_B = i_frt_irq;
			o_mac_len_B = i_frt_len;
			o_mac_data_B = i_frt_data;		
			
			o_mac_irq_C = i_frt_irq;
			o_mac_len_C = i_frt_len;
			o_mac_data_C = i_frt_data;		
			
			o_mac_port_select = i_frt_port_select;
			
			o_frt_rd_addr = i_mac_rd_addr_A;              //Modified by SYF 2014.5.27
			
			o_ptp_rd_addr_A = 10'h0;                      //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end
		
		else if(sending_nfrt_A || sending_nfrt_B)
		begin
			o_mac_irq_A = i_nfrt_irq;                 //Modified by SYF 2014.5.27
			o_mac_len_A = i_nfrt_len;                 //Modified by SYF 2014.5.27
			o_mac_data_A = i_nfrt_data;               //Modified by SYF 2014.5.27
			
			o_mac_irq_B = i_nfrt_irq;
			o_mac_len_B = i_nfrt_len;
			o_mac_data_B = i_nfrt_data;			
			
			o_mac_irq_C = i_nfrt_irq;
			o_mac_len_C = i_nfrt_len;
			o_mac_data_C = i_nfrt_data;		
			
			o_nfrt_rd_addr = i_mac_rd_addr_A;              //Modified by SYF 2014.5.27
			
			o_ptp_rd_addr_A = 10'h0;                      //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end
		
	else if(sending_ptp_A)                                     //Modified by SYF 2014.5.27
		begin 
			o_mac_irq_A = i_ptp_irq_A;                           //Modified by SYF 2014.5.27
			o_mac_len_A = i_ptp_len_A;                           //Modified by SYF 2014.5.27
			o_mac_data_A = i_ptp_data_A;                         //Modified by SYF 2014.5.27
			o_mac_port_select = i_ptp_port_select;
			o_ptp_rd_addr_A = i_mac_rd_addr_A;                   //Modified by SYF 2014.5.27
			o_frt_rd_addr = 10'h0;
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end

	else if(sending_ptp_B)
		begin
			o_mac_irq_B = i_ptp_irq_B;
			o_mac_len_B = i_ptp_len_B;
			o_mac_data_B = i_ptp_data_B;
			o_mac_port_select = i_ptp_port_select;
			o_ptp_rd_addr_B = i_mac_rd_addr_B;
			o_frt_rd_addr = 10'h0;
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end		
		
	else if(sending_ptp_C)
		begin
			o_mac_irq_C = i_ptp_irq_C;
			o_mac_len_C = i_ptp_len_C;
			o_mac_data_C = i_ptp_data_C;
			o_mac_port_select = i_ptp_port_select;
			o_ptp_rd_addr_C = i_mac_rd_addr_C;
			o_frt_rd_addr = 10'h0;
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end
	else if(sending_mm || sending_mm_B)
		begin
			o_mac_irq_A = i_mm_irq;                   //Modified by SYF 2014.5.27
			o_mac_len_A = i_mm_len;                   //Modified by SYF 2014.5.27
			o_mac_data_A = i_mm_data;                 //Modified by SYF 2014.5.27
		
			o_mac_irq_B = i_mm_irq;
			o_mac_len_B = i_mm_len;
			o_mac_data_B = i_mm_data;		
			
			o_mac_port_select = i_mm_port_select;
			
			o_mm_rd_addr = i_mac_rd_addr_A;          //Modified by SYF 2014.5.27
			
			o_frt_rd_addr = 10'h0;
			o_ptp_rd_addr_A = 10'h0;                 //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;
			o_mcc_rd_addr = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end	
		
	else if(sending_mcc)
		begin
			o_mac_irq_A = i_mcc_irq;           //Modified by SYF 2014.5.27
			o_mac_len_A = i_mcc_len;           //Modified by SYF 2014.5.27
			o_mac_data_A = i_mcc_data;         //Modified by SYF 2014.5.27
			
			o_mac_irq_B = i_mcc_irq;           //Modified by SYF 2014.5.27
			o_mac_len_B = i_mcc_len;           //Modified by SYF 2014.5.27
			o_mac_data_B = i_mcc_data;			  //Modified by SYF 2014.5.27
			
			o_mac_irq_C = i_mcc_irq;           //Modified by SYF 2014.5.27
			o_mac_len_C = i_mcc_len;           //Modified by SYF 2014.5.27
			o_mac_data_C = i_mcc_data;			  //Modified by SYF 2014.5.27
			
			o_mac_port_select = i_mcc_port_select;
			o_mcc_rd_addr = i_mac_rd_addr_A;   //Modified by SYF 2014.5.27
			o_mm_rd_addr  = 10'h0;
			o_frt_rd_addr = 10'h0;
			o_ptp_rd_addr_A = 10'h0;           //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;
			o_DHCP_rd_addr = 10'h0;//wangkai0351 for DHCP

		end	
		
	else 
		begin
		   
			o_mac_irq_A = 1'b0;                   //Modified by SYF 2014.5.27
			o_mac_len_A = 10'h0;                  //Modified by SYF 2014.5.27
			o_mac_data_A = 16'h0;                 //Modified by SYF 2014.5.27
			
			o_mac_irq_B = 1'b0;
			o_mac_len_B = 10'h0;
			o_mac_data_B = 16'h0;
			
			o_mac_irq_C = 1'b0;
			o_mac_len_C = 10'h0;
			o_mac_data_C = 16'h0;
			
			o_mac_port_select = 3'b0;
			o_frt_rd_addr = 10'h0;
			
			o_ptp_rd_addr_A = 10'h0;              //Modified by SYF 2014.5.27
			o_ptp_rd_addr_B = 10'h0;			
			
			o_mm_rd_addr = 10'h0;
			o_mcc_rd_addr = 10'h0;
			
			o_DHCP_rd_addr = 10'h0;
		end
		
end

endmodule
