//------------------------------------------------------------------------------
  //
  //  Filename       : fft_ctrl_fifo.v
  //  Author         : LiuXun
  //  Created        : 2022-05-27
  //  Description    : 
  //
//------------------------------------------------------------------------------

module fft_ctrl_fifo(
  clk,
  rst_n,
  wr_vld_i,
  wr_dat_i,
  wr_ful_o,
  rd_vld_i,
  rd_vld_o,
  rd_dat_o,
  rd_ept_o
);

//*** PARAMETER ****************************************************************
parameter  DATA_WD = 10;
parameter  SIZE = 3;

localparam SIZE_WD = 2;


//*** INPUT/OUTPUT *************************************************************
  input                         clk  ;
  input                         rst_n;

  input                         wr_vld_i;
  input       [DATA_WD  -1 : 0] wr_dat_i;
  output                        wr_ful_o;
  input                         rd_vld_i;
  output reg                    rd_vld_o;
  output reg  [DATA_WD  -1 : 0] rd_dat_o;
  output                        rd_ept_o;


//*** WIRE/REG *****************************************************************
  reg        [SIZE_WD  -1 : 0] wr_addr;
  reg        [SIZE_WD  -1 : 0] rd_addr;
  reg        [DATA_WD  -1 : 0] fifo_ram[0:SIZE-1];
  reg        [SIZE_WD  -1 : 0] ram_usd;

  integer   i;


//*** MAIN BODY ****************************************************************
//--- WRITE ----------------------------
  // wr_ful_o
  assign wr_ful_o = ram_usd == SIZE ;

  // wr_addr
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_addr <= 'd0 ;
    end
    else if (wr_vld_i) begin
      if (wr_addr == SIZE - 'd1) begin
        wr_addr <= 'd0 ;
      end
      else begin
        wr_addr <= wr_addr + 'd1 ;
      end
    end
  end


//--- READ -----------------------------
  // rd_ept_o
  assign rd_ept_o = ram_usd == 'd0 ;

  // rd_addr
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_addr <= 'd0;
    end
    else if (rd_vld_i) begin
      if (rd_addr == SIZE - 'd1) begin
        rd_addr <= 'd0 ;
      end
      else begin
        rd_addr <= rd_addr + 'd1 ;
      end
    end
  end


//--- COMMON ---------------------------
  // ram_usd
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ram_usd <= 'd0 ;
    end
    else if (wr_vld_i && rd_vld_i) begin
      ram_usd <= ram_usd ;
    end
    else if (wr_vld_i) begin
      if (ram_usd == SIZE) begin    // full error
        ram_usd <= ram_usd ;
      end
      else begin
        ram_usd <= ram_usd + 'd1 ;
      end
    end
    else if (rd_vld_i) begin
      if (ram_usd == 'd0) begin    // empty error
        ram_usd <= ram_usd ;
      end
      else begin
        ram_usd <= ram_usd - 'd1 ;
      end
    end
  end


//--- REG ARRAY ------------------------
  // wr_dat
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n)
      for (i=0; i<SIZE; i=i+1) begin
        fifo_ram[i] <= 'h0;
      end
    else if(wr_vld_i && (!wr_ful_o))
        fifo_ram[wr_addr] <= wr_dat_i;
  end


  // rd_dat
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_vld_o <= 'd0;
      rd_dat_o <= 'd0;
    end
    else if (rd_vld_i && (!rd_ept_o)) begin
      rd_vld_o <= rd_vld_i;
      rd_dat_o <= fifo_ram[rd_addr];
    end
  end


//*** DEBUG ********************************************************************
`ifdef DEBUG
  // write full check
  initial begin
    @(posedge rst_n);
    forever begin
      @(posedge clk);
      if (wr_vld_i && wr_ful_o) begin
        $display( "\n\t FIFO ERROR: at %08d ns, write full happens!\n" ,$time);
        #1000 ;
        $finish ;
      end
    end
  end

  // read empty check
  initial begin
    @(posedge rst_n);
    forever begin
      @(posedge clk);
      if (rd_vld_i && rd_ept_o) begin
        $display( "\n\t FIFO ERROR: at %08d ns, read empty happens!\n" ,$time);
        #1000 ;
        $finish ;
      end
    end
  end
`endif

endmodule