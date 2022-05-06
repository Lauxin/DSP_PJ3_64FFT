//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_core8.v
    //  Author         : LX
    //  Created        : 2021-04-14
    //  Description    : testbench for fft_core8
    //                   
//------------------------------------------------------------------------------

//--- GLOBAL ---------------------------
`define     SIM_TOP             sim_fft_core8
`define     SIM_TOP_STR         "sim_fft_core8"
`define     DUT_TOP             fft_core8
`define     DUT_TOP_STR         "fft_core8"

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10  // 100M
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     INIT_FFT_W_N_FILE   "./check_data/fft8_wn_in.dat"

`define     CHKI_FFT_DAT_FILE   "./check_data/fft8_data_in.dat"

`define     CHKO_FFT_DAT        "off"
`define     CHKO_FFT_DAT_FILE   "./check_data/fft8_data_out.dat"

`define     DUMP_FFT_DAT_FILE   "./dump/rtl_fft8_data_out.dat"

// `define     DMP_SHM_FILE        "./simul_data/waveform.shm"
// `define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
// `define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
// `define     DMP_EVCD_FILE       "./simul_data/waveform.evcd"


module `SIM_TOP;
//*** PARAMETER ****************************************************************
  localparam FFT_DATA_WD = 10 ;
  localparam FFT_WN_WD   = 10 ;


//*** INPUT/OUTPUT *************************************************************
  reg                                 clk ;
  reg                                 rst_n ;
  reg                                 vld_in ;
  wire       [8*FFT_DATA_WD   -1 : 0] fft_din_re;
  wire       [8*FFT_DATA_WD   -1 : 0] fft_din_im;
  wire       [7*FFT_WN_WD     -1 : 0] fft_wn_re ;
  wire       [7*FFT_WN_WD     -1 : 0] fft_wn_im ;

  wire                                vld_out ;
  wire       [8*FFT_DATA_WD   -1 : 0] fft_dout_re;
  wire       [8*FFT_DATA_WD   -1 : 0] fft_dout_im;


//*** WIRE/REG *****************************************************************
  reg signed [FFT_DATA_WD     -1 : 0] ram_fft_din_re[0:8 -1];
  reg signed [FFT_DATA_WD     -1 : 0] ram_fft_din_im[0:8 -1];

  reg signed [FFT_WN_WD       -1 : 0] ram_fft_wn_re [0:7 -1];
  reg signed [FFT_WN_WD       -1 : 0] ram_fft_wn_im [0:7 -1];

  reg signed [FFT_DATA_WD     -1 : 0] ram_fft_dout_re[0:8 -1];
  reg signed [FFT_DATA_WD     -1 : 0] ram_fft_dout_im[0:8 -1];


  event chki_fft_wn_event ;
  event chki_fft_dat_event;


//*** DUT **********************************************************************
  `DUT_TOP #(
    .FFT_DATA_WD   ( FFT_DATA_WD ),
    .FFT_WN_WD     ( FFT_WN_WD   )
  ) dut (
    .rst_n         ( rst_n       ),
    .clk           ( clk         ),
    .vld_in        ( vld_in      ),
    .fft_din_re    ( fft_din_re  ),
    .fft_din_im    ( fft_din_im  ),
    .fft_wn_re     ( fft_wn_re   ),
    .fft_wn_im     ( fft_wn_im   ),
    .vld_out       ( vld_out     ),
    .fft_dout_re   ( fft_dout_re ),
    .fft_dout_im   ( fft_dout_im )
  );


