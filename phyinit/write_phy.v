/**************************************************************
File name   :write_phy.v
Function    :write the registers of PHY,set up the mode of PHY 
Author      :tongqing
Version     :V1.0
***************************************************************/	
module write_phy
( /***********************
    16 frequency division clk
  *************************/
  input wire i_mdc, //16 frequency division
  input wire i_rst_n,
  input wire i_write_en,
  input wire [4:0] i_phy_ad,
  input wire [4:0] i_phyreg_ad,
  input [15:0] i_phy_data_reg,
  output reg o_write_phy_Dn,
  output wire b_phydata,
  output reg o_mdc_en 
);
reg [5:0] fsm_cs; //current state register
reg [5:0] fsm_ns; //next state register
reg [15:0] count_prenum;
reg [15:0] count_data;
wire [0:15] phy_data_reg;
reg phydata;
/////////////////////
//reg [15:0] temp/* synthesis preserve=1 */;
//reg temp1;
/////////////////////
parameter IDLE                  = 6'h0;
parameter PRENUM                = 6'h1;
parameter START_0NUM            = 6'h2;
parameter START_1NUM            = 6'h3;
parameter OPERATION_0CODE       = 6'h4;
parameter OPERATION_1CODE       = 6'h5;
parameter PHY_4AD               = 6'h6;
parameter PHY_3AD               = 6'h7;
parameter PHY_2AD               = 6'h8;
parameter PHY_1AD               = 6'h9;
parameter PHY_0AD               = 6'ha;
parameter PHYREG_4AD            = 6'hb;         //hongdingyi
parameter PHYREG_3AD            = 6'hc;
parameter PHYREG_2AD            = 6'hd;
parameter PHYREG_1AD            = 6'he;
parameter PHYREG_0AD            = 6'hf;
parameter SHIFT_0SIGNAL         = 6'h10;
parameter SHIFT_1SIGNAL         = 6'h11;
parameter WRITE_DATA            = 6'h12;
parameter OVER                  = 6'h13;

assign phy_data_reg [0:15] = i_phy_data_reg [15:0];
assign b_phydata = phydata;

/**********************************************
***********************************************/
/**********************************************
  1st always block, sequential state transition 
***********************************************/
always @ (posedge i_mdc , negedge i_rst_n)
begin
    if (!i_rst_n)
		 begin
			  fsm_cs <= IDLE;
		 end
    else 
		 begin
			  fsm_cs  <= fsm_ns;
		 end
end
/****************************************
 count the byte number of preamble code
*****************************************/
always @ (posedge i_mdc , negedge i_rst_n)
begin
    if (!i_rst_n)
		 begin
			  count_prenum <= 16'h0;
		 end
    else if (fsm_ns == PRENUM)
		 begin
			  count_prenum <= count_prenum + 1'b1;
		 end
    else  
		 begin
			  count_prenum <= 16'h0;
		 end
end
/**********************************************************************
 count the byte number of data which is writed into the register of PHY
***********************************************************************/
always @ (posedge i_mdc , negedge i_rst_n)
begin
    if (!i_rst_n)
		 begin
			  count_data <= 16'h0;
		 end
    else if (fsm_ns == WRITE_DATA)
		 begin
			  count_data <= count_data + 1'b1;
		 end
    else 
		 begin
			  count_data <= 16'h0;
		 end
