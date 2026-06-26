module cactus_sprite(
  input wire [4:0] x, 
  input wire [4:0] y,
  output wire pixel
);
  reg [7:0] mem[79:0];
initial begin
    mem[0] = 8'hc0;     mem[1] = 8'h00;     mem[2] = 8'h00;     mem[3] = 8'h00;
    mem[4] = 8'he0;     mem[5] = 8'h01;     mem[6] = 8'h00;     mem[7] = 8'h00;
    mem[8] = 8'he0;     mem[9] = 8'h01;     mem[10] = 8'h00;     mem[11] = 8'h00;
    mem[12] = 8'he0;     mem[13] = 8'h01;     mem[14] = 8'h00;     mem[15] = 8'h00;
    mem[16] = 8'he6;     mem[17] = 8'h11;     mem[18] = 8'h00;     mem[19] = 8'h00;
    mem[20] = 8'hef;     mem[21] = 8'h39;     mem[22] = 8'h00;     mem[23] = 8'h00;
    mem[24] = 8'hef;     mem[25] = 8'h39;     mem[26] = 8'h00;     mem[27] = 8'h00;
    mem[28] = 8'hef;     mem[29] = 8'h39;     mem[30] = 8'h00;     mem[31] = 8'h00;
    mem[32] = 8'hff;     mem[33] = 8'h39;     mem[34] = 8'h00;     mem[35] = 8'h00;
    mem[36] = 8'hff;     mem[37] = 8'h39;     mem[38] = 8'h00;     mem[39] = 8'h00;
    mem[40] = 8'hfe;     mem[41] = 8'h39;     mem[42] = 8'h00;     mem[43] = 8'h00;
    mem[44] = 8'hfc;     mem[45] = 8'h39;     mem[46] = 8'h00;     mem[47] = 8'h00;
    mem[48] = 8'he0;     mem[49] = 8'h3f;     mem[50] = 8'h00;     mem[51] = 8'h00;
    mem[52] = 8'he0;     mem[53] = 8'h1f;     mem[54] = 8'h00;     mem[55] = 8'h00;
    mem[56] = 8'he0;     mem[57] = 8'h0f;     mem[58] = 8'h00;     mem[59] = 8'h00;
    mem[60] = 8'he0;     mem[61] = 8'h01;     mem[62] = 8'h00;     mem[63] = 8'h00;
    mem[64] = 8'he0;     mem[65] = 8'h01;     mem[66] = 8'h00;     mem[67] = 8'h00;
    mem[68] = 8'he0;     mem[69] = 8'h01;     mem[70] = 8'h00;     mem[71] = 8'h00;
    mem[72] = 8'he0;     mem[73] = 8'h01;     mem[74] = 8'h00;     mem[75] = 8'h00;
    mem[76] = 8'he0;     mem[77] = 8'h01;     mem[78] = 8'h00;     mem[79] = 8'h00;
  end
  wire [6:0] addr = {y[4:0],x[4:3]};
  assign pixel = mem[addr][x[2:0]];
endmodule 
