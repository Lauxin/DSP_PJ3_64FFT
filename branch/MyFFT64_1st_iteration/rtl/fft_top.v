//------------------------------------------------------------------------------
    //
    //  Filename       : fft_top.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : Build FFT using fft_core2 module with a pipeline of 6
    //
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"
module fft_top(
    clk,
    rst_n,

    dat_fft_re_i,
    dat_fft_im_i,
    val_i,

    dat_fft_re_o,
    dat_fft_im_o,
    val_o
);

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   clk;
input   rst_n;

input   val_i;
input   [`DATA_WID -1 : 0] dat_fft_re_i;
input   [`DATA_WID -1 : 0] dat_fft_im_i;

output  reg val_o;
output  signed [`DATA_WID -1 : 0] dat_fft_re_o;
output  signed [`DATA_WID -1 : 0] dat_fft_im_o;

//*** WIRE/REG *****************************************************************
// input
wire    [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_re_i_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_im_i_w;
reg     [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_re_i_r;
reg     [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_im_i_r;
reg     [`LOG2_FFT_LEN      -1 : 0] cnt_fft_i_r ;
reg     ready;

// output
wire    done;
wire    [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_re_o_w;
wire    [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_im_o_w;
reg     [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_re_o_r;
reg     [`FFT_LEN*`DATA_WID -1 : 0] dat_fft_im_o_r;
reg     [`LOG2_FFT_LEN+1    -1 : 0] cnt_fft_o_r ;

//*** MAIN BODY ****************************************************************
// input serial to parallel
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready <= 'd0;
        cnt_fft_i_r <= 'd0;
        dat_fft_re_i_r <= 'd0;
        dat_fft_im_i_r <= 'd0;
    end
    else begin
        if (val_i) begin
            dat_fft_re_i_r <= { dat_fft_re_i, dat_fft_re_i_r[`FFT_LEN*`DATA_WID-1 : `DATA_WID] };
            dat_fft_im_i_r <= { dat_fft_im_i, dat_fft_im_i_r[`FFT_LEN*`DATA_WID-1 : `DATA_WID] };
            if (cnt_fft_i_r == `FFT_LEN -1) begin
                ready <= 'd1;
                cnt_fft_i_r <= 'd0;
            end
            else begin
                cnt_fft_i_r <= cnt_fft_i_r + 1;
            end
        end
        else begin
            ready <= 'd0;
            cnt_fft_i_r <= 'd0; 
        end

    end
end

// output parallel to serial
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        val_o <= 'd0;
        cnt_fft_o_r <= 'd0;
        dat_fft_re_o_r <= 'd0;
        dat_fft_im_o_r <= 'd0;
    end
    else begin
        if(done) begin
            val_o <= 'd1;
            cnt_fft_o_r <= `FFT_LEN;
            dat_fft_re_o_r <= dat_fft_re_o_w;
            dat_fft_im_o_r <= dat_fft_im_o_w;
        end
        else begin 
            if (|cnt_fft_o_r) begin
                cnt_fft_o_r <= cnt_fft_o_r - 1;
                dat_fft_re_o_r <= dat_fft_re_o_r >> `DATA_WID;
                dat_fft_im_o_r <= dat_fft_im_o_r >> `DATA_WID;
            end
            else val_o <= 'd0;
        end
    end
end

assign dat_fft_re_o = dat_fft_re_o_r[`DATA_WID-1 -: `DATA_WID];
assign dat_fft_im_o = dat_fft_im_o_r[`DATA_WID-1 -: `DATA_WID];

// main
fft_core64 fft_core64_u(
    .clk(clk),
    .rst_n(rst_n),
    .val_i(ready),
    .fft_data_re_i(dat_fft_re_i_r),
    .fft_data_im_i(dat_fft_im_i_r),
    .done_o(done),
    .fft_data_re_o(dat_fft_re_o_w),
    .fft_data_im_o(dat_fft_im_o_w)
);

endmodule
