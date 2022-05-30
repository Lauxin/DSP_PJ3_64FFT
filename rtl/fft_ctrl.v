//------------------------------------------------------------------------------
  //
  //  Filename       : fft_ctrl.v
  //  Author         : LiuXun
  //  Created        : 2020-08-02
  //  Description    : 64 points FFT(DIT) controller
  //
//------------------------------------------------------------------------------


module fft_ctrl(
  clk,
  rst_n,
  
  vld_i       ,
  fft_dat_re_i,
  fft_dat_im_i,
  vld_o       ,
  fft_dat_re_o,
  fft_dat_im_o,

  mem_dim_sel       ,
  mem_rd_addr_1x8   ,
  mem_rd_vld_1x8_inp,
  mem_rd_vld_1x8_out,
  mem_rd_dat_1x8    ,
  mem_wr_addr_1x8   ,
  mem_wr_vld_1x8    ,
  mem_wr_dat_1x8    ,
  
  mem_rd_addr_1x1   ,
  mem_rd_vld_1x1_inp,
  mem_rd_vld_1x1_out,
  mem_rd_dat_1x1    ,
  mem_wr_addr_1x1   ,
  mem_wr_vld_1x1    ,
  mem_wr_dat_1x1    ,
  
  fft_vld_inp,
  fft_din_re ,
  fft_din_im ,
  fft_wn_re  ,
  fft_wn_im  ,
  fft_vld_out,
  fft_dout_re,
  fft_dout_im,
  
  wn_vld_inp,
  wn_stg    ,
  wn_idx    ,
  wn_dat_re ,
  wn_dat_im
);

//*** PARAMETER ****************************************************************
parameter  FFT_DAT_WD  = 10;
parameter  FFT_W_N_WD  = 10;
parameter  SIZE_FFT = 64;

localparam LOG2_SIZE_FFT = 6;
localparam STG1_RD_START = 60;
localparam STG2_RD_START = 71;


//*** INPUT/OUTPUT *************************************************************
  input                               clk  ;
  input                               rst_n;
  // in/out 
  input                               vld_i       ;
  input       [FFT_DAT_WD     -1 : 0] fft_dat_re_i;
  input       [FFT_DAT_WD     -1 : 0] fft_dat_im_i;
  output wire                         vld_o       ;
  output wire [FFT_DAT_WD     -1 : 0] fft_dat_re_o;
  output wire [FFT_DAT_WD     -1 : 0] fft_dat_im_o;
  // 8x8mem 
  //---1x8--- 
  output wire                         mem_dim_sel       ;
  output reg  [3              -1 : 0] mem_rd_addr_1x8   ;
  output reg                          mem_rd_vld_1x8_inp;
  input                               mem_rd_vld_1x8_out;
  input       [FFT_DAT_WD*8*2 -1 : 0] mem_rd_dat_1x8    ;
  output wire [3              -1 : 0] mem_wr_addr_1x8   ;
  output wire                         mem_wr_vld_1x8    ;
  output wire [FFT_DAT_WD*8*2 -1 : 0] mem_wr_dat_1x8    ;
  //---1x1--- 
  output wire [6              -1 : 0] mem_rd_addr_1x1   ;
  output wire                         mem_rd_vld_1x1_inp;
  input                               mem_rd_vld_1x1_out;
  input       [FFT_DAT_WD*2   -1 : 0] mem_rd_dat_1x1    ;
  output wire [6              -1 : 0] mem_wr_addr_1x1   ;
  output wire                         mem_wr_vld_1x1    ;
  output wire [FFT_DAT_WD*2   -1 : 0] mem_wr_dat_1x1    ;
  // fft_core 
  output wire                         fft_vld_inp;
  output wire [FFT_DAT_WD*8   -1 : 0] fft_din_re ;
  output wire [FFT_DAT_WD*8   -1 : 0] fft_din_im ;
  output wire [FFT_W_N_WD*7   -1 : 0] fft_wn_re  ;
  output wire [FFT_W_N_WD*7   -1 : 0] fft_wn_im  ;
  input                               fft_vld_out;
  input       [FFT_DAT_WD*8   -1 : 0] fft_dout_re;
  input       [FFT_DAT_WD*8   -1 : 0] fft_dout_im;
  // wn 
  output wire                         wn_vld_inp;
  output wire                         wn_stg    ;
  output wire [3              -1 : 0] wn_idx    ;
  input       [FFT_W_N_WD*7   -1 : 0] wn_dat_re ;
  input       [FFT_W_N_WD*7   -1 : 0] wn_dat_im ;

