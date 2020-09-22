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
    fft_dat1_i,
    fft_dat2_i,
    fft_wn_i,

    fft_dat1_o,
    fft_dat2_o
  );

  //*** PARAMETER ***
  parameter     DATA_INP_WD = -1 ;
  parameter     DATA_OUT_WD = -1 ;
  // DATA_OUT_WD should be (DATA_INP_WD-DATA_FRA_WD) + (CFG_WN_WD-DATA_FRA_WD) +1 + DATA_FRA_WD ;

  //*** INPUT/OUTPUT ***
  input  signed [DATA_INP_WD*2    -1 :0] fft_dat1_i;
  input  signed [DATA_INP_WD*2    -1 :0] fft_dat2_i;
  input  signed [`CFG_WN_WD*2     -1 :0] fft_wn_i;

  output signed [DATA_OUT_WD*2    -1 :0] fft_dat1_o;
  output signed [DATA_OUT_WD*2    -1 :0] fft_dat2_o;

  //*** WIRE/REG ***
  wire   signed [DATA_INP_WD      -1 :0] fft_dat1_re_i_w, fft_dat1_im_i_w;
  wire   signed [DATA_INP_WD      -1 :0] fft_dat2_re_i_w, fft_dat2_im_i_w;
  wire   signed [DATA_OUT_WD      -1 :0] fft_dat1_re_o_w, fft_dat1_im_o_w;
  wire   signed [DATA_OUT_WD      -1 :0] fft_dat2_re_o_w, fft_dat2_im_o_w;

  reg    signed [DATA_INP_WD+`CFG_WN_WD+1   -1 :0] fft_cal1_re_w, fft_cal1_im_w; 
  reg    signed [DATA_INP_WD+`CFG_WN_WD+1   -1 :0] fft_cal2_re_w, fft_cal2_im_w; 

  //*** MAIN BODY ***
  assign fft_dat1_re_i_w = fft_dat1_i[2*DATA_INP_WD -1 : DATA_INP_WD];
  assign fft_dat1_im_i_w = fft_dat1_i[DATA_INP_WD   -1 : 0          ];
  assign fft_dat2_re_i_w = fft_dat2_i[2*DATA_INP_WD -1 : DATA_INP_WD];
  assign fft_dat2_im_i_w = fft_dat2_i[DATA_INP_WD   -1 : 0          ];

  assign fft_wn_re_i_w = fft_wn_i[2*`CFG_WN_WD -1 : `CFG_WN_WD];
  assign fft_wn_im_i_w = fft_wn_i[  `CFG_WN_WD -1 : 0         ];

  // "*" and "<<" in verilog will expend to the output width
  always @(*) begin
    fft_cal1_re_w = (fft_dat1_re_i_w << `DATA_FRA_WD) + (fft_dat2_re_i_w*fft_wn_re_i_w - fft_dat2_im_i_w*fft_wn_im_i_w);
    fft_cal1_im_w = (fft_dat1_im_i_w << `DATA_FRA_WD) + (fft_dat2_re_i_w*fft_wn_im_i_w + fft_dat2_im_i_w*fft_wn_re_i_w);
    fft_cal2_re_w = (fft_dat1_re_i_w << `DATA_FRA_WD) - (fft_dat2_re_i_w*fft_wn_re_i_w - fft_dat2_im_i_w*fft_wn_im_i_w);
    fft_cal2_im_w = (fft_dat1_im_i_w << `DATA_FRA_WD) - (fft_dat2_re_i_w*fft_wn_im_i_w + fft_dat2_im_i_w*fft_wn_re_i_w);
  end

  // fraction round / floor
  assign fft_dat1_re_o_w = (fft_cal1_re_w >> `DATA_FRA_WD) /*+ fft_cal_re1_out[`DATA_FRA_WD -1]*/;
  assign fft_dat1_im_o_w = (fft_cal1_im_w >> `DATA_FRA_WD) /*+ fft_cal_im1_out[`DATA_FRA_WD -1]*/;
  assign fft_dat2_re_o_w = (fft_cal2_re_w >> `DATA_FRA_WD) /*+ fft_cal_re2_out[`DATA_FRA_WD -1]*/;
  assign fft_dat2_im_o_w = (fft_cal2_im_w >> `DATA_FRA_WD) /*+ fft_cal_im2_out[`DATA_FRA_WD -1]*/;

  assign fft_dat1_o = {fft_dat1_re_o_w, fft_dat1_im_o_w};
  assign fft_dat2_o = {fft_dat2_re_o_w, fft_dat2_im_o_w};

endmodule

