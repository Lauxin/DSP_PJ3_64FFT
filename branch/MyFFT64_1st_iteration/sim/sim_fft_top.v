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
`define SIM_TOP -1
`define DUT_TOP -1

//--- LOCAL ----------------------------
`define DUT_FULL_CLK 10  //100M
`define DUT_HALF_CLK (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     AUTO_CHECK          "on"
`define     CHKI_FFT_DATA       "./check_data/fft_data_in.dat"
`define     CHKI_FFT_REORD      "./check_data/fft_data_reord.dat"
`define     CHKI_FFT_ORD        "./check_data/fft_ord.dat"
`define     CHKI_WN             "./check_data/fft_wn_64.dat"
`define     CHKO_FFT            "./check_data/fft_data_out.dat"

`define     DMP_FFT_TMP         "./fft_rtl_tmp.dat"
`define     DMP_FFT_OUT         "./fft_rtl_out.dat"

`define     DMP_SHM_FILE        "./simul_data/waveform.shm"
// `define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
// `define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
// `define     DMP_EVCD_FIL        "./simul_data/waveform.evcd"


module `SIM_TOP;

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
reg     clk;
reg     rst_n;
reg     val_i;
reg     signed [`DATA_WID -1 : 0]    fft_data_re_i, fft_data_im_i;

