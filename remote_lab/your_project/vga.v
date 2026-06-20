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
  reg [9:0] pix_x;
  reg [9:0] pix_y;
  reg [2:0] color = 0;
  reg [5:0] frame_count = 0;
  // palette palette_inst(
  //   .color_index(color),
  //   .rrggbb({r,g,b})
  // );
  scanner scanner_inst(
    .clk(clk),
    .reset(~rst_n), //loi o day nữa, do rst_n khi không ân luôn là 1
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .abs_x(pix_x),
    .abs_y(pix_y)
  );
  // --- Cài đặt Kích thước và Tọa độ ---
    parameter GROUND_Y = 420; 

    // Cài đặt Khủng long (Dino)
    parameter DINO_SIZE = 20; 
    parameter ZOOM = 2;       // Phóng to 4x
    parameter DINO_W = DINO_SIZE * ZOOM; // 80 pixel
    parameter DINO_H = DINO_SIZE * ZOOM; // 80 pixel
    parameter DINO_X = 60;      
    localparam DINO_START_Y = GROUND_Y - DINO_H; // 320 - 80 = 240

    // Cài đặt Xương rồng (Cactus)
    parameter CAC_W = 20;
    parameter CAC_H = 20;
    parameter CAC_START_X = 640; // Xuất phát từ mép phải màn hình
    parameter CAC_SPEED = 6;     // Tốc độ chạy của xương rồng
    wire [9:0] cac_y = GROUND_Y - CAC_H;

    // ==========================================
    // 1. THANH GHI TRẠNG THÁI (STATE REGISTERS)
    // ==========================================
    reg signed [10:0] dino_y_reg = DINO_START_Y;
    reg signed [10:0] dino_vy = 0;
    reg [9:0] cac_x = CAC_START_X;
    reg game_over = 0; // Cờ trạng thái: 0 = Đang chơi, 1 = Chết

    // ==========================================
    // 2. MẠCH ĐỌC NÚT BẤM (EDGE DETECTOR)
    // ==========================================
    reg sw0_dly;
    always @(posedge clk) begin
        if (~rst_n) sw0_dly <= 1'b0;
        else        sw0_dly <= SW[0];
    end
    wire jump_edge = SW[0] && !sw0_dly;

    reg jump_latched = 0;
    wire frame_tick = (pix_x == 0 && pix_y == 0); // Kích hoạt 1 lần mỗi khung hình (60Hz)

    always @(posedge clk) begin
        if (~rst_n || game_over) begin
            jump_latched <= 0; // Xóa chốt nhảy nếu chết
        end else begin
            if (jump_edge) 
                jump_latched <= 1;
            else if (frame_tick && (dino_y_reg >= DINO_START_Y))
                jump_latched <= 0;
        end
    end
    // ==========================================
    // 3. THUẬT TOÁN VA CHẠM AABB (COLLISION)
    // ==========================================
    /* Hitbox Optimization: Cộng/trừ đi một lượng dung sai (margin = 10) 
       vào các cạnh để Khủng long không bị chết oan do khoảng trắng. */
    wire collision = (draw_dino == 1) && (draw_cactus == 1);

    // ==========================================
    // 4. GAME ENGINE CHÍNH (VẬT LÝ & DI CHUYỂN)
    // ==========================================
    always @(posedge clk) begin
        if (~rst_n) begin
            dino_y_reg <= DINO_START_Y;
            dino_vy    <= 0;
            cac_x      <= CAC_START_X;
            game_over  <= 0;
        end else if (frame_tick) begin
            if (game_over) begin
                // TRẠNG THÁI GAME OVER: Đứng im. Chờ bấm nhảy để Reset
                if (jump_edge) begin
                    game_over  <= 0;
                    cac_x      <= CAC_START_X;
                    dino_y_reg <= DINO_START_Y;
                    dino_vy    <= 0;
                end
            end else begin
                // Kiểm tra chết ở đầu khung hình
                if (collision) begin
                    game_over <= 1;
                end else begin
                    // ---- XỬ LÝ XƯƠNG RỒNG CHẠY ----
                    if (cac_x <= CAC_SPEED) 
                        cac_x <= CAC_START_X; // Cuốn chiếu vòng lại
                    else 
                        cac_x <= cac_x - CAC_SPEED;
                    
                    // ---- XỬ LÝ KHỦNG LONG NHẢY ----
                    if (dino_y_reg < DINO_START_Y) begin
                        dino_y_reg <= dino_y_reg + dino_vy;
                        dino_vy    <= dino_vy + 1; // Trọng lực
                    end else begin
                        dino_y_reg <= DINO_START_Y;
                        if (jump_latched) begin
                            dino_vy    <= -12; // Lực bật nhảy
                            dino_y_reg <= DINO_START_Y - 12; 
                        end else begin
                            dino_vy    <= 0;
                        end
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
    wire [9:0] local_cac_x = pix_x - cac_x;
    wire [9:0] local_cac_y = pix_y - cac_y;
    wire dino_pixel_on;
    wire cac_pixel_on;

    dino_sprite my_dino (
      .x(local_dino_x[5:1]), 
      .y(local_dino_y[5:1]),
      .pixel(dino_pixel_on)
    );
    cactus_sprite my_cactus(
      .x(local_cac_x[5:1]),
      .y(local_cac_y[5:1]),
      .pixel(cac_pixel_on)
    );

    wire draw_dino   = (pix_x >= DINO_X) && (pix_x < DINO_X + DINO_W) &&
                       (pix_y >= dino_y) && (pix_y < dino_y + DINO_H) &&
                       dino_pixel_on;
                       
    wire draw_cactus = (pix_x >= cac_x) && (pix_x < cac_x + CAC_W) &&
                       (pix_y >= cac_y) && (pix_y < cac_y + CAC_H) &&
                       cac_pixel_on;
                       
    wire draw_ground = (pix_y == GROUND_Y) || (pix_y == GROUND_Y + 1);

    always @(posedge clk) begin
        if (~rst_n) begin
            r <= 2'b00; g <= 2'b00; b <= 2'b00;
        end else begin
            if (video_active) begin
                if (draw_dino) begin
                    // Nếu chết (game_over = 1), biến thành màu ĐỎ. Bình thường màu XANH LÁ.
                    r <= game_over ? 2'b11 : 2'b00; 
                    g <= game_over ? 2'b00 : 2'b11; 
                    b <= 2'b00; 
                end else if (draw_cactus) begin
                    r <= 2'b11; g <= 2'b00; b <= 2'b00; // Cây xương rồng đỏ
                end else if (draw_ground) begin
                    r <= 2'b11; g <= 2'b11; b <= 2'b11; // Nền đất trắng
                end else begin
                    r <= 2'b00; g <= 2'b00; b <= 2'b00; // Bầu trời đen
                end
            end else begin
                r <= 2'b00; g <= 2'b00; b <= 2'b00; // Blanking
            end
        end
    end

endmodule

