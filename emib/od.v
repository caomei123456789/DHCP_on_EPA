
/*******************************************************************
File name   			:	od.v
Function    			:	1.output base  address and offset address of data access to objid and subidx
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  od 
		(
		input  i_clk,
		input  i_rst_n,
		input  [15:0]  i_dobjid,
		input  [15:0]  i_subidx,
		input  [15:0]  i_frt_linknum_up,                         //modified by SYF 2014.5.20
		input  [15:0]  i_frt_linknum_down,                       //modified by SYF 2014.5.20
		input  [15:0]  i_frt_linknum_net_up,                     //modified by SYF 2014.5.20
		input  [15:0]  i_frt_linknum_net_down,                   //modified by SYF 2014.5.20
		input  [15:0]  i_device_num_up,                          //modified by SYF 2014.5.20
		input  [15:0]  i_device_num_down,                        //modified by SYF 2014.5.20
		output reg [`ADDR_SZ-1:0]  o_base_addr,
		output reg [`ADDR_SZ-1:0]  o_offset_addr,
		output reg [`ADDR_SZ-1:0]  o_offset_len,
		output reg o_error
//		output reg [3:0] subid_num
);


reg [`ADDR_SZ-1:0] base_addr_fix;
reg [`ADDR_SZ-1:0] base_addr_appobj;
reg [`ADDR_SZ-1:0] base_addr_linkobj;

wire [`ADDR_SZ-1:0] base_addr_linkobj_temp1,base_addr_linkobj_temp2,base_addr_linkobj_temp3,base_addr_linkobj_temp4,base_addr_linkobj_temp5,base_addr_linkobj_temp6;


reg [`ADDR_SZ-1:0] offset_addr0,offset_addr1,offset_addr2,offset_addr3,offset_addr4,offset_addr5;
reg [`ADDR_SZ-1:0] offset_addr6,offset_addr9,offset_addr10,offset_addr11 ;
reg [`ADDR_SZ-1:0] offset_addr12,offset_addr13,offset_addr14,offset_addr15,offset_addr16;
reg [`ADDR_SZ-1:0] offset_addr17,offset_addr18,offset_addr19,offset_addr20,offset_addr21,offset_addr22;

reg [`ADDR_SZ-1:0] o_offset_len0,o_offset_len1,o_offset_len2,o_offset_len3,o_offset_len4,o_offset_len5;
reg [`ADDR_SZ-1:0] o_offset_len6,o_offset_len9,o_offset_len10,o_offset_len11;
reg [`ADDR_SZ-1:0] o_offset_len12,o_offset_len13,o_offset_len14,o_offset_len15,o_offset_len16;
reg [`ADDR_SZ-1:0] o_offset_len17,o_offset_len18,o_offset_len19,o_offset_len20,o_offset_len21,o_offset_len22;

parameter EMIB_All = 16'h0;                         //Modified by SYF 2014.4.13
parameter EMIB_Header = 16'h1;
parameter EPA_Device_Decriptor = 16'h2;
parameter Clock_Sync = 16'h3;
parameter Max_RSP_TIme = 16'h4;
parameter Commulation_Sche_Management = 16'h5;
parameter Device_App_Info = 16'h6;
parameter FB_App_info_Header = 16'h7;
parameter Link_Object_Header = 16'h8;
parameter Domain_Application_Obj_Header = 16'h9;
parameter FRT_Link_obj_Header_Local_Up = 16'ha;
parameter FRT_Link_obj_Header_Net_Up =16'hb;
parameter Device_Properties_Header_Up=16'hc;
parameter FRT_Link_obj_Header_Local_Down=16'hd;
parameter FRT_Link_obj_Header_Net_Down=16'he;
parameter Device_Properties_Header_Down=16'hf;



/*************calculator the base address**************************/
 
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		base_addr_fix <= `ADDR_SZ'h0fff;
//		subid_num <= 4'h0;
	end
	else if(i_dobjid >= 16'd6000)
	begin
	   base_addr_fix <= `ADDR_SZ'h0fff;
	end
	else
	case(i_dobjid)
	EMIB_All:                                        //Modified by SYF 2014.4.13
	   begin
		base_addr_fix <= `ADDR_SZ'd0000;
		end
	EMIB_Header:
		begin
		base_addr_fix <= `ADDR_SZ'd0000;
//		subid_num <= 4'd2;
		end
	EPA_Device_Decriptor:
		begin
		base_addr_fix <= `ADDR_SZ'd002;
//		subid_num <= 4'd15;	
		end
	Clock_Sync:
		begin
		base_addr_fix <= `ADDR_SZ'd054;
