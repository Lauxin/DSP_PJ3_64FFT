//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_mem.v
    //  Author         : LX
    //  Created        : 2022-05-09
    //  Description    : testbench for fft_mem
    //                   
//------------------------------------------------------------------------------

//--- GLOBAL ---------------------------
`define     SIM_TOP             sim_fft_mem
`define     SIM_TOP_STR         "sim_fft_mem"
`define     DUT_TOP             fft_mem
`define     DUT_TOP_STR         "fft_mem"

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10  // 100M
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
// `define     DMP_SHM_FILE        "./simul_data/waveform.shm"
// `define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
// `define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
// `define     DMP_EVCD_FILE       "./simul_data/waveform.evcd"


module `SIM_TOP;
//*** PARAMETER ****************************************************************
  localparam FFT_DATA_WD     = 10 ;

  localparam SIZE_MAT        = 8 ;
  localparam SIZE_MAT_WD     = 3 ;
  localparam SIZE_MAT_FUL    = SIZE_MAT    * SIZE_MAT    ;
  localparam SIZE_MAT_FUL_WD = SIZE_MAT_WD + SIZE_MAT_WD ;

//*** INPUT/OUTPUT *************************************************************
reg                                      rst_n     ;
reg                                      clk       ;
reg                                      dim_sel   ;
reg        [SIZE_MAT_WD           -1 :0] rd_addr_1x8;
reg                                      rd_vld_1x8;
wire                                     rd_vld_1x8_o;
wire       [SIZE_MAT*FFT_DATA_WD  -1 :0] rd_dat_1x8;
reg        [SIZE_MAT_WD           -1 :0] wr_addr_1x8;
reg                                      wr_vld_1x8;
reg        [SIZE_MAT*FFT_DATA_WD  -1 :0] wr_dat_1x8;
reg        [SIZE_MAT_FUL_WD       -1 :0] rd_addr_1x1;
reg                                      rd_vld_1x1;
wire                                     rd_vld_1x1_o;
wire       [FFT_DATA_WD           -1 :0] rd_dat_1x1;
reg        [SIZE_MAT_FUL_WD       -1 :0] wr_addr_1x1;
reg                                      wr_vld_1x1;
reg        [FFT_DATA_WD           -1 :0] wr_dat_1x1;

//*** WIRE/REG *****************************************************************
wire       [FFT_DATA_WD           -1 :0] rd_data_unfold[0:7];

integer rd_cnt_1x1;
integer wr_cnt_1x1;
integer rd_cnt_1x8;
integer wr_cnt_1x8;



//*** DUT **********************************************************************
`DUT_TOP #(
    .DATA_WD(FFT_DATA_WD)
) dut (
  .rst_n        ( rst_n        ),
  .clk          ( clk          ),
  .dim_sel_i    ( dim_sel      ),
  .rd_addr_1x8_i( rd_addr_1x8  ),
  .rd_vld_1x8_i ( rd_vld_1x8   ),
  .rd_vld_1x8_o ( rd_vld_1x8_o ),
  .rd_dat_1x8_o ( rd_dat_1x8   ),
  .wr_addr_1x8_i( wr_addr_1x8  ),
  .wr_vld_1x8_i ( wr_vld_1x8   ),
  .wr_dat_1x8_i ( wr_dat_1x8   ),
  .rd_addr_1x1_i( rd_addr_1x1  ),
  .rd_vld_1x1_i ( rd_vld_1x1   ),
  .rd_vld_1x1_o ( rd_vld_1x1_o ),
  .rd_dat_1x1_o ( rd_dat_1x1   ),
  .wr_addr_1x1_i( wr_addr_1x1  ),
  .wr_vld_1x1_i ( wr_vld_1x1   ),
  .wr_dat_1x1_i ( wr_dat_1x1   )
);

