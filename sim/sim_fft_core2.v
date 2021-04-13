//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_core2.v
    //  Author         : LX
    //  Created        : 2021-04-12
    //  Description    : testbench for fft_core2
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

//--- GLOBAL ---------------------------
`define     SIM_TOP             sim_fft_core2
`define     DUT_TOP             fft_core2

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10  // 100M
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
// `define     INIT_DATA_W_N_FILE    "./check_data/fft_wn_64.dat"

// `define     CHKI_DATA_FFT_FILE    "./check_data/dat_fft_in.dat"

// `define     CHKO          "on"
//   `define     CHKO_DATA_FFT       `CHKO
// `define     CHKO_DATA_FFT_FILE    "./check_data/dat_fft_out.dat"

// `define     DMP_SHM_FILE        "./simul_data/waveform.shm"
// `define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
// `define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
// `define     DMP_EVCD_FILE       "./simul_data/waveform.evcd"


module `SIM_TOP;
//*** PARAMETER ****************************************************************
  //global
  localparam DATA_INP_WD = 10 ;
  // localparam DATA_OUT_WD = 15 ;
  localparam DATA_W_N_WD = 10 ;
  localparam DATA_FRC_WD = 8 ;
  //derived
  localparam DATA_OUT_WD = (DATA_INP_WD-DATA_FRC_WD) + (DATA_W_N_WD-DATA_FRC_WD) + 1 + DATA_FRC_WD ;

//*** INPUT/OUTPUT *************************************************************
  reg    [DATA_INP_WD     -1 : 0]  dat_fft_1_re_i ;
  reg    [DATA_INP_WD     -1 : 0]  dat_fft_1_im_i ;
  reg    [DATA_INP_WD     -1 : 0]  dat_fft_2_re_i ;
  reg    [DATA_INP_WD     -1 : 0]  dat_fft_2_im_i ;
  reg    [DATA_W_N_WD     -1 : 0]  dat_wn_re_i    ;
  reg    [DATA_W_N_WD     -1 : 0]  dat_wn_im_i    ;

  wire   [DATA_OUT_WD     -1 : 0]  dat_fft_1_re_o ;
  wire   [DATA_OUT_WD     -1 : 0]  dat_fft_1_im_o ;
  wire   [DATA_OUT_WD     -1 : 0]  dat_fft_2_re_o ;
  wire   [DATA_OUT_WD     -1 : 0]  dat_fft_2_im_o ;


//*** WIRE/REG *****************************************************************
  reg                               clk ;
  reg                               rst ;


//*** DUT **********************************************************************
  `DUT_TOP #(
    .DATA_INP_WD     ( DATA_INP_WD ),
    .DATA_OUT_WD     ( DATA_OUT_WD ),
    .DATA_W_N_WD     ( DATA_W_N_WD ),
    .DATA_FRC_WD     ( DATA_FRC_WD )
  ) dut(
    .dat_fft_1_re_i ( dat_fft_1_re_i ),
    .dat_fft_1_im_i ( dat_fft_1_im_i ),
    .dat_fft_2_re_i ( dat_fft_2_re_i ),
    .dat_fft_2_im_i ( dat_fft_2_im_i ),
    .dat_wn_re_i    ( dat_wn_re_i    ),
    .dat_wn_im_i    ( dat_wn_im_i    ),

    .dat_fft_1_re_o ( dat_fft_1_re_o ),
    .dat_fft_1_im_o ( dat_fft_1_im_o ),
    .dat_fft_2_re_o ( dat_fft_2_re_o ),
    .dat_fft_2_im_o ( dat_fft_2_im_o )
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

  // rst
  initial begin
    rst = 'd0 ;
    #(5 * `DUT_FULL_CLK) ;
    @(negedge clk) ;
    rst = 'd1 ;
  end

  // main
  initial begin
    #(20*`DUT_FULL_CLK) ;
    dat_fft_1_re_i = 'sd50;
    dat_fft_1_im_i = -'sd260;
    dat_fft_2_re_i = -'sd367;
    dat_fft_2_im_i = 'sd30;
    dat_wn_re_i    = -'sd154;
    dat_wn_im_i    = 'sd70;
    #(100*`DUT_FULL_CLK) ;
    $stop;
  end


//*** INIT **********************************************************************
  // INIT_DATA_W_N


//*** CHKI **********************************************************************
  // CHKI_DATA_FFT


//*** CHKO **********************************************************************


endmodule
