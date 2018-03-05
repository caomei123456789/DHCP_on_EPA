module   phy_init(
			input wire i_clk,
			input wire i_rst_n,
			output reg o_initDn,
			inout wire b_mdio,
			output wire o_mdc,
			output wire o_phy_clk0,		
			output wire o_phy_clk1, 
			output reg o_rst_phy0_n,
		   output reg o_rst_phy1_n
);


reg [3:0] fsm_cs;
reg [3:0] fsm_ns;
wire write_phy_Dn;
wire [6:0] i_divider;
reg write_en;
reg [4:0] phy_ad;
reg [4:0] phyreg_ad;
reg [15:0] phy_data_reg;
wire mdc;
wire mdcWr_en;
reg writephy_Dn_dly1;
wire write_Dn;

reg [31:0] reset_time;
reg initEn;

reg [31:0] counter;
assign i_divider = 7'h10;

assign o_phy_clk0 = i_clk;
assign o_phy_clk1 = i_clk;

parameter IDLE               = 4'h0;
parameter REGA_S19           = 4'h1;
parameter REGA_B0            = 4'h2;
parameter REGA_S4            = 4'h3;
parameter REGB_S19           = 4'h4;
parameter REGB_B0            = 4'h5;
parameter REGB_S4            = 4'h6;
parameter REGC_S19           = 4'h7;
parameter REGC_B0            = 4'h8;
parameter REGC_S4            = 4'h9;
parameter REGD_S19           = 4'ha;
parameter REGD_B0            = 4'hb;
parameter REGD_S4            = 4'hc;
parameter REGD_OVER			  = 4'hd;
parameter INIT_DN            = 4'he;
assign write_Dn = (!writephy_Dn_dly1 && write_phy_Dn)? 1'b1:1'b0;
//assign o_mdc = mdcWr_en ? mdc : 1'b0;
assign o_mdc = mdc;

//parameter  START_RESET = 32'h1000000;
//parameter  RESET_TIME =  32'h3000000;
//parameter  STABLE_TIME = 32'h4000000;

