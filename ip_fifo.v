

module ip_fifo(
    input               sys_clk        ,  //系统时钟
    input               sys_rst_n         //系统复位，低电平有效
    );

//wire define
wire             clk_50m ;
wire             clk_25m ;
wire             locked  ;
wire             rst_n   ;
   
wire    [7:0]   rd_usedw;
wire    [7:0]   wr_usedw;


wire wr_full  ;
wire wr_empt  ;
wire wr_req   ;
wire [7:0] wr_data  ;   

wire rd_full  ;
wire rd_empt  ;
wire rd_req   ;
wire [7:0] rd_data  ;   

assign rst_n = sys_rst_n & locked;

//锁相环模块
pll_clk u_pll_clk(
    .areset   (~sys_rst_n),
    .inclk0   (sys_clk),
    .c0       (clk_50m),
    .c1       (clk_25m),
    .locked   (locked)
    );


async_fifo  usr_async_fifo (
    .aclr ( ~rst_n ),
    .data ( wr_data ),
    .rdclk ( clk_25m ),
    .rdreq ( rd_req ),
    .wrclk ( clk_50m ),
    .wrreq ( wr_req ),
    .q ( rd_data ),
    .rdempty ( rd_empt ),
    .rdfull ( rd_full ),
    .rdusedw ( rd_usedw ),
    .wrempty ( wr_empt ),
    .wrfull ( wr_full ),
    .wrusedw ( wr_usedw )
    );


fifo_wr usr_fifo_wr(

    .clk                       (clk_50m)   ,
    .rst_n                     (rst_n)    ,

    .wr_full                   (wr_full)  ,
    .wr_empt                   (wr_empt)     ,
    .wr_req                   (wr_req)     ,
    .wr_data                   (wr_data)

    );


fifo_rd usr_fifo_rd(

    .clk                       (clk_25m)   ,
    .rst_n                     (rst_n)    ,

    .rd_full                   (rd_full)  ,
    .rd_empt                   (rd_empt)     ,

    . rd_req                   (rd_req)     ,
    .rd_data       (rd_data)

    );

endmodule
