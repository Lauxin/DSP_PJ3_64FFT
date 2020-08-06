//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core4.v
    //  Author         : liuxun
    //  Created        : 2020-01-08
    //  Description    : FFT core part. 4 points FFT based on core2
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_core4(
    fft_data_re_i,
    fft_data_im_i,
    fft_wn_re_i,
    fft_wn_im_i,

    fft_data_re_o,
    fft_data_im_o
);


//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   [4 * `DATA_WID  -1 : 0]  fft_data_re_i, fft_data_im_i;
input   [2 * `WN_WID    -1 : 0]  fft_wn_re_i, fft_wn_im_i;

output  [4 * `DATA_WID  -1 : 0]  fft_data_re_o, fft_data_im_o;

//*** WIRE/REG *****************************************************************
wire    [4 * `DATA_WID  -1 : 0] fft_data_re_stage1;
wire    [4 * `DATA_WID  -1 : 0] fft_data_im_stage1;
wire    [4 * `DATA_WID  -1 : 0] fft_data_re_stage2;
wire    [4 * `DATA_WID  -1 : 0] fft_data_im_stage2;

//*** MAIN BODY ****************************************************************
// stage 1
fft_core2 fft_core2_u11(
    .fft_data_re1_i(fft_data_re_i[`DATA_WID -1 : 0]),
    .fft_data_im1_i(fft_data_im_i[`DATA_WID -1 : 0]),
    .fft_data_re2_i(fft_data_re_i[2*`DATA_WID -1 : `DATA_WID]),
    .fft_data_im2_i(fft_data_im_i[2*`DATA_WID -1 : `DATA_WID]),
    .fft_wn_re_i(fft_wn_re_i[`WN_WID -1 : 0]),
    .fft_wn_im_i(fft_wn_im_i[`WN_WID -1 : 0]),

    .fft_data_re1_o(fft_data_re_stage1[`DATA_WID -1 : 0]),
    .fft_data_im1_o(fft_data_im_stage1[`DATA_WID -1 : 0]),
    .fft_data_re2_o(fft_data_re_stage1[2*`DATA_WID -1 : `DATA_WID]),
    .fft_data_im2_o(fft_data_im_stage1[2*`DATA_WID -1 : `DATA_WID])
);

fft_core2 fft_core2_u12(
    .fft_data_re1_i(fft_data_re_i[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_data_im1_i(fft_data_im_i[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_data_re2_i(fft_data_re_i[4*`DATA_WID -1 : 3*`DATA_WID]),
    .fft_data_im2_i(fft_data_im_i[4*`DATA_WID -1 : 3*`DATA_WID]),
    .fft_wn_re_i(fft_wn_re_i[`WN_WID -1 : 0]),
    .fft_wn_im_i(fft_wn_im_i[`WN_WID -1 : 0]),

    .fft_data_re1_o(fft_data_re_stage1[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_data_im1_o(fft_data_im_stage1[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_data_re2_o(fft_data_re_stage1[4*`DATA_WID -1 : 3*`DATA_WID]),
    .fft_data_im2_o(fft_data_im_stage1[4*`DATA_WID -1 : 3*`DATA_WID])
);

// stage 2
fft_core2 fft_core2_u21(
    .fft_data_re1_i(fft_data_re_stage1[`DATA_WID -1 : 0]),
    .fft_data_im1_i(fft_data_im_stage1[`DATA_WID -1 : 0]),
    .fft_data_re2_i(fft_data_re_stage1[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_data_im2_i(fft_data_im_stage1[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_wn_re_i(fft_wn_re_i[`WN_WID -1 : 0]),
    .fft_wn_im_i(fft_wn_im_i[`WN_WID -1 : 0]),

    .fft_data_re1_o(fft_data_re_stage2[`DATA_WID -1 : 0]),
    .fft_data_im1_o(fft_data_im_stage2[`DATA_WID -1 : 0]),
    .fft_data_re2_o(fft_data_re_stage2[3*`DATA_WID -1 : 2*`DATA_WID]),
    .fft_data_im2_o(fft_data_im_stage2[3*`DATA_WID -1 : 2*`DATA_WID])
);

fft_core2 fft_core2_u22(
    .fft_data_re1_i(fft_data_re_stage1[2*`DATA_WID -1 : `DATA_WID]),
    .fft_data_im1_i(fft_data_im_stage1[2*`DATA_WID -1 : `DATA_WID]),
    .fft_data_re2_i(fft_data_re_stage1[4*`DATA_WID -1 : 3*`DATA_WID]),
    .fft_data_im2_i(fft_data_im_stage1[4*`DATA_WID -1 : 3*`DATA_WID]),
    .fft_wn_re_i(fft_wn_re_i[2*`WN_WID -1 : `WN_WID]),
    .fft_wn_im_i(fft_wn_im_i[2*`WN_WID -1 : `WN_WID]),

    .fft_data_re1_o(fft_data_re_stage2[2*`DATA_WID -1 : `DATA_WID]),
    .fft_data_im1_o(fft_data_im_stage2[2*`DATA_WID -1 : `DATA_WID]),
    .fft_data_re2_o(fft_data_re_stage2[4*`DATA_WID -1 : 3*`DATA_WID]),
    .fft_data_im2_o(fft_data_im_stage2[4*`DATA_WID -1 : 3*`DATA_WID])
);

assign fft_data_re_o = fft_data_re_stage2;
assign fft_data_im_o = fft_data_im_stage2;

endmodule
