`default_nettype none
`timescale 1 ns / 1 ps

module systolic_fpga #(
  parameter integer C_S_AXI_CONTROL_ADDR_WIDTH    = 12 ,
  parameter integer C_S_AXI_CONTROL_DATA_WIDTH    = 32 ,
  parameter integer C_M00_IMEM_AXI_ADDR_WIDTH     = 64 ,
  parameter integer C_M00_IMEM_AXI_DATA_WIDTH     = 512,
  parameter integer C_M01_PARAMBUF_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M01_PARAMBUF_AXI_DATA_WIDTH = 512,
  parameter integer C_M02_IBUF_AXI_ADDR_WIDTH     = 64 ,
  parameter integer C_M02_IBUF_AXI_DATA_WIDTH     = 512,
  parameter integer C_M03_OBUF_AXI_ADDR_WIDTH     = 64 ,
  parameter integer C_M03_OBUF_AXI_DATA_WIDTH     = 512
)
(

  input  wire                                       ap_clk                  ,
  input  wire                                       ap_rst_n                ,
  // AXI4 master interface m00_imem_axi
  output wire                                       m00_imem_axi_awvalid    ,
  input  wire                                       m00_imem_axi_awready    ,
  output wire [C_M00_IMEM_AXI_ADDR_WIDTH-1:0]       m00_imem_axi_awaddr     ,
  output wire [8-1:0]                               m00_imem_axi_awlen      ,
  output wire                                       m00_imem_axi_wvalid     ,
  input  wire                                       m00_imem_axi_wready     ,
  output wire [C_M00_IMEM_AXI_DATA_WIDTH-1:0]       m00_imem_axi_wdata      ,
  output wire [C_M00_IMEM_AXI_DATA_WIDTH/8-1:0]     m00_imem_axi_wstrb      ,
  output wire                                       m00_imem_axi_wlast      ,
  input  wire                                       m00_imem_axi_bvalid     ,
  output wire                                       m00_imem_axi_bready     ,
  output wire                                       m00_imem_axi_arvalid    ,
  input  wire                                       m00_imem_axi_arready    ,
  output wire [C_M00_IMEM_AXI_ADDR_WIDTH-1:0]       m00_imem_axi_araddr     ,
  output wire [8-1:0]                               m00_imem_axi_arlen      ,
  input  wire                                       m00_imem_axi_rvalid     ,
  output wire                                       m00_imem_axi_rready     ,
  input  wire [C_M00_IMEM_AXI_DATA_WIDTH-1:0]       m00_imem_axi_rdata      ,
  input  wire                                       m00_imem_axi_rlast      ,
  // AXI4 master interface m01_parambuf_axi
  output wire                                       m01_parambuf_axi_awvalid,
  input  wire                                       m01_parambuf_axi_awready,
  output wire [C_M01_PARAMBUF_AXI_ADDR_WIDTH-1:0]   m01_parambuf_axi_awaddr ,
  output wire [8-1:0]                               m01_parambuf_axi_awlen  ,
  output wire                                       m01_parambuf_axi_wvalid ,
  input  wire                                       m01_parambuf_axi_wready ,
  output wire [C_M01_PARAMBUF_AXI_DATA_WIDTH-1:0]   m01_parambuf_axi_wdata  ,
  output wire [C_M01_PARAMBUF_AXI_DATA_WIDTH/8-1:0] m01_parambuf_axi_wstrb  ,
  output wire                                       m01_parambuf_axi_wlast  ,
  input  wire                                       m01_parambuf_axi_bvalid ,
  output wire                                       m01_parambuf_axi_bready ,
  output wire                                       m01_parambuf_axi_arvalid,
  input  wire                                       m01_parambuf_axi_arready,
  output wire [C_M01_PARAMBUF_AXI_ADDR_WIDTH-1:0]   m01_parambuf_axi_araddr ,
  output wire [8-1:0]                               m01_parambuf_axi_arlen  ,
  input  wire                                       m01_parambuf_axi_rvalid ,
  output wire                                       m01_parambuf_axi_rready ,
  input  wire [C_M01_PARAMBUF_AXI_DATA_WIDTH-1:0]   m01_parambuf_axi_rdata  ,
  input  wire                                       m01_parambuf_axi_rlast  ,
  // AXI4 master interface m02_ibuf_axi
  output wire                                       m02_ibuf_axi_awvalid    ,
  input  wire                                       m02_ibuf_axi_awready    ,
  output wire [C_M02_IBUF_AXI_ADDR_WIDTH-1:0]       m02_ibuf_axi_awaddr     ,
  output wire [8-1:0]                               m02_ibuf_axi_awlen      ,
  output wire                                       m02_ibuf_axi_wvalid     ,
  input  wire                                       m02_ibuf_axi_wready     ,
  output wire [C_M02_IBUF_AXI_DATA_WIDTH-1:0]       m02_ibuf_axi_wdata      ,
  output wire [C_M02_IBUF_AXI_DATA_WIDTH/8-1:0]     m02_ibuf_axi_wstrb      ,
  output wire                                       m02_ibuf_axi_wlast      ,
  input  wire                                       m02_ibuf_axi_bvalid     ,
  output wire                                       m02_ibuf_axi_bready     ,
  output wire                                       m02_ibuf_axi_arvalid    ,
  input  wire                                       m02_ibuf_axi_arready    ,
  output wire [C_M02_IBUF_AXI_ADDR_WIDTH-1:0]       m02_ibuf_axi_araddr     ,
  output wire [8-1:0]                               m02_ibuf_axi_arlen      ,
  input  wire                                       m02_ibuf_axi_rvalid     ,
  output wire                                       m02_ibuf_axi_rready     ,
  input  wire [C_M02_IBUF_AXI_DATA_WIDTH-1:0]       m02_ibuf_axi_rdata      ,
  input  wire                                       m02_ibuf_axi_rlast      ,
  // AXI4 master interface m03_obuf_axi
  output wire                                       m03_obuf_axi_awvalid    ,
  input  wire                                       m03_obuf_axi_awready    ,
  output wire [C_M03_OBUF_AXI_ADDR_WIDTH-1:0]       m03_obuf_axi_awaddr     ,
  output wire [8-1:0]                               m03_obuf_axi_awlen      ,
  output wire                                       m03_obuf_axi_wvalid     ,
  input  wire                                       m03_obuf_axi_wready     ,
  output wire [C_M03_OBUF_AXI_DATA_WIDTH-1:0]       m03_obuf_axi_wdata      ,
  output wire [C_M03_OBUF_AXI_DATA_WIDTH/8-1:0]     m03_obuf_axi_wstrb      ,
  output wire                                       m03_obuf_axi_wlast      ,
  input  wire                                       m03_obuf_axi_bvalid     ,
  output wire                                       m03_obuf_axi_bready     ,
  output wire                                       m03_obuf_axi_arvalid    ,
  input  wire                                       m03_obuf_axi_arready    ,
  output wire [C_M03_OBUF_AXI_ADDR_WIDTH-1:0]       m03_obuf_axi_araddr     ,
  output wire [8-1:0]                               m03_obuf_axi_arlen      ,
  input  wire                                       m03_obuf_axi_rvalid     ,
  output wire                                       m03_obuf_axi_rready     ,
  input  wire [C_M03_OBUF_AXI_DATA_WIDTH-1:0]       m03_obuf_axi_rdata      ,
  input  wire                                       m03_obuf_axi_rlast      ,
  // AXI4 master interface m04_simd_axi
  output wire                                       m04_simd_axi_awvalid    ,
  input  wire                                       m04_simd_axi_awready    ,
  output wire [C_M03_OBUF_AXI_ADDR_WIDTH-1:0]       m04_simd_axi_awaddr     ,
  output wire [8-1:0]                               m04_simd_axi_awlen      ,
  output wire                                       m04_simd_axi_wvalid     ,
  input  wire                                       m04_simd_axi_wready     ,
  output wire [C_M03_OBUF_AXI_DATA_WIDTH-1:0]       m04_simd_axi_wdata      ,
  output wire [C_M03_OBUF_AXI_DATA_WIDTH/8-1:0]     m04_simd_axi_wstrb      ,
  output wire                                       m04_simd_axi_wlast      ,
  input  wire                                       m04_simd_axi_bvalid     ,
  output wire                                       m04_simd_axi_bready     ,
  output wire                                       m04_simd_axi_arvalid    ,
  input  wire                                       m04_simd_axi_arready    ,
  output wire [C_M03_OBUF_AXI_ADDR_WIDTH-1:0]       m04_simd_axi_araddr     ,
  output wire [8-1:0]                               m04_simd_axi_arlen      ,
  input  wire                                       m04_simd_axi_rvalid     ,
  output wire                                       m04_simd_axi_rready     ,
  input  wire [C_M03_OBUF_AXI_DATA_WIDTH-1:0]       m04_simd_axi_rdata      ,
  input  wire                                       m04_simd_axi_rlast      ,
  // AXI4-Lite slave interface
  input  wire                                       s_axi_control_awvalid   ,
  output wire                                       s_axi_control_awready   ,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]      s_axi_control_awaddr    ,
  input  wire                                       s_axi_control_wvalid    ,
  output wire                                       s_axi_control_wready    ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]      s_axi_control_wdata     ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0]    s_axi_control_wstrb     ,
  input  wire                                       s_axi_control_arvalid   ,
  output wire                                       s_axi_control_arready   ,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]      s_axi_control_araddr    ,
  output wire                                       s_axi_control_rvalid    ,
  input  wire                                       s_axi_control_rready    ,
  output wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]      s_axi_control_rdata     ,
  output wire [2-1:0]                               s_axi_control_rresp     ,
  output wire                                       s_axi_control_bvalid    ,
  input  wire                                       s_axi_control_bready    ,
  output wire [2-1:0]                               s_axi_control_bresp     ,
  output wire                                       interrupt               
);



