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
    parameter ZOOM = 4;       // Phóng to 4x
    parameter DINO_W = DINO_SIZE * ZOOM; // 80 pixel
    parameter DINO_H = DINO_SIZE * ZOOM; // 80 pixel
    parameter DINO_X = 60;      
    wire [9:0] dino_y = GROUND_Y - DINO_H; 

    // Cài đặt Xương rồng (Cactus)
    parameter CAC_W = 20;
    parameter CAC_H = 60;
    parameter CAC_X = 500;      
    wire [9:0] cac_y = GROUND_Y - CAC_H;   


    // Khai báo kiểu SIGNED (có dấu) để làm toán cộng trừ vận tốc âm/dương
    reg signed [10:0] dino_y_reg = DINO_START_Y;
    reg signed [10:0] dino_vy = 0;
    
    // 1. Mạch bắt cạnh lên (posedge) của công tắc SW[0]
    reg sw0_dly;
    always @(posedge clk) begin
        if (~rst_n) sw0_dly <= 1'b0;
        else        sw0_dly <= SW[0];
    end
    wire jump_edge = SW[0] && !sw0_dly; // Bật lên 1 chu kỳ clock khi gạt công tắc

    // 2. Mạch chốt lệnh nhảy (LATCH) chờ xử lý ở đầu Frame
    reg jump_latched = 0;
    always @(posedge clk) begin
        if (~rst_n) begin
            jump_latched <= 0;
        end else begin
            if (jump_edge) 
                jump_latched <= 1; // Giữ lệnh muốn nhảy
            else if (frame_tick && (dino_y_reg >= DINO_START_Y))
                jump_latched <= 0; // Xóa lệnh sau khi đã thực hiện cú nhảy trên mặt đất
        end
    end

    // Xung kích hoạt tính toán vật lý: Chỉ chạy 1 lần khi sang Frame mới (60Hz)
    wire frame_tick = (pix_x == 0 && pix_y == 0);

    // 3. Khối tính toán Trọng lực và Vị trí qua từng Frame
    always @(posedge clk) begin
        if (~rst_n) begin
            dino_y_reg <= DINO_START_Y;
            dino_vy    <= 0;
        end else if (frame_tick) begin
            if (dino_y_reg < DINO_START_Y) begin
                // TRẠNG THÁI TRÊN KHÔNG: Rơi tự do
                dino_y_reg <= dino_y_reg + dino_vy;  // Cập nhật vị trí bằng vận tốc hiện tại
                dino_vy    <= dino_vy + 1;           // Trọng lực: Gia tăng vận tốc rơi (+1 mỗi frame)
            end else begin
                // TRẠNG THÁI MẶT ĐẤT: Đứng yên chờ lệnh
                dino_y_reg <= DINO_START_Y;
                if (jump_latched) begin
                    dino_vy    <= -14; // Lực nhảy ban đầu (dấu âm để kéo tọa độ Y giảm, tức là bay lên)
                    dino_y_reg <= DINO_START_Y - 14; // Nhấc nhẹ thân lên để thoát khỏi điều kiện mặt đất ở frame sau
                end else begin
                    dino_vy    <= 0;
                end
            end
        end
    end

    // Ép kiểu ngược từ signed reg về wire unsigned 10-bit để đưa vào mạch hiển thị
    wire [9:0] dino_y = dino_y_reg[9:0];
    // --- Logic vẽ Khủng long từ ROM ---
    // Tính tọa độ nội bộ của Dino (0 -> 79)
    wire [9:0] local_dino_x = pix_x - DINO_X;
    wire [9:0] local_dino_y = pix_y - dino_y;
    wire dino_pixel_on;
    
    // Trích xuất bit [6:2] tương đương chia 4 để tạo hiệu ứng Zoom 4x
    dino_sprite my_dino (
        .x(local_dino_x[6:2]), 
        .y(local_dino_y[6:2]),
        .pixel(dino_pixel_on)
    );

    // --- Cờ Vẽ (Draw Flags) ---
    // Kiểm tra tia quét có đang nằm lọt trong Bounding Box hay không
    wire in_dino_box = (pix_x >= DINO_X) && (pix_x < DINO_X + DINO_W) &&
                       (pix_y >= dino_y) && (pix_y < dino_y + DINO_H);
                       
    wire draw_dino   = in_dino_box && dino_pixel_on; // Chỉ vẽ khi bit trong ROM = 1

    wire draw_cactus = (pix_x >= CAC_X) && (pix_x < CAC_X + CAC_W) &&
                       (pix_y >= cac_y) && (pix_y < cac_y + CAC_H);

    wire draw_ground = (pix_y == GROUND_Y) || (pix_y == GROUND_Y + 1);

    // --- Xuất màu ra màn hình ---
    always @(posedge clk) begin
        if (~rst_n) begin
            r <= 2'b11; g <= 2'b11; b <= 2'b11;
        end else begin
            if (video_active) begin
                // Trộn màu theo thứ tự ưu tiên (Lớp trên vẽ trước)
                if (draw_dino) begin
                    r <= 2'b00; g <= 2'b00; b <= 2'b00; // Xanh lá cây
                end else if (draw_cactus) begin
                    r <= 2'b11; g <= 2'b00; b <= 2'b00; // Đỏ
                end else if (draw_ground) begin
                    r <= 2'b00; g <= 2'b00; b <= 2'b00; // đen
                end else begin
                    r <= 2'b11; g <= 2'b11; b <= 2'b11; // Nền trắng
                end
            end else begin
                // Video Blanking: Bắt buộc tắt màu khi ra ngoài khung nhìn
                r <= 2'b00; g <= 2'b00; b <= 2'b00; 
            end
        end
    end

endmodule
