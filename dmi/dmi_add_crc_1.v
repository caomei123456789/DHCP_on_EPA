module dmi_add_crc_1(
		 input wire i_clk, 
		 input wire i_rst_n,
		 input wire i_crc_reset, 
		 input wire [15:0] i_data, 
		 input wire i_crc_enable, 
		 output reg [31:0] o_crc 
);

reg crc_enable_1clk, crc_enable_2clk;

wire [31:0] NewCRC;

wire [15:0] D;
wire [31:0] C;

wire [7:0] CRC_dataH;
wire [7:0] CRC_dataL;
assign CRC_dataH = {i_data[8],i_data[9],i_data[10],i_data[11],i_data[12],i_data[13],i_data[14],i_data[15]};
assign CRC_dataL = {i_data[0],i_data[1],i_data[2],i_data[3],i_data[4],i_data[5],i_data[6],i_data[7]};

/*********************************************************
call the CRC calculation function to calculate the CRC value 
of the package received, the initial value of CRC must be 32 bits "1"
**********************************************************/ 

always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        crc_enable_1clk <= 1'b0;
		  crc_enable_2clk <= 1'b0;
    end
    else 
    begin
        crc_enable_1clk <= i_crc_enable;
		  crc_enable_2clk <= crc_enable_1clk;
    end
end




always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        o_crc <= 32'hffffffff;
    end
	 else if(crc_enable_2clk && !crc_enable_1clk)
	 begin
		  o_crc = ~o_crc;
	 end
    else if(i_crc_enable && crc_enable_1clk)
	 begin
        o_crc <= NewCRC;
	 end
    else if (i_crc_reset)
    begin
        o_crc <= 32'hffffffff;
    end
end


assign    D = {CRC_dataH, CRC_dataL};
assign    C = o_crc;

assign    NewCRC[0] = D[12] ^ D[10] ^ D[9] ^ D[6] ^ D[0] ^ C[16] ^ C[22] ^ 
                C[25] ^ C[26] ^ C[28];
assign    NewCRC[1] = D[13] ^ D[12] ^ D[11] ^ D[9] ^ D[7] ^ D[6] ^ D[1] ^ 
                D[0] ^ C[16] ^ C[17] ^ C[22] ^ C[23] ^ C[25] ^ C[27] ^ 
                C[28] ^ C[29];
assign    NewCRC[2] = D[14] ^ D[13] ^ D[9] ^ D[8] ^ D[7] ^ D[6] ^ D[2] ^ 
                D[1] ^ D[0] ^ C[16] ^ C[17] ^ C[18] ^ C[22] ^ C[23] ^ 
                C[24] ^ C[25] ^ C[29] ^ C[30];
assign    NewCRC[3] = D[15] ^ D[14] ^ D[10] ^ D[9] ^ D[8] ^ D[7] ^ D[3] ^ 
                D[2] ^ D[1] ^ C[17] ^ C[18] ^ C[19] ^ C[23] ^ C[24] ^ 
                C[25] ^ C[26] ^ C[30] ^ C[31];
assign    NewCRC[4] = D[15] ^ D[12] ^ D[11] ^ D[8] ^ D[6] ^ D[4] ^ D[3] ^ 
                D[2] ^ D[0] ^ C[16] ^ C[18] ^ C[19] ^ C[20] ^ C[22] ^ 
                C[24] ^ C[27] ^ C[28] ^ C[31];
assign    NewCRC[5] = D[13] ^ D[10] ^ D[7] ^ D[6] ^ D[5] ^ D[4] ^ D[3] ^ 
                D[1] ^ D[0] ^ C[16] ^ C[17] ^ C[19] ^ C[20] ^ C[21] ^ 
                C[22] ^ C[23] ^ C[26] ^ C[29];
assign    NewCRC[6] = D[14] ^ D[11] ^ D[8] ^ D[7] ^ D[6] ^ D[5] ^ D[4] ^ 
                D[2] ^ D[1] ^ C[17] ^ C[18] ^ C[20] ^ C[21] ^ C[22] ^ 
                C[23] ^ C[24] ^ C[27] ^ C[30];
assign    NewCRC[7] = D[15] ^ D[10] ^ D[8] ^ D[7] ^ D[5] ^ D[3] ^ D[2] ^ 
                D[0] ^ C[16] ^ C[18] ^ C[19] ^ C[21] ^ C[23] ^ C[24] ^ 
                C[26] ^ C[31];
assign    NewCRC[8] = D[12] ^ D[11] ^ D[10] ^ D[8] ^ D[4] ^ D[3] ^ D[1] ^ 
                D[0] ^ C[16] ^ C[17] ^ C[19] ^ C[20] ^ C[24] ^ C[26] ^ 
                C[27] ^ C[28];
assign    NewCRC[9] = D[13] ^ D[12] ^ D[11] ^ D[9] ^ D[5] ^ D[4] ^ D[2] ^ 
                D[1] ^ C[17] ^ C[18] ^ C[20] ^ C[21] ^ C[25] ^ C[27] ^ 
                C[28] ^ C[29];
assign    NewCRC[10] = D[14] ^ D[13] ^ D[9] ^ D[5] ^ D[3] ^ D[2] ^ D[0] ^ 
                 C[16] ^ C[18] ^ C[19] ^ C[21] ^ C[25] ^ C[29] ^ C[30];
