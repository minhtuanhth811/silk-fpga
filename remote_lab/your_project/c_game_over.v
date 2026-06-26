`default_nettype none

module c_game_over #(
    parameter ZOOM = 8,
    parameter GO_START_X = 148, // Xuất phát từ mép phải màn hình
    parameter GO_START_Y = 220, // Xuất phát từ mép phải màn hìn
    parameter GO_SPEED = 6    // Tốc độ chạy của xương rồng
    parameter GO_W = 43 * ZOOM;
    parameter GO_H = 5 * ZOOM;
)(
    input wire clk,
    input wire frame_tick,
    input wire [9:0] abs_x,
    input wire [9:0] abs_y,
    output wire draw_game_over,
    input wire game_over,
    input wire rst_n
);

  // ==========================================
  // 5. MẠCH RENDER ĐỒ HỌA
  // ==========================================
  wire [9:0] local_go_x = abs_x - go_x;
  wire [9:0] local_go_y = abs_y - go_y;
  wire go_pixel_on;

  game_over_sprite go_inst(
    .x(local_go_x[8:3]),
    .y(local_go_y[5:3]),
    .pixel(go_pixel_on)
  );
                     
  assign draw_game_over = (abs_x >= go_x) && (abs_x < go_x + GO_W) &&
                          (abs_y >= go_y) && (abs_y < go_y + GO_H) &&
                          go_pixel_on && game_over;
                     

endmodule
