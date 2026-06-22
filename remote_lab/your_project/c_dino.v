`default_nettype none
`define COLOR_CYAN  3'd5

module c_dino
  (
    input wire clk,
    input wire [9:0] abs_x,
    input wire [9:0] abs_y,
    input wire       rst_n,
    input wire       game_over,
    output wire      draw_dino,
    output wire      state,
    input wire       command
  );
    reg [9:0] pix_x;
    reg [9:0] pix_y;

    parameter GROUND_Y = 420; 

    // Cài đặt Khủng long (Dino)
    parameter DINO_SIZE = 20; 
    parameter ZOOM = 2;       // Phóng to 4x
    parameter DINO_W = DINO_SIZE * ZOOM; // 80 pixel
    parameter DINO_H = DINO_SIZE * ZOOM; // 80 pixel
    parameter DINO_X = 60;      
    localparam DINO_START_Y = GROUND_Y - DINO_H; // 320 - 80 = 240


    // ==========================================
    // 1. THANH GHI TRẠNG THÁI (STATE REGISTERS)
    // ==========================================
    reg signed [10:0] dino_y_reg = DINO_START_Y;
    reg signed [10:0] dino_vy = 0;

    // ==========================================
    // 3. GAME ENGINE CHÍNH (VẬT LÝ & DI CHUYỂN)
    // ==========================================
    always @(posedge clk) begin
        if (~rst_n) begin
            dino_y_reg <= DINO_START_Y;
            dino_vy    <= 0;
            jumping <= 0;
        end else if (frame_tick) begin
          if (game_over) begin
          end else begin
              // ---- XỬ LÝ KHỦNG LONG NHẢY ----
              if (dino_y_reg < DINO_START_Y) begin
                  dino_y_reg <= dino_y_reg + dino_vy;
                  dino_vy    <= dino_vy + 1; // Trọng lực
              end else begin
                  dino_y_reg <= DINO_START_Y;
                  jumping <= 0;
                  if (command) begin
                      dino_vy    <= -12; // Lực bật nhảy
                      dino_y_reg <= DINO_START_Y - 12; 
                      jumping <= 1;
                  end else begin
                      dino_vy    <= 0;
                  end
              end
            end
        end
    end

    wire [9:0] dino_y = dino_y_reg[9:0];

    // ==========================================
    // 5. MẠCH RENDER ĐỒ HỌA
    // ==========================================
    wire [9:0] local_dino_x = pix_x - DINO_X;
    wire [9:0] local_dino_y = pix_y - dino_y;
    wire dino_pixel_on;

    dino_sprite my_dino (
      .x(local_dino_x[5:1]), 
      .y(local_dino_y[5:1]),
      .pixel(dino_pixel_on)
    );

    assign draw_dino  = (pix_x >= DINO_X) && (pix_x < DINO_X + DINO_W) &&
                       (pix_y >= dino_y) && (pix_y < dino_y + DINO_H) &&
                       dino_pixel_on;

endmodule
