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

    fft_data_re_i,
    fft_data_im_i,
    val_i,

    fft_data_re_o,
    fft_data_im_o,
    val_o
);

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   clk;
input   rst_n;

input   val_i;
input   [`DATA_WID -1 : 0] fft_data_re_i;
input   [`DATA_WID -1 : 0] fft_data_im_i;

output  reg val_o;
output  reg signed [`DATA_WID -1 : 0] fft_data_re_o;
output  reg signed [`DATA_WID -1 : 0] fft_data_im_o;

//*** WIRE/REG *****************************************************************
// input 
reg     [`DATA_WID -1 : 0] get_data_re_buf [0:`FFT_LEN -1];
reg     [`DATA_WID -1 : 0] get_data_im_buf [0:`FFT_LEN -1];
reg     [`FFT_LEN*`DATA_WID -1 : 0] in_data_re_buf;
reg     [`FFT_LEN*`DATA_WID -1 : 0] in_data_im_buf;
reg     [`LOG2_FFT_LEN -1 : 0] fft_i_cnt;
reg     ready;
// output
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_w, fft_data_im_w;
wire    fft_done;
reg     [`FFT_LEN*`DATA_WID -1 : 0] out_data_re_buf;
reg     [`FFT_LEN*`DATA_WID -1 : 0] out_data_im_buf;
reg     [`DATA_WID -1 : 0] dmp_data_re_buf [0:`FFT_LEN -1];
reg     [`DATA_WID -1 : 0] dmp_data_im_buf [0:`FFT_LEN -1];
reg     [`LOG2_FFT_LEN -1 : 0] fft_o_cnt;

