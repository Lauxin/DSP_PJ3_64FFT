//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core64.v
    //  Author         : liuxun
    //  Created        : 2020-01-09
    //  Description    : FFT core part. Do 64-FFT using 2-based FFT
    //                   May use fsm to implement
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"
`define     STATE     4

module fft_core64(
    clk,
    rst_n,
    val_i,
    fft_data_re_i,
    fft_data_im_i,
    done_o,
    fft_data_re_o,
    fft_data_im_o
);

//*** PARAMETER ****************************************************************

localparam idle     = `STATE'd0;
localparam order    = `STATE'd1;
localparam fft      = `STATE'd2;
localparam reord    = `STATE'd3;

//*** INPUT/OUTPUT *************************************************************
input   clk;
input   rst_n;
input   val_i;
input   [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_i;
input   [`FFT_LEN*`DATA_WID -1 : 0] fft_data_im_i;
output  done_o;
output  [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_o;
output  [`FFT_LEN*`DATA_WID -1 : 0] fft_data_im_o;


//*** WIRE/REG *****************************************************************
reg     [`STATE -1 : 0] cur_state_r;
reg     [`STATE -1 : 0] nxt_state_r;
reg     fft_done;
reg     [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_r;
reg     [`FFT_LEN*`DATA_WID -1 : 0] fft_data_im_r;

wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_ord_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_im_ord_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_reord_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_im_reord_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_fft_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_im_fft_w;

wire    [`WN_LEN*`WN_WID -1 : 0] fft_wn_re_w;
wire    [`WN_LEN*`WN_WID -1 : 0] fft_wn_im_w;

reg     [`STG_WID -1 : 0] stage_r;


//*** MAIN BODY ****************************************************************
always  @(posedge clk or negedge rst_n) begin
    if(!rst_n) cur_state_r <= idle;
    else cur_state_r <= nxt_state_r;
end

always @(*) begin
    nxt_state_r = idle;
    case (cur_state_r)
        idle: begin
            if (val_i) nxt_state_r = order;
            else nxt_state_r = idle;
        end 
        order:  nxt_state_r = fft;
        fft:    nxt_state_r = reord;
        reord:  begin
            if(!fft_done)
                nxt_state_r = order;
            else
                nxt_state_r = idle;
        end
        default: nxt_state_r = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        stage_r <= 'd0;
        fft_done <= 'd0;
        fft_data_re_r <= 'd0;
        fft_data_im_r <= 'd0;
    end
    else begin
        case (nxt_state_r)
            idle: begin
                stage_r <= 'd0;
                fft_data_re_r <= 'd0;
                fft_data_im_r <= 'd0;
            end
            order: begin
                fft_data_re_r <= stage_r == 'd0 ? fft_data_re_i : (stage_r == 'd1 ? fft_data_re_r : fft_data_re_reord_w);
                fft_data_im_r <= stage_r == 'd0 ? fft_data_im_i : (stage_r == 'd1 ? fft_data_im_r : fft_data_im_reord_w);
            end
            fft: begin
                stage_r <= stage_r + 1;
                if(stage_r == `LOG2_FFT_LEN -1) fft_done <= 'b1;
                fft_data_re_r <= fft_data_re_ord_w;
                fft_data_im_r <= fft_data_im_ord_w;
            end
            reord: begin
                fft_data_re_r <= fft_data_re_fft_w;
                fft_data_im_r <= fft_data_im_fft_w;
            end 
            default: begin
                fft_data_re_r <= 'd0;
                fft_data_im_r <= 'd0;
            end
        endcase
    end
end

assign fft_data_re_o = (fft_done & cur_state_r == reord) ? fft_data_re_reord_w : 'd0;
assign fft_data_im_o = (fft_done & cur_state_r == reord) ? fft_data_im_reord_w : 'd0;
assign done_o = fft_done & cur_state_r == reord;

fft_ord fft_ord_u(
    .stage_i(cur_state_r == order ? stage_r : stage_r-`STG_WID'd1),

    .fft_data_re_i(fft_data_re_r),
    .fft_data_im_i(fft_data_im_r),

    .fft_data_re_o(fft_data_re_ord_w),
    .fft_data_im_o(fft_data_im_ord_w)
);

fft_reord fft_reord_u(
    .stage_i(cur_state_r == order ? stage_r : stage_r-`STG_WID'd1),

    .fft_data_re_i(fft_data_re_r),
    .fft_data_im_i(fft_data_im_r),

    .fft_data_re_o(fft_data_re_reord_w),
    .fft_data_im_o(fft_data_im_reord_w)
);

fft_core2x32 fft_core2x32_u(
    .fft_data_re_2x32_i(fft_data_re_r),
    .fft_data_im_2x32_i(fft_data_im_r),
    .fft_wn_re_2x32_i(fft_wn_re_w),
    .fft_wn_im_2x32_i(fft_wn_im_w),
    .fft_data_re_2x32_o(fft_data_re_fft_w),
    .fft_data_im_2x32_o(fft_data_im_fft_w)
);

fft_gen_wn fft_gen_wn_u(
    .stage_i(cur_state_r == order ? stage_r : stage_r-`STG_WID'd1),

    .fft_wn_re_o(fft_wn_re_w),
    .fft_wn_im_o(fft_wn_im_w)
);

endmodule


//*** SUB MODULE ****************************************************************
module fft_core2x32(
    fft_data_re_2x32_i,
    fft_data_im_2x32_i,
    fft_wn_re_2x32_i,
    fft_wn_im_2x32_i,
    fft_data_re_2x32_o,
    fft_data_im_2x32_o
);

input   [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_2x32_i, fft_data_im_2x32_i;
input   [`WN_LEN*`WN_WID -1 : 0] fft_wn_re_2x32_i, fft_wn_im_2x32_i;
output  [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_2x32_o, fft_data_im_2x32_o;

generate
genvar i;
    for (i = 0; i<`FFT_LEN/2; i = i+1) begin:fft_core2x32
        fft_core2 fft_core2_u(
            .fft_data_re1_i ( fft_data_re_2x32_i[(2*i+1)*`DATA_WID -1 : (2*i  )*`DATA_WID] ),
            .fft_data_im1_i ( fft_data_im_2x32_i[(2*i+1)*`DATA_WID -1 : (2*i  )*`DATA_WID] ),
            .fft_data_re2_i ( fft_data_re_2x32_i[(2*i+2)*`DATA_WID -1 : (2*i+1)*`DATA_WID] ),
            .fft_data_im2_i ( fft_data_im_2x32_i[(2*i+2)*`DATA_WID -1 : (2*i+1)*`DATA_WID] ),

            .fft_wn_re_i    ( fft_wn_re_2x32_i[(i+1)*`WN_WID -1 : i*`WN_WID]               ),
            .fft_wn_im_i    ( fft_wn_im_2x32_i[(i+1)*`WN_WID -1 : i*`WN_WID]               ),

            .fft_data_re1_o ( fft_data_re_2x32_o[(2*i+1)*`DATA_WID -1 : (2*i  )*`DATA_WID] ),
            .fft_data_im1_o ( fft_data_im_2x32_o[(2*i+1)*`DATA_WID -1 : (2*i  )*`DATA_WID] ),
            .fft_data_re2_o ( fft_data_re_2x32_o[(2*i+2)*`DATA_WID -1 : (2*i+1)*`DATA_WID] ),
            .fft_data_im2_o ( fft_data_im_2x32_o[(2*i+2)*`DATA_WID -1 : (2*i+1)*`DATA_WID] )
        );
    end
endgenerate


endmodule
