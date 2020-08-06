//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core2.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : FFT core part. 2 points FFT
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

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
input signed    [`DATA_WID -1 :0] fft_data_re1_i, fft_data_re2_i;
input signed    [`DATA_WID -1 :0] fft_data_im1_i, fft_data_im2_i;
input signed    [`WN_WID -1 :0] fft_wn_re_i;
input signed    [`WN_WID -1 :0] fft_wn_im_i;

output signed [`DATA_WID -1 :0] fft_data_re1_o, fft_data_re2_o;
output signed [`DATA_WID -1 :0] fft_data_im1_o, fft_data_im2_o;

//*** WIRE/REG *****************************************************************
wire signed [`DATA_WID + `WN_WID -1 :0] fft_re1_enl, fft_im1_enl; //enlarged data
wire signed [`DATA_WID + `WN_WID -1 :0] fft_re2_enl, fft_im2_enl; //enlarged data

reg signed  [`DATA_WID + `WN_WID -1 :0] fft_cal_re1_out, fft_cal_im1_out;
reg signed  [`DATA_WID + `WN_WID -1 :0] fft_cal_re2_out, fft_cal_im2_out;


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
