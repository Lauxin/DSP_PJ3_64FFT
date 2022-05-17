//------------------------------------------------------------------------------
  //
  //  Filename       : fft_wn.v
  //  Author         : LiuXun
  //  Created        : 2022-05-12
  //  Description    : 64 points FFT(DIT) wn
  //
//------------------------------------------------------------------------------

module fft_wn(
  clk,
  rst_n,
  vld_in,
  fft_stg,
  fft_idx,
  vld_out,
  fft_wn_re,
  fft_wn_im
);

//*** PARAMETER ****************************************************************
parameter FFT_WN_WD = 10;


//*** INPUT/OUTPUT *************************************************************
input                                   clk;
input                                   rst_n;
input                                   vld_in;
input         [1                 -1 :0] fft_stg;
input         [3                 -1 :0] fft_idx;
output reg                              vld_out;
output reg    [7*FFT_WN_WD       -1 :0] fft_wn_re;
output reg    [7*FFT_WN_WD       -1 :0] fft_wn_im;


//*** WIRE/REG *****************************************************************
wire          [FFT_WN_WD         -2 :0] mem_wn[0 : 16];

reg           [7*FFT_WN_WD       -1 :0] fft_wn_re_tmp;
reg           [7*FFT_WN_WD       -1 :0] fft_wn_im_tmp;


//*** MAIN BODY ****************************************************************
assign mem_wn[0 ] = 9'd0  ;
assign mem_wn[1 ] = 9'd25 ;
assign mem_wn[2 ] = 9'd50 ;
assign mem_wn[3 ] = 9'd74 ;
assign mem_wn[4 ] = 9'd98 ;
assign mem_wn[5 ] = 9'd121;
assign mem_wn[6 ] = 9'd142;
assign mem_wn[7 ] = 9'd162;
assign mem_wn[8 ] = 9'd181;
assign mem_wn[9 ] = 9'd198;
assign mem_wn[10] = 9'd213;
assign mem_wn[11] = 9'd226;
assign mem_wn[12] = 9'd237;
assign mem_wn[13] = 9'd245;
assign mem_wn[14] = 9'd251;
assign mem_wn[15] = 9'd255;
assign mem_wn[16] = 9'd256;

//*** Four quadrant for the idx of Wn
// 32~47(- +j) | 48~63(+ +j)
//--------------------------
// 16~31(- -j) | 0 ~15(+ -j)

//*** Function of real and imag of Wn
// re: mem_idx = |16-idx|
// re: flag    = idx > 16
// im: mem_idx = 16 - |16-idx|
// im: flag    = idx > 0
always @(*) begin
  if (fft_stg == 1'd0) begin
  //wn[0]
  //wn[0::16]
  //wn[0::8]
    fft_wn_re_tmp = {
      {1'b1,~mem_wn[8 ] + 1'b1},  //wn[24]
      {1'b0, mem_wn[0 ]},  //wn[16]
      {1'b0, mem_wn[8 ]},  //wn[8]
      {1'b0, mem_wn[16]},  //wn[0]
      {1'b0, mem_wn[0 ]},  //wn[16]
      {1'b0, mem_wn[16]},  //wn[0]
      {1'b0, mem_wn[16]}   //wn[0]
    };
    fft_wn_im_tmp ={
      {1'b1,~mem_wn[8 ] + 1'b1},  //wn[24]
      {1'b1,~mem_wn[16] + 1'b1},  //wn[16]
      {1'b1,~mem_wn[8 ] + 1'b1},  //wn[8]
      {1'b0, mem_wn[0 ]},  //wn[0]
      {1'b1,~mem_wn[16] + 1'b1},  //wn[16]
      {1'b0, mem_wn[0 ]},  //wn[0]
      {1'b0, mem_wn[0 ]}   //wn[0]
    };
  end
  else begin
  //wn[i*4]
  //wn[i*2::16]
  //wn[i::8]
    fft_wn_re_tmp = {
      {1'b1                       , ~mem_wn[8  + fft_idx] + 1'b1},  //wn[i+24]
      {(fft_idx > 0 ? 1'b1 : 1'b0), (mem_wn[fft_idx  ] ^ {9{fft_idx > 0}}) + (fft_idx > 0 ? 1'b1 : 1'b0)},  //wn[i+16]
      {1'b0                       ,  mem_wn[8  - fft_idx]},  //wn[i+8]
      {1'b0                       ,  mem_wn[16 - fft_idx]},  //wn[i]
      {(fft_idx > 0 ? 1'b1 : 1'b0), (mem_wn[fft_idx*2] ^ {9{fft_idx > 0}}) + (fft_idx > 0 ? 1'b1 : 1'b0)},  //wn[2i+16]
      {1'b0                       ,  mem_wn[16 - fft_idx*2]},  //wn[2i]
      {(fft_idx > 4 ? 1'b1 : 1'b0), (mem_wn[fft_idx > 4 ? fft_idx*4 - 16 : 16 - fft_idx*4] ^ {9{fft_idx > 4}}) + (fft_idx > 4 ? 1'b1 : 1'b0)}   //wn[4i]
    };
    fft_wn_im_tmp = {
      {1'b1                       , ~mem_wn[8  - fft_idx] + 1'b1},  //wn[i+24]
      {1'b1                       , ~mem_wn[16 - fft_idx] + 1'b1},  //wn[i+16]
      {1'b1                       , ~mem_wn[8  + fft_idx] + 1'b1},  //wn[i+8]
      {(fft_idx > 0 ? 1'b1 : 1'b0), (mem_wn[fft_idx  ] ^ {9{fft_idx > 0}}) + (fft_idx > 0 ? 1'b1 : 1'b0)},  //wn[i]
      {1'b1                       , ~mem_wn[16 - fft_idx*2] + 1'b1},  //wn[2i+16]
      {(fft_idx > 0 ? 1'b1 : 1'b0), (mem_wn[fft_idx*2] ^ {9{fft_idx > 0}}) + (fft_idx > 0 ? 1'b1 : 1'b0)},  //wn[2i]
      {(fft_idx > 0 ? 1'b1 : 1'b0), (mem_wn[fft_idx > 4 ? 32 - fft_idx*4 : fft_idx*4] ^ {9{fft_idx > 0}}) + (fft_idx > 0 ? 1'b1 : 1'b0)}   //wn[4i]
    };
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    fft_wn_re <= 'd0;
    fft_wn_im <= 'd0;
  end
  else begin
    fft_wn_re <= fft_wn_re_tmp;
    fft_wn_im <= fft_wn_im_tmp;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    vld_out <= 1'b0;
  else
    vld_out <= vld_in;
end

endmodule
