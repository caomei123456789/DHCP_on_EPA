/*******************************************************************
File name   			:	bus_select.v
Function    			:	1.selcet the bus between extern interface and ram
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/


`include "../master_rtl/define/define.v"
module  bus_select(
/***********global input  signals*************/
		input  wire i_clk,
		input  wire i_rst_n,
/***********frt index  signals*****************/		
		input  wire  i_frt_rd_ram_en,
		input wire [`ADDR_SZ-1:0]   i_frt_emib_addr_out,
		output  reg  [15:0] o_frt_emib_data,		
		
/*************read emib signals*************/		
		input  wire  i_rd_en_out,		
		input  wire [`ADDR_SZ-1:0]  i_emib_rd_address,
		output reg [15:0]   o_emib_rd_data,
		
/************write emib signals***************/
		
		input  wire  i_wr_en_out,
		input wire [`ADDR_SZ-1:0]   i_emib_wr_address,
		input  wire [15:0]  i_emib_wr_data,
		
/************flash interface signals**************/

		input wire  [`ADDR_SZ-1:0] i_flash_raddr,
		input wire   i_flash_rd_en,
		output reg  [15:0] o_flash_data,
		
		input wire [`ADDR_SZ-1:0] i_flash_waddr,
		input wire [15:0] i_flash_data,	
		input wire i_flash_wr_en,
		
/************commen data signals******************/		
		input wire   i_commen_rd_en_out ,
		input wire [`ADDR_SZ-1:0] i_commen_emib_addr_out ,
		output reg  [15:0] o_commen_data ,
		
/***********emib RAM signals************/		
		output reg [`ADDR_SZ-1:0] o_rd_ram_addr,
 		output reg [`ADDR_SZ-1:0] o_wr_ram_addr,
		input  wire [15:0] i_ram_data_out,
		output reg [15:0] o_ram_data,	
		output reg  o_rd_en,
		output reg  o_wr_en
		
);

reg [2:0] State,Nextstate;
reg i_flash_rd_en_dly1,i_flash_rd_en_dly2;
reg i_rd_en_out_dly1,i_rd_en_out_dly2;
reg i_frt_rd_ram_en_dly1,i_frt_rd_ram_en_dly2;
reg i_commen_rd_en_out_dly1,i_commen_rd_en_out_dly2;

//reg [`ADDR_SZ-1:0] i_flash_waddr_dly1;        //modified by SYF 2013.10.24
//reg [15:0] i_flash_data_dly1;	

parameter IDLE = 3'b000;
parameter READ_FLASH = 3'b001;
parameter WRITE_FLASH = 3'b011;
parameter WRITE_EMIB = 3'b010;
parameter READ_EMIB = 3'b110;
parameter FRT_INDEX = 3'b111;
parameter READ_COMMEN_DATA = 3'b101;

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	i_flash_rd_en_dly1 <= 1'b0;
	i_flash_rd_en_dly2 <= 1'b0;
	
	i_rd_en_out_dly1 <= 1'b0;
	i_rd_en_out_dly2 <= 1'b0;
	
	i_frt_rd_ram_en_dly1 <= 1'b0;
	i_frt_rd_ram_en_dly2 <= 1'b0;
	
	i_commen_rd_en_out_dly1 <= 1'b0;
	i_commen_rd_en_out_dly2 <= 1'b0;
	
//	i_flash_waddr_dly1 <= `ADDR_SZ'b0;        //modified by SYF 2013.10.24
	end
	else
	begin
	i_flash_rd_en_dly1 <= i_flash_rd_en;
	i_flash_rd_en_dly2 <= i_flash_rd_en_dly1;
	
	i_rd_en_out_dly1 <= i_rd_en_out;
	i_rd_en_out_dly2 <= i_rd_en_out_dly1;
	
	i_frt_rd_ram_en_dly1 <= i_frt_rd_ram_en;
	i_frt_rd_ram_en_dly2 <= i_frt_rd_ram_en_dly1;
	
	i_commen_rd_en_out_dly1 <= i_commen_rd_en_out;
	i_commen_rd_en_out_dly2 <= i_commen_rd_en_out_dly1;
	
//	i_flash_waddr_dly1 <= i_flash_waddr;      //modified by SYF 2013.10.24
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_flash_data <= 16'h0 ;
	end
	else if(i_flash_rd_en_dly2)
	begin
	o_flash_data <= i_ram_data_out ;
	end
//	else
//	begin
//	o_flash_data <= 16'h0 ;
//	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_emib_rd_data <= 16'h0 ;
	end
	else if(i_rd_en_out_dly2)
	begin
	o_emib_rd_data <= i_ram_data_out ;
	end
	else
	begin
	o_emib_rd_data <= 16'h0 ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_emib_data <= 16'h0 ;
	end
	else if(i_frt_rd_ram_en_dly2)
	begin
	o_frt_emib_data <= i_ram_data_out ;
	end
	else
	begin
	o_frt_emib_data <= 16'h0 ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_commen_data <= 16'h0 ;
	end
	else if(i_commen_rd_en_out_dly2)
	begin
	o_commen_data <= i_ram_data_out ;
	end
	else
	begin
	o_commen_data <= 16'h0 ;
	end
