//------------------------------------------------------------------------------
  //
  //  Filename       : fft_mem.v
  //  Author         : LiuXun
  //  Created        : 2021-04-16
  //  Description    : base8 FFT register manager.
  //                   
//------------------------------------------------------------------------------

module fft_mem (
  rst_n       ,
  clk         ,
//--- 1x8 ---
  dim_1x8_i   ,
  adr_1x8_i   ,
  //rd
  rd_val_1x8_i,
  rd_val_1x8_o,
  rd_dat_1x8_o,
  //wr
  wr_val_1x8_i,
  wr_dat_1x8_i,
//--- 1x1 ---
  adr_x_1x1_i ,
  adr_y_1x1_i ,
  //rd
  rd_val_1x1_i,
  rd_val_1x1_o,
  rd_dat_1x1_o,
  //wr
  wr_val_1x1_i,
  wr_dat_1x1_i,
);

//*** PARAMETER ************
  parameter DATA_WD = -1 ;

  localparam SIZE_MAT        = 8 ;
  localparam SIZE_MAT_WD     = 3 ;
  localparam SIZE_MAT_FUL    = SIZE_MAT    * SIZE_MAT    ;
  localparam SIZE_MAT_FUL_WD = SIZE_MAT_WD + SIZE_MAT_WD ;

//*** INPUT/OUTPUT *********
  input                               clk          ;
  input                               rst_n        ;
//--- 1x8 ---
  input     [1                 -1 :0] dim_1x8_i    ;  //0: row; 1: col
  input     [SIZE_MAT_WD       -1 :0] adr_1x8_i    ;
  //rd
  input                               rd_val_1x8_i ;
  output                              rd_val_1x8_o ;
  output    [SIZE_MAT*DATA_WD  -1 :0] rd_dat_1x8_o ;
  //wr
  input                               wr_val_1x8_i ;
  input     [SIZE_MAT*DATA_WD  -1 :0] wr_dat_1x8_i ;
//--- 1x1 ---
  input     [SIZE_MAT_WD       -1 :0] adr_x_1x1_i  ;
  input     [SIZE_MAT_WD       -1 :0] adr_y_1x1_i  ;
  //rd
  input                               rd_val_1x1_i ;
  output                              rd_val_1x1_o ;
  output    [DATA_WD           -1 :0] rd_dat_1x1_o ;
  //wr
  input                               wr_val_1x1_i ;
  input     [DATA_WD           -1 :0] wr_dat_1x1_i ;


//*** WIRE/REG *************
  wire      [SIZE_MAT_FUL_WD   -1 :0] adr_1x1_w    ;
  reg                                 rd_val_1x1_r ;
  reg                                 rd_val_1x8_r ;
  reg       [DATA_WD           -1 :0] rd_dat_1x1_r ;
  reg       [SIZE_MAT*DATA_WD  -1 :0] rd_dat_1x8_r ;
  reg       [DATA_WD           -1 :0] mem_array[0:SIZE_MAT*SIZE_MAT-1] ;


//*** MAIN BODY ************
  assign adr_1x1_w = (adr_y_1x1_i << 'd3) + adr_x_1x1_i ;
  assign wr_val_i_w = wr_val_1x1_i || wr_val_1x8_i ;
  assign rd_val_i_w = rd_val_1x1_i || rd_val_1x8_i ;

  //wr
  always @ (posedge clk) begin
    if (wr_val_i_w) begin
      if (wr_val_1x1_i) begin
        mem_array[adr_1x1_w] <= wr_dat_1x1_i ;
      end
      else begin  //wr_val_1x8_i
        if (dim_1x8_i) begin
          mem_array[(adr_1x8_i << 'd3)      ] <= wr_dat_1x8_i[      DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd1] <= wr_dat_1x8_i['d2 * DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd2] <= wr_dat_1x8_i['d3 * DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd3] <= wr_dat_1x8_i['d4 * DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd4] <= wr_dat_1x8_i['d5 * DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd5] <= wr_dat_1x8_i['d6 * DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd6] <= wr_dat_1x8_i['d7 * DATA_WD-1 -: DATA_WD] ;
          mem_array[(adr_1x8_i << 'd3) + 'd7] <= wr_dat_1x8_i['d8 * DATA_WD-1 -: DATA_WD] ;
        end
        else begin
          mem_array[               adr_1x8_i] <= wr_dat_1x8_i[      DATA_WD-1 -: DATA_WD] ;
          mem_array[('d1 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d2 * DATA_WD-1 -: DATA_WD] ;
          mem_array[('d2 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d3 * DATA_WD-1 -: DATA_WD] ;
          mem_array[('d3 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d4 * DATA_WD-1 -: DATA_WD] ;
          mem_array[('d4 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d5 * DATA_WD-1 -: DATA_WD] ;
          mem_array[('d5 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d6 * DATA_WD-1 -: DATA_WD] ;
          mem_array[('d6 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d7 * DATA_WD-1 -: DATA_WD] ;
          mem_array[('d7 << 'd3) + adr_1x8_i] <= wr_dat_1x8_i['d8 * DATA_WD-1 -: DATA_WD] ;
        end
      end
    end
  end

  //rd
  always @(posedge clk or negedge rst_n) begin
    if (rst_n) begin
      rd_dat_1x1_r <= 'd0 ;
      rd_dat_1x8_r <= 'd0 ;
    end
    else begin
      if (rd_val_i_w) begin
        if (rd_val_1x1_i) begin
          rd_dat_1x1_r <= mem_array[adr_1x1_w] ;
        end
        else begin  //rd_val_1x8_i
          if (dim_1x8_i) begin
            rd_dat_1x8_r <= {
              mem_array[(adr_1x8_i << 'd3) + 'd7] ,
              mem_array[(adr_1x8_i << 'd3) + 'd6] ,
              mem_array[(adr_1x8_i << 'd3) + 'd5] ,
              mem_array[(adr_1x8_i << 'd3) + 'd4] ,
              mem_array[(adr_1x8_i << 'd3) + 'd3] ,
              mem_array[(adr_1x8_i << 'd3) + 'd2] ,
              mem_array[(adr_1x8_i << 'd3) + 'd1] ,
              mem_array[(adr_1x8_i << 'd3)      ]
            };
          end
          else begin
            rd_dat_1x8_r <= {
              mem_array[('d7 << 'd3) + adr_1x8_i] ,
              mem_array[('d6 << 'd3) + adr_1x8_i] ,
              mem_array[('d5 << 'd3) + adr_1x8_i] ,
              mem_array[('d4 << 'd3) + adr_1x8_i] ,
              mem_array[('d3 << 'd3) + adr_1x8_i] ,
              mem_array[('d2 << 'd3) + adr_1x8_i] ,
              mem_array[('d1 << 'd3) + adr_1x8_i] ,
              mem_array[               adr_1x8_i]
            };
          end
        end
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (rst_n) begin
      rd_val_1x8_r <= 'd0 ;
      rd_val_1x8_r <= 'd0 ;
    end
    else begin
      rd_val_1x1_r <= rd_val_1x1_i ;
      rd_val_1x8_r <= rd_val_1x8_i ;
    end
  end

  assign rd_val_1x1_o = rd_val_1x1_r ;
  assign rd_val_1x8_o = rd_val_1x8_r ;
  assign rd_dat_1x1_o = rd_dat_1x1_r ;
  assign rd_dat_1x8_o = rd_dat_1x8_r ;

endmodule
