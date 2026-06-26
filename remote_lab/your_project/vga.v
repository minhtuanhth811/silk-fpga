`default_nettype none
`define COLOR_CYAN  3'd5

module top_module(
  input wire       clk,
  output wire      hsync,
  output wire      vsync,
  output wire      video_active,
  output reg [1:0] r,
  output reg [1:0] g,
  output reg [1:0] b,
  input wire       rst_n,
  input wire [7:0] SW
);
  wire [9:0] pix_x;
  wire [9:0] pix_y;
  wire draw_dino;
  wire draw_cactus;
  reg [5:0] frame_count = 0;
  wire frame_tick;
  
  scanner scanner_inst(
    .clk(clk),
    .reset(~rst_n), //loi o day nữa, do rst_n khi không ân luôn là 1
    .hsync(hsync),
    .vsync(vsync),
    .frame_tick(frame_tick),
    .display_on(video_active),
    .abs_x(pix_x),
    .abs_y(pix_y)
  );
  
  // tao vat the
  c_dino dino_inst(
    .clk(clk),
    .abs_x(pix_x),
    .abs_y(pix_y),
    .frame_tick(frame_tick),
    .rst_n(reset_n),
    .game_over(game_over),
    .draw_dino(draw_dino),
    .command(jump_latch),
    .state(jumping)
  );
  
  c_cactus cactus_inst(
    .clk(clk),
    .abs_x(pix_x),
    .abs_y(pix_y),
    .rst_n(reset_n),
    .frame_tick(frame_tick),
    .game_over(game_over),
    .draw_cactus(draw_cactus)
  );
  
  parameter GROUND_Y = 420; 
  wire draw_ground = (pix_y == GROUND_Y) || (pix_y == GROUND_Y + 1);
  
  // 2. xu ly nut bam
  reg prev_sw;
  wire edge_detector = !prev_sw & SW[0];
  always @(posedge clk) begin
    if (~rst_n) prev_sw <= 0;
    else prev_sw <= SW[0];
  end

  reg game_over = 0; // Cờ trạng thái: 0 = Đang chơi, 1 = Chết
  reg collision_latched = 0;
  wire collision = (draw_dino == 1) && (draw_cactus == 1);
  reg game_reset_n_reg = 1;
  wire reset_n = rst_n & game_reset_n_reg;

  always @(posedge clk) begin
    if(~rst_n) begin
      game_over <= 0;
      collision_latched <= 0;
      game_reset_n_reg <= 1;
    end
    else begin
      if(game_over && edge_detector) begin
        game_reset_n_reg <= 0;
        game_over <= 0;
        collision_latched <= 0;
      end
      else begin
        game_reset_n_reg <= 1;
      end
      if (!game_over  && collision) begin
        game_over <= 1;
        collision_latched <= 1;
      end
    end
  end


  reg jump_latch;
  wire jumping;
  //wire reset_n = rst_n & !(game_over & edge_detector); dùng wire thì nguy hiểm do dễ bị glitch làm nhảy toàn hệ thống
  always @(posedge clk) begin
    if (~rst_n || game_over || frame_tick || jumping) jump_latch <= 0;
    else if (edge_detector && !game_over) begin 
      jump_latch <= 1;
    end
  end
      

  
    // ==========================================
    // 5. MẠCH RENDER ĐỒ HỌA
    // ==========================================
    always @(posedge clk) begin
        if (~rst_n) begin
            r <= 2'b11; g <= 2'b11; b <= 2'b11;
        end else begin
            if (video_active) begin
                if (draw_dino) begin
                    // Nếu chết (game_over = 1), biến thành màu ĐỎ. Bình thường màu XANH LÁ.
                    r <= 2'b00; 
                    g <= 2'b00; 
                    b <= 2'b00; 
                end else if (draw_cactus) begin
                    r <= 2'b00; g <= 2'b00; b <= 2'b00; // Cây xương rồng đỏ
                end else if (draw_ground) begin
                    r <= 2'b00; g <= 2'b00; b <= 2'b00; // Nền đất trắng
                end else begin
                    r <= 2'b11; g <= 2'b11; b <= 2'b11; // Bầu trời đen
                end
            end else begin
                r <= 2'b11; g <= 2'b11; b <= 2'b11; // Blanking
            end
        end
    end


endmodule

