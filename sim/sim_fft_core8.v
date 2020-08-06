//------------------------------------------------------------------------------
    //
    //  Filename       : tb_fft_top.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : 
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

//--- GLOBAL ---------------------------
`define TST_TOP 
`define DUT_TOP 

//--- LOCAL ----------------------------
`define DUT_FULL_CLK 10  //100M
`define DUT_HALF_CLK (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     AUTO_CHECK      "on"
`define     CHKI_FFT        "./tv/fft_data_in.dat"
`define     CHKI_FFT_REORD  "./tv/fft_data_reord.dat"
`define     CHKI_WN         "./tv/fft_wn_64.dat"
`define     CHKO_FFT        "./tv/fft_data_out.dat"

`define     DMP_SHM_FILE        "./simul_data/waveform.shm"
`define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
`define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
`define     DMP_EVCD_FIL        "./simul_data/waveform.evcd"


module `TST_TOP;

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
wire  [8 * `DATA_WID  -1 : 0]  fft_data_re_i, fft_data_im_i;
wire  [4 * `WN_WID    -1 : 0]  fft_wn_re_i, fft_wn_im_i;

wire [8 * `DATA_WID  -1 : 0]  fft_data_re_o, fft_data_im_o;


//*** WIRE/REG *****************************************************************
reg signed [`DATA_WID -1 : 0] fft_data_re_r [0:`FFT_LEN-1];
reg signed [`DATA_WID -1 : 0] fft_data_im_r [0:`FFT_LEN-1];

reg signed [`WN_WID -1 : 0] fft_wn_re_r [0:`WN_LEN-1];
reg signed [`WN_WID -1 : 0] fft_wn_im_r [0:`WN_LEN-1];


//*** DUT **********************************************************************
`DUT_TOP dut(
    .fft_data_re_i(fft_data_re_i),
    .fft_data_im_i(fft_data_im_i),
    .fft_wn_re_i(fft_wn_re_i),
    .fft_wn_im_i(fft_wn_im_i),
    
    .fft_data_re_o(fft_data_re_o),
    .fft_data_im_o(fft_data_im_o)
);

//*** MAIN BODY ****************************************************************
assign fft_data_re_i = {fft_data_re_r[7], fft_data_re_r[6],
                        fft_data_re_r[5], fft_data_re_r[4],
                        fft_data_re_r[3], fft_data_re_r[2],
                        fft_data_re_r[1], fft_data_re_r[0]  };

assign fft_data_im_i = {fft_data_im_r[7], fft_data_im_r[6],
                        fft_data_im_r[5], fft_data_im_r[4],
                        fft_data_im_r[3], fft_data_im_r[2],
                        fft_data_im_r[1], fft_data_im_r[0]  };
                        
assign fft_wn_re_i = {  fft_wn_re_r[3], fft_wn_re_r[2], 
                        fft_wn_re_r[1], fft_wn_re_r[0]  }; 

assign fft_wn_im_i = {  fft_wn_im_r[3], fft_wn_im_r[2], 
                        fft_wn_im_r[1], fft_wn_im_r[0]  };


initial begin
    read_fft_i;
    read_wn;
end

initial begin
    #(`DUT_FULL_CLK*10) $finish;
end

//*** SUBTASK *******************************************************************
task read_fft_i;
integer fp_fft_i;
integer f;
integer i;

begin
    fp_fft_i = $fopen(`CHKI_FFT_REORD,"r");
    for (i = 0; i<`FFT_LEN; i = i+1) begin
        f = $fscanf(fp_fft_i, "%d + %di\n", fft_data_re_r[i], fft_data_im_r[i]);
        // fft_data_re_i[(i+1)*`DATA_WID -1 : i*`DATA_WID] = fft_data_re_r; 
        // fft_data_im_i[(i+1)*`DATA_WID -1 : i*`DATA_WID] = fft_data_im_r;
    end
end
endtask


task read_wn;
integer fp_wn;
integer f;
integer i;

begin
    fp_wn = $fopen(`CHKI_WN,"r");
    for (i = 0; i < `WN_LEN; i = i+1) begin
        f = $fscanf(fp_wn, "%d + %di\n", fft_wn_re_r[i],fft_wn_im_r[i]);
        // fft_wn_re_i[(i+1)*`DATA_WID -1 : i*`DATA_WID] = fft_wn_re_r;
        // fft_wn_im_i[(i+1)*`DATA_WID -1 : i*`DATA_WID] = fft_wn_im_r;
    end
end
endtask
//*** AUTO CHECK ****************************************************************


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
