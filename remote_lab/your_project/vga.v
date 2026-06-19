// 00 00 00 den
// 00 00 01 duong
// 00 00 10 den
// 00 00 11 duong

// 00 01 00 lá
// 00 01 01 lơ
// 00 01 10 lá
// 00 01 11 lơ

// 00 10 00 đen
// 00 10 01
// 00 10 10
// 00 10 11
// ...
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
  localparam WIDTH_PIX = 640;
  localparam HEIGHT_PIX = 480;
  reg [9:0] x = 0;
  reg [9:0] y = 0;
  reg [2:0] color = 0;
  reg [5:0] frame_count = 0;
  palette palette_inst(
    .color_index(color),
    .rrggbb({r,g,b})
  )
  always @(posedge clk) begin
    //có kẽ sẽ có lỗi logic lấy mốc 0 lệch
    // 0 trong code là tính từ trước back porch porch -> video -> porch -> retrace
    // co thể có lỗi logic video -> porch -> retrace -> porch cho vsync, hsync khác
    if (x >= 48 && x <= 687 && y >= 33 && y <= 512) video_active <= 1; else video_active <= 0;
    if (x >= 0 && x <= 703) hsync <= 1; else hsync <= 0;
    if (y >= 0 && y <= 522) vsync <= 1; else vsync <= 0;

    // co le se co bug de if(y==524) ở ngoài if(x==799) để gây ra lỗi logic mất dòng cuối
    if (x == 799) begin  
      x <= 0;
      if (y == 524) begin
        y <= 0;
        if(frame_count == 30) begin
          color <= color + 1;
          frame_count <= 0;
        end
        else frame_count <= frame_count + 1;
      end
      else y <= y + 1;
    end
    else x <= x + 1;
  end
endmodule
