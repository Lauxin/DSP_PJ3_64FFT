//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core8.v
    //  Author         : LiuXun
    //  Created        : 2020-08-02
    //  Description    : FFT core. 8 points FFT based on core2
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_core8 ( 
    fft_data_re_i,
    fft_data_im_i,
    fft_wn_re_i,
    fft_wn_im_i,

    fft_data_re_o,
    fft_data_im_o
  );

  // TODO: The deeper the stage is, the longer the data width require.
  // TODO: think of other base-8-fft algrithm, instead of based on base-2-fft.
  // TODO: modify micro defination.

  //*** PARAMETER ****************************************************************


  //*** INPUT/OUTPUT *************************************************************
  input   [8 * `DATA_WID  -1 : 0]  fft_data_re_i, fft_data_im_i;
  input   [4 * `WN_WID    -1 : 0]  fft_wn_re_i, fft_wn_im_i;

  output  [8 * `DATA_WID  -1 : 0]  fft_data_re_o, fft_data_im_o;

  //*** WIRE/REG *****************************************************************
  wire    [8 * `DATA_WID  -1 : 0] fft_data_re_stage2;
  wire    [8 * `DATA_WID  -1 : 0] fft_data_im_stage2;
  wire    [8 * `DATA_WID  -1 : 0] fft_data_re_stage3;
  wire    [8 * `DATA_WID  -1 : 0] fft_data_im_stage3;

  //*** MAIN BODY ****************************************************************
  // stage 1


  // stage 2


  // stage 3
  fft_core2 fft_core2_u31 ( 
    .fft_data_re1_i ( fft_data_re_stage2[`DATA_WID -1 : 0] ),
    .fft_data_im1_i ( fft_data_im_stage2[`DATA_WID -1 : 0] ),
    .fft_data_re2_i ( fft_data_re_stage2[5*`DATA_WID -1 : 4*`DATA_WID] ),
    .fft_data_im2_i ( fft_data_im_stage2[5*`DATA_WID -1 : 4*`DATA_WID] ),
    .fft_wn_re_i ( fft_wn_re_i[`WN_WID -1 : 0] ),
    .fft_wn_im_i ( fft_wn_im_i[`WN_WID -1 : 0] ),

    .fft_data_re1_o ( fft_data_re_stage3[`DATA_WID -1 : 0] ),
    .fft_data_im1_o ( fft_data_im_stage3[`DATA_WID -1 : 0] ),
    .fft_data_re2_o ( fft_data_re_stage3[5*`DATA_WID -1 : 4*`DATA_WID] ),
    .fft_data_im2_o ( fft_data_im_stage3[5*`DATA_WID -1 : 4*`DATA_WID] )
  );

  fft_core2 fft_core2_u32 ( 
    .fft_data_re1_i ( fft_data_re_stage2[2*`DATA_WID -1 : `DATA_WID] ),
    .fft_data_im1_i ( fft_data_im_stage2[2*`DATA_WID -1 : `DATA_WID] ),
    .fft_data_re2_i ( fft_data_re_stage2[6*`DATA_WID -1 : 5*`DATA_WID] ),
    .fft_data_im2_i ( fft_data_im_stage2[6*`DATA_WID -1 : 5*`DATA_WID] ),
    .fft_wn_re_i ( fft_wn_re_i[2*`WN_WID -1 : `WN_WID] ),
    .fft_wn_im_i ( fft_wn_im_i[2*`WN_WID -1 : `WN_WID] ),

    .fft_data_re1_o ( fft_data_re_stage3[2*`DATA_WID -1 : `DATA_WID] ),
    .fft_data_im1_o ( fft_data_im_stage3[2*`DATA_WID -1 : `DATA_WID] ),
    .fft_data_re2_o ( fft_data_re_stage3[6*`DATA_WID -1 : 5*`DATA_WID] ),
    .fft_data_im2_o ( fft_data_im_stage3[6*`DATA_WID -1 : 5*`DATA_WID] )
  );

  fft_core2 fft_core2_u33 ( 
    .fft_data_re1_i ( fft_data_re_stage2[3*`DATA_WID -1 : 2*`DATA_WID] ),
    .fft_data_im1_i ( fft_data_im_stage2[3*`DATA_WID -1 : 2*`DATA_WID] ),
    .fft_data_re2_i ( fft_data_re_stage2[7*`DATA_WID -1 : 6*`DATA_WID] ),
    .fft_data_im2_i ( fft_data_im_stage2[7*`DATA_WID -1 : 6*`DATA_WID] ),
    .fft_wn_re_i ( fft_wn_re_i[3*`WN_WID -1 : 2*`WN_WID] ),
    .fft_wn_im_i ( fft_wn_im_i[3*`WN_WID -1 : 2*`WN_WID] ),

    .fft_data_re1_o ( fft_data_re_stage3[3*`DATA_WID -1 : 2*`DATA_WID] ),
    .fft_data_im1_o ( fft_data_im_stage3[3*`DATA_WID -1 : 2*`DATA_WID] ),
    .fft_data_re2_o ( fft_data_re_stage3[7*`DATA_WID -1 : 6*`DATA_WID] ),
    .fft_data_im2_o ( fft_data_im_stage3[7*`DATA_WID -1 : 6*`DATA_WID] )
  );

  fft_core2 fft_core2_u34 ( 
    .fft_data_re1_i ( fft_data_re_stage2[4*`DATA_WID -1 : 3*`DATA_WID] ),
    .fft_data_im1_i ( fft_data_im_stage2[4*`DATA_WID -1 : 3*`DATA_WID] ),
    .fft_data_re2_i ( fft_data_re_stage2[8*`DATA_WID -1 : 7*`DATA_WID] ),
    .fft_data_im2_i ( fft_data_im_stage2[8*`DATA_WID -1 : 7*`DATA_WID] ),
    .fft_wn_re_i ( fft_wn_re_i[4*`WN_WID -1 : 3*`WN_WID] ),
    .fft_wn_im_i ( fft_wn_im_i[4*`WN_WID -1 : 3*`WN_WID] ),

    .fft_data_re1_o ( fft_data_re_stage3[4*`DATA_WID -1 : 3*`DATA_WID] ),
    .fft_data_im1_o ( fft_data_im_stage3[4*`DATA_WID -1 : 3*`DATA_WID] ),
    .fft_data_re2_o ( fft_data_re_stage3[8*`DATA_WID -1 : 7*`DATA_WID] ),
    .fft_data_im2_o ( fft_data_im_stage3[8*`DATA_WID -1 : 7*`DATA_WID] )
  );

  assign fft_data_re_o = fft_data_re_stage3;
  assign fft_data_im_o = fft_data_im_stage3;

endmodule



//*** SUB MODULE ****************************************************************

module fft_core2(
    fft_data_re1_i,
    fft_data_im1_i,
    fft_data_re2_i,
    fft_data_im2_i,
    fft_wn_re_i,
    fft_wn_im_i,

    fft_data_re1_o,
    fft_data_im1_o,
    fft_data_re2_o,
    fft_data_im2_o
  );

  //*** PARAMETER ****************************************************************


  //*** INPUT/OUTPUT *************************************************************
  input  signed [`DATA_WID -1 :0] fft_data_re1_i, fft_data_re2_i;
  input  signed [`DATA_WID -1 :0] fft_data_im1_i, fft_data_im2_i;
  input  signed [`WN_WID -1   :0] fft_wn_re_i;
  input  signed [`WN_WID -1   :0] fft_wn_im_i;

  output signed [`DATA_WID -1 :0] fft_data_re1_o, fft_data_re2_o;
  output signed [`DATA_WID -1 :0] fft_data_im1_o, fft_data_im2_o;

  //*** WIRE/REG *****************************************************************
  wire   signed [`DATA_WID + `WN_WID -1 :0] fft_re1_enl, fft_im1_enl; //enlarged data
  wire   signed [`DATA_WID + `WN_WID -1 :0] fft_re2_enl, fft_im2_enl; //enlarged data

  reg    signed [`DATA_WID + `WN_WID -1 :0] fft_cal_re1_out, fft_cal_im1_out;
  reg    signed [`DATA_WID + `WN_WID -1 :0] fft_cal_re2_out, fft_cal_im2_out;


  //*** MAIN BODY ****************************************************************
  assign fft_re1_enl = {{`WN_WID{fft_data_re1_i[`DATA_WID -1]}}, fft_data_re1_i};
  assign fft_im1_enl = {{`WN_WID{fft_data_im1_i[`DATA_WID -1]}}, fft_data_im1_i};
  assign fft_re2_enl = {{`WN_WID{fft_data_re2_i[`DATA_WID -1]}}, fft_data_re2_i};
  assign fft_im2_enl = {{`WN_WID{fft_data_im2_i[`DATA_WID -1]}}, fft_data_im2_i};

  always @(*) begin
    fft_cal_re1_out = (fft_re1_enl << `ACC_LEN) + (fft_re2_enl*fft_wn_re_i - fft_im2_enl*fft_wn_im_i);
    fft_cal_im1_out = (fft_im1_enl << `ACC_LEN) + (fft_re2_enl*fft_wn_im_i + fft_im2_enl*fft_wn_re_i);
    fft_cal_re2_out = (fft_re1_enl << `ACC_LEN) - (fft_re2_enl*fft_wn_re_i - fft_im2_enl*fft_wn_im_i);
    fft_cal_im2_out = (fft_im1_enl << `ACC_LEN) - (fft_re2_enl*fft_wn_im_i + fft_im2_enl*fft_wn_re_i);
  end

  assign fft_data_re1_o = (fft_cal_re1_out >> `ACC_LEN) + fft_cal_re1_out[`ACC_LEN -1];
  assign fft_data_im1_o = (fft_cal_im1_out >> `ACC_LEN) + fft_cal_im1_out[`ACC_LEN -1];
  assign fft_data_re2_o = (fft_cal_re2_out >> `ACC_LEN) + fft_cal_re2_out[`ACC_LEN -1];
  assign fft_data_im2_o = (fft_cal_im2_out >> `ACC_LEN) + fft_cal_im2_out[`ACC_LEN -1];

endmodule
