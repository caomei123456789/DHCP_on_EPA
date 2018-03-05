/*******************************************************************
File name   			:	write_emib.v
Function    			:	1.write  data from mm to emib module
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  write_emib 
		(
		input wire i_clk,
		input wire i_rst_n,
		
//		input wire [15:0]  dobjid,
//		input wire [15:0]  subidx,		
		
		input wire i_wr_en,
		input wire i_error,
		input wire [`RAM_WIDTH-1:0] i_mm_to_emib_data,
		input wire [`ADDR_SZ-1:0] i_mm_data_len,

		input wire i_wr_ram_en,
		
		input wire [`RAM_WIDTH-1:0] i_opc_to_emib_data,
		input wire [`ADDR_SZ-1:0] i_opc_data_len,	
	
		input wire 	[`ADDR_SZ-1:0] i_base_addr,
		input wire 	[`ADDR_SZ-1:0] i_offset_addr,
		
		output reg [`RAM_WIDTH-1:0] o_emib_data,
		output wire  [`ADDR_SZ-1:0] o_emib_addr,
		output wire o_wr_en,
		output reg o_write_error,
		output reg o_write_done,
		output reg o_config_done
);


reg [3:0] State,Nextstate;

reg [`ADDR_SZ-1:0] ptr_write,ptr_write_ram;

reg [`RAM_WIDTH-1:0] mm_to_emib_data_temp1;

reg  [`ADDR_SZ-1:0] emib_wr_address;

reg wr_ram_en, wr_en ;

wire i_opc_error;

parameter IDLE = 4'b000;
parameter WRITE_EMIB = 4'b001;
parameter WRITE_DONE = 4'b010;
parameter JUGE_ERR = 4'b011;
parameter WRITE_ERR = 3'b100;
parameter WRITE_FRT_LINK = 4'b101;
parameter JUGE_OPC_ERR= 4'b110;
parameter WAIT1= 4'b111;
parameter WAIT2= 4'b1000;
parameter WAIT3= 4'b1001;
parameter WRITE_CONFIG_DONE = 4'b1010;

assign o_emib_addr = wr_ram_en ? emib_wr_address:( i_base_addr + i_offset_addr+ emib_wr_address );

assign i_opc_error = 1'b0;
assign o_wr_en = wr_ram_en | wr_en;

always @(posedge i_clk )
begin
	mm_to_emib_data_temp1 <= i_mm_to_emib_data;
end 


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	State <= 2'b0 ;
	end
	else
	begin
	State <= Nextstate ;
	end
end


always @(*)
begin
	if(!i_rst_n)
	begin
	Nextstate = IDLE;
	end
	else 
	case(State)
	IDLE:
		begin
		if(i_wr_en)
		Nextstate =  JUGE_ERR;
		else if(i_wr_ram_en)                 
		Nextstate =  JUGE_OPC_ERR;
		else
		Nextstate = IDLE;		
		end
	JUGE_ERR:                          //judge error or not
		begin	
		if(!i_error)
			Nextstate = WRITE_EMIB;
		else 
			Nextstate = WRITE_ERR;
		end
	JUGE_OPC_ERR:                          
		begin	
		if(!i_opc_error)
			Nextstate = WRITE_FRT_LINK;
		else 
			Nextstate = WRITE_ERR;
		end	
	WRITE_EMIB:                      // write emib 
		begin
		if(ptr_write >= i_mm_data_len )
		Nextstate = WRITE_DONE;
		else
		Nextstate = WRITE_EMIB;		
		end	
	WRITE_FRT_LINK:                        
		begin
		if(ptr_write_ram >= i_opc_data_len + `ADDR_SZ'd492)
		Nextstate = WRITE_CONFIG_DONE;
		else
		Nextstate = WRITE_FRT_LINK;		
		end	
	WRITE_DONE,WRITE_CONFIG_DONE:                   //write finish
		Nextstate = WAIT1;	
	WRITE_ERR:                   //write error
		Nextstate = WAIT1;	
	WAIT1:
		Nextstate = WAIT2;	
	WAIT2:
		Nextstate = WAIT3;	
	WAIT3:
		Nextstate = IDLE;	
	default:
		Nextstate = IDLE;		
	endcase
end




always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		wr_en <= 1'b0;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b0 ;	
		o_write_done <= 1'b0;
		o_config_done <= 1'b0;
	end
	else
	case(Nextstate)	
	IDLE,JUGE_ERR:
		begin
		wr_en <= 1'b0;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b0;
		o_config_done <= 1'b0;
		end
	WRITE_EMIB:
		begin
		wr_en <= 1'b1;
		wr_ram_en <= 1'b0;
		o_emib_data<= mm_to_emib_data_temp1; 
		emib_wr_address <= ptr_write ;
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b0;
		o_config_done <= 1'b0;
		end	
	WRITE_FRT_LINK:
		begin
		wr_ram_en <= 1'b1;
		wr_en <= 1'b0;
		o_emib_data<= i_opc_to_emib_data; 
		emib_wr_address <= ptr_write_ram ;
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b0;
		o_config_done <= 1'b0;
		end		
	WRITE_DONE:
		begin
		wr_en <= 1'b0;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b1;
	   o_config_done <= 1'b0;	
		end
	WRITE_CONFIG_DONE:
		begin
		wr_en <= 1'b0;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b0;	
		o_config_done <= 1'b1;
		end
	WAIT1,WAIT2,WAIT3:	
		begin
		wr_en <= 1'b0;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b0;	
		o_config_done <= 1'b1;
		end	
	WRITE_ERR:
		begin
		wr_en <= 1'b0 ;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b1 ;
		o_write_done <= 1'b0;
		o_config_done <= 1'b0;
		end
	default:
		begin
		wr_en <= 1'b0;
		wr_ram_en <= 1'b0;
		o_emib_data<=`RAM_WIDTH'b0; 
		emib_wr_address	<= `ADDR_SZ'b0;	
		o_write_error <= 1'b0 ;
		o_write_done <= 1'b0;
		o_config_done <= 1'b0;
		end	
	endcase
end



/****************generate write emib address*********************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	ptr_write <= `ADDR_SZ'b0 ;
	end
	else if((Nextstate == WRITE_EMIB)&&(ptr_write < i_mm_data_len))
	begin
	ptr_write <= ptr_write + 1'b1;
	end
	else
	begin
	ptr_write <= `ADDR_SZ'b0 ;
	end
end
/*************************end***********************************/


/****************generate write emib address*********************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	ptr_write_ram <= `ADDR_SZ'd492 ;
	end
	else if((Nextstate == WRITE_FRT_LINK)&&(ptr_write_ram < `ADDR_SZ'd492 + i_opc_data_len))
	begin
	ptr_write_ram <= ptr_write_ram + 1'b1;
	end
	else
	begin
	ptr_write_ram <= `ADDR_SZ'd492 ;
	end
end
/*************************end***********************************/

endmodule
