//------------------------------------------------------------------------------
  //
  //  Filename       : fft_top.v
  //  Author         : LiuXun
  //  Created        : 2020-08-02
  //  Description    : 64 points FFT(DIT) top
  //
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_top(
    clk,
    rst,

    val_i,
    fft_dat_re_i,
    fft_dat_im_i,

    val_o,
    fft_dat_re_o,
    fft_dat_im_o
  );

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
  input                         clk;
  input                         rst;

  input                         val_i;
  input   [`DATA_RE_WD -1   :0] fft_dat_re_i; // unsigned data
  input   [`DATA_IM_WD -1   :0] fft_dat_im_i; // unsigned data

  output                        val_o;
  output  [`DATA_RE_WD -1   :0] fft_dat_re_o; // signed data
  output  [`DATA_IM_WD -1   :0] fft_dat_im_o; // signed data

//*** WIRE/REG *****************************************************************
  // d0
  reg     [`DATA_WD       -1 :0] dat_inp_buf [0:`SIZE_FFT -1];
  // d1
  reg     [`DATA_WD       -1 :0] fft_d1_g0_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g1_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g2_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g3_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g4_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g5_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g6_m [0:`SIZE_GRP-1];
  reg     [`DATA_WD       -1 :0] fft_d1_g7_m [0:`SIZE_GRP-1];

  // cnt
  wire    [`LOG2_SIZE_FFT -1 :0] pos_d0_w;
  reg     [`LOG2_SIZE_FFT -1 :0] pos_d0_r;
  reg     [`LOG2_SIZE_FFT -1 :0] cnt_inp_r;
  reg     [`LOG2_SIZE_FFT -1 :0] cnt_out_r;

//*** MAIN BODY ****************************************************************
  // --- input reorder -----------------
  always @ (posedge clk or negedge rst) begin
    if (!rst) begin
      cnt_inp_r <= 'd0;
    end
    else begin
      if (val_i)      cnt_inp_r <= cnt_inp_r + 'd1;
      else if (val_o) cnt_inp_r <= 'd0;
    end
  end

  assign pos_d0_w = {cnt_inp_r[`LOG2_SIZE_FFT-6],
                     cnt_inp_r[`LOG2_SIZE_FFT-5],
                     cnt_inp_r[`LOG2_SIZE_FFT-4],
                     cnt_inp_r[`LOG2_SIZE_FFT-3],
                     cnt_inp_r[`LOG2_SIZE_FFT-2],
                     cnt_inp_r[`LOG2_SIZE_FFT-1]}
  ;

  always @ (posedge clk or negedge rst) begin
    if (!rst) begin
      dat_inp_buf <= 'd0;
    end
    else begin
      if (val_i) begin
        dat_inp_buf[pos_d0_w] <= {fft_dat_re_i,fft_dat_im_i};
      end
    end
  end

  always @ (posedge clk or negedge rst) begin
    if (!rst) begin
      full_g0_r <= 'd0;
      full_g1_r <= 'd0;
      full_g2_r <= 'd0;
      full_g3_r <= 'd0;
      full_g4_r <= 'd0;
      full_g5_r <= 'd0;
      full_g6_r <= 'd0;
      full_g7_r <= 'd0;
    end
    else begin
      full_g0_r <= pos_d0_w == 'd7 ;
      full_g1_r <= pos_d0_w == 'd15;
      full_g2_r <= pos_d0_w == 'd23;
      full_g3_r <= pos_d0_w == 'd31;
      full_g4_r <= pos_d0_w == 'd39;
      full_g5_r <= pos_d0_w == 'd47;
      full_g6_r <= pos_d0_w == 'd55;
      full_g7_r <= pos_d0_w == 'd63;
    end
  end

  // --- fft_core in/out -----------------
  // stage 0
  // input: at "rising edge" of full_gx_r
  always @ (*) begin
    case ({full_g0_r,
           full_g1_r,
           full_g2_r,
           full_g3_r,
           full_g4_r,
           full_g5_r,
           full_g6_r,
           full_g7_r})
      8'b1000_0000: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0100_0000: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0010_0000: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0001_0000: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0000_1000: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0000_0100: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0000_0010: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      8'b0000_0001: begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
      default     : begin
        CORE_dat_i_w = {};
        CORE_wn_i_w  = {};
      end
    endcase
  end

  // output: at full edge of full_gx_r
  always @ (posedge clk or negedge rst) begin
    if (!rst) begin
    end
    else begin
      if (full_g0_r) begin
        fft_d1_g0_m[] <= ;
      end
      if (full_g1_r) begin
        fft_d1_g1_m[] <= ;
      end
      if (full_g2_r) begin
        fft_d1_g2_m[] <= ;
      end
      if (full_g3_r) begin
        fft_d1_g3_m[] <= ;
      end
      if (full_g4_r) begin
        fft_d1_g4_m[] <= ;
      end
      if (full_g5_r) begin
        fft_d1_g5_m[] <= ;
      end
      if (full_g6_r) begin
        fft_d1_g6_m[] <= ;
      end
      if (full_g7_r) begin
        fft_d1_g7_m[] <= ;
      end
    end
  end

  // combinatial logic
  fft_core8 fft_core8_u1(
    .
  );

  // --- output -----------------
  always @ (posedge clk or negedge rst) begin
  end


endmodule
