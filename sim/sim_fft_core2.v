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
`define     SIM_TOP_STR         "sim_fft_core8"
`define     DUT_TOP             fft_core2
`define     DUT_TOP_STR         "fft_core2"
//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     INIT_FFT_W_N_FILE   "./check_data/fft2_wn_in.dat"

`define     CHKI_FFT_DAT_FILE   "./check_data/fft2_data_in.dat"

`define     CHKO_FFT_DAT        "on"
`define     CHKO_FFT_DAT_FILE   "./check_data/fft2_data_out.dat"

`define     DUMP_FFT_DAT_FILE   "./rtl_fft8_data_out.dat"

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

  event chki_fft_wn_event ;
  event chki_fft_dat_event;


//*** WIRE/REG *****************************************************************
  reg                               clk ;
  reg                               rst_n ;
  reg                               fft_en;


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

  // rst_n
  initial begin
    rst_n = 'd0;
    #(2 * `DUT_FULL_CLK);
    rst_n = 'd1;
  end

  // main
  initial begin
    // log
    $display( "\n\n*** CHECK %s BEGIN ! ***\n", `DUT_TOP_STR );

    // init
    fft_en = 1'b0;

    // delay
    #(5 * `DUT_FULL_CLK);

    // main
    repeat (200) begin
      @(posedge clk);
      fft_en = 1'b1;
      -> chki_fft_wn_event ;
      -> chki_fft_dat_event;
    end
    @(posedge clk);
    fft_en = 1'b0;
  end

  //finish
  initial begin
    #(1000*`DUT_FULL_CLK) $stop;
  end


//*** INIT **********************************************************************


//*** CHKI **********************************************************************
  initial fork
    CHKI_FFT_DAT;
    CHKI_FFT_WN ;
  join

  task CHKI_FFT_DAT;
    // variables
    integer fp;
    integer i;
    integer tmp;

    // main body
    begin
      // open files
      fp = $fopen(`CHKI_FFT_DAT_FILE,"r");

      // logs
      $display("\n\t read fft input...");

      // core
      forever begin
        // wait
        @(chki_fft_dat_event);

        // read file
        tmp = $fscanf(fp, "(%d+%dj), (%d+%dj)\n", fft_din_1_re, fft_din_1_im, fft_din_2_re, fft_din_2_im);
      end
    end
  endtask


  task CHKI_FFT_WN;
    // variables
    integer fp;
    integer i;
    integer tmp;

    // main body
    begin
      // open files
      fp = $fopen(`INIT_FFT_W_N_FILE, "r");

      // logs
      $display("\n\t read wn for fft...");

      // core
      forever begin
        // wait
        @(chki_fft_wn_event);

        // read file
        tmp = $fscanf(fp, "(%d+%dj)\n", fft_wn_re, fft_wn_im);
      end
    end
  endtask


//*** CHKO **********************************************************************
  initial fork
    CHKO_FFT_DAT;
  join

  task CHKO_FFT_DAT;
    // variables
    integer fp;
    integer i;
    integer tmp;
    reg  signed [FFT_WN_WD -1 :0] dout_1_re;
    reg  signed [FFT_WN_WD -1 :0] dout_1_im;
    reg  signed [FFT_WN_WD -1 :0] dout_2_re;
    reg  signed [FFT_WN_WD -1 :0] dout_2_im;

    // main body
    begin
      // open files
      fp = $fopen(`CHKO_FFT_DAT_FILE, "r");

      // log
      $display("\n\t autocheck fft2 output...");

      // core
      forever begin
        @(negedge clk);
        if (fft_en == 1'b1) begin
          tmp = $fscanf(fp, "(%d+%dj), (%d+%dj)\n", dout_1_re, dout_1_im, dout_2_re, dout_2_im);
          if (dout_1_re == fft_dout_1_re 
          &&  dout_1_im == fft_dout_1_im
          &&  dout_2_re == fft_dout_2_re 
          &&  dout_2_im == fft_dout_2_im ) begin
            $display("\t\t check PASS!!!");
          end
          else begin
            $display("\t\t @(%t), check FAIL!!! should be (%d+%dj) (%d+%dj), rather than (%d+%dj) (%d+%dj)", $time, 
              dout_1_re    , dout_1_im    , dout_2_re    , dout_2_im    ,
              fft_dout_1_re, fft_dout_1_im, fft_dout_2_re, fft_dout_2_im
            );
          end
        end
      end
    end
  endtask

endmodule
