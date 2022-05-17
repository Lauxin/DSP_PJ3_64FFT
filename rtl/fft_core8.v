//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core8.v
    //  Author         : LiuXun
    //  Created        : 2020-08-02
    //  Description    : FFT core. 8 points FFT based on core2
    //                   
//------------------------------------------------------------------------------


module fft_core8 ( 
  rst_n         ,
  clk           ,

  vld_in        ,
  fft_din_re    ,
  fft_din_im    ,
  fft_wn_re     ,
  fft_wn_im     ,

  vld_out       ,
  fft_dout_re   ,
  fft_dout_im
);
  

//*** PARAMETER ****************************************************************
  //global
  parameter     FFT_DATA_WD     = 10 ;
  parameter     FFT_WN_WD       = 10 ;

  //derived

//*** INPUT/OUTPUT *************************************************************
  input                            clk       ;
  input                            rst_n     ;
  input                            vld_in    ;
  input   [8*FFT_DATA_WD   -1 : 0] fft_din_re;
  input   [8*FFT_DATA_WD   -1 : 0] fft_din_im;
  input   [7*FFT_WN_WD     -1 : 0] fft_wn_re ;
  input   [7*FFT_WN_WD     -1 : 0] fft_wn_im ;

  output                           vld_out    ;
  output  [8*FFT_DATA_WD   -1 : 0] fft_dout_re;
  output  [8*FFT_DATA_WD   -1 : 0] fft_dout_im;


//*** WIRE/REG *****************************************************************
  wire    [FFT_DATA_WD     -1 : 0] fft_din_re_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_din_im_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg1_re_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg1_im_unfold[0:7];
  wire    [8*FFT_DATA_WD   -1 : 0] fft_stg1_re;
  wire    [8*FFT_DATA_WD   -1 : 0] fft_stg1_im;
  reg     [8*FFT_DATA_WD   -1 : 0] fft_stg1_re_d;
  reg     [8*FFT_DATA_WD   -1 : 0] fft_stg1_im_d;

  wire    [FFT_DATA_WD     -1 : 0] fft_stg1_re_d_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg1_im_d_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg2_re_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg2_im_unfold[0:7];
  wire    [8*FFT_DATA_WD   -1 : 0] fft_stg2_re;
  wire    [8*FFT_DATA_WD   -1 : 0] fft_stg2_im;
  reg     [8*FFT_DATA_WD   -1 : 0] fft_stg2_re_d;
  reg     [8*FFT_DATA_WD   -1 : 0] fft_stg2_im_d;

  wire    [FFT_DATA_WD     -1 : 0] fft_stg2_re_d_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg2_im_d_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg3_re_unfold[0:7];
  wire    [FFT_DATA_WD     -1 : 0] fft_stg3_im_unfold[0:7];

  reg     [6*FFT_WN_WD     -1 : 0] fft_wn_re_d1;
  reg     [6*FFT_WN_WD     -1 : 0] fft_wn_im_d1;
  reg     [4*FFT_WN_WD     -1 : 0] fft_wn_re_d2;
  reg     [4*FFT_WN_WD     -1 : 0] fft_wn_im_d2;

  reg                              vld_d1       ;
  reg                              vld_d2       ;