//*** WIRE/REG *****************************************************************
  reg                                 vld_i_1d;
  reg                                 vld_o_1d;
  wire                                fft_start_pls;
  wire                                fft_end_pls;
  wire    [8                  -1 : 0] flg_stg1_ready;
  wire    [8                  -1 : 0] flg_stg2_ready;
  reg     [3                  -1 : 0] fft_rd_addr_tmp;
  reg                                 fft_vld_out_1pre;
  // cnt
  wire    [LOG2_SIZE_FFT      -1 : 0] re_idx_in;
  reg     [8                  -1 : 0] sys_cnt;


//*** MAIN BODY ****************************************************************
  //--- sys_cnt ---
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sys_cnt <= 8'd0;
    end
    else if (fft_start_pls == 1'b1) begin
      sys_cnt <= 8'd1;
    end
    else if (fft_end_pls == 1'b1) begin
      sys_cnt <= 8'd0;
    end
    else if (sys_cnt) begin
      sys_cnt <= sys_cnt + 1'b1;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      vld_i_1d <= 1'b0;
      vld_o_1d <= 1'd0;
    end
    else begin
      vld_i_1d <= vld_i;
      vld_o_1d <= vld_o;
    end
  end
  assign fft_start_pls = vld_i & ~vld_i_1d;
  assign fft_end_pls   = ~vld_o & vld_o_1d;

  //--- fft_mem 1x1 wr ---
  assign re_idx_in = {
    sys_cnt[0],
    sys_cnt[1],
    sys_cnt[2],
    sys_cnt[3],
    sys_cnt[4],
    sys_cnt[5]
  };
  assign mem_wr_addr_1x1 = re_idx_in;
  assign mem_wr_vld_1x1 = vld_i & sys_cnt < 64;
  assign mem_wr_dat_1x1 = {fft_dat_im_i, fft_dat_re_i};

  //--- fft_mem 1x8 rd ---
  // assign flg_stg1_ready = {
  //  re_idx_in == 6'd63, // sys_cnt = 63(111111)
  //  re_idx_in == 6'd55, // sys_cnt = 59(111011)
  //  re_idx_in == 6'd47, // sys_cnt = 61(111101)
  //  re_idx_in == 6'd39, // sys_cnt = 57(111001)
  //  re_idx_in == 6'd31, // sys_cnt = 62(111110)
  //  re_idx_in == 6'd23, // sys_cnt = 58(111010)
  //  re_idx_in == 6'd15, // sys_cnt = 60(111100)
  //  re_idx_in == 6'd7   // sys_cnt = 56(111000)
  // };
  assign flg_stg1_ready = {
    sys_cnt == STG1_RD_START + 7,
    sys_cnt == STG1_RD_START + 6,
    sys_cnt == STG1_RD_START + 5,
    sys_cnt == STG1_RD_START + 4,
    sys_cnt == STG1_RD_START + 3,
    sys_cnt == STG1_RD_START + 2,
    sys_cnt == STG1_RD_START + 1,
    sys_cnt == STG1_RD_START
  };
  assign flg_stg2_ready = {
    sys_cnt == STG2_RD_START + 7,
    sys_cnt == STG2_RD_START + 6,
    sys_cnt == STG2_RD_START + 5,
    sys_cnt == STG2_RD_START + 4,
    sys_cnt == STG2_RD_START + 3,
    sys_cnt == STG2_RD_START + 2,
    sys_cnt == STG2_RD_START + 1,
    sys_cnt == STG2_RD_START
  };

  always @(*) begin
    case (flg_stg1_ready | flg_stg2_ready)
      8'b0000_0001: fft_rd_addr_tmp = 3'd0;
      8'b0000_0010: fft_rd_addr_tmp = 3'd1;
      8'b0000_0100: fft_rd_addr_tmp = 3'd2;
      8'b0000_1000: fft_rd_addr_tmp = 3'd3;
      8'b0001_0000: fft_rd_addr_tmp = 3'd4;
      8'b0010_0000: fft_rd_addr_tmp = 3'd5;
      8'b0100_0000: fft_rd_addr_tmp = 3'd6;
      8'b1000_0000: fft_rd_addr_tmp = 3'd7;
      default:      fft_rd_addr_tmp = 3'd0;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mem_rd_addr_1x8    <= 3'd0;
      mem_rd_vld_1x8_inp <= 1'd0;
    end
    else begin
      mem_rd_addr_1x8    <= fft_rd_addr_tmp;
      mem_rd_vld_1x8_inp <= |(flg_stg1_ready | flg_stg2_ready);
    end
  end

  assign mem_dim_sel = sys_cnt > STG2_RD_START ? 1'b1 : 1'b0;


  //--- fft_mem 1x8 wr ---
  fft_ctrl_fifo #(
    .DATA_WD(3),
    .SIZE(3)
  ) fifo_rd2wr_u0 (
    .clk      ( clk                ),
    .rst_n    ( rst_n              ),
    .wr_vld_i ( mem_rd_vld_1x8_inp ),
    .wr_dat_i ( mem_rd_addr_1x8    ),
    .wr_ful_o (                    ),
    .rd_vld_i ( fft_vld_out_1pre   ),
    .rd_vld_o (                    ),
    .rd_dat_o ( mem_wr_addr_1x8    ),
    .rd_ept_o (                    )
  );
  assign mem_wr_vld_1x8 = fft_vld_out;
  assign mem_wr_dat_1x8 = {
    {fft_dout_im[7*FFT_DAT_WD +: FFT_DAT_WD], fft_dout_re[7*FFT_DAT_WD +: FFT_DAT_WD]},
    {fft_dout_im[6*FFT_DAT_WD +: FFT_DAT_WD], fft_dout_re[6*FFT_DAT_WD +: FFT_DAT_WD]},
    {fft_dout_im[5*FFT_DAT_WD +: FFT_DAT_WD], fft_dout_re[5*FFT_DAT_WD +: FFT_DAT_WD]},
    {fft_dout_im[4*FFT_DAT_WD +: FFT_DAT_WD], fft_dout_re[4*FFT_DAT_WD +: FFT_DAT_WD]},
    {fft_dout_im[3*FFT_DAT_WD +: FFT_DAT_WD], fft_dout_re[3*FFT_DAT_WD +: FFT_DAT_WD]},
    {fft_dout_im[2*FFT_DAT_WD +: FFT_DAT_WD], fft_dout_re[2*FFT_DAT_WD +: FFT_DAT_WD]},
    {fft_dout_im[FFT_DAT_WD   +: FFT_DAT_WD], fft_dout_re[FFT_DAT_WD   +: FFT_DAT_WD]},
    {fft_dout_im[0            +: FFT_DAT_WD], fft_dout_re[0            +: FFT_DAT_WD]}
  };

  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
      fft_vld_out_1pre <= 'd0;
    else
      fft_vld_out_1pre <= fft_vld_inp;
  end


  //--- fft_wn -----------------
  assign wn_vld_inp = mem_rd_vld_1x8_inp;
  assign wn_stg = mem_dim_sel;
  assign wn_idx = mem_rd_addr_1x8;


  //--- fft_core -----------------
  assign fft_din_re = {
    mem_rd_dat_1x8[7*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[6*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[5*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[4*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[3*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[2*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[1*2*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[0              +: FFT_DAT_WD]
  };
  assign fft_din_im = {
    mem_rd_dat_1x8[(7*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[(6*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[(5*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[(4*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[(3*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[(2*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[(1*2+1)*FFT_DAT_WD +: FFT_DAT_WD],
    mem_rd_dat_1x8[FFT_DAT_WD         +: FFT_DAT_WD]
  };
  assign fft_vld_inp = mem_rd_vld_1x8_out;
  assign fft_wn_re = wn_dat_re;
  assign fft_wn_im = wn_dat_im;


  //--- output -----------------
  assign mem_rd_vld_1x1_inp = sys_cnt >= STG2_RD_START + 5 && sys_cnt < STG2_RD_START + 5 + 64;
  assign mem_rd_addr_1x1 = sys_cnt - STG2_RD_START - 5;
  
  assign vld_o = mem_rd_vld_1x1_out;
  assign fft_dat_re_o = mem_rd_dat_1x1[0 +: FFT_DAT_WD];
  assign fft_dat_im_o = mem_rd_dat_1x1[FFT_DAT_WD +: FFT_DAT_WD];


endmodule