end

//state1
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	State <= 3'b0 ;
	end
	else
	begin
	State <= Nextstate;
	end
end

//state2
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
		if(i_flash_wr_en)
		Nextstate =  READ_FLASH;  //bus select to read flash interface
		else	if(i_wr_en_out)
		Nextstate =  WRITE_EMIB;	//bus select to write emib interface
		else	if(i_flash_rd_en)
		Nextstate =  WRITE_FLASH;		//bus select to write flash interface
		else	if(i_rd_en_out)
		Nextstate =  READ_EMIB;	//bus select to read emib interface
		else	if(i_frt_rd_ram_en)
		Nextstate =  FRT_INDEX;	//bus select to frt index interface
		else if(i_commen_rd_en_out)
		Nextstate =  READ_COMMEN_DATA;	//bus select to read commen data interface		
		else
		Nextstate = IDLE;
		end
	READ_FLASH:
		begin
		if(i_flash_wr_en)
		Nextstate =  READ_FLASH;
		else
		Nextstate = IDLE;
		end	
	WRITE_FLASH:
		begin
		if(i_flash_rd_en)
		Nextstate =  WRITE_FLASH;
		else
		Nextstate = IDLE;
		end		
	WRITE_EMIB:
		begin
		if(i_wr_en_out)
		Nextstate =  WRITE_EMIB;
		else
		Nextstate = IDLE;
		end	
	READ_EMIB:
		begin
		if(i_rd_en_out)
		Nextstate =  READ_EMIB;
		else
		Nextstate = IDLE;
		end	
	FRT_INDEX:
		begin
		if(i_frt_rd_ram_en)
		Nextstate =  FRT_INDEX;
		else
		Nextstate = IDLE;
		end	
	READ_COMMEN_DATA:
		begin
		if(i_commen_rd_en_out)
		Nextstate =  READ_COMMEN_DATA;
		else
		Nextstate = IDLE;
		end	
	default:
		Nextstate = IDLE;			
	endcase
end	

//state3
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_rd_ram_addr <= `ADDR_SZ 'd000;
		o_wr_ram_addr <= `ADDR_SZ 'd000;	
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b0;
		o_wr_en  <= 1 'b0;	
	end
	else
	case(Nextstate)
	IDLE:
		begin
		o_rd_ram_addr <= `ADDR_SZ 'd000;
		o_wr_ram_addr <= `ADDR_SZ 'd000;	
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b0;
		o_wr_en  <= 1 'b0;	
		end
	READ_FLASH:
		begin
		o_rd_ram_addr <= `ADDR_SZ 'd000;
		o_wr_ram_addr <= i_flash_waddr;		//modified by SYF 2013.10.24
		o_ram_data  <= i_flash_data;
		o_rd_en  <= 1 'b0;
		o_wr_en  <= 1 'b1;	
		end	
	WRITE_FLASH:
		begin
		o_rd_ram_addr <= i_flash_raddr;
		o_wr_ram_addr <= `ADDR_SZ 'd000;
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b1;
		o_wr_en  <= 1 'b0;	
		end		
	WRITE_EMIB:
		begin
		o_rd_ram_addr <= `ADDR_SZ 'd000;
		o_wr_ram_addr <= i_emib_wr_address;
		o_ram_data  <= i_emib_wr_data;
		o_rd_en  <= 1 'b0;
		o_wr_en  <= 1 'b1;	
		end	
	READ_EMIB:
		begin
		o_rd_ram_addr <= i_emib_rd_address;
		o_wr_ram_addr <= `ADDR_SZ 'd000;
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b1;
		o_wr_en  <= 1 'b0;	
		end	
	FRT_INDEX:
		begin
		o_rd_ram_addr <= i_frt_emib_addr_out;
		o_wr_ram_addr <= `ADDR_SZ 'd000;	
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b1;
		o_wr_en  <= 1 'b0;	
		end	
	READ_COMMEN_DATA:
		begin
		o_rd_ram_addr <= i_commen_emib_addr_out;
		o_wr_ram_addr <= `ADDR_SZ 'd000;			
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b1;
		o_wr_en  <= 1 'b0;	
		end
	default:
		begin
		o_rd_ram_addr <= `ADDR_SZ 'd000;
		o_wr_ram_addr <= `ADDR_SZ 'd000;
		o_ram_data  <= 16 'd000;
		o_rd_en  <= 1 'b0;
		o_wr_en  <= 1 'b0;	
		end			
	endcase
end

endmodule 