assign    NewCRC[11] = D[15] ^ D[14] ^ D[12] ^ D[9] ^ D[4] ^ D[3] ^ D[1] ^ 
                 D[0] ^ C[16] ^ C[17] ^ C[19] ^ C[20] ^ C[25] ^ C[28] ^ 
                 C[30] ^ C[31];
assign    NewCRC[12] = D[15] ^ D[13] ^ D[12] ^ D[9] ^ D[6] ^ D[5] ^ D[4] ^ 
                 D[2] ^ D[1] ^ D[0] ^ C[16] ^ C[17] ^ C[18] ^ C[20] ^ 
                 C[21] ^ C[22] ^ C[25] ^ C[28] ^ C[29] ^ C[31];
assign    NewCRC[13] = D[14] ^ D[13] ^ D[10] ^ D[7] ^ D[6] ^ D[5] ^ D[3] ^ 
                 D[2] ^ D[1] ^ C[17] ^ C[18] ^ C[19] ^ C[21] ^ C[22] ^ 
                 C[23] ^ C[26] ^ C[29] ^ C[30];
assign    NewCRC[14] = D[15] ^ D[14] ^ D[11] ^ D[8] ^ D[7] ^ D[6] ^ D[4] ^ 
                 D[3] ^ D[2] ^ C[18] ^ C[19] ^ C[20] ^ C[22] ^ C[23] ^ 
                 C[24] ^ C[27] ^ C[30] ^ C[31];
assign    NewCRC[15] = D[15] ^ D[12] ^ D[9] ^ D[8] ^ D[7] ^ D[5] ^ D[4] ^ 
                 D[3] ^ C[19] ^ C[20] ^ C[21] ^ C[23] ^ C[24] ^ C[25] ^ 
                 C[28] ^ C[31];
assign    NewCRC[16] = D[13] ^ D[12] ^ D[8] ^ D[5] ^ D[4] ^ D[0] ^ C[0] ^ 
                 C[16] ^ C[20] ^ C[21] ^ C[24] ^ C[28] ^ C[29];
assign    NewCRC[17] = D[14] ^ D[13] ^ D[9] ^ D[6] ^ D[5] ^ D[1] ^ C[1] ^ 
                 C[17] ^ C[21] ^ C[22] ^ C[25] ^ C[29] ^ C[30];
assign    NewCRC[18] = D[15] ^ D[14] ^ D[10] ^ D[7] ^ D[6] ^ D[2] ^ C[2] ^ 
                 C[18] ^ C[22] ^ C[23] ^ C[26] ^ C[30] ^ C[31];
assign    NewCRC[19] = D[15] ^ D[11] ^ D[8] ^ D[7] ^ D[3] ^ C[3] ^ C[19] ^ 
                 C[23] ^ C[24] ^ C[27] ^ C[31];
assign    NewCRC[20] = D[12] ^ D[9] ^ D[8] ^ D[4] ^ C[4] ^ C[20] ^ C[24] ^ 
                 C[25] ^ C[28];
assign    NewCRC[21] = D[13] ^ D[10] ^ D[9] ^ D[5] ^ C[5] ^ C[21] ^ C[25] ^ 
                 C[26] ^ C[29];
assign    NewCRC[22] = D[14] ^ D[12] ^ D[11] ^ D[9] ^ D[0] ^ C[6] ^ C[16] ^ 
                 C[25] ^ C[27] ^ C[28] ^ C[30];
assign    NewCRC[23] = D[15] ^ D[13] ^ D[9] ^ D[6] ^ D[1] ^ D[0] ^ C[7] ^ 
                 C[16] ^ C[17] ^ C[22] ^ C[25] ^ C[29] ^ C[31];
assign    NewCRC[24] = D[14] ^ D[10] ^ D[7] ^ D[2] ^ D[1] ^ C[8] ^ C[17] ^ 
                 C[18] ^ C[23] ^ C[26] ^ C[30];
assign    NewCRC[25] = D[15] ^ D[11] ^ D[8] ^ D[3] ^ D[2] ^ C[9] ^ C[18] ^ 
                 C[19] ^ C[24] ^ C[27] ^ C[31];
assign    NewCRC[26] = D[10] ^ D[6] ^ D[4] ^ D[3] ^ D[0] ^ C[10] ^ C[16] ^ 
                 C[19] ^ C[20] ^ C[22] ^ C[26];
assign    NewCRC[27] = D[11] ^ D[7] ^ D[5] ^ D[4] ^ D[1] ^ C[11] ^ C[17] ^ 
                 C[20] ^ C[21] ^ C[23] ^ C[27];
assign    NewCRC[28] = D[12] ^ D[8] ^ D[6] ^ D[5] ^ D[2] ^ C[12] ^ C[18] ^ 
                 C[21] ^ C[22] ^ C[24] ^ C[28];
assign    NewCRC[29] = D[13] ^ D[9] ^ D[7] ^ D[6] ^ D[3] ^ C[13] ^ C[19] ^ 
                 C[22] ^ C[23] ^ C[25] ^ C[29];
assign    NewCRC[30] = D[14] ^ D[10] ^ D[8] ^ D[7] ^ D[4] ^ C[14] ^ C[20] ^ 
                 C[23] ^ C[24] ^ C[26] ^ C[30];
assign    NewCRC[31] = D[15] ^ D[11] ^ D[9] ^ D[8] ^ D[5] ^ C[15] ^ C[21] ^ 
                 C[24] ^ C[25] ^ C[27] ^ C[31];

endmodule 
