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
  rst_n         ,
  clk           ,
  val_i         ,

  dat_fft_re_i  ,
  dat_fft_im_i  ,
  dat_wn_re_i   ,
  dat_wn_im_i   ,

  val_o         ,
  dat_fft_re_o  ,
  dat_fft_im_o  ,
);
  

//*** PARAMETER ****************************************************************
  //global
  parameter     DATA_INP_WD     = -1 ;
  parameter     DATA_OUT_WD     = -1 ;
  parameter     DATA_W_N_WD     = -1 ;
  parameter     DATA_FRC_WD     = -1 ;
  //derived
  localparam    DATA_SG1_WD =   ((DATA_INP_WD-DATA_FRC_WD) + (DATA_W_N_WD-DATA_FRC_WD) + 1) + DATA_FRC_WD ;
  localparam    DATA_SG2_WD = 2*((DATA_INP_WD-DATA_FRC_WD) + (DATA_W_N_WD-DATA_FRC_WD) + 1) + DATA_FRC_WD ;
  // localparam    DATA_OUT_WD = 3*((DATA_INP_WD-DATA_FRC_WD) + (DATA_W_N_WD-DATA_FRC_WD) + 1) + DATA_FRC_WD ;


//*** INPUT/OUTPUT *************************************************************
  input                             clk          ;
  input                             rst_n        ;
  input                             val_i        ;
  input   [8*DATA_INP_WD   -1 : 0]  dat_fft_re_i ;
  input   [8*DATA_INP_WD   -1 : 0]  dat_fft_im_i ;
  input   [4*DATA_W_N_WD   -1 : 0]  dat_wn_re_i  ;
  input   [4*DATA_W_N_WD   -1 : 0]  dat_wn_im_i  ;

  output                            val_o        ;
  output  [8*DATA_OUT_WD   -1 : 0]  dat_fft_re_o ;
  output  [8*DATA_OUT_WD   -1 : 0]  dat_fft_im_o ;


//*** WIRE/REG *****************************************************************
  wire    [8*DATA_SG1_WD   -1 : 0]  dat_fft_re_d1_w ;
  wire    [8*DATA_SG1_WD   -1 : 0]  dat_fft_im_d1_w ;
  reg     [8*DATA_SG1_WD   -1 : 0]  dat_fft_re_d1_r ;
  reg     [8*DATA_SG1_WD   -1 : 0]  dat_fft_im_d1_r ;

  wire    [8*DATA_SG2_WD   -1 : 0]  dat_fft_re_d2_w ;
  wire    [8*DATA_SG2_WD   -1 : 0]  dat_fft_im_d2_w ;
  reg     [8*DATA_SG2_WD   -1 : 0]  dat_fft_re_d2_r ;
  reg     [8*DATA_SG2_WD   -1 : 0]  dat_fft_im_d2_r ;

  reg                               val_d1_r        ;
  reg                               val_d2_r        ;