//*** MAIN BODY ****************************************************************
  // clk
  initial begin
    clk = 'd0 ;
    forever begin
      #`DUT_HALF_CLK ;
      clk = !clk ;
    end
  end

  // rst_n
  initial begin
    rst_n = 'd0;
    #(2 * `DUT_FULL_CLK);
    rst_n = 'd1;
  end

  // rd_unfold
  assign rd_data_unfold[0] = rd_dat_1x8[  FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[1] = rd_dat_1x8[2*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[2] = rd_dat_1x8[3*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[3] = rd_dat_1x8[4*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[4] = rd_dat_1x8[5*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[5] = rd_dat_1x8[6*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[6] = rd_dat_1x8[7*FFT_DATA_WD -1 -: FFT_DATA_WD];
  assign rd_data_unfold[7] = rd_dat_1x8[8*FFT_DATA_WD -1 -: FFT_DATA_WD];

  // main
  initial begin
    // log
    $display( "\n\n*** CHECK %s BEGIN ! ***\n", `DUT_TOP_STR );

    // init
    dim_sel     = 0;
    rd_addr_1x8 = 0;
    rd_vld_1x8  = 0;
    wr_addr_1x8 = 0;
    wr_vld_1x8  = 0;
    wr_dat_1x8  = 0;
    rd_addr_1x1 = 0;
    rd_vld_1x1  = 0;
    wr_addr_1x1 = 0;
    wr_vld_1x1  = 0;
    wr_dat_1x1  = 0;

    // delay
    #(5 * `DUT_FULL_CLK);

    // main
    fork
      begin
        //---wr_1x1---
        for (wr_cnt_1x1 = 0; wr_cnt_1x1 < SIZE_MAT_FUL; wr_cnt_1x1 = wr_cnt_1x1 + 1) begin
          @(posedge clk);
          wr_addr_1x1 = wr_cnt_1x1;
          wr_vld_1x1 = 1;
          wr_dat_1x1 = wr_cnt_1x1;
        end
        @(posedge clk);
        wr_vld_1x1 = 0;
      end
      begin
        @(posedge clk);
        //---rd_1x1---
        for (rd_cnt_1x1 = 0; rd_cnt_1x1 < SIZE_MAT_FUL; rd_cnt_1x1 = rd_cnt_1x1 + 1) begin
          @(posedge clk);
          rd_addr_1x1 = rd_cnt_1x1;
          rd_vld_1x1 = 1;
        end
        @(posedge clk);
        rd_vld_1x1 = 0;
      end
    join

    fork
      begin
        //---wr_1x8(row)---
        for (wr_cnt_1x8 = 0; wr_cnt_1x8 < SIZE_MAT; wr_cnt_1x8 = wr_cnt_1x8 + 1) begin
          @(posedge clk);
          wr_addr_1x8 = wr_cnt_1x8;
          dim_sel = 0;
          wr_vld_1x8 = 1;
          wr_dat_1x8 = { 8{wr_cnt_1x8[FFT_DATA_WD-1 : 0]} };
        end
        @(posedge clk);
        wr_vld_1x8 = 0;
      end
      begin
        @(posedge clk);
        //---rd_1x8(row)---
        for (rd_cnt_1x8 = 0; rd_cnt_1x8 < SIZE_MAT; rd_cnt_1x8 = rd_cnt_1x8 + 1) begin
          @(posedge clk);
          rd_addr_1x8 = rd_cnt_1x8;
          dim_sel = 0;
          rd_vld_1x8 = 1;
        end
        @(posedge clk);
        rd_vld_1x8 = 0;
      end
    join

    //---wr_1x8(col)---
    for (wr_cnt_1x8 = 0; wr_cnt_1x8 < SIZE_MAT; wr_cnt_1x8 = wr_cnt_1x8 + 1) begin
      @(posedge clk);
      wr_addr_1x8 = wr_cnt_1x8;
      dim_sel = 1;
      wr_vld_1x8 = 1;
      wr_dat_1x8 = { 8{wr_cnt_1x8[FFT_DATA_WD-1 : 0]} };
    end
    @(posedge clk);
    wr_vld_1x8 = 0;

    //---rd_1x8(col)---
    for (rd_cnt_1x8 = 0; rd_cnt_1x8 < SIZE_MAT; rd_cnt_1x8 = rd_cnt_1x8 + 1) begin
      @(posedge clk);
      rd_addr_1x8 = rd_cnt_1x8;
      dim_sel = 1;
      rd_vld_1x8 = 1;
    end
    @(posedge clk);
    rd_vld_1x8 = 0;
  end

  // finish
  initial begin
    #(1000*`DUT_FULL_CLK) $stop;
  end


//*** INIT *********************************************************************


//*** CHKI *********************************************************************


//*** CHKO *********************************************************************



endmodule