//		subid_num <= 4'd10;
		end	
	Max_RSP_TIme:
		begin
		base_addr_fix <= `ADDR_SZ'd75;
//		subid_num <= 4'd3;
		end	
	Commulation_Sche_Management:
		begin
		base_addr_fix <= `ADDR_SZ'd079;	
//		subid_num <= 4'd7;
		end
	Device_App_Info:
		begin
		base_addr_fix <= `ADDR_SZ'd0103;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0101; 
//		subid_num <= 4'd2;
		end	
	FB_App_info_Header:
		begin
		base_addr_fix <= `ADDR_SZ'd105;         //Modified by SYF 201.5.22   //`ADDR_SZ'd103; 
//		subid_num <= 4'd5;
		end	
	Link_Object_Header:
		begin
		base_addr_fix <= `ADDR_SZ'd108;	       //Modified by SYF 201.5.22   //`ADDR_SZ'd106;
//		subid_num <= 4'h6;
		end
	Domain_Application_Obj_Header:
		begin
		base_addr_fix <= `ADDR_SZ'd0113;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0111;
//		subid_num <= 4'h5;
		end	
	FRT_Link_obj_Header_Local_Up:
		begin
		base_addr_fix <= `ADDR_SZ'd0118;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0116; 
//		subid_num <= 4'h5;
		end	
	FRT_Link_obj_Header_Net_Up:
		begin
		base_addr_fix <= `ADDR_SZ'd0123;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0121;
//		subid_num <= 4'h5;
		end	
	Device_Properties_Header_Up:
		begin
		base_addr_fix <= `ADDR_SZ'd0128;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0126;
//		subid_num <= 4'h5;
		end	
	FRT_Link_obj_Header_Local_Down:
		begin
		base_addr_fix <= `ADDR_SZ'd0131;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0129;
//		subid_num <= 4'h5;
		end
	FRT_Link_obj_Header_Net_Down:
		begin
		base_addr_fix <= `ADDR_SZ'd0136;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0134; 
//		subid_num <= 4'h5;
		end	
	Device_Properties_Header_Down:
		begin
		base_addr_fix <= `ADDR_SZ'd0141;        //Modified by SYF 201.5.22   //`ADDR_SZ'd0139;
