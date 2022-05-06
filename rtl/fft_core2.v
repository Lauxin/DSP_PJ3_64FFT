//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core8.v
    //  Author         : LiuXun
    //  Created        : 2020-08-02
    //  Description    : FFT core. 8 points FFT based on core2
    //                   
//------------------------------------------------------------------------------


module fft_core2(
  fft_din_1_re,
  fft_din_1_im,
  fft_din_2_re,
  fft_din_2_im,
  fft_wn_re,
  fft_wn_im,
  
  fft_dout_1_re,
  fft_dout_1_im,
  fft_dout_2_re,
  fft_dout_2_im
);

//*** PARAMETER ************
  //global
  parameter     FFT_DATA_WD   = 10 ;
  parameter     FFT_WN_WD     = 10 ;
  //derived
  localparam    DATA_MUL_WD     = FFT_DATA_WD + FFT_WN_WD;
  localparam    DATA_MUL_ADD_WD = FFT_DATA_WD + FFT_WN_WD + 1;
  localparam    DATA_WN_FRC_WD = FFT_WN_WD - 2;

//*** INPUT/OUTPUT *********
  input         [FFT_DATA_WD      -1 :0] fft_din_1_re;
  input         [FFT_DATA_WD      -1 :0] fft_din_1_im;
  input         [FFT_DATA_WD      -1 :0] fft_din_2_re;
  input         [FFT_DATA_WD      -1 :0] fft_din_2_im;
  input         [FFT_WN_WD        -1 :0] fft_wn_re;
  input         [FFT_WN_WD        -1 :0] fft_wn_im;

  output wire   [FFT_DATA_WD      -1 :0] fft_dout_1_re;
  output wire   [FFT_DATA_WD      -1 :0] fft_dout_1_im;
  output wire   [FFT_DATA_WD      -1 :0] fft_dout_2_re;
  output wire   [FFT_DATA_WD      -1 :0] fft_dout_2_im;

//*** WIRE/REG *************
  reg    signed [DATA_MUL_WD      -1 :0] dat_mul_upper_re;
  reg    signed [DATA_MUL_WD      -1 :0] dat_mul_upper_im;
  reg    signed [DATA_MUL_WD      -1 :0] dat_mul_downer_re;
  reg    signed [DATA_MUL_WD      -1 :0] dat_mul_downer_im;
  reg    signed [DATA_MUL_ADD_WD  -1 :0] dat_mul_add_1_re;
  reg    signed [DATA_MUL_ADD_WD  -1 :0] dat_mul_add_1_im;
  reg    signed [DATA_MUL_ADD_WD  -1 :0] dat_mul_add_2_re;
  reg    signed [DATA_MUL_ADD_WD  -1 :0] dat_mul_add_2_im;

//*** MAIN BODY ************
  always @(*) begin
    dat_mul_upper_re = $signed(fft_din_1_re) <<< DATA_WN_FRC_WD;
    dat_mul_upper_im = $signed(fft_din_1_im) <<< DATA_WN_FRC_WD;
    //!!! In case of multiplication of $signed data, the bitwidth shrink with 1bit
    dat_mul_downer_re = $signed(fft_din_2_re) * $signed(fft_wn_re) - $signed(fft_din_2_im) * $signed(fft_wn_im);
    dat_mul_downer_im = $signed(fft_din_2_im) * $signed(fft_wn_re) + $signed(fft_din_2_re) * $signed(fft_wn_im);
    dat_mul_add_1_re = dat_mul_upper_re + dat_mul_downer_re;
    dat_mul_add_1_im = dat_mul_upper_im + dat_mul_downer_im;
    dat_mul_add_2_re = dat_mul_upper_re - dat_mul_downer_re;
    dat_mul_add_2_im = dat_mul_upper_im - dat_mul_downer_im;
  end

  // fraction floor
  assign fft_dout_1_re = (dat_mul_add_1_re >>> DATA_WN_FRC_WD);
  assign fft_dout_1_im = (dat_mul_add_1_im >>> DATA_WN_FRC_WD);
  assign fft_dout_2_re = (dat_mul_add_2_re >>> DATA_WN_FRC_WD);
  assign fft_dout_2_im = (dat_mul_add_2_im >>> DATA_WN_FRC_WD);

  //!!! overflow

endmodule