//*** MAIN BODY ****************************************************************
// input serial to parallel
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready <= 'd0;
        fft_i_cnt <= 'd0;
        in_data_re_buf <= 'd0;
        in_data_im_buf <= 'd0;
    end
    else begin
        if (val_i) begin
            if (fft_i_cnt == `FFT_LEN -1) begin
                ready <= 'd1;
                fft_i_cnt <= 'd0;
                get_data_re_buf[fft_i_cnt] <= fft_data_re_i;
                get_data_im_buf[fft_i_cnt] <= fft_data_im_i;
                
                in_data_re_buf <= { fft_data_re_i      , get_data_re_buf[62], get_data_re_buf[61], get_data_re_buf[60],
                                    get_data_re_buf[59], get_data_re_buf[58], get_data_re_buf[57], get_data_re_buf[56],
                                    get_data_re_buf[55], get_data_re_buf[54], get_data_re_buf[53], get_data_re_buf[52],
                                    get_data_re_buf[51], get_data_re_buf[50], get_data_re_buf[49], get_data_re_buf[48],
                                    get_data_re_buf[47], get_data_re_buf[46], get_data_re_buf[45], get_data_re_buf[44],
                                    get_data_re_buf[43], get_data_re_buf[42], get_data_re_buf[41], get_data_re_buf[40],
                                    get_data_re_buf[39], get_data_re_buf[38], get_data_re_buf[37], get_data_re_buf[36],
                                    get_data_re_buf[35], get_data_re_buf[34], get_data_re_buf[33], get_data_re_buf[32],
                                    get_data_re_buf[31], get_data_re_buf[30], get_data_re_buf[29], get_data_re_buf[28],
                                    get_data_re_buf[27], get_data_re_buf[26], get_data_re_buf[25], get_data_re_buf[24],
                                    get_data_re_buf[23], get_data_re_buf[22], get_data_re_buf[21], get_data_re_buf[20],
                                    get_data_re_buf[19], get_data_re_buf[18], get_data_re_buf[17], get_data_re_buf[16],
                                    get_data_re_buf[15], get_data_re_buf[14], get_data_re_buf[13], get_data_re_buf[12],
                                    get_data_re_buf[11], get_data_re_buf[10], get_data_re_buf[ 9], get_data_re_buf[ 8],
                                    get_data_re_buf[ 7], get_data_re_buf[ 6], get_data_re_buf[ 5], get_data_re_buf[ 4],
                                    get_data_re_buf[ 3], get_data_re_buf[ 2], get_data_re_buf[ 1], get_data_re_buf[ 0] };
                
                in_data_im_buf <= { fft_data_im_i      , get_data_im_buf[62], get_data_im_buf[61], get_data_im_buf[60],
                                    get_data_im_buf[59], get_data_im_buf[58], get_data_im_buf[57], get_data_im_buf[56],
                                    get_data_im_buf[55], get_data_im_buf[54], get_data_im_buf[53], get_data_im_buf[52],
                                    get_data_im_buf[51], get_data_im_buf[50], get_data_im_buf[49], get_data_im_buf[48],
                                    get_data_im_buf[47], get_data_im_buf[46], get_data_im_buf[45], get_data_im_buf[44],
                                    get_data_im_buf[43], get_data_im_buf[42], get_data_im_buf[41], get_data_im_buf[40],
                                    get_data_im_buf[39], get_data_im_buf[38], get_data_im_buf[37], get_data_im_buf[36],
                                    get_data_im_buf[35], get_data_im_buf[34], get_data_im_buf[33], get_data_im_buf[32],
                                    get_data_im_buf[31], get_data_im_buf[30], get_data_im_buf[29], get_data_im_buf[28],
                                    get_data_im_buf[27], get_data_im_buf[26], get_data_im_buf[25], get_data_im_buf[24],
                                    get_data_im_buf[23], get_data_im_buf[22], get_data_im_buf[21], get_data_im_buf[20],
                                    get_data_im_buf[19], get_data_im_buf[18], get_data_im_buf[17], get_data_im_buf[16],
                                    get_data_im_buf[15], get_data_im_buf[14], get_data_im_buf[13], get_data_im_buf[12],
                                    get_data_im_buf[11], get_data_im_buf[10], get_data_im_buf[ 9], get_data_im_buf[ 8],
                                    get_data_im_buf[ 7], get_data_im_buf[ 6], get_data_im_buf[ 5], get_data_im_buf[ 4],
                                    get_data_im_buf[ 3], get_data_im_buf[ 2], get_data_im_buf[ 1], get_data_im_buf[ 0] };
                
                /*
                in_data_re_buf <= { fft_data_re_i      , get_data_re_buf[30], get_data_re_buf[29], get_data_re_buf[28],
                                    get_data_re_buf[27], get_data_re_buf[26], get_data_re_buf[25], get_data_re_buf[24],
                                    get_data_re_buf[23], get_data_re_buf[22], get_data_re_buf[21], get_data_re_buf[20],
                                    get_data_re_buf[19], get_data_re_buf[18], get_data_re_buf[17], get_data_re_buf[16],
                                    get_data_re_buf[15], get_data_re_buf[14], get_data_re_buf[13], get_data_re_buf[12],
                                    get_data_re_buf[11], get_data_re_buf[10], get_data_re_buf[ 9], get_data_re_buf[ 8],
                                    get_data_re_buf[ 7], get_data_re_buf[ 6], get_data_re_buf[ 5], get_data_re_buf[ 4],
                                    get_data_re_buf[ 3], get_data_re_buf[ 2], get_data_re_buf[ 1], get_data_re_buf[ 0] };

                in_data_im_buf <= { fft_data_im_i      , get_data_im_buf[30], get_data_im_buf[29], get_data_im_buf[28],
                                    get_data_im_buf[27], get_data_im_buf[26], get_data_im_buf[25], get_data_im_buf[24],
                                    get_data_im_buf[23], get_data_im_buf[22], get_data_im_buf[21], get_data_im_buf[20],
                                    get_data_im_buf[19], get_data_im_buf[18], get_data_im_buf[17], get_data_im_buf[16],
                                    get_data_im_buf[15], get_data_im_buf[14], get_data_im_buf[13], get_data_im_buf[12],
                                    get_data_im_buf[11], get_data_im_buf[10], get_data_im_buf[ 9], get_data_im_buf[ 8],
                                    get_data_im_buf[ 7], get_data_im_buf[ 6], get_data_im_buf[ 5], get_data_im_buf[ 4],
                                    get_data_im_buf[ 3], get_data_im_buf[ 2], get_data_im_buf[ 1], get_data_im_buf[ 0] };
                */
                /*
                in_data_re_buf <= { fft_data_re_i      , get_data_re_buf[14], get_data_re_buf[13], get_data_re_buf[12],
                                    get_data_re_buf[11], get_data_re_buf[10], get_data_re_buf[ 9], get_data_re_buf[ 8],
                                    get_data_re_buf[ 7], get_data_re_buf[ 6], get_data_re_buf[ 5], get_data_re_buf[ 4],
                                    get_data_re_buf[ 3], get_data_re_buf[ 2], get_data_re_buf[ 1], get_data_re_buf[ 0] };

                in_data_im_buf <= { fft_data_im_i      , get_data_im_buf[14], get_data_im_buf[13], get_data_im_buf[12],
                                    get_data_im_buf[11], get_data_im_buf[10], get_data_im_buf[ 9], get_data_im_buf[ 8],
                                    get_data_im_buf[ 7], get_data_im_buf[ 6], get_data_im_buf[ 5], get_data_im_buf[ 4],
                                    get_data_im_buf[ 3], get_data_im_buf[ 2], get_data_im_buf[ 1], get_data_im_buf[ 0] };
                */
            end
            else begin
                fft_i_cnt <= fft_i_cnt + 1;
                get_data_re_buf[fft_i_cnt] <= fft_data_re_i;
                get_data_im_buf[fft_i_cnt] <= fft_data_im_i;
            end
        end
        else begin
            ready <= 'd0;
            fft_i_cnt <= 'd0; 
        end

    end
end

// load output parallel
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data_re_buf <= 'd0;
        out_data_im_buf <= 'd0;
    end
    else begin
        if(fft_done) begin
            out_data_re_buf <= fft_data_re_w;
            out_data_im_buf <= fft_data_im_w;
        end
        else begin
            out_data_re_buf <= out_data_re_buf;
            out_data_im_buf <= out_data_im_buf;
        end
    end
end

// output parallel to serial
generate
genvar i;
    for (i = 0; i<`FFT_LEN; i = i+1) begin:serial_dmp
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                dmp_data_re_buf[i] <= 'd0;
                dmp_data_im_buf[i] <= 'd0;
            end
            else begin
                if(fft_done) begin
                    dmp_data_re_buf[i] <= fft_data_re_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
                    dmp_data_im_buf[i] <= fft_data_im_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
                end
                else begin
                    dmp_data_re_buf[i] <= dmp_data_re_buf[i];
                    dmp_data_im_buf[i] <= dmp_data_im_buf[i];
                end
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fft_o_cnt <= 'd0;
        val_o <= 'd0;
        fft_data_re_o <= 'd0;
        fft_data_im_o <= 'd0;
    end
    else begin
        if (fft_done) begin
            fft_o_cnt <= 'd1;
            val_o <= 'd1;
            fft_data_re_o <= dmp_data_re_buf[fft_o_cnt];
            fft_data_im_o <= dmp_data_im_buf[fft_o_cnt];
        end
        else begin
            if(|fft_o_cnt) begin
                if(fft_o_cnt == `FFT_LEN -1) fft_o_cnt <= 'd0;
                else fft_o_cnt <= fft_o_cnt + 1;
                fft_data_re_o <= dmp_data_re_buf[fft_o_cnt];
                fft_data_im_o <= dmp_data_im_buf[fft_o_cnt];
            end
            else begin
                fft_o_cnt <= 'd0;
                val_o <= 'd0;
                fft_data_re_o <= 'd0;
                fft_data_im_o <= 'd0;
            end
        end
    end
end

fft_core64 fft_core64_u(
    .clk(clk),
    .rst_n(rst_n),
    .val_i(ready),
    .fft_data_re_i(in_data_re_buf),
    .fft_data_im_i(in_data_im_buf),
    .done_o(fft_done),
    .fft_data_re_o(fft_data_re_w),
    .fft_data_im_o(fft_data_im_w)
);


endmodule
