//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_top.v
    //  Author         : LX
    //  Created        : 2022-05-27
    //  Description    : testbench for fft_top
    //                   
//------------------------------------------------------------------------------

//--- GLOBAL ---------------------------
  `define     SIM_TOP             sim_fft_top
  `define     SIM_TOP_STR         "sim_fft_top"
  `define     DUT_TOP             fft_top
  `define     DUT_TOP_STR         "fft_top"

//--- LOCAL ----------------------------
  `define     DUT_FULL_CLK        10  // 100M
  `define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
  `define     CHKI_FFT64_DAT_FILE   "./check_data/fft64_data_in.dat"

  `define     CHKO_FFT_DAT        "off"
  `define     CHKO_FFT64_DAT_FILE   "./check_data/fft64_data_out.dat"
  `define     CHKO_FFT8_DAT_FILE    "./check_data/fft8_data_out.dat"
  `define     CHKO_FFT8_W_N_FILE    "./check_data/fft8_wn_in.dat"

  `define     DUMP_FFT8_DAT_IN_FILE     "./dump/fft8_data_in.dat"


module `SIM_TOP;
//*** PARAMETER ****************************************************************
  localparam FFT_DAT_WD = 10 ;
  localparam FFT_W_N_WD = 10 ;
  localparam SIZE_FFT   = 64 ;

  
//*** INPUT/OUTPUT *************************************************************
  reg                                 clk ;
  reg                                 rst_n ;
  reg                                 vld_i;
  reg       [FFT_DAT_WD       -1 : 0] fft_dat_re_i;
  reg       [FFT_DAT_WD       -1 : 0] fft_dat_im_i;
  wire                                vld_o;
  wire      [FFT_DAT_WD       -1 : 0] fft_dat_re_o;
  wire      [FFT_DAT_WD       -1 : 0] fft_dat_im_o;


//*** WIRE/REG *****************************************************************
  reg signed [FFT_DAT_WD      -1 : 0] fft8_dout_re_unfold[0:8 -1];
  reg signed [FFT_DAT_WD      -1 : 0] fft8_dout_im_unfold[0:8 -1];
  reg signed [FFT_DAT_WD      -1 : 0] fft8_din_re_unfold[0:8 -1];
  reg signed [FFT_DAT_WD      -1 : 0] fft8_din_im_unfold[0:8 -1];

  reg signed [FFT_W_N_WD      -1 : 0] fft8_wn_re_unfold[0:7 -1];
  reg signed [FFT_W_N_WD      -1 : 0] fft8_wn_im_unfold[0:7 -1];

  event chki_fft_dat_event;


//*** DUT **********************************************************************
  `DUT_TOP #(
    .FFT_DAT_WD     ( FFT_DAT_WD ),
    .FFT_W_N_WD     ( FFT_W_N_WD )
  ) dut (
    .clk          ( clk          ),
    .rst_n        ( rst_n        ),
    .vld_i        ( vld_i        ),
    .fft_dat_re_i ( fft_dat_re_i ),
    .fft_dat_im_i ( fft_dat_im_i ),
    .vld_o        ( vld_o        ),
    .fft_dat_re_o ( fft_dat_re_o ),
    .fft_dat_im_o ( fft_dat_im_o )
  );

  
//*** MAIN BODY ****************************************************************
  //fft8
  genvar gvar_fft8;
  generate
    for (gvar_fft8=0; gvar_fft8<8; gvar_fft8=gvar_fft8+1) begin:FFT8_DATA
      always @(*) begin
        fft8_dout_re_unfold[gvar_fft8] = dut.fft_core8_u0.fft_dout_re[gvar_fft8*FFT_DAT_WD +: FFT_DAT_WD];
        fft8_dout_im_unfold[gvar_fft8] = dut.fft_core8_u0.fft_dout_im[gvar_fft8*FFT_DAT_WD +: FFT_DAT_WD];
        fft8_din_re_unfold[gvar_fft8] = dut.fft_core8_u0.fft_din_re[gvar_fft8*FFT_DAT_WD +: FFT_DAT_WD];
        fft8_din_im_unfold[gvar_fft8] = dut.fft_core8_u0.fft_din_im[gvar_fft8*FFT_DAT_WD +: FFT_DAT_WD];
      end
    end
  endgenerate

  //wn8
  genvar gvar_wn8;
  generate
    for (gvar_wn8=0; gvar_wn8<7; gvar_wn8=gvar_wn8+1) begin:FFT8_WN_IN
      always @(*) begin
        fft8_wn_re_unfold[gvar_wn8] = dut.fft_wn_u0.fft_wn_re[gvar_wn8*FFT_W_N_WD +: FFT_W_N_WD];
        fft8_wn_im_unfold[gvar_wn8] = dut.fft_wn_u0.fft_wn_im[gvar_wn8*FFT_W_N_WD +: FFT_W_N_WD];
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
    vld_i = 'd0 ;
    fft_dat_re_i = 'd0;
    fft_dat_im_i = 'd0;

    // delay
    #(5*`DUT_FULL_CLK);

    // input
    -> chki_fft_dat_event;
  end

  // finish
  initial begin
    #(500*`DUT_FULL_CLK) $stop;
  end


