/*******************************************************************
File name   			:	commen_data.v
Function    			:	1.output the commen data to other modules
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  plant_index(
		input  wire i_clk,
		input  wire i_rst_n,
		
		input wire i_plant_index_irq,
		input wire [47:0] i_plant_mac,
		input wire i_config_flag,
		output reg [31:0] o_plant_ip,
		output reg [31:0] o_plant_toffset,
		output reg [15:0] o_plant_datalen,
		output reg [15:0] o_plant_interval,        //Modified by SYF 2014.5.21
		output reg o_plant_index_done,
		output reg o_plant_index_error,
		
		input wire [`ADDR_SZ-1:0] i_emib_device_property_addr,   //Modified by SYF 2014.5.21
		input wire [15:0] i_ram_data,
		output reg [`ADDR_SZ-1:0] o_emib_addr,
		output reg o_rd_ram_en

);

reg [3:0] State,Nextstate;

parameter  IDLE                = 4'b0000;
parameter  JUDGE_ERROR         = 4'b0001;
parameter  GET_IP_H            = 4'b0010;
parameter  GET_IP_L            = 4'b0011;
parameter  GET_TIME_OFFSET_H   = 4'b0100;
parameter  GET_TIME_OFFSET_L   = 4'b0101;
parameter  GET_DATA_LEN        = 4'b0110;
parameter  GET_PLANT_INTERVAL  = 4'b0111;        //Modified by SYF 2014.5.21
parameter  GET_DONE            = 4'b1000;
parameter  GET_ERROR           = 4'b1001;



//state1
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	State <= IDLE;
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
	case(State)//
	IDLE:
		begin
		if(i_plant_index_irq && i_config_flag)
		//if(i_plant_index_irq)
		Nextstate = JUDGE_ERROR;
		else
		Nextstate = IDLE;			
		end	
	JUDGE_ERROR:
		begin
		if(i_plant_mac[7:0] > 8'h0 && i_plant_mac[7:0] < 8'hff)
      Nextstate = GET_IP_H;
		else
		Nextstate = GET_ERROR;
		end	
	GET_IP_H:                      
		begin
		Nextstate = GET_IP_L;      
		end
	GET_IP_L:                       
		begin
		Nextstate = GET_TIME_OFFSET_H;
		end	
	GET_TIME_OFFSET_H:                      
		begin
		Nextstate = GET_TIME_OFFSET_L;	
		end		
	GET_TIME_OFFSET_L:             
		begin
 		Nextstate = GET_DATA_LEN;	
		end	
	GET_DATA_LEN:         
		begin
 		Nextstate = GET_PLANT_INTERVAL;	//Modified by SYF 2014.5.21
		end
   GET_PLANT_INTERVAL:                 //Modified by SYF 2014.5.21
		begin
 		Nextstate = GET_DONE;	
		end	
	GET_DONE:  
		begin
		Nextstate = IDLE;			 
		end
	GET_ERROR:
	   begin
		Nextstate = IDLE;
		end
	default:
		Nextstate = IDLE;				
	endcase	
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_emib_addr <= i_emib_device_property_addr;        //Modified by SYF 2014.5.21   //`ADDR_SZ'h00;
	o_plant_index_done <= 1'b0 ;
	o_rd_ram_en <= 1'b0 ;
	o_plant_index_error <= 1'b0;	
	end
	else
	case(Nextstate)
	IDLE:
		begin
	   o_emib_addr <= i_emib_device_property_addr;     //Modified by SYF 2014.5.21   //`ADDR_SZ'h00;
		o_plant_index_done <= 1'b0;
		o_rd_ram_en <= 1'b0;
		o_plant_index_error <= 1'b0;	
		end	
	JUDGE_ERROR:
		begin
	   o_emib_addr <= i_emib_device_property_addr + (i_plant_mac[7:0]-8'b1)* 8'd9;     //Modified by SYF 2014.5.21   //`ADDR_SZ'h240 + {(i_plant_mac[7:0]-8'b1),3'b000};
		o_plant_index_done <= 1'b0;
		o_rd_ram_en <= 1'b1;
		o_plant_index_error <= 1'b0;	
		end
	GET_IP_H:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;       
		o_rd_ram_en <= 1'b1;
		end
	GET_IP_L:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd04;
		o_rd_ram_en <= 1'b1;
		end
	GET_TIME_OFFSET_H:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end	
	GET_TIME_OFFSET_L:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end
	GET_DATA_LEN:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;   //Modified by SYF 2014.5.21
		o_rd_ram_en <= 1'b1;
		end
	GET_PLANT_INTERVAL:                             //Modified by SYF 2014.5.21
		begin
		o_rd_ram_en <= 1'b1;
		end
	GET_DONE:
		begin
	   o_emib_addr <= i_emib_device_property_addr;  //Modified by SYF 2014.5.21   //`ADDR_SZ'h00;
		o_plant_index_done <= 1'b1;
		o_plant_index_error <= 1'b0;
		o_rd_ram_en <= 1'b0;
		end		
	GET_ERROR:
		begin
	   o_emib_addr <= i_emib_device_property_addr;  //Modified by SYF 2014.5.21   //`ADDR_SZ'h00;
		o_plant_index_done <= 1'b0;
		o_plant_index_error <= 1'b1;
		o_rd_ram_en <= 1'b0;
		end
	default:
		begin
	   o_emib_addr <= i_emib_device_property_addr;  //Modified by SYF 2014.5.21   //`ADDR_SZ'h00;
		o_plant_index_done <= 1'b0;
		o_plant_index_error <= 1'b1;		
		o_rd_ram_en <= 1'b0;
		end
	endcase
end



/******************output plant ip*************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_plant_ip <= 32'h0;
	end
	else if(State == GET_IP_H)
	begin
	o_plant_ip[31:16] <= i_ram_data;	
	end
	else if(State == GET_IP_L)
	begin
	o_plant_ip[15:0] <= i_ram_data;	
	end	
	else if(State == IDLE)
	begin
	o_plant_ip <= 32'h0;
	end	
end
/******************end***********************/


/***************output plant time offset ******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_plant_toffset <= 32'h0;
	end
	else if(State == GET_TIME_OFFSET_H)
	begin
	o_plant_toffset[31:16] <= i_ram_data;	
	end
	else if(State == GET_TIME_OFFSET_L)
	begin
	o_plant_toffset[15:0] <= i_ram_data;	
	end	
	else if(State == IDLE)
	begin
	o_plant_toffset <= 32'h0;
	end
	else
	begin
	o_plant_toffset <= o_plant_toffset;
	end	
end
/******************end***********************/


/***************output plant send data len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_plant_datalen <= 16'h0;
	end
	else if(State == GET_DATA_LEN)
	begin
	o_plant_datalen <= i_ram_data[15:1];	
	end
	else if(State == IDLE)
	begin
	o_plant_datalen <= 16'h0;
	end
	else
	begin
	o_plant_datalen <= o_plant_datalen;	
	end	
end
/******************end***********************/

/***************output plant interval ******************/   //Modified by SYF 2014.5.21
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_plant_interval <= 16'h0;
	end
	else if(State == GET_PLANT_INTERVAL)
	begin
	o_plant_interval <= i_ram_data[15:0];	
	end
	else if(State == IDLE)
	begin
	o_plant_interval <= 16'h0;
	end
	else
	begin
	o_plant_interval <= o_plant_interval;	
	end	
end
/******************end***********************/

endmodule 