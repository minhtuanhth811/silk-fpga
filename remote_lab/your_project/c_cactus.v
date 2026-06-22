`default_nettype none

module c_cactus(
  input wire clk,
  input wire [9:0] abs_x,
  input wire [9:0] abs_y,
  output wire draw_cactus,
  input wire game_over,
  input wire rst_n
);
  reg [9:0] pix_x;
  reg [9:0] pix_y;
    
  // --- Cài đặt Kích thước và Tọa độ ---
  parameter GROUND_Y = 420; 
  parameter ZOOM = 2;
  // Cài đặt Xương rồng (Cactus)
  parameter CAC_W = 20 * ZOOM;
  parameter CAC_H = 20 * ZOOM;
  parameter CAC_START_X = 640; // Xuất phát từ mép phải màn hình
  parameter CAC_SPEED = 6;     // Tốc độ chạy của xương rồng
  wire [9:0] cac_y = GROUND_Y - CAC_H;
  // ==========================================
  // 1. THANH GHI TRẠNG THÁI (STATE REGISTERS)
  // ==========================================
  reg [9:0] cac_x = CAC_START_X;

  // ==========================================
  // 4. GAME ENGINE CHÍNH (VẬT LÝ & DI CHUYỂN)
  // ==========================================
  wire frame_tick = (pix_x == 0) & (pix_y == 0);
  always @(posedge clk) begin
      if (~rst_n) begin
          cac_x      <= CAC_START_X;
      end else if (frame_tick) begin
          if (game_over) begin
          end else begin
                // ---- XỬ LÝ XƯƠNG RỒNG CHẠY ----
                if (cac_x <= CAC_SPEED) 
                    cac_x <= CAC_START_X; // Cuốn chiếu vòng lại
                else 
                    cac_x <= cac_x - CAC_SPEED;
          end
      end
  end

  // ==========================================
  // 5. MẠCH RENDER ĐỒ HỌA
  // ==========================================
  wire [9:0] local_cac_x = pix_x - cac_x;
  wire [9:0] local_cac_y = pix_y - cac_y;
  wire cac_pixel_on;

  cactus_sprite my_cactus(
    .x(local_cac_x[5:1]),
    .y(local_cac_y[5:1]),
    .pixel(cac_pixel_on)
  );
                     
  wire draw_cactus = (pix_x >= cac_x) && (pix_x < cac_x + CAC_W) &&
                     (pix_y >= cac_y) && (pix_y < cac_y + CAC_H) &&
                     cac_pixel_on;
                     

endmodule
