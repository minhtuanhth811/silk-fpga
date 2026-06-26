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
    mem[80] = 8'h00;     mem[81] = 8'hfc;     mem[82] = 8'h07;     mem[83] = 8'h00;
    mem[84] = 8'h00;     mem[85] = 8'hf6;     mem[86] = 8'h0f;     mem[87] = 8'h00;
    mem[88] = 8'h00;     mem[89] = 8'hfe;     mem[90] = 8'h0f;     mem[91] = 8'h00;
    mem[92] = 8'h00;     mem[93] = 8'hfe;     mem[94] = 8'h0f;     mem[95] = 8'h00;
    mem[96] = 8'h00;     mem[97] = 8'hfe;     mem[98] = 8'h0f;     mem[99] = 8'h00;
    mem[100] = 8'h00;     mem[101] = 8'h7e;     mem[102] = 8'h00;     mem[103] = 8'h00;
    mem[104] = 8'h00;     mem[105] = 8'hfe;     mem[106] = 8'h03;     mem[107] = 8'h00;
    mem[108] = 8'h00;     mem[109] = 8'h3e;     mem[110] = 8'h00;     mem[111] = 8'h00;
    mem[112] = 8'h01;     mem[113] = 8'h3f;     mem[114] = 8'h00;     mem[115] = 8'h00;
    mem[116] = 8'h81;     mem[117] = 8'hff;     mem[118] = 8'h00;     mem[119] = 8'h00;
    mem[120] = 8'hc3;     mem[121] = 8'hbf;     mem[122] = 8'h00;     mem[123] = 8'h00;
    mem[124] = 8'he7;     mem[125] = 8'h3f;     mem[126] = 8'h00;     mem[127] = 8'h00;
    mem[128] = 8'hff;     mem[129] = 8'h3f;     mem[130] = 8'h00;     mem[131] = 8'h00;
    mem[132] = 8'hfe;     mem[133] = 8'h1f;     mem[134] = 8'h00;     mem[135] = 8'h00;
    mem[136] = 8'hfc;     mem[137] = 8'h0f;     mem[138] = 8'h00;     mem[139] = 8'h00;
    mem[140] = 8'hf8;     mem[141] = 8'h07;     mem[142] = 8'h00;     mem[143] = 8'h00;
    mem[144] = 8'h20;     mem[145] = 8'h06;     mem[146] = 8'h00;     mem[147] = 8'h00;
    mem[148] = 8'h60;     mem[149] = 8'h04;     mem[150] = 8'h00;     mem[151] = 8'h00;
    mem[152] = 8'h00;     mem[153] = 8'h04;     mem[154] = 8'h00;     mem[155] = 8'h00;
    mem[156] = 8'h00;     mem[157] = 8'h0c;     mem[158] = 8'h00;     mem[159] = 8'h00;
  end

  // Dùng lại tuyệt chiêu toán học: Địa chỉ = y * 4 + x / 8
  wire [7:0] addr = {sprite, y[4:0], x[4:3]};
  assign pixel = mem[addr][x[2:0]];

endmodule