parameter  START_RESET = 32'h1000000;
parameter  RESET_TIME =  32'h4000000;
parameter  STABLE_TIME = 32'h5000000;
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
		counter <= 32'b0;
	 end
	 else if(counter >= 32'h47868C0)
	 begin
		counter <= counter;
	 end
	 else if(fsm_ns == REGD_OVER)
	 begin
		counter <= counter + 32'b1;
	 end
end


always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        reset_time <= 32'b0;
    end
    else if(reset_time <= 32'hfffffff0)
    begin
        reset_time <= reset_time + 1'b1;
    end
end


always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        o_rst_phy0_n <= 1'b1;
		  o_rst_phy1_n <= 1'b1;
		  initEn <= 1'b0;
    end
    else if(reset_time == START_RESET)
    begin
        o_rst_phy0_n <= 1'b0;
		  o_rst_phy1_n <= 1'b0;
		  initEn <= 1'b0;
    end	 
    else if(reset_time == RESET_TIME)
    begin
        o_rst_phy0_n <= 1'b1;
		  o_rst_phy1_n <= 1'b1;
		  initEn <= 1'b0;
    end
	 else if(reset_time >= STABLE_TIME)
    begin
        o_rst_phy0_n <= 1'b1;
		  o_rst_phy1_n <= 1'b1;
		  initEn <= 1'b1;
    end	 
end


always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        writephy_Dn_dly1 <= 1'b0;
    end
    else 
    begin
        writephy_Dn_dly1 <= write_phy_Dn;
    end
end
/**********************************************
  1st always block, sequential state transition 
***********************************************/
always @ (posedge i_clk , negedge i_rst_n)
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

/****************************************************
  2nd always block, combinational condition judgment
*****************************************************/
always @(*)
begin
    if(!initEn)  
    begin
        fsm_ns = IDLE;
    end
    else 
    case (fsm_cs)
    IDLE: 
        fsm_ns = REGA_S19;
    REGA_S19: 
    begin
        if (write_Dn)
        begin
            fsm_ns = REGA_B0;
        end
        else 
        begin
            fsm_ns = REGA_S19;
        end
    end
    REGA_B0:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGA_S4;
        end
        else
        begin
            fsm_ns = REGA_B0;
        end
    end
	 REGA_S4:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGB_S19;
        end
        else
        begin
            fsm_ns = REGA_S4;
        end
    end	 
    REGB_S19: 
    begin
        if (write_Dn)
        begin
            fsm_ns = REGB_B0;
        end
        else 
        begin
            fsm_ns = REGB_S19;
        end
    end
    REGB_B0:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGB_S4;
        end
        else
        begin
            fsm_ns = REGB_B0;
        end
    end
	 REGB_S4:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGC_S19;
        end
        else
        begin
            fsm_ns = REGB_S4;
        end
    end	
 REGC_S19: 
    begin
        if (write_Dn)
        begin
            fsm_ns = REGC_B0;
        end
        else 
        begin
            fsm_ns = REGC_S19;
        end
    end
    REGC_B0:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGC_S4;
        end
        else
        begin
            fsm_ns = REGC_B0;
        end
    end
	 REGC_S4:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGD_S19;
        end
        else
        begin
            fsm_ns = REGC_S4;
        end
    end	
 REGD_S19: 
    begin
        if (write_Dn)
        begin
            fsm_ns = REGD_B0;
        end
        else 
        begin
            fsm_ns = REGD_S19;
        end
    end
    REGD_B0:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGD_S4;
        end
        else
        begin
            fsm_ns = REGD_B0;
        end
    end
	 REGD_S4:
    begin
        if (write_Dn)
        begin
            fsm_ns = REGD_OVER;
        end
        else
        begin
            fsm_ns = REGD_S4;
        end
    end
	 REGD_OVER:
	 begin
		if(counter >= 32'h47868C0)
		begin
			fsm_ns = INIT_DN;
		end
		else
		begin
			fsm_ns = REGD_OVER;
		end
	 end
    INIT_DN:
        fsm_ns = INIT_DN;
    default:
        fsm_ns = IDLE;
    endcase
end
/**************************************************
    3rd always block, the combinational FSM output
***************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
       o_initDn <= 1'b0;
       write_en <= 1'b0;
       phy_ad <= 5'b0;
       phyreg_ad <= 5'b11111;
       phy_data_reg <= 16'hffff;
    end
    else 
    case (fsm_ns)
    IDLE:
    begin
        o_initDn <= o_initDn;
        write_en <= 1'b0;
        phy_ad <= 5'b11111;
        phyreg_ad <= 5'b11111;
        phy_data_reg <= 16'h0;
    end
    REGA_S19:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00000;
        phyreg_ad <= 5'b11001;
        phy_data_reg <= 16'h8040;
    end
    REGA_B0:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00000;
        phyreg_ad <= 5'b00000;
        phy_data_reg <= 16'h3100;//2100

    end
	 REGA_S4:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00000;
        phyreg_ad <= 5'b10111;
        phy_data_reg <= 16'h00c1;
    end	
    REGB_S19:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00001;
        phyreg_ad <= 5'b11001;
        phy_data_reg <= 16'h8041;
    end
    REGB_B0:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00001;
        phyreg_ad <= 5'b00000;
        phy_data_reg <= 16'h3100;//2100

    end
	 REGB_S4:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00001;
        phyreg_ad <= 5'b10111;
        phy_data_reg <= 16'h00c1;
    end	
	REGC_S19:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00010;
        phyreg_ad <= 5'b11001;
        phy_data_reg <= 16'h8042;
    end
    REGC_B0:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00010;
        phyreg_ad <= 5'b00000;
        phy_data_reg <= 16'h3100;//2100

    end
	 REGC_S4:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00010;
        phyreg_ad <= 5'b10111;
        phy_data_reg <= 16'h00c1;
    end	
	 REGD_S19:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00011;
        phyreg_ad <= 5'b11001;
        phy_data_reg <= 16'h8043;
    end
    REGD_B0:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00011;
        phyreg_ad <= 5'b00000;
        phy_data_reg <= 16'h3100;//2100

    end
	 REGD_S4:
    begin
        write_en <= 1'b1;
        phy_ad <= 5'b00011;
        phyreg_ad <= 5'b10111;
        phy_data_reg <= 16'h00c1;
    end	 
    INIT_DN:
    begin
       o_initDn <= 1'b1;
       write_en <= 1'b0;
       phy_ad <= 5'b11111;
       phyreg_ad <= 5'b11111;
       phy_data_reg <= 16'h0;
    end
    default:
    begin
       o_initDn <= o_initDn;
       write_en <= 1'b0;
       phy_ad <= 5'b11111;
       phyreg_ad <= 5'b11111;
       phy_data_reg <= 16'h0;
    end
    endcase
end

write_phy write_phy_inst
( 
  .i_mdc(mdc),
  .i_rst_n(i_rst_n),
  .i_write_en(write_en),
  .i_phy_ad(phy_ad),
  .i_phyreg_ad(phyreg_ad),
  .i_phy_data_reg(phy_data_reg),
  .o_write_phy_Dn(write_phy_Dn),
  .b_phydata(b_mdio),
  .o_mdc_en(mdcWr_en)
);

mii_mdc mii_mdc_inst
(
 .i_clk(i_clk),
 .i_rst_n(i_rst_n),
 .i_divider(i_divider),
 .o_mdc(mdc)
);

endmodule 