wire    val_o;
wire    signed [`DATA_WID -1 : 0]    fft_data_re_o, fft_data_im_o;



//*** WIRE/REG *****************************************************************
wire [`FFT_LEN*`DATA_WID -1 : 0]  fft_data_re_tmp_w = dut.fft_core64_u.fft_data_re_r;
wire [`FFT_LEN*`DATA_WID -1 : 0]  fft_data_im_tmp_w = dut.fft_core64_u.fft_data_im_r;

wire [`FFT_LEN*`DATA_WID -1 : 0]  fft_data_re_o_w = dut.fft_core64_u.fft_data_re_o;
wire [`FFT_LEN*`DATA_WID -1 : 0]  fft_data_im_o_w = dut.fft_core64_u.fft_data_im_o;
wire fft_done = dut.done;

reg signed [`DATA_WID -1 : 0] fft_re_tmp_mem [0:`FFT_LEN-1];
reg signed [`DATA_WID -1 : 0] fft_im_tmp_mem [0:`FFT_LEN-1];

reg signed [`DATA_WID -1 : 0] fft_re_o_mem [0:`FFT_LEN-1];
reg signed [`DATA_WID -1 : 0] fft_im_o_mem [0:`FFT_LEN-1];


//*** DUT **********************************************************************
`DUT_TOP dut(
    .clk(clk),
    .rst_n(rst_n),

    .dat_fft_re_i(fft_data_re_i),
    .dat_fft_im_i(fft_data_im_i),
    .val_i(val_i),

    .dat_fft_re_o(fft_data_re_o),
    .dat_fft_im_o(fft_data_im_o),
    .val_o(val_o)
);

//*** MAIN BODY ****************************************************************
genvar i;
generate 
    for (i = 0; i < `FFT_LEN; i = i+1) begin:mid_result
        always @(fft_data_re_tmp_w or fft_data_im_tmp_w) begin
            fft_re_tmp_mem[i] = fft_data_re_tmp_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
            fft_im_tmp_mem[i] = fft_data_im_tmp_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
        end
    end
endgenerate

generate 
    for (i = 0; i < `FFT_LEN; i = i+1) begin:final_result
        always @(fft_data_re_o_w or fft_data_im_o_w) begin
            fft_re_o_mem[i] = fft_data_re_o_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
            fft_im_o_mem[i] = fft_data_im_o_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
        end
    end
endgenerate

//clk
initial begin
    clk = 0;
    forever #(`DUT_HALF_CLK) clk = ~clk;
end

//rst
initial begin
    rst_n = 0;
    #(2*`DUT_FULL_CLK) rst_n = 1;
end

initial begin
    val_i <= 0;
    fft_data_re_i <= 0;
    fft_data_im_i <= 0;
    #(4*`DUT_FULL_CLK)
    read_fft_i;
    @(posedge clk) val_i <= 0;
    dump_fft_tmp;
end

initial begin
    dump_fft_o;
end

initial begin
    #(`DUT_FULL_CLK*200) $finish;
end

//*** SUBTASK *******************************************************************
task read_fft_i;
integer fp_read;
integer f;
reg [`DATA_WID -1 : 0] fft_data_re_tmp;
reg [`DATA_WID -1 : 0] fft_data_im_tmp;
begin
    fp_read = $fopen(`CHKI_FFT_DATA,"r");
    repeat(`FFT_LEN) begin
        @(posedge clk);
        f = $fscanf(fp_read, "%d + %di\n", fft_data_re_tmp, fft_data_im_tmp);
        val_i           <= 1;
        fft_data_re_i   <= fft_data_re_tmp;
        fft_data_im_i   <= fft_data_im_tmp;
    end
end
endtask


task dump_fft_tmp;
integer fp_dump;
integer f;
begin
    fp_dump = $fopen(`DMP_FFT_TMP,"w");
    while (1) begin
        @(posedge clk);
        $fdisplay( fp_dump, "%d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di",
                   fft_re_tmp_mem[ 0], fft_im_tmp_mem[ 0], fft_re_tmp_mem[ 1], fft_im_tmp_mem[ 1], 
                   fft_re_tmp_mem[ 2], fft_im_tmp_mem[ 2], fft_re_tmp_mem[ 3], fft_im_tmp_mem[ 3], 
                   fft_re_tmp_mem[ 4], fft_im_tmp_mem[ 4], fft_re_tmp_mem[ 5], fft_im_tmp_mem[ 5], 
                   fft_re_tmp_mem[ 6], fft_im_tmp_mem[ 6], fft_re_tmp_mem[ 7], fft_im_tmp_mem[ 7],
                   fft_re_tmp_mem[ 8], fft_im_tmp_mem[ 8], fft_re_tmp_mem[ 9], fft_im_tmp_mem[ 9], 
                   fft_re_tmp_mem[10], fft_im_tmp_mem[10], fft_re_tmp_mem[11], fft_im_tmp_mem[11], 
                   fft_re_tmp_mem[12], fft_im_tmp_mem[12], fft_re_tmp_mem[13], fft_im_tmp_mem[13], 
                   fft_re_tmp_mem[14], fft_im_tmp_mem[14], fft_re_tmp_mem[15], fft_im_tmp_mem[15],
                   fft_re_tmp_mem[16], fft_im_tmp_mem[16], fft_re_tmp_mem[17], fft_im_tmp_mem[17], 
                   fft_re_tmp_mem[18], fft_im_tmp_mem[18], fft_re_tmp_mem[19], fft_im_tmp_mem[19], 
                   fft_re_tmp_mem[20], fft_im_tmp_mem[20], fft_re_tmp_mem[21], fft_im_tmp_mem[21], 
                   fft_re_tmp_mem[22], fft_im_tmp_mem[22], fft_re_tmp_mem[23], fft_im_tmp_mem[23],
                   fft_re_tmp_mem[24], fft_im_tmp_mem[24], fft_re_tmp_mem[25], fft_im_tmp_mem[25], 
                   fft_re_tmp_mem[26], fft_im_tmp_mem[26], fft_re_tmp_mem[27], fft_im_tmp_mem[27], 
                   fft_re_tmp_mem[28], fft_im_tmp_mem[28], fft_re_tmp_mem[29], fft_im_tmp_mem[29], 
                   fft_re_tmp_mem[30], fft_im_tmp_mem[30], fft_re_tmp_mem[31], fft_im_tmp_mem[31], 
                   fft_re_tmp_mem[32], fft_im_tmp_mem[32], fft_re_tmp_mem[33], fft_im_tmp_mem[33], 
                   fft_re_tmp_mem[34], fft_im_tmp_mem[34], fft_re_tmp_mem[35], fft_im_tmp_mem[35], 
                   fft_re_tmp_mem[36], fft_im_tmp_mem[36], fft_re_tmp_mem[37], fft_im_tmp_mem[37], 
                   fft_re_tmp_mem[38], fft_im_tmp_mem[38], fft_re_tmp_mem[39], fft_im_tmp_mem[39],
                   fft_re_tmp_mem[40], fft_im_tmp_mem[40], fft_re_tmp_mem[41], fft_im_tmp_mem[41], 
                   fft_re_tmp_mem[42], fft_im_tmp_mem[42], fft_re_tmp_mem[43], fft_im_tmp_mem[43], 
                   fft_re_tmp_mem[44], fft_im_tmp_mem[44], fft_re_tmp_mem[45], fft_im_tmp_mem[45], 
                   fft_re_tmp_mem[46], fft_im_tmp_mem[46], fft_re_tmp_mem[47], fft_im_tmp_mem[47],
                   fft_re_tmp_mem[48], fft_im_tmp_mem[48], fft_re_tmp_mem[49], fft_im_tmp_mem[49], 
                   fft_re_tmp_mem[50], fft_im_tmp_mem[50], fft_re_tmp_mem[51], fft_im_tmp_mem[51], 
                   fft_re_tmp_mem[52], fft_im_tmp_mem[52], fft_re_tmp_mem[53], fft_im_tmp_mem[53], 
                   fft_re_tmp_mem[54], fft_im_tmp_mem[54], fft_re_tmp_mem[55], fft_im_tmp_mem[55],
                   fft_re_tmp_mem[56], fft_im_tmp_mem[56], fft_re_tmp_mem[57], fft_im_tmp_mem[57], 
                   fft_re_tmp_mem[58], fft_im_tmp_mem[58], fft_re_tmp_mem[59], fft_im_tmp_mem[59], 
                   fft_re_tmp_mem[60], fft_im_tmp_mem[60], fft_re_tmp_mem[61], fft_im_tmp_mem[61], 
                   fft_re_tmp_mem[62], fft_im_tmp_mem[62], fft_re_tmp_mem[63], fft_im_tmp_mem[63] );
    end
end
endtask


task dump_fft_o;
integer fp_dump;
integer f;
begin
    fp_dump = $fopen(`DMP_FFT_OUT,"w");
    while (1) begin
        @(posedge clk)
        if(fft_done)begin
            $fdisplay( fp_dump, "%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di\n%d+%di",
                       fft_re_o_mem[ 0], fft_im_o_mem[ 0], fft_re_o_mem[ 1], fft_im_o_mem[ 1], 
                       fft_re_o_mem[ 2], fft_im_o_mem[ 2], fft_re_o_mem[ 3], fft_im_o_mem[ 3], 
                       fft_re_o_mem[ 4], fft_im_o_mem[ 4], fft_re_o_mem[ 5], fft_im_o_mem[ 5], 
                       fft_re_o_mem[ 6], fft_im_o_mem[ 6], fft_re_o_mem[ 7], fft_im_o_mem[ 7],
                       fft_re_o_mem[ 8], fft_im_o_mem[ 8], fft_re_o_mem[ 9], fft_im_o_mem[ 9], 
                       fft_re_o_mem[10], fft_im_o_mem[10], fft_re_o_mem[11], fft_im_o_mem[11], 
                       fft_re_o_mem[12], fft_im_o_mem[12], fft_re_o_mem[13], fft_im_o_mem[13], 
                       fft_re_o_mem[14], fft_im_o_mem[14], fft_re_o_mem[15], fft_im_o_mem[15],
                       fft_re_o_mem[16], fft_im_o_mem[16], fft_re_o_mem[17], fft_im_o_mem[17], 
                       fft_re_o_mem[18], fft_im_o_mem[18], fft_re_o_mem[19], fft_im_o_mem[19], 
                       fft_re_o_mem[20], fft_im_o_mem[20], fft_re_o_mem[21], fft_im_o_mem[21],
                       fft_re_o_mem[22], fft_im_o_mem[22], fft_re_o_mem[23], fft_im_o_mem[23], 
                       fft_re_o_mem[24], fft_im_o_mem[24], fft_re_o_mem[25], fft_im_o_mem[25], 
                       fft_re_o_mem[26], fft_im_o_mem[26], fft_re_o_mem[27], fft_im_o_mem[27],
                       fft_re_o_mem[28], fft_im_o_mem[28], fft_re_o_mem[29], fft_im_o_mem[29], 
                       fft_re_o_mem[30], fft_im_o_mem[30], fft_re_o_mem[31], fft_im_o_mem[31],
                       fft_re_o_mem[32], fft_im_o_mem[32], fft_re_o_mem[33], fft_im_o_mem[33], 
                       fft_re_o_mem[34], fft_im_o_mem[34], fft_re_o_mem[35], fft_im_o_mem[35], 
                       fft_re_o_mem[36], fft_im_o_mem[36], fft_re_o_mem[37], fft_im_o_mem[37], 
                       fft_re_o_mem[38], fft_im_o_mem[38], fft_re_o_mem[39], fft_im_o_mem[39],
                       fft_re_o_mem[40], fft_im_o_mem[40], fft_re_o_mem[41], fft_im_o_mem[41], 
                       fft_re_o_mem[42], fft_im_o_mem[42], fft_re_o_mem[43], fft_im_o_mem[43], 
                       fft_re_o_mem[44], fft_im_o_mem[44], fft_re_o_mem[45], fft_im_o_mem[45], 
                       fft_re_o_mem[46], fft_im_o_mem[46], fft_re_o_mem[47], fft_im_o_mem[47],
                       fft_re_o_mem[48], fft_im_o_mem[48], fft_re_o_mem[49], fft_im_o_mem[49], 
                       fft_re_o_mem[50], fft_im_o_mem[50], fft_re_o_mem[51], fft_im_o_mem[51], 
                       fft_re_o_mem[52], fft_im_o_mem[52], fft_re_o_mem[53], fft_im_o_mem[53],
                       fft_re_o_mem[54], fft_im_o_mem[54], fft_re_o_mem[55], fft_im_o_mem[55], 
                       fft_re_o_mem[56], fft_im_o_mem[56], fft_re_o_mem[57], fft_im_o_mem[57], 
                       fft_re_o_mem[58], fft_im_o_mem[58], fft_re_o_mem[59], fft_im_o_mem[59],
                       fft_re_o_mem[60], fft_im_o_mem[60], fft_re_o_mem[61], fft_im_o_mem[61], 
                       fft_re_o_mem[62], fft_im_o_mem[62], fft_re_o_mem[63], fft_im_o_mem[63] 
            );
        end
    end
end
endtask

//*** AUTO CHECK ****************************************************************


//*** WAVEFORM ******************************************************************
// dump fsdb
`ifdef DMP_FSDB
    initial begin
        #`DMP_FSDB_BGN ;
        $fsdbDumpfile( `DMP_FSDB_FILE );
        $fsdbDumpvars( `SIM_TOP );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (fsdb) to this test is on !" );
    end
`endif

// dump shm
initial begin
    if( `DMP_SHM=="on" ) begin
        #`DMP_SHM_BGN ;
        $shm_open( `DMP_SHM_FILE );
        $shm_probe( `SIM_TOP ,`DMP_SHM_LVL );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (shm,%s) to this test is on !" ,`DMP_SHM_LVL );
    end
end

// dump vcd
`ifdef DMP_VCD
    initial begin
        #`DMP_VCD_BGN ;
        $dumpfile( `DMP_VCD_FILE );
        $dumpvars( 0, `SIM_TOP );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (vcd) to this test is on !" );
    end
`endif

// dump evcd
`ifdef DMP_EVCD
    initial begin
        #`DMP_EVCD_BGN ;
        $dumpports( dut ,`DMP_EVCD_FILE );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (evcd) to this test is on !" );
    end
`endif

endmodule
