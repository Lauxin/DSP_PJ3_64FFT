//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_core2.v
    //  Author         : LX
    //  Created        : 2021-04-12
    //  Description    : testbench for fft_core2
    //                   
//------------------------------------------------------------------------------


//--- GLOBAL ---------------------------
`define     SIM_TOP             sim_fft_core2
`define     DUT_TOP             fft_core2

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
// `define     INIT_DATA_W_N_FILE    "./check_data/cfg_fft_wn_64.dat"

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
  localparam FFT_DATA_WD = 10 ;
  localparam FFT_WN_WD = 10 ;

//*** INPUT/OUTPUT *************************************************************
  reg  signed  [FFT_DATA_WD     -1 : 0] fft_din_1_re;
  reg  signed  [FFT_DATA_WD     -1 : 0] fft_din_1_im;
  reg  signed  [FFT_DATA_WD     -1 : 0] fft_din_2_re;
  reg  signed  [FFT_DATA_WD     -1 : 0] fft_din_2_im;
  reg  signed  [FFT_WN_WD       -1 : 0] fft_wn_re;
  reg  signed  [FFT_WN_WD       -1 : 0] fft_wn_im;

  wire signed  [FFT_DATA_WD     -1 : 0] fft_dout_1_re;
  wire signed  [FFT_DATA_WD     -1 : 0] fft_dout_1_im;
  wire signed  [FFT_DATA_WD     -1 : 0] fft_dout_2_re;
  wire signed  [FFT_DATA_WD     -1 : 0] fft_dout_2_im;


//*** WIRE/REG *****************************************************************
  reg                               clk ;
  reg                               rst ;


//*** DUT **********************************************************************
  `DUT_TOP #(
    .FFT_DATA_WD     ( FFT_DATA_WD ),
    .FFT_WN_WD       ( FFT_WN_WD   )
  ) dut(
    .fft_din_1_re  ( fft_din_1_re  ),
    .fft_din_1_im  ( fft_din_1_im  ),
    .fft_din_2_re  ( fft_din_2_re  ),
    .fft_din_2_im  ( fft_din_2_im  ),
    .fft_wn_re     ( fft_wn_re     ),
    .fft_wn_im     ( fft_wn_im     ),
    .fft_dout_1_re ( fft_dout_1_re ),
    .fft_dout_1_im ( fft_dout_1_im ),
    .fft_dout_2_re ( fft_dout_2_re ),
    .fft_dout_2_im ( fft_dout_2_im )
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
    fft_din_1_re = 'sd50;
    fft_din_1_im = -'sd260;
    fft_din_2_re = -'sd367;
    fft_din_2_im = 'sd30;
    fft_wn_re    = -'sd154;
    fft_wn_im    = 'sd70;
    #(100*`DUT_FULL_CLK) ;
    $stop;
  end


//*** INIT **********************************************************************
  // INIT_DATA_W_N


//*** CHKI **********************************************************************
  // CHKI_DATA_FFT


//*** CHKO **********************************************************************


endmodule
