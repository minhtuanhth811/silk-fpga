`default_nettype none

module dino_sprite (
    input wire [4:0] x, // Tọa độ local X (0 -> 19)
    input wire [4:0] y, // Tọa độ local Y (0 -> 19)
    output wire pixel,
    input wire sprite
);
  // Lưới 32x20 = 80 byte. Lưu ý: Lấy LSB làm pixel bên trái trước.
  reg [7:0] mem[159:0];

 initial begin
  //sprite 0
    mem[0] = 8'h00;     mem[1] = 8'hfc;     mem[2] = 8'h07;     mem[3] = 8'h00;
    mem[4] = 8'h00;     mem[5] = 8'hf6;     mem[6] = 8'h0f;     mem[7] = 8'h00;
    mem[8] = 8'h00;     mem[9] = 8'hfe;     mem[10] = 8'h0f;     mem[11] = 8'h00;
    mem[12] = 8'h00;     mem[13] = 8'hfe;     mem[14] = 8'h0f;     mem[15] = 8'h00;
    mem[16] = 8'h00;     mem[17] = 8'hfe;     mem[18] = 8'h0f;     mem[19] = 8'h00;
    mem[20] = 8'h00;     mem[21] = 8'h7e;     mem[22] = 8'h00;     mem[23] = 8'h00;
    mem[24] = 8'h00;     mem[25] = 8'hfe;     mem[26] = 8'h03;     mem[27] = 8'h00;
    mem[28] = 8'h00;     mem[29] = 8'h3e;     mem[30] = 8'h00;     mem[31] = 8'h00;
    mem[32] = 8'h01;     mem[33] = 8'h3f;     mem[34] = 8'h00;     mem[35] = 8'h00;
    mem[36] = 8'h81;     mem[37] = 8'hff;     mem[38] = 8'h00;     mem[39] = 8'h00;
    mem[40] = 8'hc3;     mem[41] = 8'hbf;     mem[42] = 8'h00;     mem[43] = 8'h00;
    mem[44] = 8'he7;     mem[45] = 8'h3f;     mem[46] = 8'h00;     mem[47] = 8'h00;
    mem[48] = 8'hff;     mem[49] = 8'h3f;     mem[50] = 8'h00;     mem[51] = 8'h00;
    mem[52] = 8'hfe;     mem[53] = 8'h1f;     mem[54] = 8'h00;     mem[55] = 8'h00;
    mem[56] = 8'hfc;     mem[57] = 8'h0f;     mem[58] = 8'h00;     mem[59] = 8'h00;
    mem[60] = 8'hf8;     mem[61] = 8'h07;     mem[62] = 8'h00;     mem[63] = 8'h00;
    mem[64] = 8'he0;     mem[65] = 8'h0e;     mem[66] = 8'h00;     mem[67] = 8'h00;
    mem[68] = 8'h60;     mem[69] = 8'h00;     mem[70] = 8'h00;     mem[71] = 8'h00;
    mem[72] = 8'h20;     mem[73] = 8'h00;     mem[74] = 8'h00;     mem[75] = 8'h00;
    mem[76] = 8'h60;     mem[77] = 8'h00;     mem[78] = 8'h00;     mem[79] = 8'h00;
    //sprite 1
    mem[128] = 8'h00;     mem[129] = 8'hfc;     mem[130] = 8'h07;     mem[131] = 8'h00;
    mem[132] = 8'h00;     mem[133] = 8'hf6;     mem[134] = 8'h0f;     mem[135] = 8'h00;
    mem[136] = 8'h00;     mem[137] = 8'hfe;     mem[138] = 8'h0f;     mem[139] = 8'h00;
    mem[140] = 8'h00;     mem[141] = 8'hfe;     mem[142] = 8'h0f;     mem[143] = 8'h00;
    mem[144] = 8'h00;     mem[145] = 8'hfe;     mem[146] = 8'h0f;     mem[147] = 8'h00;
    mem[148] = 8'h00;     mem[149] = 8'h7e;     mem[150] = 8'h00;     mem[151] = 8'h00;
    mem[152] = 8'h00;     mem[153] = 8'hfe;     mem[154] = 8'h03;     mem[155] = 8'h00;
    mem[156] = 8'h00;     mem[157] = 8'h3e;     mem[158] = 8'h00;     mem[159] = 8'h00;
    mem[160] = 8'h01;     mem[161] = 8'h3f;     mem[162] = 8'h00;     mem[163] = 8'h00;
    mem[164] = 8'h81;     mem[165] = 8'hff;     mem[166] = 8'h00;     mem[167] = 8'h00;
    mem[168] = 8'hc3;     mem[169] = 8'hbf;     mem[170] = 8'h00;     mem[171] = 8'h00;
    mem[172] = 8'he7;     mem[173] = 8'h3f;     mem[174] = 8'h00;     mem[175] = 8'h00;
    mem[176] = 8'hff;     mem[177] = 8'h3f;     mem[178] = 8'h00;     mem[179] = 8'h00;
    mem[180] = 8'hfe;     mem[181] = 8'h1f;     mem[182] = 8'h00;     mem[183] = 8'h00;
    mem[184] = 8'hfc;     mem[185] = 8'h0f;     mem[186] = 8'h00;     mem[187] = 8'h00;
    mem[188] = 8'hf8;     mem[189] = 8'h07;     mem[190] = 8'h00;     mem[191] = 8'h00;
    mem[192] = 8'h20;     mem[193] = 8'h06;     mem[194] = 8'h00;     mem[195] = 8'h00;
    mem[196] = 8'h60;     mem[197] = 8'h04;     mem[198] = 8'h00;     mem[199] = 8'h00;
    mem[200] = 8'h00;     mem[201] = 8'h04;     mem[202] = 8'h00;     mem[203] = 8'h00;
    mem[204] = 8'h00;     mem[205] = 8'h0c;     mem[206] = 8'h00;     mem[207] = 8'h00;
  end

  // Dùng lại tuyệt chiêu toán học: Địa chỉ = y * 4 + x / 8
  wire [7:0] addr = {sprite, y[4:0], x[4:3]};
  assign pixel = mem[addr][x[2:0]];

endmodule
