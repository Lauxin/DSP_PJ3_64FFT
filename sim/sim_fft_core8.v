//------------------------------------------------------------------------------
    //
    //  Filename       : sim_fft_core8.v
    //  Author         : LX
    //  Created        : 2019-12-03
    //  Description    : testbench for fft_core8
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

//--- GLOBAL ---------------------------
`define     TST_TOP             sim_fft_core8
`define     DUT_TOP             fft_core8

//--- LOCAL ----------------------------
`define     DUT_FULL_CLK        10  // 100M
`define     DUT_HALF_CLK        (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     INIT_WN_FILE        "./check_data/fft_wn_64.dat"

`define     CHKI_FFT_FILE       "./check_data/fft_data_in.dat"

`define     CHKO          "on"
  `define     CHKO_FFT            `CHKO
`define     CHKO_FFT_FILE       "./check_data/fft_data_out.dat"

`define     DMP_SHM_FILE        "./simul_data/waveform.shm"
`define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
`define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
`define     DMP_EVCD_FIL        "./simul_data/waveform.evcd"


module `TST_TOP();
//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
  wire   [8*DATA_INP_WD   -1 : 0]  fft_dat_re_i;
  wire   [8*DATA_INP_WD   -1 : 0]  fft_dat_im_i;
  wire   [4*`CFG_WN_WD    -1 : 0]  fft_wn_re_i;
  wire   [4*`CFG_WN_WD    -1 : 0]  fft_wn_im_i;

  wire   [8*DATA_OUT_WD   -1 : 0]  fft_dat_re_o;
  wire   [8*DATA_OUT_WD   -1 : 0]  fft_dat_re_o;


//*** WIRE/REG *****************************************************************
  reg        [`DATA_INP_WD  -1 : 0] ram_fft_dat_re [0:8 -1];
  reg        [`DATA_INP_WD  -1 : 0] ram_fft_dat_im [0:8 -1];

  reg signed [`CFG_WN_WD    -1 : 0] cfg_fft_wn_re [0:4 -1];
  reg signed [`CFG_WN_WD    -1 : 0] cfg_fft_wn_im [0:4 -1];

  reg                               clk ;
  reg                               rst ;

  event init_cfg_wn_event;
  event chki_fft_dat_event;


//*** DUT **********************************************************************
  `DUT_TOP dut(
    .fft_dat_re_i  ( fft_dat_re_i ),
    .fft_dat_im_i  ( fft_dat_im_i ),
    .fft_wn_re_i   ( fft_wn_re_i  ),
    .fft_wn_im_i   ( fft_wn_im_i  ),
    .fft_dat_re_o  ( fft_dat_re_o ),
    .fft_dat_im_o  ( fft_dat_im_o )
  );

//*** MAIN BODY ****************************************************************
  assign fft_dat_re_i = {ram_fft_dat_re[7], ram_fft_dat_re[6],
                         ram_fft_dat_re[5], ram_fft_dat_re[4],
                         ram_fft_dat_re[3], ram_fft_dat_re[2],
                         ram_fft_dat_re[1], ram_fft_dat_re[0]  };

  assign fft_dat_im_i = {ram_fft_dat_im[7], ram_fft_dat_im[6],
                         ram_fft_dat_im[5], ram_fft_dat_im[4],
                         ram_fft_dat_im[3], ram_fft_dat_im[2],
                         ram_fft_dat_im[1], ram_fft_dat_im[0]  };

  assign fft_wn_re_i = { cfg_fft_wn_re[3], cfg_fft_wn_re[2], 
                         cfg_fft_wn_re[1], cfg_fft_wn_re[0]  }; 

  assign fft_wn_im_i = { cfg_fft_wn_im[3], cfg_fft_wn_im[2], 
                         cfg_fft_wn_im[1], cfg_fft_wn_im[0]  };

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

  // init
  
  // prepare data
  initial begin
    -> init_cfg_wn_event;
    forever begin
      @(negedge clk) ;
      -> chki_fft_dat_event;
    end
  end

  // finish
  initial begin
    #(`DUT_FULL_CLK*100) $finish;
  end


//*** INIT **********************************************************************
  // INIT_CFG_WN
  initial begin
    INIT_CFG_WN;
  end

  task INIT_CFG_WN;
    // variables
    // main body
    begin
      // open files
      $fopen();

      // logs
      $display();

      // core
      forever begin
        // wait
        @(init_cfg_wn_event);

        // read file
      end
    end
  endtask

//*** CHKI **********************************************************************
  // CHKI_FFT_DAT
  initial begin
    CHKI_FFT_DAT;
  end

  task CHKI_FFT_DAT;
    // variables
    // main body
    begin
      // open files
      $fopen();

      // logs
      $display();

      // core
      forever begin
        // wait
        @(chki_fft_dat_event);

        // read file
      end
    end
  endtask

//*** CHKO **********************************************************************


//*** WAVEFORM ******************************************************************
  // dump fsdb
  `ifdef DMP_FSDB
    initial begin
      #`DMP_FSDB_TIME ;
      $fsdbDumpfile( `DMP_FSDB_FILE );
      $fsdbDumpvars( `TST_TOP );
      #(10*`DUT_FULL_CLK );
      $display( "\t\t dump (fsdb) to this test is on !" );
    end
  `endif

  // dump shm
  initial begin
    if( `DMP_SHM=="on" ) begin
      #`DMP_SHM_TIME ;
      $shm_open( `DMP_SHM_FILE );
      $shm_probe( `TST_TOP ,`DMP_SHM_LEVEL );
      #(10*`DUT_FULL_CLK );
      $display( "\t\t dump (shm,%s) to this test is on !" ,`DMP_SHM_LEVEL );
    end
  end

  // dump vcd
  `ifdef DMP_VCD
    initial begin
      #`DMP_VCD_TIME ;
      $dumpfile( `DMP_VCD_FILE );
      $dumpvars( 0, `TST_TOP );
      #(10*`DUT_FULL_CLK );
      $display( "\t\t dump (vcd) to this test is on !" );
    end
  `endif

  // dump evcd
  `ifdef DMP_EVCD
    initial begin
      #`DMP_EVCD_TIME ;
      $dumpports( dut ,`DMP_EVCD_FILE );
      #(10*`DUT_FULL_CLK );
      $display( "\t\t dump (evcd) to this test is on !" );
    end
  `endif

endmodule
