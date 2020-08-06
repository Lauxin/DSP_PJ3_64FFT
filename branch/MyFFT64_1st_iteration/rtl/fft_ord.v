//------------------------------------------------------------------------------
    //
    //  Filename       : fft_ord.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : or
    //                   and do reorder as well.
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_ord(
    stage_i,

    fft_data_re_i,
    fft_data_im_i,

    fft_data_re_o,
    fft_data_im_o
);


//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   [`STG_WID -1 : 0] stage_i;
input   [`FFT_LEN * `DATA_WID -1 : 0] fft_data_re_i;
input   [`FFT_LEN * `DATA_WID -1 : 0] fft_data_im_i;

output  [`FFT_LEN * `DATA_WID -1 : 0] fft_data_re_o;
output  [`FFT_LEN * `DATA_WID -1 : 0] fft_data_im_o;

//*** WIRE/REG *****************************************************************
reg [`FFT_LEN*`LOG2_FFT_LEN -1 : 0] idx_list;
reg [`DATA_WID -1 : 0] fft_data_re_i_mem [0 : `FFT_LEN -1];
reg [`DATA_WID -1 : 0] fft_data_im_i_mem [0 : `FFT_LEN -1];


//*** MAIN BODY ****************************************************************
always @(stage_i) begin
    idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'hx;
    idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'hx;
    idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'hx;
    idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'hx;
    idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'hx;
    idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'hx;
    idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'hx;
    idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'hx;
    idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'hx;
    idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'hx;
    idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'hx;
    idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'hx;
    idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'hx;
    idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'hx;
    idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'hx;
    idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'hx;
    idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'hx;
    idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'hx;
    idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'hx;
    idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'hx;
    idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'hx;
    idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'hx;
    idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'hx;
    idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'hx;
    idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'hx;
    idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'hx;
    idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'hx;
    idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'hx;
    idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'hx;
    idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'hx;
    idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'hx;
    idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'hx;
    idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'hx;
    idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'hx;
    idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'hx;
    idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'hx;
    idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'hx;
    idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'hx;
    idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'hx;
    idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'hx;
    idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'hx;
    idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'hx;
    idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'hx;
    idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'hx;
    idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'hx;
    idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'hx;
    idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'hx;
    idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'hx;
    idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'hx;
    idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'hx;
    idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'hx;
    idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'hx;
    idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'hx;
    idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'hx;
    idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'hx;
    idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'hx;
    idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'hx;
    case (stage_i)
        'd0 : begin
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd32;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd16;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd48;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd8;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd40;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd24;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd56;
            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd4;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd36;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd20;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd52;
            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd12;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd44;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd28;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd60;
            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd2;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd34;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd18;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd50;
            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd10;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd42;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd26;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd58;
            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd6;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd38;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd22;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd54;
            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd14;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd46;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd30;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd62;
            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd1;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd33;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd17;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd49;
            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd9;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd41;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd25;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd57;
            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd5;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd37;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd21;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd53;
            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd13;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd45;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd29;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd61;
            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd3;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd35;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd19;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd51;
            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd11;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd43;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd27;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd59;
            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd7;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd39;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd23;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd55;
            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd15;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd47;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd31;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
        'd1 : begin //2
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd3;

            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd4;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd6;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd5;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd7;

            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd8;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd10;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd9;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd11;

            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd12;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd14;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd13;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd15;

            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd16;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd18;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd17;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd19;

            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd20;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd22;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd21;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd23;

            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd24;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd26;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd25;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd27;

            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd28;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd30;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd29;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd31;

            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd32;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd34;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd33;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd35;

            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd36;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd38;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd37;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd39;

            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd40;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd42;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd41;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd43;

            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd44;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd46;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd45;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd47;

            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd48;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd50;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd49;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd51;

            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd52;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd54;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd53;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd55;

            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd56;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd58;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd57;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd59;

            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd60;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd62;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd61;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
        'd2 : begin //4
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd4;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd5;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd6;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd7;

            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd8;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd12;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd9;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd13;
            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd10;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd14;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd11;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd15;

            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd16;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd20;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd17;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd21;
            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd18;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd22;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd19;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd23;

            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd24;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd28;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd25;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd29;
            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd26;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd30;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd27;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd31;

            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd32;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd36;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd33;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd37;
            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd34;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd38;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd35;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd39;

            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd40;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd44;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd41;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd45;
            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd42;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd46;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd43;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd47;

            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd48;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd52;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd49;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd53;
            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd50;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd54;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd51;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd55;

            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd56;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd60;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd57;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd61;
            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd58;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd62;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd59;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
        'd3 : begin //8
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd8;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd9;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd10;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd11;
            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd4;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd12;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd5;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd13;
            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd6;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd14;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd7;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd15; 

            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd16;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd24;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd17;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd25;
            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd18;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd26;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd19;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd27;
            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd20;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd28;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd21;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd29;
            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd22;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd30;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd23;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd31;

            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd32;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd40;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd33;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd41;
            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd34;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd42;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd35;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd43;
            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd36;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd44;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd37;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd45;
            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd38;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd46;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd39;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd47;

            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd48;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd56;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd49;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd57;
            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd50;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd58;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd51;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd59;
            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd52;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd60;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd53;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd61;
            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd54;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd62;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd55;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
        'd4 : begin //16
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd16;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd17;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd18;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd19;
            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd4;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd20;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd5;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd21;
            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd6;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd22;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd7;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd23;
            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd8;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd24;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd9;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd25;
            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd10;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd26;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd11;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd27;
            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd12;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd28;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd13;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd29;
            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd14;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd30;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd15;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd31;

            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd32;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd48;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd33;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd49;
            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd34;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd50;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd35;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd51;
            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd36;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd52;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd37;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd53;
            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd38;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd54;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd39;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd55;
            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd40;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd56;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd41;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd57;
            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd42;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd58;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd43;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd59;
            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd44;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd60;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd45;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd61;
            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd46;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd62;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd47;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
        'd5 : begin // 32
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd32;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd33;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd34;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd35;
            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd4;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd36;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd5;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd37;
            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd6;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd38;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd7;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd39;
            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd8;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd40;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd9;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd41;
            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd10;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd42;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd11;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd43;
            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd12;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd44;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd13;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd45;
            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd14;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd46;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd15;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd47;
            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd16;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd48;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd17;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd49;
            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd18;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd50;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd19;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd51;
            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd20;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd52;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd21;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd53;
            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd22;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd54;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd23;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd55;
            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd24;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd56;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd25;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd57;
            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd26;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd58;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd27;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd59;
            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd28;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd60;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd29;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd61;
            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd30;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd62;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd31;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
        default: begin
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd4;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd5;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd6;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd7;
            idx_list[ 9*`LOG2_FFT_LEN -1 : 8*`LOG2_FFT_LEN] = 'd8;
            idx_list[10*`LOG2_FFT_LEN -1 : 9*`LOG2_FFT_LEN] = 'd9;
            idx_list[11*`LOG2_FFT_LEN -1 :10*`LOG2_FFT_LEN] = 'd10;
            idx_list[12*`LOG2_FFT_LEN -1 :11*`LOG2_FFT_LEN] = 'd11;
            idx_list[13*`LOG2_FFT_LEN -1 :12*`LOG2_FFT_LEN] = 'd12;
            idx_list[14*`LOG2_FFT_LEN -1 :13*`LOG2_FFT_LEN] = 'd13;
            idx_list[15*`LOG2_FFT_LEN -1 :14*`LOG2_FFT_LEN] = 'd14;
            idx_list[16*`LOG2_FFT_LEN -1 :15*`LOG2_FFT_LEN] = 'd15; 
            idx_list[17*`LOG2_FFT_LEN -1 :16*`LOG2_FFT_LEN] = 'd16;
            idx_list[18*`LOG2_FFT_LEN -1 :17*`LOG2_FFT_LEN] = 'd17;
            idx_list[19*`LOG2_FFT_LEN -1 :18*`LOG2_FFT_LEN] = 'd18;
            idx_list[20*`LOG2_FFT_LEN -1 :19*`LOG2_FFT_LEN] = 'd19;
            idx_list[21*`LOG2_FFT_LEN -1 :20*`LOG2_FFT_LEN] = 'd20;
            idx_list[22*`LOG2_FFT_LEN -1 :21*`LOG2_FFT_LEN] = 'd21;
            idx_list[23*`LOG2_FFT_LEN -1 :22*`LOG2_FFT_LEN] = 'd22;
            idx_list[24*`LOG2_FFT_LEN -1 :23*`LOG2_FFT_LEN] = 'd23;
            idx_list[25*`LOG2_FFT_LEN -1 :24*`LOG2_FFT_LEN] = 'd24;
            idx_list[26*`LOG2_FFT_LEN -1 :25*`LOG2_FFT_LEN] = 'd25;
            idx_list[27*`LOG2_FFT_LEN -1 :26*`LOG2_FFT_LEN] = 'd26;
            idx_list[28*`LOG2_FFT_LEN -1 :27*`LOG2_FFT_LEN] = 'd27;
            idx_list[29*`LOG2_FFT_LEN -1 :28*`LOG2_FFT_LEN] = 'd28;
            idx_list[30*`LOG2_FFT_LEN -1 :29*`LOG2_FFT_LEN] = 'd29;
            idx_list[31*`LOG2_FFT_LEN -1 :30*`LOG2_FFT_LEN] = 'd30;
            idx_list[32*`LOG2_FFT_LEN -1 :31*`LOG2_FFT_LEN] = 'd31;
            idx_list[33*`LOG2_FFT_LEN -1 :32*`LOG2_FFT_LEN] = 'd32;
            idx_list[34*`LOG2_FFT_LEN -1 :33*`LOG2_FFT_LEN] = 'd33;
            idx_list[35*`LOG2_FFT_LEN -1 :34*`LOG2_FFT_LEN] = 'd34;
            idx_list[36*`LOG2_FFT_LEN -1 :35*`LOG2_FFT_LEN] = 'd35;
            idx_list[37*`LOG2_FFT_LEN -1 :36*`LOG2_FFT_LEN] = 'd36;
            idx_list[38*`LOG2_FFT_LEN -1 :37*`LOG2_FFT_LEN] = 'd37;
            idx_list[39*`LOG2_FFT_LEN -1 :38*`LOG2_FFT_LEN] = 'd38;
            idx_list[40*`LOG2_FFT_LEN -1 :39*`LOG2_FFT_LEN] = 'd39;
            idx_list[41*`LOG2_FFT_LEN -1 :40*`LOG2_FFT_LEN] = 'd40;
            idx_list[42*`LOG2_FFT_LEN -1 :41*`LOG2_FFT_LEN] = 'd41;
            idx_list[43*`LOG2_FFT_LEN -1 :42*`LOG2_FFT_LEN] = 'd42;
            idx_list[44*`LOG2_FFT_LEN -1 :43*`LOG2_FFT_LEN] = 'd43;
            idx_list[45*`LOG2_FFT_LEN -1 :44*`LOG2_FFT_LEN] = 'd44;
            idx_list[46*`LOG2_FFT_LEN -1 :45*`LOG2_FFT_LEN] = 'd45;
            idx_list[47*`LOG2_FFT_LEN -1 :46*`LOG2_FFT_LEN] = 'd46;
            idx_list[48*`LOG2_FFT_LEN -1 :47*`LOG2_FFT_LEN] = 'd47;
            idx_list[49*`LOG2_FFT_LEN -1 :48*`LOG2_FFT_LEN] = 'd48;
            idx_list[50*`LOG2_FFT_LEN -1 :49*`LOG2_FFT_LEN] = 'd49;
            idx_list[51*`LOG2_FFT_LEN -1 :50*`LOG2_FFT_LEN] = 'd50;
            idx_list[52*`LOG2_FFT_LEN -1 :51*`LOG2_FFT_LEN] = 'd51;
            idx_list[53*`LOG2_FFT_LEN -1 :52*`LOG2_FFT_LEN] = 'd52;
            idx_list[54*`LOG2_FFT_LEN -1 :53*`LOG2_FFT_LEN] = 'd53;
            idx_list[55*`LOG2_FFT_LEN -1 :54*`LOG2_FFT_LEN] = 'd54;
            idx_list[56*`LOG2_FFT_LEN -1 :55*`LOG2_FFT_LEN] = 'd55;
            idx_list[57*`LOG2_FFT_LEN -1 :56*`LOG2_FFT_LEN] = 'd56;
            idx_list[58*`LOG2_FFT_LEN -1 :57*`LOG2_FFT_LEN] = 'd57;
            idx_list[59*`LOG2_FFT_LEN -1 :58*`LOG2_FFT_LEN] = 'd58;
            idx_list[60*`LOG2_FFT_LEN -1 :59*`LOG2_FFT_LEN] = 'd59;
            idx_list[61*`LOG2_FFT_LEN -1 :60*`LOG2_FFT_LEN] = 'd60;
            idx_list[62*`LOG2_FFT_LEN -1 :61*`LOG2_FFT_LEN] = 'd61;
            idx_list[63*`LOG2_FFT_LEN -1 :62*`LOG2_FFT_LEN] = 'd62;
            idx_list[64*`LOG2_FFT_LEN -1 :63*`LOG2_FFT_LEN] = 'd63;
        end
    endcase
end

genvar i;
generate
    for (i = 0; i<`FFT_LEN; i = i+1) begin:order_input
        always @(fft_data_re_i or fft_data_im_i) begin
            fft_data_re_i_mem[i] = fft_data_re_i[(i+1)*`DATA_WID -1 : i*`DATA_WID];
            fft_data_im_i_mem[i] = fft_data_im_i[(i+1)*`DATA_WID -1 : i*`DATA_WID];
        end
    end
endgenerate

generate
    for (i = 0; i < `FFT_LEN; i = i+1) begin:order_output
        assign fft_data_re_o[(i+1)*`DATA_WID -1 : i*`DATA_WID] = fft_data_re_i_mem[ idx_list[(i+1)*`LOG2_FFT_LEN -1 : i*`LOG2_FFT_LEN] ];
        assign fft_data_im_o[(i+1)*`DATA_WID -1 : i*`DATA_WID] = fft_data_im_i_mem[ idx_list[(i+1)*`LOG2_FFT_LEN -1 : i*`LOG2_FFT_LEN] ];
    end
endgenerate

endmodule