end
/****************************************************
  2nd always block, combinational condition judgment
  judge the current register state
*****************************************************/
always @(*)
begin
    if (!i_write_en) //bu xie zhi shi,gai zhi wei 0;
		 begin
			  fsm_ns = IDLE;
		 end
    else
    case (fsm_cs)
    IDLE: fsm_ns = PRENUM;
    /*************************
    32 bits preamble code (1)
    **************************/
    PRENUM:
    begin
        if (count_prenum == 16'h1f)
			  begin
					fsm_ns = START_0NUM;
			  end
        else
			  begin
					fsm_ns = PRENUM;
			  end
    end
    /************************
     2 bits start number (01)
    *************************/
    START_0NUM:
    begin
        fsm_ns = START_1NUM;
    end
    START_1NUM:
    begin
        fsm_ns = OPERATION_0CODE;
    end
	/**************************************************
     2 bits operation code,10 is read,01 is write
     ***********************************************/
    OPERATION_0CODE:
    begin
        fsm_ns = OPERATION_1CODE;
    end
    OPERATION_1CODE:
    begin
        fsm_ns = PHY_4AD;
    end
	/*************************
     5 bits phy address
    **************************/
    PHY_4AD:
    begin
        fsm_ns = PHY_3AD;
    end
    PHY_3AD:
    begin
        fsm_ns = PHY_2AD;
    end
    PHY_2AD:
    begin
        fsm_ns = PHY_1AD;
    end  
    PHY_1AD:
    begin
        fsm_ns = PHY_0AD;
    end
    PHY_0AD:
    begin
        fsm_ns = PHYREG_4AD;
    end

	/***************************
	  5 bits phy reg address
	***************************/
    PHYREG_4AD:
    begin
        fsm_ns = PHYREG_3AD;
    end
    PHYREG_3AD:
    begin
        fsm_ns = PHYREG_2AD;
    end
    PHYREG_2AD:
    begin
        fsm_ns = PHYREG_1AD;
    end
    PHYREG_1AD:
    begin
        fsm_ns = PHYREG_0AD;
    end
    PHYREG_0AD:
    begin
        fsm_ns = SHIFT_0SIGNAL;  
    end
    /***************************
	 2 bits shift code :write code is 10
	**************************/
    SHIFT_0SIGNAL:
    begin
        fsm_ns = SHIFT_1SIGNAL;  
    end
    SHIFT_1SIGNAL:
    begin
        fsm_ns = WRITE_DATA;  
    end
	/***********************************
     write 16 bits data into phy reg
    **********************************/
    WRITE_DATA:
    begin
        if(count_data == 16'h10)
        begin
            fsm_ns = OVER;
        end
        else 
        begin
            fsm_ns = WRITE_DATA; 
        end
    end
    OVER:
    begin
        fsm_ns = IDLE;
    end
    default:
    begin
        fsm_ns = IDLE;
    end
    endcase
end
/**************************************************
pkg_keep=1 indicates that this package will be 
reserve and resend again because of a collision 
has happened
**************************************************/ 
always @ (posedge i_mdc , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        phydata <= 1'bz;
        o_write_phy_Dn <= 1'b0;
        o_mdc_en <= 1'b0;
    end
    else 
    case (fsm_ns)
    IDLE:
    begin
       phydata <= 1'bz;
       o_write_phy_Dn <= 1'b0;
       o_mdc_en <= 1'b0;
    end
    PRENUM:
    begin
        phydata <= 1'b1;
        o_mdc_en <= 1'b1; //start write phy
    end
    START_0NUM:
    begin
        phydata <= 1'b0;
    end
    START_1NUM:
    begin
        phydata <= 1'b1;
    end
    OPERATION_0CODE:
    begin
        phydata <= 1'b0;
    end
    OPERATION_1CODE:
    begin
        phydata <= 1'b1;
    end
    PHY_4AD:
    begin
        phydata <= i_phy_ad[4];
    end
    PHY_3AD:
    begin
        phydata <= i_phy_ad[3];
    end
    PHY_2AD:
    begin
        phydata <= i_phy_ad[2];
    end
    PHY_1AD:
    begin
        phydata <= i_phy_ad[1];
    end
    PHY_0AD:
    begin
        phydata <= i_phy_ad[0];
    end
    PHYREG_4AD:
    begin
        phydata <= i_phyreg_ad[4];
    end
     PHYREG_3AD:
    begin
        phydata <= i_phyreg_ad[3];
    end
     PHYREG_2AD:
    begin
        phydata <= i_phyreg_ad[2];
    end
     PHYREG_1AD:
    begin
        phydata <= i_phyreg_ad[1];
    end
     PHYREG_0AD:
    begin
        phydata <= i_phyreg_ad[0];
    end
    SHIFT_0SIGNAL:
    begin
        phydata <= 1'b1;
    end
    SHIFT_1SIGNAL:
    begin
        phydata <= 1'b0;
    end
    WRITE_DATA:
    begin
        phydata <= phy_data_reg[count_data];
    end
  OVER:
    begin
        o_write_phy_Dn <= 1'b1;
        phydata <= 1'bz;
    end 
    default:
    begin
        phydata <= 1'bz;
        o_write_phy_Dn <= 1'b0;
        o_mdc_en <= 1'b0;
		  
    end
    endcase
end

endmodule
