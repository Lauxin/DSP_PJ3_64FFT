//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core8.v
    //  Author         : LiuXun
    //  Created        : 2020-08-02
    //  Description    : FFT core. 8 points FFT based on core2
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_core2(
  dat_fft_1_re_i,
  dat_fft_1_im_i,
  dat_fft_2_re_i,
  dat_fft_2_im_i,
  dat_wn_re_i,
  dat_wn_im_i,
  
  dat_fft_1_re_o,
  dat_fft_1_im_o,
  dat_fft_2_re_o,
  dat_fft_2_im_o
);

//*** PARAMETER ************
  //global
  parameter     DATA_INP_WD = -1 ;
  parameter     DATA_OUT_WD = -1 ;
  parameter     DATA_W_N_WD = -1 ;
  parameter     DATA_FRC_WD = -1 ;
  //derived
  // localparam    DATA_OUT_WD = (DATA_INP_WD-DATA_FRC_WD) + (DATA_W_N_WD-DATA_FRC_WD) + 1 + DATA_FRC_WD ;
  localparam    DATA_MUL_WD = DATA_INP_WD + DATA_W_N_WD + 1 ;

//*** INPUT/OUTPUT *********
  input  signed [DATA_INP_WD      -1 :0] dat_fft_1_re_i, dat_fft_1_im_i ;
  input  signed [DATA_INP_WD      -1 :0] dat_fft_2_re_i, dat_fft_2_im_i ;
  input  signed [DATA_W_N_WD      -1 :0] dat_wn_re_i   , dat_wn_im_i    ;

  output signed [DATA_OUT_WD      -1 :0] dat_fft_1_re_o, dat_fft_1_im_o ;
  output signed [DATA_OUT_WD      -1 :0] dat_fft_2_re_o, dat_fft_2_im_o ;

//*** WIRE/REG *************
  reg    signed [DATA_MUL_WD      -1 :0] dat_mul_1_re_w, dat_mul_1_im_w ; 
  reg    signed [DATA_MUL_WD      -1 :0] dat_mul_2_re_w, dat_mul_2_im_w ; 

//*** MAIN BODY ************
  // "*" and "<<" in verilog will expend to the output width
  always @(*) begin
    dat_mul_1_re_w = (dat_fft_1_re_i << DATA_FRC_WD) + (dat_fft_2_re_i*dat_wn_re_i - dat_fft_2_im_i*dat_wn_im_i);
    dat_mul_1_im_w = (dat_fft_1_im_i << DATA_FRC_WD) + (dat_fft_2_re_i*dat_wn_im_i + dat_fft_2_im_i*dat_wn_re_i);
    dat_mul_2_re_w = (dat_fft_1_re_i << DATA_FRC_WD) - (dat_fft_2_re_i*dat_wn_re_i - dat_fft_2_im_i*dat_wn_im_i);
    dat_mul_2_im_w = (dat_fft_1_im_i << DATA_FRC_WD) - (dat_fft_2_re_i*dat_wn_im_i + dat_fft_2_im_i*dat_wn_re_i);
  end

  // fraction round / floor
  assign dat_fft_1_re_o = (dat_mul_1_re_w >> DATA_FRC_WD) /*+ fft_cal_re1_out[`DATA_FRC_WD -1]*/;
  assign dat_fft_1_im_o = (dat_mul_1_im_w >> DATA_FRC_WD) /*+ fft_cal_im1_out[`DATA_FRC_WD -1]*/;
  assign dat_fft_2_re_o = (dat_mul_2_re_w >> DATA_FRC_WD) /*+ fft_cal_re2_out[`DATA_FRC_WD -1]*/;
  assign dat_fft_2_im_o = (dat_mul_2_im_w >> DATA_FRC_WD) /*+ fft_cal_im2_out[`DATA_FRC_WD -1]*/;

endmodule