//*** CHKI **********************************************************************
  initial fork
    CHKI_FFT_DAT;
  join
  
  task CHKI_FFT_DAT;
    // variables
    integer fp;
    integer i;
    integer tmp;

    reg  [FFT_DAT_WD -1 :0] dat_re;
    reg  [FFT_DAT_WD -1 :0] dat_im;

    // main body
    begin
      // open files
      fp = $fopen(`CHKI_FFT64_DAT_FILE,"r");

      // logs
      $display("\n\t read fft input...");

      // core
      forever begin
        // wait
        @(chki_fft_dat_event);

        // read file
        for (i=0; i<64; i=i+1) begin
          @(posedge clk);
          vld_i = 'd1;
          tmp = $fscanf(fp, "(%d+%dj)", dat_re, dat_im);
          fft_dat_re_i = dat_re;
          fft_dat_im_i = dat_im;
        end
        @(posedge clk);
        vld_i = 'd0;
        fft_dat_re_i = 'd0;
        fft_dat_im_i = 'd0;
      end
    end
  endtask


//*** CHKO **********************************************************************
  initial fork
    CHKO_FFT64_DAT;
    CHKO_FFT8_DAT;
    CHKO_FFT8_WN;
  join

  task CHKO_FFT64_DAT;
    // variables
    integer fp;
    integer i;
    integer tmp;
    reg  [FFT_W_N_WD -1 :0] dat_re;
    reg  [FFT_W_N_WD -1 :0] dat_im;

    // main body
    begin
      // open files
      fp = $fopen(`CHKO_FFT64_DAT_FILE, "r");

      // logs
      $display("\t autocheck fft output...");

      // core
      forever begin
        @(negedge clk) ;

        if (vld_o) begin
          tmp = $fscanf(fp, "(%d+%dj)", dat_re, dat_im);
          if (dat_re == fft_dat_re_o && dat_im == fft_dat_im_o) begin
            $display("\tFFT64 CHECK PASS!");
          end
          else begin
            $display("@%t, FFT64 CHECK FAIL! should be(%d+%dj) rather than(%d+%dj)",
              $time, dat_re, dat_re, fft_dat_re_o, fft_dat_im_o
            );
          end
        end
      end
    end
  endtask


  task CHKO_FFT8_DAT;
    // variables
    integer fp;
    integer i;
    integer tmp;
    reg         [8            -1 : 0] correct_flag;
    reg  signed [FFT_DAT_WD   -1 : 0] ram_ref_dout_re[0:8 -1];
    reg  signed [FFT_DAT_WD   -1 : 0] ram_ref_dout_im[0:8 -1];

    // main body
    begin
      // open files
      fp = $fopen(`CHKO_FFT8_DAT_FILE, "r");

      // logs
      $display("\t autocheck fft8 output...");

      // core
      forever begin
        @(negedge clk) ;

        if (dut.fft_core8_u0.vld_out) begin
          for (i=0; i<8; i=i+1) begin
            tmp = $fscanf(fp, "(%d+%dj), ", ram_ref_dout_re[i], ram_ref_dout_im[i]);
            correct_flag[i] = (ram_ref_dout_re[i] == fft8_dout_re_unfold[i]) && (ram_ref_dout_im[i] == fft8_dout_im_unfold[i]);
          end
          if (&correct_flag) begin
            $display("\t FFT8 check PASS!");
          end
          else begin
            $display("\t @(%t) FFT8 check FAIL!", $time);
          end
        end
      end
    end
  endtask

  task CHKO_FFT8_WN;
    // variables
    integer fp;
    integer i;
    integer tmp;
    reg         [7            -1 : 0] correct_flag;
    reg  signed [FFT_W_N_WD   -1 : 0] ram_ref_wn_re[0:7-1];
    reg  signed [FFT_W_N_WD   -1 : 0] ram_ref_wn_im[0:7-1];
    // main body
    begin
      // open files
      fp = $fopen(`CHKO_FFT8_W_N_FILE, "r");
      // logs
      $display("\t autocheck wn input...");
      // core
      forever begin
        @(negedge clk);
        if (dut.fft_wn_u0.vld_out) begin
          for (i=0; i<7; i=i+1) begin
            tmp = $fscanf(fp, "(%d+%dj), ", ram_ref_wn_re[i], ram_ref_wn_im[i]);
            correct_flag[i] = (ram_ref_wn_re[i] == fft8_wn_re_unfold[i]) && (ram_ref_wn_im[i] == fft8_wn_im_unfold[i]);
          end
          if (&correct_flag) begin
            $display("\t FFT8_WN check PASS!");
          end
          else begin
            $display("\t @(%t) FFT8_WN check FAIL!", $time);
          end
        end
      end
    end
  endtask


//*** DUMP **********************************************************************
  initial fork
    DUMP_FFT8_DAT_IN;
  join

  task DUMP_FFT8_DAT_IN;
    // variables
    integer fp;
    integer i;

    // main body
    begin
      // open files
      fp = $fopen(`DUMP_FFT8_DAT_IN_FILE, "w");
      
      // logs
      $display("\n\t dump fft output...");

      // core
      forever begin
        @(negedge clk) ;

        if (dut.fft_core8_u0.vld_in) begin
          for (i=0; i<8; i=i+1) begin
            $fdisplay(fp, "%d+%di", fft8_din_re_unfold[i], fft8_din_im_unfold[i]);
          end
        end
      end
    end
    
  endtask


endmodule