//*** MAIN BODY ****************************************************************
  //input
  assign fft_din_re = {
    ram_fft_din_re[7], ram_fft_din_re[6],
    ram_fft_din_re[5], ram_fft_din_re[4],
    ram_fft_din_re[3], ram_fft_din_re[2],
    ram_fft_din_re[1], ram_fft_din_re[0]
  };
  assign fft_din_im = {
    ram_fft_din_im[7], ram_fft_din_im[6],
    ram_fft_din_im[5], ram_fft_din_im[4],
    ram_fft_din_im[3], ram_fft_din_im[2],
    ram_fft_din_im[1], ram_fft_din_im[0]
  };
  assign fft_wn_re  = {
    ram_fft_wn_re[6], ram_fft_wn_re[5], ram_fft_wn_re[4], ram_fft_wn_re[3],
    ram_fft_wn_re[2], ram_fft_wn_re[1],
    ram_fft_wn_re[0]
  };
  assign fft_wn_im  = {
    ram_fft_wn_im[6], ram_fft_wn_im[5], ram_fft_wn_im[4], ram_fft_wn_im[3],
    ram_fft_wn_im[2], ram_fft_wn_im[1],
    ram_fft_wn_im[0]
  };

  //output
  genvar i;
  generate
    for (i=0; i<8; i=i+1) begin:FFT_DATA_OUT
      always @(*) begin
        ram_fft_dout_re[i] = fft_dout_re[(i+1)*FFT_DATA_WD -1 -: FFT_DATA_WD];
        ram_fft_dout_im[i] = fft_dout_im[(i+1)*FFT_DATA_WD -1 -: FFT_DATA_WD];
      end
    end
  endgenerate

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
    rst_n = 'd0 ;
    #(2*`DUT_FULL_CLK) ;
    @(negedge clk) ;
    rst_n = 'd1 ;
  end

  // main
  initial begin
    // log
    $display( "\n\n*** CHECK %s BEGIN ! ***\n", `DUT_TOP_STR );

    // init
    vld_in       = 'd0 ;

    // delay
    #(5*`DUT_FULL_CLK);

    // input
    repeat(16) begin
      @(posedge clk);
      vld_in = 'd1;
      -> chki_fft_wn_event;
      -> chki_fft_dat_event;
    end
    @(posedge clk);
    vld_in = 'd0;
  end

  // finish
  initial begin
    #(100*`DUT_FULL_CLK) $stop;
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

    reg  [FFT_DATA_WD -1 :0] dat_re;
    reg  [FFT_DATA_WD -1 :0] dat_im;

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
        for (i=0; i<8; i=i+1) begin
          tmp = $fscanf(fp, "(%d+%dj), ", dat_re, dat_im);
          ram_fft_din_re[i] = dat_re;
          ram_fft_din_im[i] = dat_im;
        end
      end
    end
  endtask


  task CHKI_FFT_WN;
    // variables
    integer fp;
    integer i;
    integer tmp;

    reg  [FFT_WN_WD -1 :0] dat_re;
    reg  [FFT_WN_WD -1 :0] dat_im;

    // main body
    begin
      // open files
      fp = $fopen(`INIT_FFT_W_N_FILE, "r");

      // logs
      $display("\t\t read wn for fft...");

      // core
      forever begin
        // wait
        @(chki_fft_wn_event);

        // read file
        for (i=0; i<7; i=i+1) begin
          tmp = $fscanf(fp, "(%d+%dj), ", dat_re, dat_im);
          ram_fft_wn_re[i] = dat_re;
          ram_fft_wn_im[i] = dat_im;
        end
      end
    end
  endtask


//*** CHKO **********************************************************************
  initial begin
    CHKO_FFT_DAT;
  end

  task CHKO_FFT_DAT;
    // variables
    integer fp;
    integer i;
    integer tmp;
    
    // main body
    begin
      // open files
      fp = $fopen(`DUMP_FFT_DAT_FILE, "w");

      // logs
      $display("\n\t dump fft output...");

      // core
      forever begin
        @(negedge clk) ;

        if (vld_out) begin
          for (i=0; i<8; i=i+1) begin
            $fdisplay(fp, "%x(%d)+%x(%d)i", ram_fft_dout_re[i], ram_fft_dout_re[i], ram_fft_dout_im[i], ram_fft_dout_im[i]);
          end
        end
      end
    end

  endtask


endmodule