//*** MAIN BODY ****************************************************************
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      vld_d1 <= 'd0 ;
      vld_d2 <= 'd0 ;
    end
    else begin
      vld_d1 <= vld_in ;
      vld_d2 <= vld_d1 ;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fft_stg1_re_d <= 'd0 ;
      fft_stg1_im_d <= 'd0 ;
    end
    else if (vld_in) begin
      fft_stg1_re_d <= fft_stg1_re ;
      fft_stg1_im_d <= fft_stg1_im ;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fft_stg2_re_d <= 'd0 ;
      fft_stg2_im_d <= 'd0 ;
    end
    else if (vld_d1) begin
      fft_stg2_re_d <= fft_stg2_re ;
      fft_stg2_im_d <= fft_stg2_im ;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fft_wn_re_d1 <= 'd0;
      fft_wn_im_d1 <= 'd0;
      fft_wn_re_d2 <= 'd0;
      fft_wn_im_d2 <= 'd0;
    end
    else if (vld_in | vld_d1) begin
      fft_wn_re_d1 <= fft_wn_re[7*FFT_WN_WD -1 : FFT_WN_WD];
      fft_wn_im_d1 <= fft_wn_im[7*FFT_WN_WD -1 : FFT_WN_WD];
      fft_wn_re_d2 <= fft_wn_re_d1[6*FFT_WN_WD -1 : 2*FFT_WN_WD];
      fft_wn_im_d2 <= fft_wn_im_d1[6*FFT_WN_WD -1 : 2*FFT_WN_WD];
    end
  end

  //===== stage 1 =====
  // 0 1 | 2 3 | 4 5 | 6 7
  // wn0 | wn0 | wn0 | wn0
  assign fft_din_re_unfold[0] = fft_din_re[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[1] = fft_din_re[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[2] = fft_din_re[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[3] = fft_din_re[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[4] = fft_din_re[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[5] = fft_din_re[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[6] = fft_din_re[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_re_unfold[7] = fft_din_re[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  assign fft_din_im_unfold[0] = fft_din_im[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[1] = fft_din_im[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[2] = fft_din_im[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[3] = fft_din_im[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[4] = fft_din_im[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[5] = fft_din_im[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[6] = fft_din_im[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_din_im_unfold[7] = fft_din_im[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  genvar i;
  generate
    for (i=0; i<4; i=i+1) begin:FFT_STAGE_1
      fft_core2 #(
        .FFT_DATA_WD     ( FFT_DATA_WD ),
        .FFT_WN_WD       ( FFT_WN_WD   )
      ) fft8_stage1_u(
        .fft_din_1_re  ( fft_din_re_unfold[2*i]    ),
        .fft_din_1_im  ( fft_din_im_unfold[2*i]    ),
        .fft_din_2_re  ( fft_din_re_unfold[2*i+1]  ),
        .fft_din_2_im  ( fft_din_im_unfold[2*i+1]  ),
        .fft_wn_re     ( fft_wn_re[0 +: FFT_WN_WD] ),
        .fft_wn_im     ( fft_wn_im[0 +: FFT_WN_WD] ),
        .fft_dout_1_re ( fft_stg1_re_unfold[2*i]   ),
        .fft_dout_1_im ( fft_stg1_im_unfold[2*i]   ),
        .fft_dout_2_re ( fft_stg1_re_unfold[2*i+1] ),
        .fft_dout_2_im ( fft_stg1_im_unfold[2*i+1] )
      );
    end
  endgenerate

  assign fft_stg1_re = {
    fft_stg1_re_unfold[7],
    fft_stg1_re_unfold[6],
    fft_stg1_re_unfold[5],
    fft_stg1_re_unfold[4],
    fft_stg1_re_unfold[3],
    fft_stg1_re_unfold[2],
    fft_stg1_re_unfold[1],
    fft_stg1_re_unfold[0]
  };
  assign fft_stg1_im = {
    fft_stg1_im_unfold[7],
    fft_stg1_im_unfold[6],
    fft_stg1_im_unfold[5],
    fft_stg1_im_unfold[4],
    fft_stg1_im_unfold[3],
    fft_stg1_im_unfold[2],
    fft_stg1_im_unfold[1],
    fft_stg1_im_unfold[0]
  };

  //===== stage 2 =====
  // 0 2 | 1 3 | 4 6 | 5 7
  // wn1 | wn2 | wn1 | wn2
  assign fft_stg1_re_d_unfold[0] = fft_stg1_re_d[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[1] = fft_stg1_re_d[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[2] = fft_stg1_re_d[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[3] = fft_stg1_re_d[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[4] = fft_stg1_re_d[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[5] = fft_stg1_re_d[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[6] = fft_stg1_re_d[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_re_d_unfold[7] = fft_stg1_re_d[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  assign fft_stg1_im_d_unfold[0] = fft_stg1_im_d[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[1] = fft_stg1_im_d[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[2] = fft_stg1_im_d[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[3] = fft_stg1_im_d[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[4] = fft_stg1_im_d[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[5] = fft_stg1_im_d[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[6] = fft_stg1_im_d[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg1_im_d_unfold[7] = fft_stg1_im_d[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  genvar j;
  generate
    for (j=0; j<4; j=j+1) begin:FFT_STAGE_2
      fft_core2 #(
        .FFT_DATA_WD     ( FFT_DATA_WD ),
        .FFT_WN_WD       ( FFT_WN_WD   )
      ) fft8_stage2_u(
        .fft_din_1_re  ( fft_stg1_re_d_unfold[2*j]   ),
        .fft_din_1_im  ( fft_stg1_im_d_unfold[2*j]   ),
        .fft_din_2_re  ( fft_stg1_re_d_unfold[2*j+1] ),
        .fft_din_2_im  ( fft_stg1_im_d_unfold[2*j+1] ),
        .fft_wn_re     ( fft_wn_re_d1[(j%2)*FFT_WN_WD +: FFT_WN_WD] ),
        .fft_wn_im     ( fft_wn_im_d1[(j%2)*FFT_WN_WD +: FFT_WN_WD] ),
        .fft_dout_1_re ( fft_stg2_re_unfold[2*j]     ),
        .fft_dout_1_im ( fft_stg2_im_unfold[2*j]     ),
        .fft_dout_2_re ( fft_stg2_re_unfold[2*j+1]   ),
        .fft_dout_2_im ( fft_stg2_im_unfold[2*j+1]   )
      );
    end
  endgenerate

  assign fft_stg2_re = {
    fft_stg2_re_unfold[7],
    fft_stg2_re_unfold[5],
    fft_stg2_re_unfold[6],
    fft_stg2_re_unfold[4],
    fft_stg2_re_unfold[3],
    fft_stg2_re_unfold[1],
    fft_stg2_re_unfold[2],
    fft_stg2_re_unfold[0]
  };
  assign fft_stg2_im = {
    fft_stg2_im_unfold[7],
    fft_stg2_im_unfold[5],
    fft_stg2_im_unfold[6],
    fft_stg2_im_unfold[4],
    fft_stg2_im_unfold[3],
    fft_stg2_im_unfold[1],
    fft_stg2_im_unfold[2],
    fft_stg2_im_unfold[0]
  };

  //===== stage 3 =====
  // 0 4 | 1 5 | 2 6 | 3 7
  // wn3 | wn4 | wn5 | wn6
  assign fft_stg2_re_d_unfold[0] = fft_stg2_re_d[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[1] = fft_stg2_re_d[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[2] = fft_stg2_re_d[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[3] = fft_stg2_re_d[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[4] = fft_stg2_re_d[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[5] = fft_stg2_re_d[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[6] = fft_stg2_re_d[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_re_d_unfold[7] = fft_stg2_re_d[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  assign fft_stg2_im_d_unfold[0] = fft_stg2_im_d[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[1] = fft_stg2_im_d[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[2] = fft_stg2_im_d[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[3] = fft_stg2_im_d[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[4] = fft_stg2_im_d[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[5] = fft_stg2_im_d[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[6] = fft_stg2_im_d[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign fft_stg2_im_d_unfold[7] = fft_stg2_im_d[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  genvar k;
  generate
    for (k=0; k<4; k=k+1) begin:FFT_STAGE_3
      fft_core2 #(
        .FFT_DATA_WD     ( FFT_DATA_WD ),
        .FFT_WN_WD       ( FFT_WN_WD   )
      ) fft8_stage2_u(
        .fft_din_1_re  ( fft_stg2_re_d_unfold[2*k]   ),
        .fft_din_1_im  ( fft_stg2_im_d_unfold[2*k]   ),
        .fft_din_2_re  ( fft_stg2_re_d_unfold[2*k+1] ),
        .fft_din_2_im  ( fft_stg2_im_d_unfold[2*k+1] ),
        .fft_wn_re     ( fft_wn_re_d2[k*FFT_WN_WD +: FFT_WN_WD] ),
        .fft_wn_im     ( fft_wn_im_d2[k*FFT_WN_WD +: FFT_WN_WD] ),
        .fft_dout_1_re ( fft_stg3_re_unfold[2*k]     ),
        .fft_dout_1_im ( fft_stg3_im_unfold[2*k]     ),
        .fft_dout_2_re ( fft_stg3_re_unfold[2*k+1]   ),
        .fft_dout_2_im ( fft_stg3_im_unfold[2*k+1]   )
      );
    end
  endgenerate

  assign fft_dout_re = {
    fft_stg3_re_unfold[7],
    fft_stg3_re_unfold[5],
    fft_stg3_re_unfold[3],
    fft_stg3_re_unfold[1],
    fft_stg3_re_unfold[6],
    fft_stg3_re_unfold[4],
    fft_stg3_re_unfold[2],
    fft_stg3_re_unfold[0]
  };
  assign fft_dout_im = {
    fft_stg3_im_unfold[7],
    fft_stg3_im_unfold[5],
    fft_stg3_im_unfold[3],
    fft_stg3_im_unfold[1],
    fft_stg3_im_unfold[6],
    fft_stg3_im_unfold[4],
    fft_stg3_im_unfold[2],
    fft_stg3_im_unfold[0]
  };

  assign vld_out = vld_d2 ;

endmodule

