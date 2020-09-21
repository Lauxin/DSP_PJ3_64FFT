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
    fft_dat_re_i,
    fft_dat_im_i
    fft_wn_re_i,
    fft_wn_im_i

    fft_dat_re_o,
    fft_dat_im_o
  );

  // TODO: The deeper the stage is, the longer the data width requires.
  // TODO: modify micro defination.
  // TODO: Think of other base-8-fft algrithm, instead of based on base-2-fft. (in a future version)
  

  //*** PARAMETER ****************************************************************
  parameter     DATA_INP_WD = -1;
  parameter     DATA_OUT_WD = -1;
  // DATA_OUT_WD should be 3*((DATA_INP_WD-`DATA_FRA_WD) + (`CFG_WN_WD-`DATA_FRA_WD) +1) + `DATA_FRA_WD
  // Will report warning if WIDTH donot match

  localparam    DATA_SG1_WD =   ((DATA_INP_WD-`DATA_FRA_WD) + (`CFG_WN_WD-`DATA_FRA_WD) +1) + `DATA_FRA_WD;
  localparam    DATA_SG2_WD = 2*((DATA_INP_WD-`DATA_FRA_WD) + (`CFG_WN_WD-`DATA_FRA_WD) +1) + `DATA_FRA_WD;

  //*** INPUT/OUTPUT *************************************************************
  input   [8*DATA_INP_WD   -1 : 0]  fft_dat_re_i;
  input   [8*DATA_INP_WD   -1 : 0]  fft_dat_im_i;
  input   [4*`CFG_WN_WD    -1 : 0]  fft_wn_re_i;
  input   [4*`CFG_WN_WD    -1 : 0]  fft_wn_im_i;

  output  [8*DATA_OUT_WD   -1 : 0]  fft_dat_re_o;
  output  [8*DATA_OUT_WD   -1 : 0]  fft_dat_re_o;

  //*** WIRE/REG *****************************************************************
  wire    [8*DATA_SG1_WD     -1 : 0] fft_dat_re_d1_w;
  wire    [8*DATA_SG1_WD     -1 : 0] fft_dat_im_d1_w;
  wire    [8*DATA_SG2_WD     -1 : 0] fft_dat_re_d2_w;
  wire    [8*DATA_SG2_WD     -1 : 0] fft_dat_im_d2_w;
  wire    [8*DATA_OUT_WD     -1 : 0] fft_dat_re_d3_w;
  wire    [8*DATA_OUT_WD     -1 : 0] fft_dat_im_d3_w;

  //*** MAIN BODY ****************************************************************
  //===== stage 0 =====
  // 0 1 | 2 3 | 4 5 | 6 7
  // wn0 | wn0 | wn0 | wn0
  fft_core2 #(
    .DATA_INP_WD( DATA_INP_WD ),
    .DATA_OUT_WD( DATA_SG1_WD )
  ) fft_core2_u00 (
    .fft_dat1_i ( {fft_dat_re_i   [8*DATA_INP_WD-1 : 7*DATA_INP_WD], fft_dat_im_i   [8*DATA_INP_WD-1 : 7*DATA_INP_WD]} ),
    .fft_dat2_i ( {fft_dat_re_i   [7*DATA_INP_WD-1 : 6*DATA_INP_WD], fft_dat_im_i   [7*DATA_INP_WD-1 : 6*DATA_INP_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d1_w[8*DATA_SG1_WD-1 : 7*DATA_SG1_WD], fft_dat_im_d1_w[8*DATA_SG1_WD-1 : 7*DATA_SG1_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d1_w[7*DATA_SG1_WD-1 : 6*DATA_SG1_WD], fft_dat_im_d1_w[7*DATA_SG1_WD-1 : 6*DATA_SG1_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_INP_WD ),
    .DATA_OUT_WD( DATA_SG1_WD )
  ) fft_core2_u01 (
    .fft_dat1_i ( {fft_dat_re_i   [6*DATA_INP_WD-1 : 5*DATA_INP_WD], fft_dat_im_i   [6*DATA_INP_WD-1 : 5*DATA_INP_WD]} ),
    .fft_dat2_i ( {fft_dat_re_i   [5*DATA_INP_WD-1 : 4*DATA_INP_WD], fft_dat_im_i   [5*DATA_INP_WD-1 : 4*DATA_INP_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d1_w[6*DATA_SG1_WD-1 : 5*DATA_SG1_WD], fft_dat_im_d1_w[6*DATA_SG1_WD-1 : 5*DATA_SG1_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d1_w[5*DATA_SG1_WD-1 : 4*DATA_SG1_WD], fft_dat_im_d1_w[5*DATA_SG1_WD-1 : 4*DATA_SG1_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_INP_WD ),
    .DATA_OUT_WD( DATA_SG1_WD )
  ) fft_core2_u02 (
    .fft_dat1_i ( {fft_dat_re_i   [4*DATA_INP_WD-1 : 3*DATA_INP_WD], fft_dat_im_i   [4*DATA_INP_WD-1 : 3*DATA_INP_WD]} ),
    .fft_dat2_i ( {fft_dat_re_i   [3*DATA_INP_WD-1 : 2*DATA_INP_WD], fft_dat_im_i   [3*DATA_INP_WD-1 : 2*DATA_INP_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d1_w[4*DATA_SG1_WD-1 : 3*DATA_SG1_WD], fft_dat_im_d1_w[4*DATA_SG1_WD-1 : 3*DATA_SG1_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d1_w[3*DATA_SG1_WD-1 : 2*DATA_SG1_WD], fft_dat_im_d1_w[3*DATA_SG1_WD-1 : 2*DATA_SG1_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_INP_WD ),
    .DATA_OUT_WD( DATA_SG1_WD )
  ) fft_core2_u03 (
    .fft_dat1_i ( {fft_dat_re_i   [2*DATA_INP_WD-1 :   DATA_INP_WD], fft_dat_im_i   [2*DATA_INP_WD-1 :   DATA_INP_WD]} ),
    .fft_dat2_i ( {fft_dat_re_i   [  DATA_INP_WD-1 :             0], fft_dat_im_i   [  DATA_INP_WD-1 :             0]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d1_w[2*DATA_SG1_WD-1 :   DATA_SG1_WD], fft_dat_im_d1_w[2*DATA_SG1_WD-1 :   DATA_SG1_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d1_w[  DATA_SG1_WD-1 :             0], fft_dat_im_d1_w[  DATA_SG1_WD-1 :             0]} )
  );

  //===== stage 1 =====
  // 0 2 | 1 3 | 4 6 | 5 7
  // wn0 | wn2 | wn0 | wn2
  fft_core2 #(
    .DATA_INP_WD( DATA_SG1_WD ),
    .DATA_OUT_WD( DATA_SG2_WD )
  ) fft_core2_u10 (
    .fft_dat1_i ( {fft_dat_re_d1_w[8*DATA_SG1_WD-1 : 7*DATA_SG1_WD], fft_dat_im_d1_w[8*DATA_SG1_WD-1 : 7*DATA_SG1_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d1_w[6*DATA_SG1_WD-1 : 5*DATA_SG1_WD], fft_dat_im_d1_w[6*DATA_SG1_WD-1 : 5*DATA_SG1_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[8*DATA_SG2_WD-1 : 7*DATA_SG2_WD], fft_dat_im_d2_w[8*DATA_SG2_WD-1 : 7*DATA_SG2_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[6*DATA_SG2_WD-1 : 5*DATA_SG2_WD], fft_dat_im_d2_w[6*DATA_SG2_WD-1 : 5*DATA_SG2_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_SG1_WD ),
    .DATA_OUT_WD( DATA_SG2_WD )
  ) fft_core2_u11 (
    .fft_dat1_i ( {fft_dat_re_d1_w[7*DATA_SG1_WD-1 : 6*DATA_SG1_WD], fft_dat_im_d1_w[7*DATA_SG1_WD-1 : 6*DATA_SG1_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d1_w[5*DATA_SG1_WD-1 : 4*DATA_SG1_WD], fft_dat_im_d1_w[5*DATA_SG1_WD-1 : 4*DATA_SG1_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [2*`CFG_WN_WD -1 :    `CFG_WN_WD], fft_wn_im_i    [2*`CFG_WN_WD -1 :    `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[7*DATA_SG2_WD-1 : 6*DATA_SG2_WD], fft_dat_im_d2_w[7*DATA_SG2_WD-1 : 6*DATA_SG2_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[5*DATA_SG2_WD-1 : 4*DATA_SG2_WD], fft_dat_im_d2_w[5*DATA_SG2_WD-1 : 4*DATA_SG2_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_SG1_WD ),
    .DATA_OUT_WD( DATA_SG2_WD )
  ) fft_core2_u12 (
    .fft_dat1_i ( {fft_dat_re_d1_w[4*DATA_SG1_WD-1 : 3*DATA_SG1_WD], fft_dat_im_d1_w[4*DATA_SG1_WD-1 : 3*DATA_SG1_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d1_w[2*DATA_SG1_WD-1 :   DATA_SG1_WD], fft_dat_im_d1_w[2*DATA_SG1_WD-1 :   DATA_SG1_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[4*DATA_SG2_WD-1 : 3*DATA_SG2_WD], fft_dat_im_d2_w[4*DATA_SG2_WD-1 : 3*DATA_SG2_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[2*DATA_SG2_WD-1 :   DATA_SG2_WD], fft_dat_im_d2_w[2*DATA_SG2_WD-1 :   DATA_SG2_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_SG1_WD ),
    .DATA_OUT_WD( DATA_SG2_WD )
  ) fft_core2_u13 (
    .fft_dat1_i ( {fft_dat_re_d1_w[3*DATA_SG1_WD-1 : 2*DATA_SG1_WD], fft_dat_im_d1_w[3*DATA_SG1_WD-1 : 2*DATA_SG1_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d1_w[  DATA_SG1_WD-1 :             0], fft_dat_im_d1_w[  DATA_SG1_WD-1 :             0]} ),
    .fft_wn_i   ( {fft_wn_re_i    [2*`CFG_WN_WD -1 :    `CFG_WN_WD], fft_wn_im_i    [2*`CFG_WN_WD -1 :    `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[3*DATA_SG2_WD-1 : 2*DATA_SG2_WD], fft_dat_im_d2_w[3*DATA_SG2_WD-1 : 2*DATA_SG2_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[  DATA_SG2_WD-1 :             0], fft_dat_im_d2_w[  DATA_SG2_WD-1 :             0]} )
  );

  //===== stage 2 =====
  // 0 4 | 1 5 | 2 6 | 3 7
  // wn0 | wn1 | wn2 | wn3
  fft_core2 #(
    .DATA_INP_WD( DATA_SG2_WD ),
    .DATA_OUT_WD( DATA_OUT_WD )
  ) fft_core2_u20 (
    .fft_dat1_i ( {fft_dat_re_d2_w[8*DATA_SG2_WD-1 : 7*DATA_SG2_WD], fft_dat_im_d2_w[8*DATA_SG2_WD-1 : 7*DATA_SG2_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d2_w[4*DATA_SG2_WD-1 : 3*DATA_SG2_WD], fft_dat_im_d2_w[4*DATA_SG2_WD-1 : 3*DATA_SG2_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD], fft_wn_im_i    [4*`CFG_WN_WD -1 : 3* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[8*DATA_OUT_WD-1 : 7*DATA_OUT_WD], fft_dat_im_d2_w[8*DATA_OUT_WD-1 : 7*DATA_OUT_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[4*DATA_OUT_WD-1 : 3*DATA_OUT_WD], fft_dat_im_d2_w[4*DATA_OUT_WD-1 : 3*DATA_OUT_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_SG2_WD ),
    .DATA_OUT_WD( DATA_OUT_WD )
  ) fft_core2_u21 (
    .fft_dat1_i ( {fft_dat_re_d2_w[7*DATA_SG2_WD-1 : 6*DATA_SG2_WD], fft_dat_im_d2_w[7*DATA_SG2_WD-1 : 6*DATA_SG2_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d2_w[3*DATA_SG2_WD-1 : 2*DATA_SG2_WD], fft_dat_im_d2_w[3*DATA_SG2_WD-1 : 2*DATA_SG2_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [3*`CFG_WN_WD -1 : 2* `CFG_WN_WD], fft_wn_im_i    [3*`CFG_WN_WD -1 : 2* `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[7*DATA_OUT_WD-1 : 6*DATA_OUT_WD], fft_dat_im_d2_w[7*DATA_OUT_WD-1 : 6*DATA_OUT_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[3*DATA_OUT_WD-1 : 2*DATA_OUT_WD], fft_dat_im_d2_w[3*DATA_OUT_WD-1 : 2*DATA_OUT_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_SG2_WD ),
    .DATA_OUT_WD( DATA_OUT_WD )
  ) fft_core2_u22 (
    .fft_dat1_i ( {fft_dat_re_d2_w[6*DATA_SG2_WD-1 : 5*DATA_SG2_WD], fft_dat_im_d2_w[6*DATA_SG2_WD-1 : 5*DATA_SG2_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d2_w[2*DATA_SG2_WD-1 :   DATA_SG2_WD], fft_dat_im_d2_w[2*DATA_SG2_WD-1 :   DATA_SG2_WD]} ),
    .fft_wn_i   ( {fft_wn_re_i    [2*`CFG_WN_WD -1 :    `CFG_WN_WD], fft_wn_im_i    [2*`CFG_WN_WD -1 :    `CFG_WN_WD]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[6*DATA_OUT_WD-1 : 5*DATA_OUT_WD], fft_dat_im_d2_w[6*DATA_OUT_WD-1 : 5*DATA_OUT_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[2*DATA_OUT_WD-1 :   DATA_OUT_WD], fft_dat_im_d2_w[2*DATA_OUT_WD-1 :   DATA_OUT_WD]} )
  );
  fft_core2 #(
    .DATA_INP_WD( DATA_SG2_WD ),
    .DATA_OUT_WD( DATA_OUT_WD )
  ) fft_core2_u23 (
    .fft_dat1_i ( {fft_dat_re_d2_w[5*DATA_SG2_WD-1 : 4*DATA_SG2_WD], fft_dat_im_d2_w[5*DATA_SG2_WD-1 : 4*DATA_SG2_WD]} ),
    .fft_dat2_i ( {fft_dat_re_d2_w[  DATA_SG2_WD-1 :             0], fft_dat_im_d2_w[  DATA_SG2_WD-1 :             0]} ),
    .fft_wn_i   ( {fft_wn_re_i    [  `CFG_WN_WD -1 :             0], fft_wn_im_i    [  `CFG_WN_WD -1 :             0]} ),
    .fft_dat1_o ( {fft_dat_re_d2_w[5*DATA_OUT_WD-1 : 4*DATA_OUT_WD], fft_dat_im_d2_w[5*DATA_OUT_WD-1 : 4*DATA_OUT_WD]} ),
    .fft_dat2_o ( {fft_dat_re_d2_w[  DATA_OUT_WD-1 :             0], fft_dat_im_d2_w[  DATA_OUT_WD-1 :             0]} )
  );

endmodule

