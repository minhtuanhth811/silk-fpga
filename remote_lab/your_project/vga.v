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
  palette palette_inst(
    .color_index(color),
    .rrggbb({r,g,b})
  );
  scanner scanner_inst(
    .clk(clk),
    .reset(~rst_n), //loi o day nữa, do rst_n khi không ân luôn là 1
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .abs_x(x),
    .abs_y(y)
  );
  // --- Cài đặt Kích thước và Tọa độ ---
    parameter GROUND_Y = 320; 

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
    parameter CAC_X = 400;      
    wire [9:0] cac_y = GROUND_Y - CAC_H;   

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
            r <= 2'b00; g <= 2'b00; b <= 2'b00;
        end else begin
            if (video_active) begin
                // Trộn màu theo thứ tự ưu tiên (Lớp trên vẽ trước)
                if (draw_dino) begin
                    r <= 2'b00; g <= 2'b11; b <= 2'b00; // Xanh lá cây
                end else if (draw_cactus) begin
                    r <= 2'b11; g <= 2'b00; b <= 2'b00; // Đỏ
                end else if (draw_ground) begin
                    r <= 2'b11; g <= 2'b11; b <= 2'b11; // Trắng
                end else begin
                    r <= 2'b00; g <= 2'b00; b <= 2'b00; // Nền đen
                end
            end else begin
                // Video Blanking: Bắt buộc tắt màu khi ra ngoài khung nhìn
                r <= 2'b00; g <= 2'b00; b <= 2'b00; 
            end
        end
    end

endmodule
