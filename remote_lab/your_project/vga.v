`default_nettype none
`define COLOR_CYAN  3'd5

module top_module(
  input wire       clk,
  output reg      hsync,
  output reg      vsync,
  output reg      video_active,
  output reg [1:0] r,
  output reg [1:0] g,
  output reg [1:0] b,
  input wire       rst_n,
  input wire [7:0] SW
);
  reg [9:0] x;
  reg [9:0] y;
  reg [2:0] color = 0;
  reg [5:0] frame_count = 0;
  palette palette_inst(
    .color_index(color),
    .rrggbb({r,g,b})
  );
  scanner scanner_inst(
    .clk(clk),
    .rst_n(~rst_n), //loi o day nữa, do rst_n khi không ân luôn là 1
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .abs_x(x),
    .abs_y(y)
  );
  always @(posedge clk) begin
    if(x == 0 && y ==0) begin
      if (frame_count == 29) begin
        frame_count <= 0;
        color <= color + 1;
      end
      else frame_count <= frame_count + 1;
    end
  end
endmodule
