//------------------------------------------------------------------------------
  //
  //  Filename       : fft_mem.v
  //  Author         : LiuXun
  //  Created        : 2021-04-16
  //  Description    : Base8 FFT register manager.
  //  Modified       : 2022-05-10
  //  Description    : add rd and wr addr, make dual-ports SRAM
  //                   wr 1x1 priority higher than 1x8
  //                   rd 1x1 and 1x8 are independent
  //                   wr and rd are independent
//------------------------------------------------------------------------------

module fft_mem (
  rst_n       ,
  clk         ,
//--- 1x8 ---
  dim_sel_i   ,
  //rd
  rd_addr_1x8_i,
  rd_vld_1x8_i,
  rd_vld_1x8_o,
  rd_dat_1x8_o,
  //wr
  wr_addr_1x8_i,
  wr_vld_1x8_i,
  wr_dat_1x8_i,
//--- 1x1 ---
  //rd
  rd_addr_1x1_i,
  rd_vld_1x1_i,
  rd_vld_1x1_o,
  rd_dat_1x1_o,
  //wr
  wr_addr_1x1_i,
  wr_vld_1x1_i,
  wr_dat_1x1_i
);

//*** PARAMETER ************
  parameter DATA_WD = 20 ;

  localparam SIZE_MAT        = 8 ;
  localparam SIZE_MAT_WD     = 3 ;
  localparam SIZE_MAT_FUL    = SIZE_MAT    * SIZE_MAT    ;
  localparam SIZE_MAT_FUL_WD = SIZE_MAT_WD + SIZE_MAT_WD ;

//*** INPUT/OUTPUT *********
  input                               clk         ;
  input                               rst_n       ;
//--- 1x8 ---
  input     [1                 -1 :0] dim_sel_i   ;  //0: row; 1: col
  //rd
  input     [SIZE_MAT_WD       -1 :0] rd_addr_1x8_i;
  input                               rd_vld_1x8_i;
  output                              rd_vld_1x8_o;
  output    [SIZE_MAT*DATA_WD  -1 :0] rd_dat_1x8_o;
  //wr
  input     [SIZE_MAT_WD       -1 :0] wr_addr_1x8_i;
  input                               wr_vld_1x8_i;
  input     [SIZE_MAT*DATA_WD  -1 :0] wr_dat_1x8_i;
//--- 1x1 ---
  //rd
  input     [SIZE_MAT_FUL_WD   -1 :0] rd_addr_1x1_i;
  input                               rd_vld_1x1_i;
  output                              rd_vld_1x1_o;
  output    [DATA_WD           -1 :0] rd_dat_1x1_o;
  //wr
  input     [SIZE_MAT_FUL_WD   -1 :0] wr_addr_1x1_i;
  input                               wr_vld_1x1_i;
  input     [DATA_WD           -1 :0] wr_dat_1x1_i;


//*** WIRE/REG *************
  reg                                 rd_vld_1x1_r;
  reg                                 rd_vld_1x8_r;
  reg       [DATA_WD           -1 :0] rd_dat_1x1_r;
  reg       [SIZE_MAT*DATA_WD  -1 :0] rd_dat_1x8_r;
  reg       [DATA_WD           -1 :0] mem_array[0:SIZE_MAT*SIZE_MAT-1] ;

  integer                             i;

//*** MAIN BODY ************
//--- mem display ---
//--- [0 : 7]
//--- [8 :15]
//--- [16:23]
//--- [24:31]
//--- [32:39]
//--- [40:47]
//--- [48:55]
//--- [56:63]
  //wr
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i=0; i<SIZE_MAT_FUL; i=i+1) begin
        mem_array[i] <= 'hfffff;
      end
    end
    else if (wr_vld_1x1_i) begin
      mem_array[wr_addr_1x1_i] <= wr_dat_1x1_i ;
    end
    else if (wr_vld_1x8_i) begin
      if (!dim_sel_i) begin  //row
        mem_array[(wr_addr_1x8_i << 'd3) + 'd0] <= wr_dat_1x8_i[      DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd1] <= wr_dat_1x8_i['d2 * DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd2] <= wr_dat_1x8_i['d3 * DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd3] <= wr_dat_1x8_i['d4 * DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd4] <= wr_dat_1x8_i['d5 * DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd5] <= wr_dat_1x8_i['d6 * DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd6] <= wr_dat_1x8_i['d7 * DATA_WD-1 -: DATA_WD] ;
        mem_array[(wr_addr_1x8_i << 'd3) + 'd7] <= wr_dat_1x8_i['d8 * DATA_WD-1 -: DATA_WD] ;
      end
      else begin  //col
        mem_array[               wr_addr_1x8_i] <= wr_dat_1x8_i[      DATA_WD-1 -: DATA_WD] ;
        mem_array[('d1 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d2 * DATA_WD-1 -: DATA_WD] ;
        mem_array[('d2 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d3 * DATA_WD-1 -: DATA_WD] ;
        mem_array[('d3 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d4 * DATA_WD-1 -: DATA_WD] ;
        mem_array[('d4 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d5 * DATA_WD-1 -: DATA_WD] ;
        mem_array[('d5 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d6 * DATA_WD-1 -: DATA_WD] ;
        mem_array[('d6 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d7 * DATA_WD-1 -: DATA_WD] ;
        mem_array[('d7 << 'd3) + wr_addr_1x8_i] <= wr_dat_1x8_i['d8 * DATA_WD-1 -: DATA_WD] ;
      end
    end
  end

  //rd_dat_1x1
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_dat_1x1_r <= 'd0 ;
    end
    else if (rd_vld_1x1_i) begin
      rd_dat_1x1_r <= mem_array[rd_addr_1x1_i] ;
    end
  end

  //rd_dat_1x8
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_dat_1x8_r <= 'd0 ;
    end
    else if (rd_vld_1x8_i)begin
      if (!dim_sel_i) begin  //row
        rd_dat_1x8_r <= {
          mem_array[(rd_addr_1x8_i << 'd3) + 'd7] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd6] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd5] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd4] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd3] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd2] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd1] ,
          mem_array[(rd_addr_1x8_i << 'd3) + 'd0]
        };
      end
      else begin  //col
        rd_dat_1x8_r <= {
          mem_array[('d7 << 'd3) + rd_addr_1x8_i] ,
          mem_array[('d6 << 'd3) + rd_addr_1x8_i] ,
          mem_array[('d5 << 'd3) + rd_addr_1x8_i] ,
          mem_array[('d4 << 'd3) + rd_addr_1x8_i] ,
          mem_array[('d3 << 'd3) + rd_addr_1x8_i] ,
          mem_array[('d2 << 'd3) + rd_addr_1x8_i] ,
          mem_array[('d1 << 'd3) + rd_addr_1x8_i] ,
          mem_array[               rd_addr_1x8_i]
        };
      end
    end
  end

  //rd_vld
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_vld_1x1_r <= 'd0 ;
      rd_vld_1x8_r <= 'd0 ;
    end
    else begin
      rd_vld_1x1_r <= rd_vld_1x1_i ;
      rd_vld_1x8_r <= rd_vld_1x8_i ;
    end
  end

  assign rd_vld_1x1_o = rd_vld_1x1_r ;
  assign rd_vld_1x8_o = rd_vld_1x8_r ;
  assign rd_dat_1x1_o = rd_dat_1x1_r ;
  assign rd_dat_1x8_o = rd_dat_1x8_r ;

endmodule
