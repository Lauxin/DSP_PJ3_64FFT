//------------------------------------------------------------------------------
  //
  //  Filename       : fft_top.v
  //  Author         : LiuXun
  //  Created        : 2022-05-28
  //  Description    : Top level of FFT64
  //
//------------------------------------------------------------------------------

module fft_top #(
  parameter FFT_DAT_WD = 10,
  parameter FFT_W_N_WD = 10,
  parameter SIZE_FFT = 64
) (
  input                             clk,
  input                             rst_n,
  input                             vld_i,
  input       [FFT_DAT_WD   -1 : 0] fft_dat_re_i,
  input       [FFT_DAT_WD   -1 : 0] fft_dat_im_i,
  output wire                       vld_o,
  output wire [FFT_DAT_WD   -1 : 0] fft_dat_re_o,
  output wire [FFT_DAT_WD   -1 : 0] fft_dat_im_o
);

//*** WIRE/REG *****************************************************************
  // fft_mem
  wire                         mem_dim_sel       ;
  wire [3              -1 : 0] mem_rd_addr_1x8   ;
  wire                         mem_rd_vld_1x8_inp;
  wire                         mem_rd_vld_1x8_out;
  wire [FFT_DAT_WD*8*2 -1 : 0] mem_rd_dat_1x8    ;
  wire [3              -1 : 0] mem_wr_addr_1x8   ;
  wire                         mem_wr_vld_1x8    ;
  wire [FFT_DAT_WD*8*2 -1 : 0] mem_wr_dat_1x8    ;
  wire [6              -1 : 0] mem_rd_addr_1x1   ;
  wire                         mem_rd_vld_1x1_inp;
  wire                         mem_rd_vld_1x1_out;
  wire [FFT_DAT_WD*2   -1 : 0] mem_rd_dat_1x1    ;
  wire [6              -1 : 0] mem_wr_addr_1x1   ;
  wire                         mem_wr_vld_1x1    ;
  wire [FFT_DAT_WD*2   -1 : 0] mem_wr_dat_1x1    ;
  // fft_core 8
  wire                         fft_vld_inp;
  wire [FFT_DAT_WD*8   -1 : 0] fft_din_re ;
  wire [FFT_DAT_WD*8   -1 : 0] fft_din_im ;
  wire [FFT_W_N_WD*7   -1 : 0] fft_wn_re  ;
  wire [FFT_W_N_WD*7   -1 : 0] fft_wn_im  ;
  wire                         fft_vld_out;
  wire [FFT_DAT_WD*8   -1 : 0] fft_dout_re;
  wire [FFT_DAT_WD*8   -1 : 0] fft_dout_im;
  // wn 
  wire                         wn_vld_inp;
  wire                         wn_stg    ;
  wire [3              -1 : 0] wn_idx    ;
  wire [FFT_W_N_WD*7   -1 : 0] wn_dat_re ;
  wire [FFT_W_N_WD*7   -1 : 0] wn_dat_im ;


