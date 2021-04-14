//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_core8.v
    //  Author         : LX
    //  Created        : 2021-04-14
    //  Description    : testbench for fft_core8
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

//--- GLOBAL ---------------------------
`define     SIM_TOP             sim_fft_core8
`define     SIM_TOP_STR         "sim_fft_core8"
`define     DUT_TOP             fft_core8
`define     DUT_TOP_STR         "fft_core8"

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10  // 100M
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     INIT_DAT_W_N_FILE   "./check_data/dat_wn_base8_d1_i.dat"

`define     CHKI_DAT_FFT_FILE   "./check_data/dat_fft_base8_d1_i.dat"

`define     CHKO_DAT_FFT        "off"
`define     CHKO_DAT_FFT_FILE   "./check_data/dat_fft_base8_d1_o.dat"

`define     DUMP_DAT_FFT_FILE   "./dat_fft_d1_o.dat"

`define     DMP_SHM_FILE        "./simul_data/waveform.shm"
`define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
`define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
`define     DMP_EVCD_FILE       "./simul_data/waveform.evcd"


module `SIM_TOP;
//*** PARAMETER ****************************************************************
  localparam DATA_INP_WD = 10 ;
  localparam DATA_W_N_WD = 10 ;
  localparam DATA_FRC_WD = 8  ;
  localparam DATA_OUT_WD = 3*((DATA_INP_WD-DATA_FRC_WD) + (DATA_W_N_WD-DATA_FRC_WD) +1) + DATA_FRC_WD ;

//*** INPUT/OUTPUT *************************************************************
  reg                                 clk ;
  reg                                 rst_n ;
  reg                                 val_i ;
  wire       [8*DATA_INP_WD   -1 : 0] dat_fft_re_i ;
  wire       [8*DATA_INP_WD   -1 : 0] dat_fft_im_i ;
  wire       [4*DATA_W_N_WD   -1 : 0] dat_wn_re_i  ;
  wire       [4*DATA_W_N_WD   -1 : 0] dat_wn_im_i  ;

  wire                                val_o ;
  wire       [8*DATA_OUT_WD   -1 : 0] dat_fft_re_o ;
  wire       [8*DATA_OUT_WD   -1 : 0] dat_fft_im_o ;


//*** WIRE/REG *****************************************************************
  reg signed [DATA_INP_WD     -1 : 0] ram_dat_fft_re_i[0:8 -1];
  reg signed [DATA_INP_WD     -1 : 0] ram_dat_fft_im_i[0:8 -1];

  reg signed [DATA_W_N_WD     -1 : 0] ram_dat_wn_re_i [0:4 -1];
  reg signed [DATA_W_N_WD     -1 : 0] ram_dat_wn_im_i [0:4 -1];

  reg signed [DATA_OUT_WD     -1 : 0] ram_dat_fft_re_o[0:8 -1];
  reg signed [DATA_OUT_WD     -1 : 0] ram_dat_fft_im_o[0:8 -1];


  event init_dat_wn_event ;
  event chki_dat_fft_event;

//*** DUT **********************************************************************
  `DUT_TOP #(
    .DATA_INP_WD  ( DATA_INP_WD  ),
    .DATA_OUT_WD  ( DATA_OUT_WD  ),
    .DATA_W_N_WD  ( DATA_W_N_WD  ),
    .DATA_FRC_WD  ( DATA_FRC_WD  )
  ) dut(
    .rst_n        ( rst_n        ),
    .clk          ( clk          ),
    .val_i        ( val_i        ),
    .dat_fft_re_i ( dat_fft_re_i ),
    .dat_fft_im_i ( dat_fft_im_i ),
    .dat_wn_re_i  ( dat_wn_re_i  ),
    .dat_wn_im_i  ( dat_wn_im_i  ),
    .val_o        ( val_o        ),
    .dat_fft_re_o ( dat_fft_re_o ),
    .dat_fft_im_o ( dat_fft_im_o )
  );

