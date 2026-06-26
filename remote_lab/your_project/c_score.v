`default_nettype none

module c_score #(
    parameter X_PLAY = 540, 
    parameter Y_PLAY = 20, 
    parameter X_GO = 288, 
    parameter Y_GO = 290
)(
    input wire clk,
    input wire rst_n,
    input wire frame_tick,
    input wire game_over,
    output wire draw_score,
    input wire [9:0] abs_x,
    input wire [9:0] abs_y,
    input wire count

);
    wire [3:0] dig0, dig1, dig2, dig3;
    always @(posedge clk) begin
        if (~rst_n || (game_over && dig0 == 0 && dig1 == 0)) begin
            // Lưu ý: Chỉ xóa điểm về 0 khi vừa bấm Reset chơi lại (~rst_n)
            dig0 <= 0; dig1 <= 0; dig2 <= 0; dig3 <= 0;
        end 
        else if (frame_tick && !game_over) begin
            if (count) begin
                // Thuật toán đếm BCD (Binary Coded Decimal)
                if (dig0 == 9) begin
                    dig0 <= 0;
                    if (dig1 == 9) begin
                        dig1 <= 0;
                        if (dig2 == 9) begin
                            dig2 <= 0;
                            if (dig3 < 9) dig3 <= dig3 + 1;
                        end else dig2 <= dig2 + 1;
                    end else dig1 <= dig1 + 1;
                end else dig0 <= dig0 + 1;
            end 
        end
    end

    // 1. CHỌN TỌA ĐỘ GỐC (BÍ KÍP DỊCH CHUYỂN KHÔNG GIAN)
    // - Đang chơi (!game_over): Góc trên phải (X = 540, Y = 20)
    // - Game over: Chính giữa màn hình, dưới chữ Game Over (X = 288, Y = 290)
    wire [9:0] base_x = game_over ? X_GO : X_PLAY;
    wire [9:0] base_y = game_over ? Y_GO : Y_PLAY;

    wire [9:0] lx = abs_x - base_x;
    wire [9:0] ly = abs_y - base_y;

    // Kiểm tra tia quét có đang nằm trong "khu đất" của bảng điểm không (rộng 64, cao 20)
    wire in_box = (abs_x >= base_x) && (abs_x < base_x + 64) &&
                  (abs_y >= base_y) && (abs_y < base_y + 20);

    // 2. BỘ DỒN KÊNH CHỌN SỐ (Nhờ lũy thừa 2, lx[5:4] tự động tách lô)
    reg [3:0] curr_dig;
    always @* begin
        case (lx[5:4])
            2'd0: curr_dig = dig3; // Lô 0: Hàng Nghìn
            2'd1: curr_dig = dig2; // Lô 1: Hàng Trăm
            2'd2: curr_dig = dig1; // Lô 2: Hàng Chục
            2'd3: curr_dig = dig0; // Lô 3: Hàng Đơn vị
        endcase
    end

    // 3. FONT ROM 3x5 SIÊU NHỎ (Phóng to 4x -> Chữ rộng 12px, cao 20px)
    // Mỗi chữ số gồm 15 bit (3 cột x 5 hàng). 
    reg [14:0] font_rom [0:9];
    initial begin
        font_rom[0] = 15'b111_101_101_101_111; // Số 0
        font_rom[1] = 15'b010_110_010_010_111; // Số 1
        font_rom[2] = 15'b111_001_111_100_111; // Số 2
        font_rom[3] = 15'b111_001_111_001_111; // Số 3
        font_rom[4] = 15'b101_101_111_001_001; // Số 4
        font_rom[5] = 15'b111_100_111_001_111; // Số 5
        font_rom[6] = 15'b111_100_111_101_111; // Số 6
        font_rom[7] = 15'b111_001_010_100_100; // Số 7
        font_rom[8] = 15'b111_101_111_101_111; // Số 8
        font_rom[9] = 15'b111_101_111_001_111; // Số 9
    end

    // Tọa độ bên trong 1 ký tự 3x5 (lấy lx[3:2] là chia 4, ly[4:2] là chia 4)
    wire [1:0] fx = lx[3:2]; // 0..2
    wire [2:0] fy = ly[4:2]; // 0..4

    // Công thức biến tọa độ 2D thành chỉ số mảng 1D: bit_idx = fy * 3 + fx
    wire [3:0] bit_idx = (fy << 1) + fy + fx; 

    // Điều kiện bật điểm sáng: nằm trong vùng chữ (lx[3:0] < 12) VÀ bit trong ROM = 1
    wire pixel_on = (lx[3:0] < 12) && font_rom[curr_dig][14 - bit_idx];

    assign draw_score = in_box && pixel_on;

endmodule