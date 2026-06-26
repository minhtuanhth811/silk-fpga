module game_over_sprite(
  input wire [5:0] x, 
  input wire [2:0] y,
  output wire pixel
);
    reg [7:0] mem[40:0];
    initial begin
        mem[0] = 8'hc6;     mem[1] = 8'h44;     mem[2] = 8'h0f;     mem[3] = 8'h13;     mem[4] = 8'hbd;     mem[5] = 8'h03;     mem[6] = 8'h00;     mem[7] = 8'h00;
        mem[8] = 8'h21;     mem[9] = 8'h6d;     mem[10] = 8'h81;     mem[11] = 8'h14;     mem[12] = 8'h85;     mem[13] = 8'h04;     mem[14] = 8'h00;     mem[15] = 8'h00;
        mem[16] = 8'hed;     mem[17] = 8'h55;     mem[18] = 8'h87;     mem[19] = 8'ha4;     mem[20] = 8'h9c;     mem[21] = 8'h03;     mem[22] = 8'h00;     mem[23] = 8'h00;
        mem[24] = 8'h29;     mem[25] = 8'h45;     mem[26] = 8'h81;     mem[27] = 8'ha4;     mem[28] = 8'h84;     mem[29] = 8'h02;     mem[30] = 8'h00;     mem[31] = 8'h00;
        mem[32] = 8'h26;     mem[33] = 8'h45;     mem[34] = 8'h0f;     mem[35] = 8'h43;     mem[36] = 8'hbc;     mem[37] = 8'h04;     mem[38] = 8'h00;     mem[39] = 8'h00;
    end
    wire [5:0] addr = {y[2:0],x[5:3]};
    assign pixel = mem[addr][x[2:0]];
endmodule 