// genesys systolic accelerator
genesys_systolic_wrapper #(
  .C_S_AXI_CONTROL_ADDR_WIDTH    ( C_S_AXI_CONTROL_ADDR_WIDTH    ),
  .C_S_AXI_CONTROL_DATA_WIDTH    ( C_S_AXI_CONTROL_DATA_WIDTH    ),
  .C_M00_IMEM_AXI_ADDR_WIDTH     ( C_M00_IMEM_AXI_ADDR_WIDTH     ),
  .C_M00_IMEM_AXI_DATA_WIDTH     ( C_M00_IMEM_AXI_DATA_WIDTH     ),
  .C_M01_PARAMBUF_AXI_ADDR_WIDTH ( C_M01_PARAMBUF_AXI_ADDR_WIDTH ),
  .C_M01_PARAMBUF_AXI_DATA_WIDTH ( C_M01_PARAMBUF_AXI_DATA_WIDTH ),
  .C_M02_IBUF_AXI_ADDR_WIDTH     ( C_M02_IBUF_AXI_ADDR_WIDTH     ),
  .C_M02_IBUF_AXI_DATA_WIDTH     ( C_M02_IBUF_AXI_DATA_WIDTH     ),
  .C_M03_OBUF_AXI_ADDR_WIDTH     ( C_M03_OBUF_AXI_ADDR_WIDTH     ),
  .C_M03_OBUF_AXI_DATA_WIDTH     ( C_M03_OBUF_AXI_DATA_WIDTH     )
)
inst_genesys_systolic_wrapper (
  .ap_clk                   ( ap_clk                   ),
  .ap_rst_n                 ( ap_rst_n                 ),
  .m00_imem_axi_awvalid     ( m00_imem_axi_awvalid     ),
  .m00_imem_axi_awready     ( m00_imem_axi_awready     ),
  .m00_imem_axi_awaddr      ( m00_imem_axi_awaddr      ),
  .m00_imem_axi_awlen       ( m00_imem_axi_awlen       ),
  .m00_imem_axi_wvalid      ( m00_imem_axi_wvalid      ),
  .m00_imem_axi_wready      ( m00_imem_axi_wready      ),
  .m00_imem_axi_wdata       ( m00_imem_axi_wdata       ),
  .m00_imem_axi_wstrb       ( m00_imem_axi_wstrb       ),
  .m00_imem_axi_wlast       ( m00_imem_axi_wlast       ),
  .m00_imem_axi_bvalid      ( m00_imem_axi_bvalid      ),
  .m00_imem_axi_bready      ( m00_imem_axi_bready      ),
  .m00_imem_axi_arvalid     ( m00_imem_axi_arvalid     ),
  .m00_imem_axi_arready     ( m00_imem_axi_arready     ),
  .m00_imem_axi_araddr      ( m00_imem_axi_araddr      ),
  .m00_imem_axi_arlen       ( m00_imem_axi_arlen       ),
  .m00_imem_axi_rvalid      ( m00_imem_axi_rvalid      ),
  .m00_imem_axi_rready      ( m00_imem_axi_rready      ),
  .m00_imem_axi_rdata       ( m00_imem_axi_rdata       ),
  .m00_imem_axi_rlast       ( m00_imem_axi_rlast       ),
  .m01_parambuf_axi_awvalid ( m01_parambuf_axi_awvalid ),
  .m01_parambuf_axi_awready ( m01_parambuf_axi_awready ),
  .m01_parambuf_axi_awaddr  ( m01_parambuf_axi_awaddr  ),
  .m01_parambuf_axi_awlen   ( m01_parambuf_axi_awlen   ),
  .m01_parambuf_axi_wvalid  ( m01_parambuf_axi_wvalid  ),
  .m01_parambuf_axi_wready  ( m01_parambuf_axi_wready  ),
  .m01_parambuf_axi_wdata   ( m01_parambuf_axi_wdata   ),
  .m01_parambuf_axi_wstrb   ( m01_parambuf_axi_wstrb   ),
  .m01_parambuf_axi_wlast   ( m01_parambuf_axi_wlast   ),
  .m01_parambuf_axi_bvalid  ( m01_parambuf_axi_bvalid  ),
  .m01_parambuf_axi_bready  ( m01_parambuf_axi_bready  ),
  .m01_parambuf_axi_arvalid ( m01_parambuf_axi_arvalid ),
  .m01_parambuf_axi_arready ( m01_parambuf_axi_arready ),
  .m01_parambuf_axi_araddr  ( m01_parambuf_axi_araddr  ),
  .m01_parambuf_axi_arlen   ( m01_parambuf_axi_arlen   ),
  .m01_parambuf_axi_rvalid  ( m01_parambuf_axi_rvalid  ),
  .m01_parambuf_axi_rready  ( m01_parambuf_axi_rready  ),
  .m01_parambuf_axi_rdata   ( m01_parambuf_axi_rdata   ),
  .m01_parambuf_axi_rlast   ( m01_parambuf_axi_rlast   ),
  .m02_ibuf_axi_awvalid     ( m02_ibuf_axi_awvalid     ),
  .m02_ibuf_axi_awready     ( m02_ibuf_axi_awready     ),
  .m02_ibuf_axi_awaddr      ( m02_ibuf_axi_awaddr      ),
  .m02_ibuf_axi_awlen       ( m02_ibuf_axi_awlen       ),
  .m02_ibuf_axi_wvalid      ( m02_ibuf_axi_wvalid      ),
  .m02_ibuf_axi_wready      ( m02_ibuf_axi_wready      ),
  .m02_ibuf_axi_wdata       ( m02_ibuf_axi_wdata       ),
  .m02_ibuf_axi_wstrb       ( m02_ibuf_axi_wstrb       ),
  .m02_ibuf_axi_wlast       ( m02_ibuf_axi_wlast       ),
  .m02_ibuf_axi_bvalid      ( m02_ibuf_axi_bvalid      ),
  .m02_ibuf_axi_bready      ( m02_ibuf_axi_bready      ),
  .m02_ibuf_axi_arvalid     ( m02_ibuf_axi_arvalid     ),
  .m02_ibuf_axi_arready     ( m02_ibuf_axi_arready     ),
  .m02_ibuf_axi_araddr      ( m02_ibuf_axi_araddr      ),
  .m02_ibuf_axi_arlen       ( m02_ibuf_axi_arlen       ),
  .m02_ibuf_axi_rvalid      ( m02_ibuf_axi_rvalid      ),
  .m02_ibuf_axi_rready      ( m02_ibuf_axi_rready      ),
  .m02_ibuf_axi_rdata       ( m02_ibuf_axi_rdata       ),
  .m02_ibuf_axi_rlast       ( m02_ibuf_axi_rlast       ),
  .m03_obuf_axi_awvalid     ( m03_obuf_axi_awvalid     ),
  .m03_obuf_axi_awready     ( m03_obuf_axi_awready     ),
  .m03_obuf_axi_awaddr      ( m03_obuf_axi_awaddr      ),
  .m03_obuf_axi_awlen       ( m03_obuf_axi_awlen       ),
  .m03_obuf_axi_wvalid      ( m03_obuf_axi_wvalid      ),
  .m03_obuf_axi_wready      ( m03_obuf_axi_wready      ),
  .m03_obuf_axi_wdata       ( m03_obuf_axi_wdata       ),
  .m03_obuf_axi_wstrb       ( m03_obuf_axi_wstrb       ),
  .m03_obuf_axi_wlast       ( m03_obuf_axi_wlast       ),
  .m03_obuf_axi_bvalid      ( m03_obuf_axi_bvalid      ),
  .m03_obuf_axi_bready      ( m03_obuf_axi_bready      ),
  .m03_obuf_axi_arvalid     ( m03_obuf_axi_arvalid     ),
  .m03_obuf_axi_arready     ( m03_obuf_axi_arready     ),
  .m03_obuf_axi_araddr      ( m03_obuf_axi_araddr      ),
  .m03_obuf_axi_arlen       ( m03_obuf_axi_arlen       ),
  .m03_obuf_axi_rvalid      ( m03_obuf_axi_rvalid      ),
  .m03_obuf_axi_rready      ( m03_obuf_axi_rready      ),
  .m03_obuf_axi_rdata       ( m03_obuf_axi_rdata       ),
  .m03_obuf_axi_rlast       ( m03_obuf_axi_rlast       ),
  .m04_simd_axi_awvalid     ( m04_simd_axi_awvalid     ),
  .m04_simd_axi_awready     ( m04_simd_axi_awready     ),
  .m04_simd_axi_awaddr      ( m04_simd_axi_awaddr      ),
  .m04_simd_axi_awlen       ( m04_simd_axi_awlen       ),
  .m04_simd_axi_wvalid      ( m04_simd_axi_wvalid      ),
  .m04_simd_axi_wready      ( m04_simd_axi_wready      ),
  .m04_simd_axi_wdata       ( m04_simd_axi_wdata       ),
  .m04_simd_axi_wstrb       ( m04_simd_axi_wstrb       ),
  .m04_simd_axi_wlast       ( m04_simd_axi_wlast       ),
  .m04_simd_axi_bvalid      ( m04_simd_axi_bvalid      ),
  .m04_simd_axi_bready      ( m04_simd_axi_bready      ),
  .m04_simd_axi_arvalid     ( m04_simd_axi_arvalid     ),
  .m04_simd_axi_arready     ( m04_simd_axi_arready     ),
  .m04_simd_axi_araddr      ( m04_simd_axi_araddr      ),
  .m04_simd_axi_arlen       ( m04_simd_axi_arlen       ),
  .m04_simd_axi_rvalid      ( m04_simd_axi_rvalid      ),
  .m04_simd_axi_rready      ( m04_simd_axi_rready      ),
  .m04_simd_axi_rdata       ( m04_simd_axi_rdata       ),
  .m04_simd_axi_rlast       ( m04_simd_axi_rlast       ),
  .s_axi_control_awvalid    ( s_axi_control_awvalid    ),
  .s_axi_control_awready    ( s_axi_control_awready    ),
  .s_axi_control_awaddr     ( s_axi_control_awaddr     ),
  .s_axi_control_wvalid     ( s_axi_control_wvalid     ),
  .s_axi_control_wready     ( s_axi_control_wready     ),
  .s_axi_control_wdata      ( s_axi_control_wdata      ),
  .s_axi_control_wstrb      ( s_axi_control_wstrb      ),
  .s_axi_control_arvalid    ( s_axi_control_arvalid    ),
  .s_axi_control_arready    ( s_axi_control_arready    ),
  .s_axi_control_araddr     ( s_axi_control_araddr     ),
  .s_axi_control_rvalid     ( s_axi_control_rvalid     ),
  .s_axi_control_rready     ( s_axi_control_rready     ),
  .s_axi_control_rdata      ( s_axi_control_rdata      ),
  .s_axi_control_rresp      ( s_axi_control_rresp      ),
  .s_axi_control_bvalid     ( s_axi_control_bvalid     ),
  .s_axi_control_bready     ( s_axi_control_bready     ),
  .s_axi_control_bresp      ( s_axi_control_bresp      ),
  .interrupt                ( interrupt                )
);

endmodule
`default_nettype wire
