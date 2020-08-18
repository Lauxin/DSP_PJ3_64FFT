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
    fft_dat_i,
    fft_wn_i,

    fft_dat_o
  );

  // TODO: The deeper the stage is, the longer the data width requires.
  // TODO: modify micro defination.
  // TODO: Think of other base-8-fft algrithm, instead of based on base-2-fft. (in a future version)
  

  //*** PARAMETER ****************************************************************
  parameter     DATA_INP_WD = -1;
  parameter     DATA_OUT_WD = -1;
  // DATA_OUT_WD should be 3*((DATA_INP_WD-DATA_FRA_WD) + (CFG_WN_WD-DATA_FRA_WD) +1) + DATA_FRA_WD
  // Will report warning if WIDTH donot match

  localparam    DATA_SG1_WD =   ((DATA_INP_WD-DATA_FRA_WD) + (CFG_WN_WD-DATA_FRA_WD) +1) + DATA_FRA_WD;
  localparam    DATA_SG2_WD = 2*((DATA_INP_WD-DATA_FRA_WD) + (CFG_WN_WD-DATA_FRA_WD) +1) + DATA_FRA_WD;

  //*** INPUT/OUTPUT *************************************************************
  input   [8*2*DATA_INP_WD   -1 : 0]  fft_dat_i;
  input   [4*2*`CFG_WN_WD    -1 : 0]  fft_wn_i;

  output  [8*2*DATA_OUT_WD   -1 : 0]  fft_dat_o;

  //*** WIRE/REG *****************************************************************
  wire    [8*DATA_SG1_WD     -1 : 0] fft_dat_re_d1_w;
  wire    [8*DATA_SG1_WD     -1 : 0] fft_dat_im_d1_w;
  wire    [8*DATA_SG2_WD     -1 : 0] fft_dat_re_d2_w;
  wire    [8*DATA_SG2_WD     -1 : 0] fft_dat_im_d2_w;
  wire    [8*DATA_OUT_WD     -1 : 0] fft_dat_re_d3_w;
  wire    [8*DATA_OUT_WD     -1 : 0] fft_dat_im_d3_w;

  //*** MAIN BODY ****************************************************************
  // stage 0


  // stage 1


  // stage 2


endmodule

