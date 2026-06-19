`default_nettype none

module palette(
  input wire [2:0] color_index,
  output wire [5:0] rrggbb
);
  reg [5:0] palette[7:0];
  
  palette[0] = 6'b00_00_00; //black
  palette[1] = 6'b00_00_11; //blue
  palette[2] = 6'b00_11_00; //green
  palette[3] = 6'b11_00_00; //red
  palette[4] = 6'b00_11_11; //cyan
  palette[5] = 6'b11_00_11; //purple
  palette[6] = 6'b11_11_00; //yellow
  palette[7] = 6'b11_11_11; //white

  assign rrggbb = palette[color_index];
  
endmodule
