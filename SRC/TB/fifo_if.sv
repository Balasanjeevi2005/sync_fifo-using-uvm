
`include "uvm_macros.svh"
interface fifo_if(input logic clk,input logic rst);
  import uvm_pkg::*;
  //input
  logic wr_cs;
  logic rd_cs;
  logic rd_en;
  logic wr_en;
  logic [`DATA_WIDTH-1:0]data_in  ;
  //output
  logic full;
  logic empty;
  logic [`DATA_WIDTH-1:0]data_out ;
  
  clocking inp_drv_cb@(posedge clk);
    
    default input #1 output #1;
    output wr_cs  ;
    output rd_cs  ;
    output rd_en  ;
    output wr_en  ;
    output data_in;
    
  endclocking
  
  
  clocking inp_mon_cb@(posedge clk);
    default input #1 output #1;
    input rst    ;
    input wr_cs  ;
    input rd_cs  ;
    input rd_en  ;
    input wr_en  ;
    input data_in;
  endclocking
  
  clocking out_mon_cb@(posedge clk);
    default input #1 output #1;
    input full    ;
    input empty   ;
    input data_out;
  endclocking
  
  modport IN_DRV(clocking inp_drv_cb);
  modport IN_MON(clocking inp_mon_cb);
  modport OUT_MON(clocking out_mon_cb);
     
    write_full:assert property(
    @(posedge clk)
    disable iff(rst)
    (wr_cs && wr_en && full && (!rd_en || !rd_cs))|=>((data_out===$past(data_out)) && (full==1)&& (empty==0))      
    )
    else
      `uvm_error("assertion_fail","write when fifo full");
      
    read_empty:assert property(
    @(posedge clk)
    disable iff(rst)
      (rd_cs && rd_en && empty && (!wr_en || !wr_cs))|=>((data_out===$past(data_out)) && (full==0)&& (empty==1))      
    )
    else
      `uvm_error("assertion_fail","read when fifo empty");
      
    wr_not_f_e:assert property(
    @(posedge clk)
    disable iff(rst)
      (wr_cs && wr_en && rd_en && rd_cs && !full && !empty) |=> (!full && !empty )      
    )
    else
      `uvm_error("assertion_fail","write/read when fifo is not full & not empty");
      
    wr_full:assert property(
    @(posedge clk)
    disable iff(rst)
      (wr_cs && wr_en && rd_en && rd_cs && full && !empty) |=> (full && !empty)      
    )
    else
      `uvm_error("assertion_fail","write/read when fifo is full");
      
    wr_empty:assert property(
    @(posedge clk)
    disable iff(rst)
      (wr_cs && wr_en && rd_en && rd_cs && !full && empty) |=> (!full && !empty )      
    )
    else
      `uvm_error("assertion_fail","write/read when fifo is empty");
      
    no_operation:assert property(
    @(posedge clk)
    disable iff(rst)
      ( !(wr_cs && wr_en) && !(rd_en && rd_cs) ) |=>((data_out===$past(data_out)) && (full==$past(full)) &&(empty==$past(empty)) )   
    )
    else
      `uvm_error("assertion_fail","no read/write operation");
    
    asyn_rst:assert property(
      @(posedge rst)
      1 |=> data_out==0 && !full && empty    
    )
    else
      `uvm_error("assertion_fail","async reset failed");

endinterface