//*** MAIN BODY ****************************************************************
  //input
  assign dat_fft_re_i = {ram_dat_fft_re_i[7], ram_dat_fft_re_i[6],
                         ram_dat_fft_re_i[5], ram_dat_fft_re_i[4],
                         ram_dat_fft_re_i[3], ram_dat_fft_re_i[2],
                         ram_dat_fft_re_i[1], ram_dat_fft_re_i[0]}
  ;
  assign dat_fft_im_i = {ram_dat_fft_im_i[7], ram_dat_fft_im_i[6],
                         ram_dat_fft_im_i[5], ram_dat_fft_im_i[4],
                         ram_dat_fft_im_i[3], ram_dat_fft_im_i[2],
                         ram_dat_fft_im_i[1], ram_dat_fft_im_i[0]}
  ;
  assign dat_wn_re_i  = {ram_dat_wn_re_i[3], ram_dat_wn_re_i[2], 
                         ram_dat_wn_re_i[1], ram_dat_wn_re_i[0]}
  ;
  assign dat_wn_im_i  = {ram_dat_wn_im_i[3], ram_dat_wn_im_i[2], 
                         ram_dat_wn_im_i[1], ram_dat_wn_im_i[0]}
  ;
  //output
  genvar i;
  generate
    for (i = 0; i < 8; i = i+1) begin:final_result
      always @(dat_fft_re_o or dat_fft_im_o) begin
        ram_dat_fft_re_o[i] = dat_fft_re_o[(i+1)*DATA_OUT_WD -1 -: DATA_OUT_WD];
        ram_dat_fft_im_o[i] = dat_fft_im_o[(i+1)*DATA_OUT_WD -1 -: DATA_OUT_WD];
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
    rst_n        = 'd0 ;
    clk          = 'd0 ;
    val_i        = 'd0 ;
    // dat_fft_re_i = 'd0 ;
    // dat_fft_im_i = 'd0 ;
    // dat_wn_re_i  = 'd0 ;
    // dat_wn_im_i  = 'd0 ;

    // delay
    #(5*`DUT_FULL_CLK);

    -> init_dat_wn_event;
    repeat(4) begin
      @(negedge clk) ;
      val_i = 'd1;
      -> chki_dat_fft_event;
    end
    @(negedge clk) ;
    val_i = 'd0;
  end

  // finish
  initial begin
    #(100*`DUT_FULL_CLK) $stop;
  end


//*** INIT **********************************************************************
  // INIT_DAT_W_N
  initial begin
    INIT_DAT_W_N;
  end

  task INIT_DAT_W_N;
    // variables
    integer fpt;
    integer i  ;
    integer tmp;

    reg  [DATA_INP_WD -1 :0] dat_re;
    reg  [DATA_INP_WD -1 :0] dat_im;

    // main body
    begin
      // open files
      fpt = $fopen(`INIT_DAT_W_N_FILE, "r");

      // logs
      $display("\t\t init wn for fft...");

      // core
      forever begin
        // wait
        @(init_dat_wn_event);

        // read file
        for (i=0; i<4; i=i+1) begin
          tmp = $fscanf(fpt, "%d+%di\n", dat_re, dat_im);
          ram_dat_wn_re_i[i] = dat_re;
          ram_dat_wn_im_i[i] = dat_im;
        end
      end
    end
  endtask


//*** CHKI **********************************************************************
  // CHKI_DAT_FFT
  initial begin
    CHKI_DAT_FFT;
  end

  task CHKI_DAT_FFT;
    // variables
    integer fpt;
    integer i  ;
    integer tmp;

    reg  [DATA_INP_WD -1 :0] dat_re;
    reg  [DATA_INP_WD -1 :0] dat_im;

    // main body
    begin
      // open files
      fpt = $fopen(`CHKI_DAT_FFT_FILE,"r");

      // logs
      $display("\n\t read fft input...");

      // core
      forever begin
        // wait
        @(chki_dat_fft_event);

        // read file
        for (i=0; i<8; i=i+1) begin
          tmp = $fscanf(fpt, "%d+%di\n", dat_re, dat_im);
          ram_dat_fft_re_i[i] = dat_re;
          ram_dat_fft_im_i[i] = dat_im;
        end
      end
    end
  endtask


//*** CHKO **********************************************************************

  // CHKO_DAT_FFT
  initial begin
    CHKO_DAT_FFT;
  end

  task CHKO_DAT_FFT;
    // variables
    integer fpt;
    integer i  ;
    integer tmp;

    // main body
    begin
      // open files
      fpt = $fopen(`DUMP_DAT_FFT_FILE, "w");

      // logs
      $display("\n\t dump fft output...");

      // core
      forever begin
        @(negedge clk) ;

        if (val_o) begin
          for (i=0; i<8; i=i+1) begin
            $fdisplay(fpt, "%x+%xi", ram_dat_fft_re_o[i], ram_dat_fft_im_o[i]);
          end
        end
      end
    end

  endtask


endmodule