//*** MAIN BODY ****************************************************************
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      val_d1_r <= 'd0 ;
      val_d2_r <= 'd0 ;
    end
    else begin
      val_d1_r <= val_i ;
      val_d2_r <= val_d1_r ;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dat_fft_re_d1_r <= 'd0 ;
      dat_fft_im_d1_r <= 'd0 ;
      dat_fft_re_d2_r <= 'd0 ;
      dat_fft_im_d2_r <= 'd0 ;
    end
    else begin
      if (val_i) begin
        dat_fft_re_d1_r <= dat_fft_re_d1_w ;
        dat_fft_im_d1_r <= dat_fft_im_d1_w ;
      end
      if (val_d1_r) begin
        dat_fft_re_d2_r <= dat_fft_re_d2_w ;
        dat_fft_im_d2_r <= dat_fft_im_d2_w ;
      end
    end
  end

  //===== stage 0 =====
  // 0 1 | 2 3 | 4 5 | 6 7
  // wn0 | wn0 | wn0 | wn0
  fft_core2 #(
    .DATA_INP_WD    ( DATA_INP_WD     ),
    .DATA_OUT_WD    ( DATA_SG1_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u00 (
    .dat_fft_1_re_i (dat_fft_re_i   [  DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_1_im_i (dat_fft_im_i   [  DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_re_i (dat_fft_re_i   [2*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_im_i (dat_fft_im_i   [2*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d1_w[  DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_o (dat_fft_im_d1_w[  DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_o (dat_fft_re_d1_w[2*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_o (dat_fft_im_d1_w[2*DATA_SG1_WD-1 -: DATA_SG1_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_INP_WD     ),
    .DATA_OUT_WD    ( DATA_SG1_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u01 (
    .dat_fft_1_re_i (dat_fft_re_i   [3*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_1_im_i (dat_fft_im_i   [3*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_re_i (dat_fft_re_i   [4*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_im_i (dat_fft_im_i   [4*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d1_w[3*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_o (dat_fft_im_d1_w[3*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_o (dat_fft_re_d1_w[4*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_o (dat_fft_im_d1_w[4*DATA_SG1_WD-1 -: DATA_SG1_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_INP_WD     ),
    .DATA_OUT_WD    ( DATA_SG1_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u02 (
    .dat_fft_1_re_i (dat_fft_re_i   [5*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_1_im_i (dat_fft_im_i   [5*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_re_i (dat_fft_re_i   [6*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_im_i (dat_fft_im_i   [6*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d1_w[5*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_o (dat_fft_im_d1_w[5*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_o (dat_fft_re_d1_w[6*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_o (dat_fft_im_d1_w[6*DATA_SG1_WD-1 -: DATA_SG1_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_INP_WD     ),
    .DATA_OUT_WD    ( DATA_SG1_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u03 (
    .dat_fft_1_re_i (dat_fft_re_i   [7*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_1_im_i (dat_fft_im_i   [7*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_re_i (dat_fft_re_i   [8*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_fft_2_im_i (dat_fft_im_i   [8*DATA_INP_WD-1 -: DATA_INP_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d1_w[7*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_o (dat_fft_im_d1_w[7*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_o (dat_fft_re_d1_w[8*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_o (dat_fft_im_d1_w[8*DATA_SG1_WD-1 -: DATA_SG1_WD])
  );

  //===== stage 1 =====
  // 0 2 | 1 3 | 4 6 | 5 7
  // wn0 | wn2 | wn0 | wn2
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG1_WD     ),
    .DATA_OUT_WD    ( DATA_SG2_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u10 (
    .dat_fft_1_re_i (dat_fft_re_d1_r[  DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_i (dat_fft_im_d1_r[  DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_i (dat_fft_re_d1_r[3*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_i (dat_fft_im_d1_r[3*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d2_w[  DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_o (dat_fft_im_d2_w[  DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_o (dat_fft_re_d2_w[3*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_o (dat_fft_im_d2_w[3*DATA_SG2_WD-1 -: DATA_SG2_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG1_WD     ),
    .DATA_OUT_WD    ( DATA_SG2_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u11 (
    .dat_fft_1_re_i (dat_fft_re_d1_r[2*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_i (dat_fft_im_d1_r[2*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_i (dat_fft_re_d1_r[4*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_i (dat_fft_im_d1_r[4*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [3*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [3*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d2_w[2*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_o (dat_fft_im_d2_w[2*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_o (dat_fft_re_d2_w[4*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_o (dat_fft_im_d2_w[4*DATA_SG2_WD-1 -: DATA_SG2_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG1_WD     ),
    .DATA_OUT_WD    ( DATA_SG2_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u12 (
    .dat_fft_1_re_i (dat_fft_re_d1_r[5*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_i (dat_fft_im_d1_r[5*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_i (dat_fft_re_d1_r[7*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_i (dat_fft_im_d1_r[7*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d2_w[5*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_o (dat_fft_im_d2_w[5*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_o (dat_fft_re_d2_w[7*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_o (dat_fft_im_d2_w[7*DATA_SG2_WD-1 -: DATA_SG2_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG1_WD     ),
    .DATA_OUT_WD    ( DATA_SG2_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u13 (
    .dat_fft_1_re_i (dat_fft_re_d1_r[6*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_1_im_i (dat_fft_im_d1_r[6*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_re_i (dat_fft_re_d1_r[8*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_fft_2_im_i (dat_fft_im_d1_r[8*DATA_SG1_WD-1 -: DATA_SG1_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [3*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [3*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_d2_w[6*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_o (dat_fft_im_d2_w[6*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_o (dat_fft_re_d2_w[8*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_o (dat_fft_im_d2_w[8*DATA_SG2_WD-1 -: DATA_SG2_WD])
  );

  //===== stage 2 =====
  // 0 4 | 1 5 | 2 6 | 3 7
  // wn0 | wn1 | wn2 | wn3
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG2_WD     ),
    .DATA_OUT_WD    ( DATA_OUT_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u20 (
    .dat_fft_1_re_i (dat_fft_re_d2_r[  DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_i (dat_fft_im_d2_r[  DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_i (dat_fft_re_d2_r[5*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_i (dat_fft_im_d2_r[5*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [  DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_o   [  DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_1_im_o (dat_fft_im_o   [  DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_re_o (dat_fft_re_o   [5*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_im_o (dat_fft_im_o   [5*DATA_OUT_WD-1 -: DATA_OUT_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG2_WD     ),
    .DATA_OUT_WD    ( DATA_OUT_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u21 (
    .dat_fft_1_re_i (dat_fft_re_d2_r[2*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_i (dat_fft_im_d2_r[2*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_i (dat_fft_re_d2_r[6*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_i (dat_fft_im_d2_r[6*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [2*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [2*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_o   [2*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_1_im_o (dat_fft_im_o   [2*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_re_o (dat_fft_re_o   [6*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_im_o (dat_fft_im_o   [6*DATA_OUT_WD-1 -: DATA_OUT_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG2_WD     ),
    .DATA_OUT_WD    ( DATA_OUT_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u22 (
    .dat_fft_1_re_i (dat_fft_re_d2_r[3*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_i (dat_fft_im_d2_r[3*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_i (dat_fft_re_d2_r[7*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_i (dat_fft_im_d2_r[7*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [3*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [3*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_o   [3*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_1_im_o (dat_fft_im_o   [3*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_re_o (dat_fft_re_o   [7*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_im_o (dat_fft_im_o   [7*DATA_OUT_WD-1 -: DATA_OUT_WD])
  );
  fft_core2 #(
    .DATA_INP_WD    ( DATA_SG2_WD     ),
    .DATA_OUT_WD    ( DATA_OUT_WD     ),
    .DATA_W_N_WD    ( DATA_W_N_WD     ),
    .DATA_FRC_WD    ( DATA_FRC_WD     )
  ) fft_core2_u23 (
    .dat_fft_1_re_i (dat_fft_re_d2_r[4*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_1_im_i (dat_fft_im_d2_r[4*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_re_i (dat_fft_re_d2_r[7*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_fft_2_im_i (dat_fft_im_d2_r[7*DATA_SG2_WD-1 -: DATA_SG2_WD]),
    .dat_wn_re_i    (dat_wn_re_i    [4*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_wn_im_i    (dat_wn_im_i    [4*DATA_W_N_WD-1 -: DATA_W_N_WD]),
    .dat_fft_1_re_o (dat_fft_re_o   [4*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_1_im_o (dat_fft_im_o   [4*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_re_o (dat_fft_re_o   [8*DATA_OUT_WD-1 -: DATA_OUT_WD]),
    .dat_fft_2_im_o (dat_fft_im_o   [8*DATA_OUT_WD-1 -: DATA_OUT_WD])
  );

//*** OUTPUT *******************************************************************
  assign val_o = val_d2_r ;

endmodule