//*** MAIN BODY ****************************************************************
fft_ctrl #(
  .FFT_DAT_WD ( FFT_DAT_WD ),
  .FFT_W_N_WD ( FFT_W_N_WD ),
  .SIZE_FFT   ( SIZE_FFT   )
) fft_ctrl_u0 (
  .clk   ( clk   ),
  .rst_n ( rst_n ),
  // top
  .vld_i        ( vld_i        ),
  .fft_dat_re_i ( fft_dat_re_i ),
  .fft_dat_im_i ( fft_dat_im_i ),
  .vld_o        ( vld_o        ),
  .fft_dat_re_o ( fft_dat_re_o ),
  .fft_dat_im_o ( fft_dat_im_o ),
  // fft_mem
  .mem_dim_sel        ( mem_dim_sel        ),
  .mem_rd_addr_1x8    ( mem_rd_addr_1x8    ),
  .mem_rd_vld_1x8_inp ( mem_rd_vld_1x8_inp ),
  .mem_rd_vld_1x8_out ( mem_rd_vld_1x8_out ),
  .mem_rd_dat_1x8     ( mem_rd_dat_1x8     ),
  .mem_wr_addr_1x8    ( mem_wr_addr_1x8    ),
  .mem_wr_vld_1x8     ( mem_wr_vld_1x8     ),
  .mem_wr_dat_1x8     ( mem_wr_dat_1x8     ),
  .mem_rd_addr_1x1    ( mem_rd_addr_1x1    ),
  .mem_rd_vld_1x1_inp ( mem_rd_vld_1x1_inp ),
  .mem_rd_vld_1x1_out ( mem_rd_vld_1x1_out ),
  .mem_rd_dat_1x1     ( mem_rd_dat_1x1     ),
  .mem_wr_addr_1x1    ( mem_wr_addr_1x1    ),
  .mem_wr_vld_1x1     ( mem_wr_vld_1x1     ),
  .mem_wr_dat_1x1     ( mem_wr_dat_1x1     ),
  // fft_core8
  .fft_vld_inp ( fft_vld_inp ),
  .fft_din_re  ( fft_din_re  ),
  .fft_din_im  ( fft_din_im  ),
  .fft_wn_re   ( fft_wn_re   ),
  .fft_wn_im   ( fft_wn_im   ),
  .fft_vld_out ( fft_vld_out ),
  .fft_dout_re ( fft_dout_re ),
  .fft_dout_im ( fft_dout_im ),
  // fft_wn
  .wn_vld_inp ( wn_vld_inp ),
  .wn_stg     ( wn_stg     ),
  .wn_idx     ( wn_idx     ),
  .wn_dat_re  ( wn_dat_re  ),
  .wn_dat_im  ( wn_dat_im  )
);

fft_mem #(
  .DATA_WD ( FFT_DAT_WD + FFT_DAT_WD )
) fft_mem_u0 (
  .rst_n         ( rst_n              ),
  .clk           ( clk                ),
  .dim_sel_i     ( mem_dim_sel        ),
  //rd
  .rd_addr_1x8_i ( mem_rd_addr_1x8    ),
  .rd_vld_1x8_i  ( mem_rd_vld_1x8_inp ),
  .rd_vld_1x8_o  ( mem_rd_vld_1x8_out ),
  .rd_dat_1x8_o  ( mem_rd_dat_1x8     ),
  //wr
  .wr_addr_1x8_i ( mem_wr_addr_1x8    ),
  .wr_vld_1x8_i  ( mem_wr_vld_1x8     ),
  .wr_dat_1x8_i  ( mem_wr_dat_1x8     ),
  //rd
  .rd_addr_1x1_i ( mem_rd_addr_1x1    ),
  .rd_vld_1x1_i  ( mem_rd_vld_1x1_inp ),
  .rd_vld_1x1_o  ( mem_rd_vld_1x1_out ),
  .rd_dat_1x1_o  ( mem_rd_dat_1x1     ),
  //wr
  .wr_addr_1x1_i ( mem_wr_addr_1x1    ),
  .wr_vld_1x1_i  ( mem_wr_vld_1x1     ),
  .wr_dat_1x1_i  ( mem_wr_dat_1x1     )
);

fft_wn #(
  .FFT_WN_WD ( FFT_W_N_WD )
) fft_wn_u0 (
  .clk       ( clk        ),
  .rst_n     ( rst_n      ),
  .vld_in    ( wn_vld_inp ),
  .fft_stg   ( wn_stg     ),
  .fft_idx   ( wn_idx     ),
  .vld_out   (            ),
  .fft_wn_re ( wn_dat_re  ),
  .fft_wn_im ( wn_dat_im  )
);

fft_core8 #(
  .FFT_DATA_WD ( FFT_DAT_WD ),
  .FFT_WN_WD   ( FFT_W_N_WD )
) fft_core8_u0 (
  .rst_n       ( rst_n       ),
  .clk         ( clk         ),
  .vld_in      ( fft_vld_inp ),
  .fft_din_re  ( fft_din_re  ),
  .fft_din_im  ( fft_din_im  ),
  .fft_wn_re   ( fft_wn_re   ),
  .fft_wn_im   ( fft_wn_im   ),
  .vld_out     ( fft_vld_out ),
  .fft_dout_re ( fft_dout_re ),
  .fft_dout_im ( fft_dout_im )
);

endmodule