//		subid_num <= 4'h5;
		end	
	default:
		begin
		base_addr_fix <= `ADDR_SZ'h0fff;	      
//		subid_num <= 4'h0;
		end	
	endcase
end

//assign  base_addr_linkobj_temp = (i_dobjid-16'd6000)<<2'h3+(i_dobjid-16'd6000)<<2'h1;
//assign  base_addr_linkobj_temp = (i_dobjid-16'd6000)*4'd7;
assign  base_addr_linkobj_temp1 = {(i_dobjid-16'd6000),3'b000};                 //Modified by SYF 2014.4.13
assign  base_addr_linkobj_temp2 = {(i_dobjid-16'd7000),2'b00};                  //{(i_dobjid-16'd7000),3'b000};  //Modified by SYF 2014.5.20
assign  base_addr_linkobj_temp3 = (i_dobjid-16'd8000)*4'd9;                     //{(i_dobjid-16'd8000),3'b000};  //Modified by SYF 2014.5.20
assign  base_addr_linkobj_temp4 = {(i_dobjid-16'd9000),3'b000};                 //Modified by SYF 2014.4.13
assign  base_addr_linkobj_temp5 = {(i_dobjid-16'd10000),2'b00};                 //{(i_dobjid-16'd10000),3'b000}; //Modified by SYF 2014.5.20
assign  base_addr_linkobj_temp6 = (i_dobjid-16'd11000)*4'd9;                    //{(i_dobjid-16'd11000),3'b000}; //Modified by SYF 2014.5.20

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	base_addr_linkobj <= `ADDR_SZ'd0000;
	end
	else if(i_dobjid >= 16'd6000 && i_dobjid <= 16'd6999)                          //Modified by SYF 2014.4.13
	begin
	base_addr_linkobj <= base_addr_linkobj_temp1[`ADDR_SZ-1:0] + `ADDR_SZ'h100;
	end
	else if(i_dobjid >= 16'd7000 && i_dobjid <= 16'd7999)
	begin
   base_addr_linkobj <= base_addr_linkobj_temp2[`ADDR_SZ-1:0] + `ADDR_SZ'h300;
	end
	else if(i_dobjid >= 16'd8000 && i_dobjid <= 16'd8999)
	begin
	base_addr_linkobj <= base_addr_linkobj_temp3[`ADDR_SZ-1:0] + `ADDR_SZ'h400;
	end
	else if(i_dobjid >= 16'd9000 && i_dobjid <= 16'd9999)
	begin
   base_addr_linkobj <= base_addr_linkobj_temp4[`ADDR_SZ-1:0] + `ADDR_SZ'h600;
	end
	else if(i_dobjid >= 16'd10000 && i_dobjid <= 16'd10999)
	begin
	base_addr_linkobj <= base_addr_linkobj_temp5[`ADDR_SZ-1:0] + `ADDR_SZ'h800;
	end
	else if(i_dobjid >= 16'd11000 && i_dobjid <= 16'd11999)
	begin
   base_addr_linkobj <= base_addr_linkobj_temp6[`ADDR_SZ-1:0] + `ADDR_SZ'h900;
	end
	else
	begin
	base_addr_linkobj <= `ADDR_SZ'h0fff;
	end		
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	o_base_addr <= `ADDR_SZ'h0;	
	else 
	o_base_addr <= base_addr_fix & base_addr_linkobj;
end


/*****************************end************************************/

/*************calculator the offset address**************************/

/*************calculator the EMIB_All offset address**************************/     //modified by SYF 2013.10.16
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr0 <= `ADDR_SZ'd0000;
	o_offset_len0 <= `ADDR_SZ'h00;
	end
	else if(i_dobjid == EMIB_All)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr0 <= `ADDR_SZ'd0000;
		o_offset_len0 <= `ADDR_SZ'd144;		//Modified by SYF 2014.5.22  //`ADDR_SZ'd142;
		end
	default:
		begin
		offset_addr0 <= `ADDR_SZ'h0fff;
		o_offset_len0 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
		offset_addr0 <= `ADDR_SZ'd0000;
		o_offset_len0 <= `ADDR_SZ'd0;	
	end
end

/*****************************end************************************/


/*************calculator the EMIB_Header offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr1 <= `ADDR_SZ'd0000;
	o_offset_len1 <= `ADDR_SZ'h00;
	end
	else if(i_dobjid == EMIB_Header)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr1 <= `ADDR_SZ'd0000;
		o_offset_len1 <= `ADDR_SZ'd2;		
		end
	16'h1:  
		begin
		offset_addr1 <= `ADDR_SZ'd0000;
		o_offset_len1 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr1 <= `ADDR_SZ'd0001;
		o_offset_len1 <= `ADDR_SZ'd1;	
		end
	default:
		begin
		offset_addr1 <= `ADDR_SZ'h0fff;
		o_offset_len1 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
		offset_addr1 <= `ADDR_SZ'd0000;
		o_offset_len1 <= `ADDR_SZ'd0;	
	end
end

/*****************************end************************************/

/*************calculator the EPA_Device_Decriptor offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr2 <= `ADDR_SZ'd0000;
	o_offset_len2 <= `ADDR_SZ'h00;
	end
	else if(i_dobjid == EPA_Device_Decriptor)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr2 <= `ADDR_SZ'd0000;
		o_offset_len2 <= `ADDR_SZ'd52;		
		end
	16'h1:  
		begin
		offset_addr2 <= `ADDR_SZ'd0000;
		o_offset_len2 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr2 <= `ADDR_SZ'd0001;
		o_offset_len2 <= `ADDR_SZ'd1;
		end	
	16'h3:  
		begin
		offset_addr2 <= `ADDR_SZ'd0002;
		o_offset_len2 <= `ADDR_SZ'd16;
		end
	16'h4:	
		begin
		offset_addr2 <= `ADDR_SZ'd0018;
		o_offset_len2 <= `ADDR_SZ'd16;
		end	
	16'h5:  
		begin
		offset_addr2 <= `ADDR_SZ'd0034;
		o_offset_len2 <= `ADDR_SZ'd2;
		end
	16'h6:	
		begin
		offset_addr2 <= `ADDR_SZ'd0036;
		o_offset_len2 <= `ADDR_SZ'd2;
		end	
	16'h7:  
		begin
		offset_addr2 <= `ADDR_SZ'd0038;
		o_offset_len2 <= `ADDR_SZ'd2;
		end
	16'h8:	
		begin
		offset_addr2 <= `ADDR_SZ'd0040;
		o_offset_len2 <= `ADDR_SZ'd2;
		end	
	16'h9:  
		begin
		offset_addr2 <= `ADDR_SZ'd0042;
		o_offset_len2 <= `ADDR_SZ'd3;
		end
	16'ha:	
		begin
		offset_addr2 <= `ADDR_SZ'd0045;
		o_offset_len2 <= `ADDR_SZ'd1;
		end
	16'hb:  
		begin
		offset_addr2 <= `ADDR_SZ'd0046;
		o_offset_len2 <= `ADDR_SZ'd2;
		end
	16'hc:	
		begin
		offset_addr2 <= `ADDR_SZ'd0048;
		o_offset_len2 <= `ADDR_SZ'd1;
		end
	16'hd:  
		begin
		offset_addr2 <= `ADDR_SZ'd0049;
		o_offset_len2 <= `ADDR_SZ'd1;
		end
	16'he:	
		begin
		offset_addr2 <= `ADDR_SZ'd0050;
		o_offset_len2 <= `ADDR_SZ'd1;
		end		
	16'hf:	
		begin
		offset_addr2 <= `ADDR_SZ'd0051;
		o_offset_len2 <= `ADDR_SZ'd1;
		end	
	default:
		begin
		offset_addr2 <= `ADDR_SZ'h0fff;
		o_offset_len2 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
		offset_addr2 <= `ADDR_SZ'd0000;
		o_offset_len2 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/

/*************calculator the Clock_Sync offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr3 <= `ADDR_SZ'd0000;
	o_offset_len3 <= `ADDR_SZ'h00;
	end
	else if(i_dobjid == Clock_Sync)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr3 <= `ADDR_SZ'd0000;
		o_offset_len3 <= `ADDR_SZ'd21;		
		end
	16'h1:  
		begin
		offset_addr3 <= `ADDR_SZ'd0000;
		o_offset_len3 <= `ADDR_SZ'd1;		
		end
	16'h2:	
		begin
		offset_addr3 <= `ADDR_SZ'd0001;
		o_offset_len3 <= `ADDR_SZ'd1;
		end	
	16'h3:  
		begin
		offset_addr3 <= `ADDR_SZ'd0002;
		o_offset_len3 <= `ADDR_SZ'd2;
		end	
	16'h4:	
		begin
		offset_addr3 <= `ADDR_SZ'd0004;
		o_offset_len3 <= `ADDR_SZ'd2;
		end	
	16'h5:  
		begin
		offset_addr3 <= `ADDR_SZ'd006;
		o_offset_len3 <= `ADDR_SZ'd2;
		end	
	16'h6:	
		begin
		offset_addr3 <= `ADDR_SZ'd008;
		o_offset_len3 <= `ADDR_SZ'd2;
		end	
	16'h7: 
		begin
		offset_addr3 <= `ADDR_SZ'd0010;
		o_offset_len3 <= `ADDR_SZ'd2;
		end	
	16'h8:	
		begin
		offset_addr3 <= `ADDR_SZ'd0012;
		o_offset_len3 <= `ADDR_SZ'd2;	
		end
	16'h9:  
		begin
		offset_addr3 <= `ADDR_SZ'd0014;
		o_offset_len3 <= `ADDR_SZ'd4;
		end
	16'ha:	
		begin
		offset_addr3 <= `ADDR_SZ'd0018;
		o_offset_len3 <= `ADDR_SZ'd3;
		end						
	default:
		begin
		offset_addr3 <= `ADDR_SZ'h0fff;
		o_offset_len3 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr3 <= `ADDR_SZ'd0000;
	o_offset_len3 <= `ADDR_SZ'd0;	
	end
end

/*****************************end************************************/




/*************calculator the Max_RSP_TIme offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr4 <= `ADDR_SZ'd0000;
	o_offset_len4 <= `ADDR_SZ'h00;
	end
	else if(i_dobjid == Max_RSP_TIme)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr4 <= `ADDR_SZ'd0000;
		o_offset_len4 <= `ADDR_SZ'd4;		
		end
	16'h1:  
		begin
		offset_addr4 <= `ADDR_SZ'd0000;
		o_offset_len4 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr4 <= `ADDR_SZ'd0001;
		o_offset_len4 <= `ADDR_SZ'd1;
		end	
	16'h3:	
		begin
		offset_addr4 <= `ADDR_SZ'd0002;
		o_offset_len4 <= `ADDR_SZ'd2;
		end	
	default:
		begin
		offset_addr4 <= `ADDR_SZ'h0fff;
		o_offset_len4 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr4 <= `ADDR_SZ'd0000;
	o_offset_len4 <= `ADDR_SZ'd0;		
	end
end

/*****************************end************************************/


/*************calculator the Commulation_Sche_Management offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr5 <= `ADDR_SZ'd0000;
	o_offset_len5 <= `ADDR_SZ'h00;		
	end
	else if(i_dobjid == Commulation_Sche_Management)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr5 <= `ADDR_SZ'd0000;
		o_offset_len5 <= `ADDR_SZ'd24;    //Modified by SYF 2014.5.22
		end
	16'h1:  
		begin
		offset_addr5 <= `ADDR_SZ'd0000;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h2:	
		begin
		offset_addr5 <= `ADDR_SZ'd0001;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end	
	16'h3:  
		begin
		offset_addr5 <= `ADDR_SZ'd0002;
		o_offset_len5 <= `ADDR_SZ'd2;			
		end
	16'h4:	
		begin
		offset_addr5 <= `ADDR_SZ'd0004;
		o_offset_len5 <= `ADDR_SZ'd2;			
		end
	16'h5:  
		begin
		offset_addr5 <= `ADDR_SZ'd006;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h6:	
		begin
		offset_addr5 <= `ADDR_SZ'd007;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h7:  
		begin
		offset_addr5 <= `ADDR_SZ'd008;
		o_offset_len5 <= `ADDR_SZ'd2;			
		end
	16'h8:  
		begin
		offset_addr5 <= `ADDR_SZ'd010;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h9:  
		begin
		offset_addr5 <= `ADDR_SZ'd011;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'ha:  
		begin
		offset_addr5 <= `ADDR_SZ'd012;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'hb:                             //Modified by SYF 2014.5.22   //Datalen_Net
		begin
		offset_addr5 <= `ADDR_SZ'd013;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'hc:                             //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd014;
		o_offset_len5 <= `ADDR_SZ'd2;			
		end 
	16'hd:                             //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd016;
		o_offset_len5 <= `ADDR_SZ'd2;			
		end
	16'he:                             //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd018;
		o_offset_len5 <= `ADDR_SZ'd2;			
		end
	16'hf:                             //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd020;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h10:                            //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd021;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h11:                            //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd022;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end
	16'h12:                            //Modified by SYF 2014.5.22
		begin
		offset_addr5 <= `ADDR_SZ'd023;
		o_offset_len5 <= `ADDR_SZ'd1;			
		end	
	default:
		begin
		offset_addr5 <= `ADDR_SZ'h0fff;
		o_offset_len5 <= `ADDR_SZ'd0;			
		end
	endcase
	end
	else
	begin
	offset_addr5 <= `ADDR_SZ'd0000;	
	o_offset_len5 <= `ADDR_SZ'd0;	
	end
end

/*****************************end************************************/



/*************calculator the Device_App_Info offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr6 <= `ADDR_SZ'd0000;
	o_offset_len6 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == Device_App_Info)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr6 <= `ADDR_SZ'd0000;
		o_offset_len6 <= `ADDR_SZ'd2;		
		end
	16'h1: 
		begin
		offset_addr6 <= `ADDR_SZ'd0000;
		o_offset_len6 <= `ADDR_SZ'd1;
		end
	16'h2:
		begin
		offset_addr6 <= `ADDR_SZ'd0001;
		o_offset_len6 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr6 <= `ADDR_SZ'h0fff;
		o_offset_len6 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr6 <= `ADDR_SZ'd0000;	
	o_offset_len6 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/


/*************calculator the Domain_Application_Obj_Header offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr9 <= `ADDR_SZ'd0000;
	o_offset_len9 <= `ADDR_SZ'h00;
	end
	else if(i_dobjid == Domain_Application_Obj_Header)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr9 <= `ADDR_SZ'd0000;
		o_offset_len9 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr9 <= `ADDR_SZ'd0000;
		o_offset_len9 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr9 <= `ADDR_SZ'd0001;
		o_offset_len9 <= `ADDR_SZ'd1;
		end	
	16'h3:  
		begin
		offset_addr9 <= `ADDR_SZ'd0002;
		o_offset_len9 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr9 <= `ADDR_SZ'd0003;
		o_offset_len9 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr9 <= `ADDR_SZ'd0004;
		o_offset_len9 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr9 <= `ADDR_SZ'h0fff;
		o_offset_len9 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr9 <= `ADDR_SZ'd0000;
	o_offset_len9 <= `ADDR_SZ'd0;	
	end
end

/*****************************end************************************/



/*************calculator the FRT_Link_obj_Header offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr10 <= `ADDR_SZ'd0000;
	o_offset_len10 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == FRT_Link_obj_Header_Local_Up)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr10 <= `ADDR_SZ'd0000;
		o_offset_len10 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr10 <= `ADDR_SZ'd0000;
		o_offset_len10 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr10 <= `ADDR_SZ'd0001;
		o_offset_len10 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr10 <= `ADDR_SZ'd0002;
		o_offset_len10 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr10 <= `ADDR_SZ'd0003;
		o_offset_len10 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr10 <= `ADDR_SZ'd0004;
		o_offset_len10 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr10 <= `ADDR_SZ'h0fff;
		o_offset_len10 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr10 <= `ADDR_SZ'd0000;	
	o_offset_len10 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr12 <= `ADDR_SZ'd0000;
	o_offset_len12 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == FRT_Link_obj_Header_Net_Up)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr12 <= `ADDR_SZ'd0000;
		o_offset_len12 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr12 <= `ADDR_SZ'd0000;
		o_offset_len12 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr12 <= `ADDR_SZ'd0001;
		o_offset_len12 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr12 <= `ADDR_SZ'd0002;
		o_offset_len12 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr12 <= `ADDR_SZ'd0003;
		o_offset_len12 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr12 <= `ADDR_SZ'd0004;
		o_offset_len12 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr12 <= `ADDR_SZ'h0fff;
		o_offset_len12 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr12 <= `ADDR_SZ'd0000;	
	o_offset_len12 <= `ADDR_SZ'd0;
	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr13 <= `ADDR_SZ'd0000;
	o_offset_len13 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == Device_Properties_Header_Up)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr13 <= `ADDR_SZ'd0000;
		o_offset_len13 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr13 <= `ADDR_SZ'd0000;
		o_offset_len13 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr13 <= `ADDR_SZ'd0001;
		o_offset_len13 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr13 <= `ADDR_SZ'd0002;
		o_offset_len13 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr13 <= `ADDR_SZ'h0fff;
		o_offset_len13 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr13 <= `ADDR_SZ'd0000;	
	o_offset_len13 <= `ADDR_SZ'd0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr14 <= `ADDR_SZ'd0000;
	o_offset_len14 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == FRT_Link_obj_Header_Local_Down)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr14 <= `ADDR_SZ'd0000;
		o_offset_len14 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr14 <= `ADDR_SZ'd0000;
		o_offset_len14 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr14 <= `ADDR_SZ'd0001;
		o_offset_len14 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr14 <= `ADDR_SZ'd0002;
		o_offset_len14 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr14 <= `ADDR_SZ'd0003;
		o_offset_len14 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr14 <= `ADDR_SZ'd0004;
		o_offset_len14 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr14 <= `ADDR_SZ'h0fff;
		o_offset_len14 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr14 <= `ADDR_SZ'd0000;	
	o_offset_len14 <= `ADDR_SZ'd0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr15 <= `ADDR_SZ'd0000;
	o_offset_len15 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == FRT_Link_obj_Header_Net_Down)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr15 <= `ADDR_SZ'd0000;
		o_offset_len15 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr15 <= `ADDR_SZ'd0000;
		o_offset_len15 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr15 <= `ADDR_SZ'd0001;
		o_offset_len15 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr15 <= `ADDR_SZ'd0002;
		o_offset_len15 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr15 <= `ADDR_SZ'd0003;
		o_offset_len15 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr15 <= `ADDR_SZ'd0004;
		o_offset_len15 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr15 <= `ADDR_SZ'h0fff;
		o_offset_len15 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr15 <= `ADDR_SZ'd0000;	
	o_offset_len15 <= `ADDR_SZ'd0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr16 <= `ADDR_SZ'd0000;
	o_offset_len16 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid == Device_Properties_Header_Down)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr16 <= `ADDR_SZ'd0000;
		o_offset_len16 <= `ADDR_SZ'd5;		
		end
	16'h1:  
		begin
		offset_addr16 <= `ADDR_SZ'd0000;
		o_offset_len16 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr16 <= `ADDR_SZ'd0001;
		o_offset_len16 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr16 <= `ADDR_SZ'd0002;
		o_offset_len16 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr16 <= `ADDR_SZ'h0fff;
		o_offset_len16 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr16 <= `ADDR_SZ'd0000;	
	o_offset_len16 <= `ADDR_SZ'd0;
	end
end

//*****************************************************************************************//
//Modified by SYF 2014.4.21
/*************calculator the FRT_Link_obj_Local_Up offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr17 <= `ADDR_SZ'd0000;
	o_offset_len17 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid >= 6000 && i_dobjid <=6999)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr17 <= `ADDR_SZ'd0000;
		o_offset_len17 <= i_frt_linknum_up[`ADDR_SZ-1:0];		
		end
	16'h1:  
		begin
		offset_addr17 <= `ADDR_SZ'd0000;
		o_offset_len17 <= `ADDR_SZ'd2;
		end
	16'h2:	
		begin
		offset_addr17 <= `ADDR_SZ'd0002;
		o_offset_len17 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr17 <= `ADDR_SZ'd0003;
		o_offset_len17 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr17 <= `ADDR_SZ'd0004;
		o_offset_len17 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr17 <= `ADDR_SZ'd0005;
		o_offset_len17 <= `ADDR_SZ'd1;
		end
	16'h6:  
		begin
		offset_addr17 <= `ADDR_SZ'd0006;
		o_offset_len17 <= `ADDR_SZ'd1;
		end
	16'h7:                                  //modified by SYF 2013.10.16
		begin
		offset_addr17 <= `ADDR_SZ'd0007;
		o_offset_len17 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr17 <= `ADDR_SZ'h0fff;
		o_offset_len17 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr17 <= `ADDR_SZ'd0000;	
	o_offset_len17 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/

/*************calculator the FRT_Link_obj_Net_Up offset address**************************/   //modified by SYF 2013.10.16
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr18 <= `ADDR_SZ'd0000;
	o_offset_len18 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid >= 7000 && i_dobjid <=7999)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr18 <= `ADDR_SZ'd0000;
		o_offset_len18 <= i_frt_linknum_net_up[`ADDR_SZ-1:0];		
		end
	16'h1:  
		begin
		offset_addr18 <= `ADDR_SZ'd0000;
		o_offset_len18 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr18 <= `ADDR_SZ'd0001;
		o_offset_len18 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr18 <= `ADDR_SZ'd0002;
		o_offset_len18 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr18 <= `ADDR_SZ'd0003;
		o_offset_len18 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr18 <= `ADDR_SZ'h0fff;
		o_offset_len18 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr18 <= `ADDR_SZ'd0000;	
	o_offset_len18 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/


/*************calculator the Device_Properties_Up offset address**************************/   //modified by SYF 2013.10.16
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr19 <= `ADDR_SZ'd0000;
	o_offset_len19 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid >= 8000 && i_dobjid <=8999)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr19 <= `ADDR_SZ'd0000;
		o_offset_len19 <= i_device_num_up[`ADDR_SZ-1:0];		
		end
	16'h1:  
		begin
		offset_addr19 <= `ADDR_SZ'd0000;
		o_offset_len19 <= `ADDR_SZ'd2;
		end
	16'h2:	
		begin
		offset_addr19 <= `ADDR_SZ'd0002;
		o_offset_len19 <= `ADDR_SZ'd3;
		end
	16'h3:  
		begin
		offset_addr19 <= `ADDR_SZ'd0005;
		o_offset_len19 <= `ADDR_SZ'd2;
		end
	16'h4:	
		begin
		offset_addr19 <= `ADDR_SZ'd0007;
		o_offset_len19 <= `ADDR_SZ'd1;
		end
	16'h5:	                             //Modified by SYF 2014.5.20
		begin
		offset_addr19 <= `ADDR_SZ'd0008;
		o_offset_len19 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr19 <= `ADDR_SZ'h0fff;
		o_offset_len19 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr19 <= `ADDR_SZ'd0000;	
	o_offset_len19 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/


/*************calculator the FRT_Link_obj_Local_Down offset address**************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr20 <= `ADDR_SZ'd0000;
	o_offset_len20 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid >= 9000 && i_dobjid <=9999)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr20 <= `ADDR_SZ'd0000;
		o_offset_len20 <= i_frt_linknum_down[`ADDR_SZ-1:0];		
		end
	16'h1:  
		begin
		offset_addr20 <= `ADDR_SZ'd0000;
		o_offset_len20 <= `ADDR_SZ'd2;
		end
	16'h2:	
		begin
		offset_addr20 <= `ADDR_SZ'd0002;
		o_offset_len20 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr20 <= `ADDR_SZ'd0003;
		o_offset_len20 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr20 <= `ADDR_SZ'd0004;
		o_offset_len20 <= `ADDR_SZ'd1;
		end
	16'h5:  
		begin
		offset_addr20 <= `ADDR_SZ'd0005;
		o_offset_len20 <= `ADDR_SZ'd1;
		end
	16'h6:  
		begin
		offset_addr20 <= `ADDR_SZ'd0006;
		o_offset_len20 <= `ADDR_SZ'd1;
		end
	16'h7:                                  //modified by SYF 2013.10.16
		begin
		offset_addr20 <= `ADDR_SZ'd0007;
		o_offset_len20 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr20 <= `ADDR_SZ'h0fff;
		o_offset_len20 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr20 <= `ADDR_SZ'd0000;	
	o_offset_len20 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/

/*************calculator the FRT_Link_obj_Net_Down offset address**************************/   //modified by SYF 2013.10.16
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr21 <= `ADDR_SZ'd0000;
	o_offset_len21 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid >= 10000 && i_dobjid <=10999)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr21 <= `ADDR_SZ'd0000;
		o_offset_len21 <= i_frt_linknum_net_down[`ADDR_SZ-1:0];		
		end
	16'h1:  
		begin
		offset_addr21 <= `ADDR_SZ'd0000;
		o_offset_len21 <= `ADDR_SZ'd1;
		end
	16'h2:	
		begin
		offset_addr21 <= `ADDR_SZ'd0001;
		o_offset_len21 <= `ADDR_SZ'd1;
		end
	16'h3:  
		begin
		offset_addr21 <= `ADDR_SZ'd0002;
		o_offset_len21 <= `ADDR_SZ'd1;
		end
	16'h4:	
		begin
		offset_addr21 <= `ADDR_SZ'd0003;
		o_offset_len21 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr21 <= `ADDR_SZ'h0fff;
		o_offset_len21 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr21 <= `ADDR_SZ'd0000;	
	o_offset_len21 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/


/*************calculator the Device_Properties_Down offset address**************************/   //modified by SYF 2013.10.16
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	offset_addr22 <= `ADDR_SZ'd0000;
	o_offset_len22 <= `ADDR_SZ'h00;	
	end
	else if(i_dobjid >= 11000 && i_dobjid <=11999)
	begin
	case(i_subidx)
	16'h0:
		begin
		offset_addr22 <= `ADDR_SZ'd0000;
		o_offset_len22 <= i_device_num_down[`ADDR_SZ-1:0];		
		end
	16'h1:  
		begin
		offset_addr22 <= `ADDR_SZ'd0000;
		o_offset_len22 <= `ADDR_SZ'd2;
		end
	16'h2:	
		begin
		offset_addr22 <= `ADDR_SZ'd0002;
		o_offset_len22 <= `ADDR_SZ'd3;
		end
	16'h3:  
		begin
		offset_addr22 <= `ADDR_SZ'd0005;
		o_offset_len22 <= `ADDR_SZ'd2;
		end
	16'h4:	
		begin
		offset_addr22 <= `ADDR_SZ'd0007;
		o_offset_len22 <= `ADDR_SZ'd1;
		end
	16'h5:	
		begin
		offset_addr22 <= `ADDR_SZ'd008;
		o_offset_len22 <= `ADDR_SZ'd1;
		end
	default:
		begin
		offset_addr22 <= `ADDR_SZ'h0fff;
		o_offset_len22 <= `ADDR_SZ'd0;
		end
	endcase
	end
	else
	begin
	offset_addr22 <= `ADDR_SZ'd0000;	
	o_offset_len22 <= `ADDR_SZ'd0;
	end
end

/*****************************end************************************/
//End Modified
//********************************************************************//

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_offset_addr <= `ADDR_SZ'h0;
	end
	else
	begin
	o_offset_addr <= offset_addr0 + offset_addr1 + offset_addr2 +offset_addr3 +offset_addr4+offset_addr5+offset_addr6+offset_addr9+offset_addr10+offset_addr11+offset_addr12+offset_addr13+offset_addr14+offset_addr15+offset_addr16+offset_addr17+offset_addr18+offset_addr19+offset_addr20+offset_addr21+offset_addr22;	
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_offset_len <= `ADDR_SZ'h0;
	end
	else
	begin
	o_offset_len <= o_offset_len0 + o_offset_len1 + o_offset_len2 + o_offset_len3 + o_offset_len4 + o_offset_len5 + o_offset_len6 + o_offset_len9 + o_offset_len10 + o_offset_len11+o_offset_len12+o_offset_len13+o_offset_len14+o_offset_len15+o_offset_len16+o_offset_len17+o_offset_len18+o_offset_len19+o_offset_len20+o_offset_len21+o_offset_len22;	
	end
end

/*****************************end************************************/

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_error <= 1'b0 ;
	end
	else if((o_offset_addr == `ADDR_SZ'h0fff) || (o_base_addr == `ADDR_SZ'h0fff))
	begin
	o_error <= 1'b1 ;	
	end
	else
	begin
	o_error <= 1'b0 ;	
	end
end
 
endmodule
