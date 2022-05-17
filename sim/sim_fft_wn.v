//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_wn.v
    //  Author         : LX
    //  Created        : 2022-05-15
    //  Description    : testbench for fft_wn
    //                   
//------------------------------------------------------------------------------


//--- GLOBAL ---------------------------
`define     SIM_TOP             sim_fft_wn
`define     SIM_TOP_STR         "sim_fft_wn"
`define     DUT_TOP             fft_wn
`define     DUT_TOP_STR         "fft_wn"

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10  // 100M
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     CHKO_FFT_WN_FILE    "./check_data/fft8_wn_in.dat"

// `define     DMP_SHM_FILE        "./simul_data/waveform.shm"
// `define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
// `define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
// `define     DMP_EVCD_FILE       "./simul_data/waveform.evcd"


module `SIM_TOP;
//*** PARAMETER ****************************************************************
  localparam FFT_WN_WD     = 10 ;


//*** INPUT/OUTPUT *************************************************************
  reg                                      clk;
  reg                                      rst_n;
  reg                                      vld_in;
  reg                                      fft_stg;
  reg        [3                     -1 :0] fft_idx;
  wire                                     vld_out;
  wire       [FFT_WN_WD*7           -1 :0] fft_wn_re;
  wire       [FFT_WN_WD*7           -1 :0] fft_wn_im;


//*** WIRE/REG *****************************************************************
  wire       [FFT_WN_WD             -1 :0] wn_re_unfold[0:7-1];
  wire       [FFT_WN_WD             -1 :0] wn_im_unfold[0:7-1];

  reg signed [FFT_WN_WD             -1 :0] ram_ref_wn_re[0:7-1];
  reg signed [FFT_WN_WD             -1 :0] ram_ref_wn_im[0:7-1];

  integer                                  wn_cnt;


//*** DUT **********************************************************************
  `DUT_TOP #(
    .FFT_WN_WD(FFT_WN_WD)
  ) dut (
    .clk       ( clk       ),
    .rst_n     ( rst_n     ),
    .vld_in    ( vld_in    ),
    .fft_stg   ( fft_stg   ),
    .fft_idx   ( fft_idx   ),
    .vld_out   ( vld_out   ),
    .fft_wn_re ( fft_wn_re ),
    .fft_wn_im ( fft_wn_im )
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

  // wn unfold
  genvar i;
  generate
    for(i=0; i<7; i=i+1) begin:WN_UNFOLD
      assign wn_re_unfold[i] = fft_wn_re[i*FFT_WN_WD +: FFT_WN_WD];
      assign wn_im_unfold[i] = fft_wn_im[i*FFT_WN_WD +: FFT_WN_WD];
    end
  endgenerate

  // main
  initial begin
    // log
    $display( "\n\n*** CHECK %s BEGIN ! ***\n", `DUT_TOP_STR );

    // init
    vld_in = 0;
    fft_stg = 0;
    fft_idx = 0;

    // delay
    #(5 * `DUT_FULL_CLK);

    // main
    for (wn_cnt = 0; wn_cnt < 8; wn_cnt = wn_cnt + 1) begin
      @(posedge clk);
      vld_in = 1;
      fft_stg = 0;
      fft_idx = wn_cnt;
    end
    for (wn_cnt = 0; wn_cnt < 8; wn_cnt = wn_cnt + 1) begin
      @(posedge clk);
      vld_in = 1;
      fft_stg = 1;
      fft_idx = wn_cnt;
    end
    @(posedge clk);
    vld_in = 0;
  end

  // finish
  initial begin
    #(100*`DUT_FULL_CLK) $stop;
  end


//*** INIT *********************************************************************


//*** CHKI *********************************************************************


//*** CHKO *********************************************************************
  initial fork
    CHKO_FFT_WN;
  join

  task CHKO_FFT_WN;
    // variables
    integer fp;
    integer i;
    integer tmp;
    reg [7 -1 : 0] correct_flag;

    // main body
    begin
      // open files
      fp = $fopen(`CHKO_FFT_WN_FILE, "r");
      // logs
      $display("\t autocheck wn input...");
      // core
      forever begin
        @(negedge clk);
        if (vld_out) begin
          for (i=0; i<7; i=i+1) begin
            tmp = $fscanf(fp, "(%d+%dj), ", ram_ref_wn_re[i], ram_ref_wn_im[i]);
            correct_flag[i] = (ram_ref_wn_re[i] == wn_re_unfold[i]) && (ram_ref_wn_im[i] == wn_im_unfold[i]);
          end
          if (&correct_flag) begin
            $display("\t check PASS!");
          end
          else begin
            $display("\t @(%t) check FAIL!", $time);
          end
        end
      end
    end
  endtask

endmodule
