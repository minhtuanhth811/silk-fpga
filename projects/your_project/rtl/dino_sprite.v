`default_nettype none

module dino_sprite (
    input wire [4:0] x, // Tọa độ local X (0 -> 19)
    input wire [4:0] y, // Tọa độ local Y (0 -> 19)
    output wire pixel
);
  // Lưới 32x20 = 80 byte. Lưu ý: Lấy LSB làm pixel bên trái trước.
  reg [7:0] mem[79:0];

 initial begin
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
    mem[64] = 8'he0;     mem[65] = 8'h06;     mem[66] = 8'h00;     mem[67] = 8'h00;
    mem[68] = 8'h60;     mem[69] = 8'h04;     mem[70] = 8'h00;     mem[71] = 8'h00;
    mem[72] = 8'h20;     mem[73] = 8'h04;     mem[74] = 8'h00;     mem[75] = 8'h00;
    mem[76] = 8'h60;     mem[77] = 8'h0c;     mem[78] = 8'h00;     mem[79] = 8'h00;
  end

  // Dùng lại tuyệt chiêu toán học: Địa chỉ = y * 4 + x / 8
  wire [6:0] addr = {y[4:0], x[4:3]};
  assign pixel = mem[addr][x[2:0]];

endmodule
