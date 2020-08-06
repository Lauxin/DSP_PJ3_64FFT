//------------------------------------------------------------------------------
    //
    //  Filename       : fft_gen_wn.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : Fetch Wn for FFT
    //
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_gen_wn(
    stage_i,

    fft_wn_re_o,
    fft_wn_im_o
);

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input  [`STG_WID -1 : 0] stage_i;

output reg [`WN_LEN*`WN_WID -1 : 0] fft_wn_re_o;
output reg [`WN_LEN*`WN_WID -1 : 0] fft_wn_im_o;

//*** WIRE/REG *****************************************************************
// reg [`WN_WID -1 : 0] wn_re_r [0:`WN_LEN];
// reg [`WN_WID -1 : 0] wn_im_r [0:`WN_LEN];


//*** MAIN BODY ****************************************************************
always @(stage_i) begin
    fft_wn_re_o = 'd0;
    fft_wn_im_o = 'd0;
    case(stage_i)
        'd0: begin
            fft_wn_re_o[ `WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[ 2*`WN_WID -1 :   `WN_WID] = 'd256;
            fft_wn_re_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd256;
            fft_wn_re_o[ 4*`WN_WID -1 : 3*`WN_WID] = 'd256;
            fft_wn_re_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd256;
            fft_wn_re_o[ 6*`WN_WID -1 : 5*`WN_WID] = 'd256;
            fft_wn_re_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd256;
            fft_wn_re_o[ 8*`WN_WID -1 : 7*`WN_WID] = 'd256;
            fft_wn_re_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd256;
            fft_wn_re_o[10*`WN_WID -1 : 9*`WN_WID] = 'd256;
            fft_wn_re_o[11*`WN_WID -1 :10*`WN_WID] = 'd256;
            fft_wn_re_o[12*`WN_WID -1 :11*`WN_WID] = 'd256;
            fft_wn_re_o[13*`WN_WID -1 :12*`WN_WID] = 'd256;
            fft_wn_re_o[14*`WN_WID -1 :13*`WN_WID] = 'd256;
            fft_wn_re_o[15*`WN_WID -1 :14*`WN_WID] = 'd256;
            fft_wn_re_o[16*`WN_WID -1 :15*`WN_WID] = 'd256;
            fft_wn_re_o[17*`WN_WID -1 :16*`WN_WID] = 'd256;
            fft_wn_re_o[18*`WN_WID -1 :17*`WN_WID] = 'd256;
            fft_wn_re_o[19*`WN_WID -1 :18*`WN_WID] = 'd256;
            fft_wn_re_o[20*`WN_WID -1 :19*`WN_WID] = 'd256;
            fft_wn_re_o[21*`WN_WID -1 :20*`WN_WID] = 'd256;
            fft_wn_re_o[22*`WN_WID -1 :21*`WN_WID] = 'd256;
            fft_wn_re_o[23*`WN_WID -1 :22*`WN_WID] = 'd256;
            fft_wn_re_o[24*`WN_WID -1 :23*`WN_WID] = 'd256;
            fft_wn_re_o[25*`WN_WID -1 :24*`WN_WID] = 'd256;
            fft_wn_re_o[26*`WN_WID -1 :25*`WN_WID] = 'd256;
            fft_wn_re_o[27*`WN_WID -1 :26*`WN_WID] = 'd256;
            fft_wn_re_o[28*`WN_WID -1 :27*`WN_WID] = 'd256;
            fft_wn_re_o[29*`WN_WID -1 :28*`WN_WID] = 'd256;
            fft_wn_re_o[30*`WN_WID -1 :29*`WN_WID] = 'd256;
            fft_wn_re_o[31*`WN_WID -1 :30*`WN_WID] = 'd256;
            fft_wn_re_o[32*`WN_WID -1 :31*`WN_WID] = 'd256;

            fft_wn_im_o[ `WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[ 2*`WN_WID -1 :   `WN_WID] = 'd0;
            fft_wn_im_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd0;
            fft_wn_im_o[ 4*`WN_WID -1 : 3*`WN_WID] = 'd0;
            fft_wn_im_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd0;
            fft_wn_im_o[ 6*`WN_WID -1 : 5*`WN_WID] = 'd0;
            fft_wn_im_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd0;
            fft_wn_im_o[ 8*`WN_WID -1 : 7*`WN_WID] = 'd0;
            fft_wn_im_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd0;
            fft_wn_im_o[10*`WN_WID -1 : 9*`WN_WID] = 'd0;
            fft_wn_im_o[11*`WN_WID -1 :10*`WN_WID] = 'd0;
            fft_wn_im_o[12*`WN_WID -1 :11*`WN_WID] = 'd0;
            fft_wn_im_o[13*`WN_WID -1 :12*`WN_WID] = 'd0;
            fft_wn_im_o[14*`WN_WID -1 :13*`WN_WID] = 'd0;
            fft_wn_im_o[15*`WN_WID -1 :14*`WN_WID] = 'd0;
            fft_wn_im_o[16*`WN_WID -1 :15*`WN_WID] = 'd0;
            fft_wn_im_o[17*`WN_WID -1 :16*`WN_WID] = 'd0;
            fft_wn_im_o[18*`WN_WID -1 :17*`WN_WID] = 'd0;
            fft_wn_im_o[19*`WN_WID -1 :18*`WN_WID] = 'd0;
            fft_wn_im_o[20*`WN_WID -1 :19*`WN_WID] = 'd0;
            fft_wn_im_o[21*`WN_WID -1 :20*`WN_WID] = 'd0;
            fft_wn_im_o[22*`WN_WID -1 :21*`WN_WID] = 'd0;
            fft_wn_im_o[23*`WN_WID -1 :22*`WN_WID] = 'd0;
            fft_wn_im_o[24*`WN_WID -1 :23*`WN_WID] = 'd0;
            fft_wn_im_o[25*`WN_WID -1 :24*`WN_WID] = 'd0;
            fft_wn_im_o[26*`WN_WID -1 :25*`WN_WID] = 'd0;
            fft_wn_im_o[27*`WN_WID -1 :26*`WN_WID] = 'd0;
            fft_wn_im_o[28*`WN_WID -1 :27*`WN_WID] = 'd0;
            fft_wn_im_o[29*`WN_WID -1 :28*`WN_WID] = 'd0;
            fft_wn_im_o[30*`WN_WID -1 :29*`WN_WID] = 'd0;
            fft_wn_im_o[31*`WN_WID -1 :30*`WN_WID] = 'd0;
            fft_wn_im_o[32*`WN_WID -1 :31*`WN_WID] = 'd0;
        end
        'd1: begin //2
            fft_wn_re_o[ `WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[ 2*`WN_WID -1 :   `WN_WID] = 'd0;
            fft_wn_re_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd256;
            fft_wn_re_o[ 4*`WN_WID -1 : 3*`WN_WID] = 'd0;
            fft_wn_re_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd256;
            fft_wn_re_o[ 6*`WN_WID -1 : 5*`WN_WID] = 'd0;
            fft_wn_re_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd256;
            fft_wn_re_o[ 8*`WN_WID -1 : 7*`WN_WID] = 'd0;
            fft_wn_re_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd256;
            fft_wn_re_o[10*`WN_WID -1 : 9*`WN_WID] = 'd0;
            fft_wn_re_o[11*`WN_WID -1 :10*`WN_WID] = 'd256;
            fft_wn_re_o[12*`WN_WID -1 :11*`WN_WID] = 'd0;
            fft_wn_re_o[13*`WN_WID -1 :12*`WN_WID] = 'd256;
            fft_wn_re_o[14*`WN_WID -1 :13*`WN_WID] = 'd0;
            fft_wn_re_o[15*`WN_WID -1 :14*`WN_WID] = 'd256;
            fft_wn_re_o[16*`WN_WID -1 :15*`WN_WID] = 'd0;
            fft_wn_re_o[17*`WN_WID -1 :16*`WN_WID] = 'd256;
            fft_wn_re_o[18*`WN_WID -1 :17*`WN_WID] = 'd0;
            fft_wn_re_o[19*`WN_WID -1 :18*`WN_WID] = 'd256;
            fft_wn_re_o[20*`WN_WID -1 :19*`WN_WID] = 'd0;
            fft_wn_re_o[21*`WN_WID -1 :20*`WN_WID] = 'd256;
            fft_wn_re_o[22*`WN_WID -1 :21*`WN_WID] = 'd0;
            fft_wn_re_o[23*`WN_WID -1 :22*`WN_WID] = 'd256;
            fft_wn_re_o[24*`WN_WID -1 :23*`WN_WID] = 'd0;
            fft_wn_re_o[25*`WN_WID -1 :24*`WN_WID] = 'd256;
            fft_wn_re_o[26*`WN_WID -1 :25*`WN_WID] = 'd0;
            fft_wn_re_o[27*`WN_WID -1 :26*`WN_WID] = 'd256;
            fft_wn_re_o[28*`WN_WID -1 :27*`WN_WID] = 'd0;
            fft_wn_re_o[29*`WN_WID -1 :28*`WN_WID] = 'd256;
            fft_wn_re_o[30*`WN_WID -1 :29*`WN_WID] = 'd0;
            fft_wn_re_o[31*`WN_WID -1 :30*`WN_WID] = 'd256;
            fft_wn_re_o[32*`WN_WID -1 :31*`WN_WID] = 'd0;

            fft_wn_im_o[ `WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[ 2*`WN_WID -1 :   `WN_WID] = -'d256;
            fft_wn_im_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd0;
            fft_wn_im_o[ 4*`WN_WID -1 : 3*`WN_WID] = -'d256;
            fft_wn_im_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd0;
            fft_wn_im_o[ 6*`WN_WID -1 : 5*`WN_WID] = -'d256;
            fft_wn_im_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd0;
            fft_wn_im_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d256;
            fft_wn_im_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd0;
            fft_wn_im_o[10*`WN_WID -1 : 9*`WN_WID] = -'d256;
            fft_wn_im_o[11*`WN_WID -1 :10*`WN_WID] = 'd0;
            fft_wn_im_o[12*`WN_WID -1 :11*`WN_WID] = -'d256;
            fft_wn_im_o[13*`WN_WID -1 :12*`WN_WID] = 'd0;
            fft_wn_im_o[14*`WN_WID -1 :13*`WN_WID] = -'d256;
            fft_wn_im_o[15*`WN_WID -1 :14*`WN_WID] = 'd0;
            fft_wn_im_o[16*`WN_WID -1 :15*`WN_WID] = -'d256;
            fft_wn_im_o[17*`WN_WID -1 :16*`WN_WID] = 'd0;
            fft_wn_im_o[18*`WN_WID -1 :17*`WN_WID] = -'d256;
            fft_wn_im_o[19*`WN_WID -1 :18*`WN_WID] = 'd0;
            fft_wn_im_o[20*`WN_WID -1 :19*`WN_WID] = -'d256;
            fft_wn_im_o[21*`WN_WID -1 :20*`WN_WID] = 'd0;
            fft_wn_im_o[22*`WN_WID -1 :21*`WN_WID] = -'d256;
            fft_wn_im_o[23*`WN_WID -1 :22*`WN_WID] = 'd0;
            fft_wn_im_o[24*`WN_WID -1 :23*`WN_WID] = -'d256;
            fft_wn_im_o[25*`WN_WID -1 :24*`WN_WID] = 'd0;
            fft_wn_im_o[26*`WN_WID -1 :25*`WN_WID] = -'d256;
            fft_wn_im_o[27*`WN_WID -1 :26*`WN_WID] = 'd0;
            fft_wn_im_o[28*`WN_WID -1 :27*`WN_WID] = -'d256;
            fft_wn_im_o[29*`WN_WID -1 :28*`WN_WID] = 'd0;
            fft_wn_im_o[30*`WN_WID -1 :29*`WN_WID] = -'d256;
            fft_wn_im_o[31*`WN_WID -1 :30*`WN_WID] = 'd0;
            fft_wn_im_o[32*`WN_WID -1 :31*`WN_WID] = -'d256;
        end
        'd2: begin //4
            fft_wn_re_o[ `WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[ 2*`WN_WID -1 :   `WN_WID] = 'd181;
            fft_wn_re_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd0;
            fft_wn_re_o[ 4*`WN_WID -1 : 3*`WN_WID] = -'d181;
            fft_wn_re_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd256;
            fft_wn_re_o[ 6*`WN_WID -1 : 5*`WN_WID] = 'd181;
            fft_wn_re_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd0;
            fft_wn_re_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d181;
            fft_wn_re_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd256;
            fft_wn_re_o[10*`WN_WID -1 : 9*`WN_WID] = 'd181;
            fft_wn_re_o[11*`WN_WID -1 :10*`WN_WID] = 'd0;
            fft_wn_re_o[12*`WN_WID -1 :11*`WN_WID] = -'d181;
            fft_wn_re_o[13*`WN_WID -1 :12*`WN_WID] = 'd256;
            fft_wn_re_o[14*`WN_WID -1 :13*`WN_WID] = 'd181;
            fft_wn_re_o[15*`WN_WID -1 :14*`WN_WID] = 'd0;
            fft_wn_re_o[16*`WN_WID -1 :15*`WN_WID] = -'d181;
            fft_wn_re_o[17*`WN_WID -1 :16*`WN_WID] = 'd256;
            fft_wn_re_o[18*`WN_WID -1 :17*`WN_WID] = 'd181;
            fft_wn_re_o[19*`WN_WID -1 :18*`WN_WID] = 'd0;
            fft_wn_re_o[20*`WN_WID -1 :19*`WN_WID] = -'d181;
            fft_wn_re_o[21*`WN_WID -1 :20*`WN_WID] = 'd256;
            fft_wn_re_o[22*`WN_WID -1 :21*`WN_WID] = 'd181;
            fft_wn_re_o[23*`WN_WID -1 :22*`WN_WID] = 'd0;
            fft_wn_re_o[24*`WN_WID -1 :23*`WN_WID] = -'d181;
            fft_wn_re_o[25*`WN_WID -1 :24*`WN_WID] = 'd256;
            fft_wn_re_o[26*`WN_WID -1 :25*`WN_WID] = 'd181;
            fft_wn_re_o[27*`WN_WID -1 :26*`WN_WID] = 'd0;
            fft_wn_re_o[28*`WN_WID -1 :27*`WN_WID] = -'d181;
            fft_wn_re_o[29*`WN_WID -1 :28*`WN_WID] = 'd256;
            fft_wn_re_o[30*`WN_WID -1 :29*`WN_WID] = 'd181;
            fft_wn_re_o[31*`WN_WID -1 :30*`WN_WID] = 'd0;
            fft_wn_re_o[32*`WN_WID -1 :31*`WN_WID] = -'d181;

            fft_wn_im_o[ `WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[ 2*`WN_WID -1 :   `WN_WID] = -'d181;
            fft_wn_im_o[ 3*`WN_WID -1 : 2*`WN_WID] = -'d256;
            fft_wn_im_o[ 4*`WN_WID -1 : 3*`WN_WID] = -'d181;
            fft_wn_im_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd0;
            fft_wn_im_o[ 6*`WN_WID -1 : 5*`WN_WID] = -'d181;
            fft_wn_im_o[ 7*`WN_WID -1 : 6*`WN_WID] = -'d256;
            fft_wn_im_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d181;
            fft_wn_im_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd0;
            fft_wn_im_o[10*`WN_WID -1 : 9*`WN_WID] = -'d181;
            fft_wn_im_o[11*`WN_WID -1 :10*`WN_WID] = -'d256;
            fft_wn_im_o[12*`WN_WID -1 :11*`WN_WID] = -'d181;
            fft_wn_im_o[13*`WN_WID -1 :12*`WN_WID] = 'd0;
            fft_wn_im_o[14*`WN_WID -1 :13*`WN_WID] = -'d181;
            fft_wn_im_o[15*`WN_WID -1 :14*`WN_WID] = -'d256;
            fft_wn_im_o[16*`WN_WID -1 :15*`WN_WID] = -'d181;
            fft_wn_im_o[17*`WN_WID -1 :16*`WN_WID] = 'd0;
            fft_wn_im_o[18*`WN_WID -1 :17*`WN_WID] = -'d181;
            fft_wn_im_o[19*`WN_WID -1 :18*`WN_WID] = -'d256;
            fft_wn_im_o[20*`WN_WID -1 :19*`WN_WID] = -'d181;
            fft_wn_im_o[21*`WN_WID -1 :20*`WN_WID] = 'd0;
            fft_wn_im_o[22*`WN_WID -1 :21*`WN_WID] = -'d181;
            fft_wn_im_o[23*`WN_WID -1 :22*`WN_WID] = -'d256;
            fft_wn_im_o[24*`WN_WID -1 :23*`WN_WID] = -'d181;
            fft_wn_im_o[25*`WN_WID -1 :24*`WN_WID] = 'd0;
            fft_wn_im_o[26*`WN_WID -1 :25*`WN_WID] = -'d181;
            fft_wn_im_o[27*`WN_WID -1 :26*`WN_WID] = -'d256;
            fft_wn_im_o[28*`WN_WID -1 :27*`WN_WID] = -'d181;
            fft_wn_im_o[29*`WN_WID -1 :28*`WN_WID] = 'd0;
            fft_wn_im_o[30*`WN_WID -1 :29*`WN_WID] = -'d181;
            fft_wn_im_o[31*`WN_WID -1 :30*`WN_WID] = -'d256;
            fft_wn_im_o[32*`WN_WID -1 :31*`WN_WID] = -'d181;
        end
        'd3: begin //8
            fft_wn_re_o[ `WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[ 2*`WN_WID -1 :   `WN_WID] = 'd237;
            fft_wn_re_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd181;
            fft_wn_re_o[ 4*`WN_WID -1 : 3*`WN_WID] = 'd98;
            fft_wn_re_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd0;
            fft_wn_re_o[ 6*`WN_WID -1 : 5*`WN_WID] = -'d98;
            fft_wn_re_o[ 7*`WN_WID -1 : 6*`WN_WID] = -'d181;
            fft_wn_re_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d237;
            fft_wn_re_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd256;
            fft_wn_re_o[10*`WN_WID -1 : 9*`WN_WID] = 'd237;
            fft_wn_re_o[11*`WN_WID -1 :10*`WN_WID] = 'd181;
            fft_wn_re_o[12*`WN_WID -1 :11*`WN_WID] = 'd98;
            fft_wn_re_o[13*`WN_WID -1 :12*`WN_WID] = 'd0;
            fft_wn_re_o[14*`WN_WID -1 :13*`WN_WID] = -'d98;
            fft_wn_re_o[15*`WN_WID -1 :14*`WN_WID] = -'d181;
            fft_wn_re_o[16*`WN_WID -1 :15*`WN_WID] = -'d237;
            fft_wn_re_o[17*`WN_WID -1 :16*`WN_WID] = 'd256;
            fft_wn_re_o[18*`WN_WID -1 :17*`WN_WID] = 'd237;
            fft_wn_re_o[19*`WN_WID -1 :18*`WN_WID] = 'd181;
            fft_wn_re_o[20*`WN_WID -1 :19*`WN_WID] = 'd98;
            fft_wn_re_o[21*`WN_WID -1 :20*`WN_WID] = 'd0;
            fft_wn_re_o[22*`WN_WID -1 :21*`WN_WID] = -'d98;
            fft_wn_re_o[23*`WN_WID -1 :22*`WN_WID] = -'d181;
            fft_wn_re_o[24*`WN_WID -1 :23*`WN_WID] = -'d237;
            fft_wn_re_o[25*`WN_WID -1 :24*`WN_WID] = 'd256;
            fft_wn_re_o[26*`WN_WID -1 :25*`WN_WID] = 'd237;
            fft_wn_re_o[27*`WN_WID -1 :26*`WN_WID] = 'd181;
            fft_wn_re_o[28*`WN_WID -1 :27*`WN_WID] = 'd98;
            fft_wn_re_o[29*`WN_WID -1 :28*`WN_WID] = 'd0;
            fft_wn_re_o[30*`WN_WID -1 :29*`WN_WID] = -'d98;
            fft_wn_re_o[31*`WN_WID -1 :30*`WN_WID] = -'d181;
            fft_wn_re_o[32*`WN_WID -1 :31*`WN_WID] = -'d237;

            fft_wn_im_o[ `WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[ 2*`WN_WID -1 :   `WN_WID] = -'d98;
            fft_wn_im_o[ 3*`WN_WID -1 : 2*`WN_WID] = -'d181;
            fft_wn_im_o[ 4*`WN_WID -1 : 3*`WN_WID] = -'d237;
            fft_wn_im_o[ 5*`WN_WID -1 : 4*`WN_WID] = -'d256;
            fft_wn_im_o[ 6*`WN_WID -1 : 5*`WN_WID] = -'d237;
            fft_wn_im_o[ 7*`WN_WID -1 : 6*`WN_WID] = -'d181;
            fft_wn_im_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d98;
            fft_wn_im_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd0;
            fft_wn_im_o[10*`WN_WID -1 : 9*`WN_WID] = -'d98;
            fft_wn_im_o[11*`WN_WID -1 :10*`WN_WID] = -'d181;
            fft_wn_im_o[12*`WN_WID -1 :11*`WN_WID] = -'d237;
            fft_wn_im_o[13*`WN_WID -1 :12*`WN_WID] = -'d256;
            fft_wn_im_o[14*`WN_WID -1 :13*`WN_WID] = -'d237;
            fft_wn_im_o[15*`WN_WID -1 :14*`WN_WID] = -'d181;
            fft_wn_im_o[16*`WN_WID -1 :15*`WN_WID] = -'d98;
            fft_wn_im_o[17*`WN_WID -1 :16*`WN_WID] = 'd0;
            fft_wn_im_o[18*`WN_WID -1 :17*`WN_WID] = -'d98;
            fft_wn_im_o[19*`WN_WID -1 :18*`WN_WID] = -'d181;
            fft_wn_im_o[20*`WN_WID -1 :19*`WN_WID] = -'d237;
            fft_wn_im_o[21*`WN_WID -1 :20*`WN_WID] = -'d256;
            fft_wn_im_o[22*`WN_WID -1 :21*`WN_WID] = -'d237;
            fft_wn_im_o[23*`WN_WID -1 :22*`WN_WID] = -'d181;
            fft_wn_im_o[24*`WN_WID -1 :23*`WN_WID] = -'d98;
            fft_wn_im_o[25*`WN_WID -1 :24*`WN_WID] = 'd0;
            fft_wn_im_o[26*`WN_WID -1 :25*`WN_WID] = -'d98;
            fft_wn_im_o[27*`WN_WID -1 :26*`WN_WID] = -'d181;
            fft_wn_im_o[28*`WN_WID -1 :27*`WN_WID] = -'d237;
            fft_wn_im_o[29*`WN_WID -1 :28*`WN_WID] = -'d256;
            fft_wn_im_o[30*`WN_WID -1 :29*`WN_WID] = -'d237;
            fft_wn_im_o[31*`WN_WID -1 :30*`WN_WID] = -'d181;
            fft_wn_im_o[32*`WN_WID -1 :31*`WN_WID] = -'d98;
        end
        'd4: begin //16
            fft_wn_re_o[ `WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[ 2*`WN_WID -1 :   `WN_WID] = 'd251;
            fft_wn_re_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd237;
            fft_wn_re_o[ 4*`WN_WID -1 : 3*`WN_WID] = 'd213;
            fft_wn_re_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd181;
            fft_wn_re_o[ 6*`WN_WID -1 : 5*`WN_WID] = 'd142;
            fft_wn_re_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd98;
            fft_wn_re_o[ 8*`WN_WID -1 : 7*`WN_WID] = 'd50;
            fft_wn_re_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd0;
            fft_wn_re_o[10*`WN_WID -1 : 9*`WN_WID] = -'d50;
            fft_wn_re_o[11*`WN_WID -1 :10*`WN_WID] = -'d98;
            fft_wn_re_o[12*`WN_WID -1 :11*`WN_WID] = -'d142;
            fft_wn_re_o[13*`WN_WID -1 :12*`WN_WID] = -'d181;
            fft_wn_re_o[14*`WN_WID -1 :13*`WN_WID] = -'d213;
            fft_wn_re_o[15*`WN_WID -1 :14*`WN_WID] = -'d237;
            fft_wn_re_o[16*`WN_WID -1 :15*`WN_WID] = -'d251;
            fft_wn_re_o[17*`WN_WID -1 :16*`WN_WID] = 'd256;
            fft_wn_re_o[18*`WN_WID -1 :17*`WN_WID] = 'd251;
            fft_wn_re_o[19*`WN_WID -1 :18*`WN_WID] = 'd237;
            fft_wn_re_o[20*`WN_WID -1 :19*`WN_WID] = 'd213;
            fft_wn_re_o[21*`WN_WID -1 :20*`WN_WID] = 'd181;
            fft_wn_re_o[22*`WN_WID -1 :21*`WN_WID] = 'd142;
            fft_wn_re_o[23*`WN_WID -1 :22*`WN_WID] = 'd98;
            fft_wn_re_o[24*`WN_WID -1 :23*`WN_WID] = 'd50;
            fft_wn_re_o[25*`WN_WID -1 :24*`WN_WID] = 'd0;
            fft_wn_re_o[26*`WN_WID -1 :25*`WN_WID] = -'d50;
            fft_wn_re_o[27*`WN_WID -1 :26*`WN_WID] = -'d98;
            fft_wn_re_o[28*`WN_WID -1 :27*`WN_WID] = -'d142;
            fft_wn_re_o[29*`WN_WID -1 :28*`WN_WID] = -'d181;
            fft_wn_re_o[30*`WN_WID -1 :29*`WN_WID] = -'d213;
            fft_wn_re_o[31*`WN_WID -1 :30*`WN_WID] = -'d237;
            fft_wn_re_o[32*`WN_WID -1 :31*`WN_WID] = -'d251;

            fft_wn_im_o[ `WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[ 2*`WN_WID -1 :   `WN_WID] = -'d50;
            fft_wn_im_o[ 3*`WN_WID -1 : 2*`WN_WID] = -'d98;
            fft_wn_im_o[ 4*`WN_WID -1 : 3*`WN_WID] = -'d142;
            fft_wn_im_o[ 5*`WN_WID -1 : 4*`WN_WID] = -'d181;
            fft_wn_im_o[ 6*`WN_WID -1 : 5*`WN_WID] = -'d213;
            fft_wn_im_o[ 7*`WN_WID -1 : 6*`WN_WID] = -'d237;
            fft_wn_im_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d251;
            fft_wn_im_o[ 9*`WN_WID -1 : 8*`WN_WID] = -'d256;
            fft_wn_im_o[10*`WN_WID -1 : 9*`WN_WID] = -'d251;
            fft_wn_im_o[11*`WN_WID -1 :10*`WN_WID] = -'d237;
            fft_wn_im_o[12*`WN_WID -1 :11*`WN_WID] = -'d213;
            fft_wn_im_o[13*`WN_WID -1 :12*`WN_WID] = -'d181;
            fft_wn_im_o[14*`WN_WID -1 :13*`WN_WID] = -'d142;
            fft_wn_im_o[15*`WN_WID -1 :14*`WN_WID] = -'d98;
            fft_wn_im_o[16*`WN_WID -1 :15*`WN_WID] = -'d50;
            fft_wn_im_o[17*`WN_WID -1 :16*`WN_WID] = 'd0;
            fft_wn_im_o[18*`WN_WID -1 :17*`WN_WID] = -'d50;
            fft_wn_im_o[19*`WN_WID -1 :18*`WN_WID] = -'d98;
            fft_wn_im_o[20*`WN_WID -1 :19*`WN_WID] = -'d142;
            fft_wn_im_o[21*`WN_WID -1 :20*`WN_WID] = -'d181;
            fft_wn_im_o[22*`WN_WID -1 :21*`WN_WID] = -'d213;
            fft_wn_im_o[23*`WN_WID -1 :22*`WN_WID] = -'d237;
            fft_wn_im_o[24*`WN_WID -1 :23*`WN_WID] = -'d251;
            fft_wn_im_o[25*`WN_WID -1 :24*`WN_WID] = -'d256;
            fft_wn_im_o[26*`WN_WID -1 :25*`WN_WID] = -'d251;
            fft_wn_im_o[27*`WN_WID -1 :26*`WN_WID] = -'d237;
            fft_wn_im_o[28*`WN_WID -1 :27*`WN_WID] = -'d213;
            fft_wn_im_o[29*`WN_WID -1 :28*`WN_WID] = -'d181;
            fft_wn_im_o[30*`WN_WID -1 :29*`WN_WID] = -'d142;
            fft_wn_im_o[31*`WN_WID -1 :30*`WN_WID] = -'d98;
            fft_wn_im_o[32*`WN_WID -1 :31*`WN_WID] = -'d50;
        end
        'd5: begin
            fft_wn_re_o[ `WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[ 2*`WN_WID -1 :   `WN_WID] = 'd255;
            fft_wn_re_o[ 3*`WN_WID -1 : 2*`WN_WID] = 'd251;
            fft_wn_re_o[ 4*`WN_WID -1 : 3*`WN_WID] = 'd245;
            fft_wn_re_o[ 5*`WN_WID -1 : 4*`WN_WID] = 'd237;
            fft_wn_re_o[ 6*`WN_WID -1 : 5*`WN_WID] = 'd226;
            fft_wn_re_o[ 7*`WN_WID -1 : 6*`WN_WID] = 'd213;
            fft_wn_re_o[ 8*`WN_WID -1 : 7*`WN_WID] = 'd198;
            fft_wn_re_o[ 9*`WN_WID -1 : 8*`WN_WID] = 'd181;
            fft_wn_re_o[10*`WN_WID -1 : 9*`WN_WID] = 'd162;
            fft_wn_re_o[11*`WN_WID -1 :10*`WN_WID] = 'd142;
            fft_wn_re_o[12*`WN_WID -1 :11*`WN_WID] = 'd121;
            fft_wn_re_o[13*`WN_WID -1 :12*`WN_WID] = 'd98;
            fft_wn_re_o[14*`WN_WID -1 :13*`WN_WID] = 'd74;
            fft_wn_re_o[15*`WN_WID -1 :14*`WN_WID] = 'd50;
            fft_wn_re_o[16*`WN_WID -1 :15*`WN_WID] = 'd25;
            fft_wn_re_o[17*`WN_WID -1 :16*`WN_WID] = 'd0;
            fft_wn_re_o[18*`WN_WID -1 :17*`WN_WID] = -'d25;
            fft_wn_re_o[19*`WN_WID -1 :18*`WN_WID] = -'d50;
            fft_wn_re_o[20*`WN_WID -1 :19*`WN_WID] = -'d74;
            fft_wn_re_o[21*`WN_WID -1 :20*`WN_WID] = -'d98;
            fft_wn_re_o[22*`WN_WID -1 :21*`WN_WID] = -'d121;
            fft_wn_re_o[23*`WN_WID -1 :22*`WN_WID] = -'d142;
            fft_wn_re_o[24*`WN_WID -1 :23*`WN_WID] = -'d162;
            fft_wn_re_o[25*`WN_WID -1 :24*`WN_WID] = -'d181;
            fft_wn_re_o[26*`WN_WID -1 :25*`WN_WID] = -'d198;
            fft_wn_re_o[27*`WN_WID -1 :26*`WN_WID] = -'d213;
            fft_wn_re_o[28*`WN_WID -1 :27*`WN_WID] = -'d226;
            fft_wn_re_o[29*`WN_WID -1 :28*`WN_WID] = -'d237;
            fft_wn_re_o[30*`WN_WID -1 :29*`WN_WID] = -'d245;
            fft_wn_re_o[31*`WN_WID -1 :30*`WN_WID] = -'d251;
            fft_wn_re_o[32*`WN_WID -1 :31*`WN_WID] = -'d255;

            fft_wn_im_o[ `WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[ 2*`WN_WID -1 :   `WN_WID] = -'d25;
            fft_wn_im_o[ 3*`WN_WID -1 : 2*`WN_WID] = -'d50;
            fft_wn_im_o[ 4*`WN_WID -1 : 3*`WN_WID] = -'d74;
            fft_wn_im_o[ 5*`WN_WID -1 : 4*`WN_WID] = -'d98;
            fft_wn_im_o[ 6*`WN_WID -1 : 5*`WN_WID] = -'d121;
            fft_wn_im_o[ 7*`WN_WID -1 : 6*`WN_WID] = -'d142;
            fft_wn_im_o[ 8*`WN_WID -1 : 7*`WN_WID] = -'d162;
            fft_wn_im_o[ 9*`WN_WID -1 : 8*`WN_WID] = -'d181;
            fft_wn_im_o[10*`WN_WID -1 : 9*`WN_WID] = -'d198;
            fft_wn_im_o[11*`WN_WID -1 :10*`WN_WID] = -'d213;
            fft_wn_im_o[12*`WN_WID -1 :11*`WN_WID] = -'d226;
            fft_wn_im_o[13*`WN_WID -1 :12*`WN_WID] = -'d237;
            fft_wn_im_o[14*`WN_WID -1 :13*`WN_WID] = -'d245;
            fft_wn_im_o[15*`WN_WID -1 :14*`WN_WID] = -'d251;
            fft_wn_im_o[16*`WN_WID -1 :15*`WN_WID] = -'d255;
            fft_wn_im_o[17*`WN_WID -1 :16*`WN_WID] = -'d256;
            fft_wn_im_o[18*`WN_WID -1 :17*`WN_WID] = -'d255;
            fft_wn_im_o[19*`WN_WID -1 :18*`WN_WID] = -'d251;
            fft_wn_im_o[20*`WN_WID -1 :19*`WN_WID] = -'d245;
            fft_wn_im_o[21*`WN_WID -1 :20*`WN_WID] = -'d237;
            fft_wn_im_o[22*`WN_WID -1 :21*`WN_WID] = -'d226;
            fft_wn_im_o[23*`WN_WID -1 :22*`WN_WID] = -'d213;
            fft_wn_im_o[24*`WN_WID -1 :23*`WN_WID] = -'d198;
            fft_wn_im_o[25*`WN_WID -1 :24*`WN_WID] = -'d181;
            fft_wn_im_o[26*`WN_WID -1 :25*`WN_WID] = -'d162;
            fft_wn_im_o[27*`WN_WID -1 :26*`WN_WID] = -'d142;
            fft_wn_im_o[28*`WN_WID -1 :27*`WN_WID] = -'d121;
            fft_wn_im_o[29*`WN_WID -1 :28*`WN_WID] = -'d98;
            fft_wn_im_o[30*`WN_WID -1 :29*`WN_WID] = -'d74;
            fft_wn_im_o[31*`WN_WID -1 :30*`WN_WID] = -'d50;
            fft_wn_im_o[32*`WN_WID -1 :31*`WN_WID] = -'d25;
        end
        default: begin
            fft_wn_re_o = 'd0;
            fft_wn_im_o = 'd0;
        end
    endcase
end


endmodule
