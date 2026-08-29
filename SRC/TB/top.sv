`include "defines.svh"
`include "uvm_macros.svh"
`include "fifo_if.sv"
`include "fifo_rtl.v"
`include "ram_dp_ar_aw.v"
`include "test_pkg.sv"
import uvm_pkg::*;
import test_pkg::*;

module top();
  
  bit clk;
  bit rst;
  
  fifo_if DUV_IF(clk,rst);

  //instatiate DUV
  syn_fifo DUV(.clk(clk),
               .rst(rst),
               .wr_cs(DUV_IF.wr_cs),
               .rd_cs(DUV_IF.rd_cs),
               .data_in(DUV_IF.data_in),
               .rd_en(DUV_IF.rd_en),
	       .wr_en(DUV_IF.wr_en),
               .data_out(DUV_IF.data_out),
               .empty(DUV_IF.empty),
               .full(DUV_IF.full)
              );
  
  initial begin
    
    uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",DUV_IF);
    $dumpfile("waves.fsdb");
    $dumpvars;
    run_test();
		
  end
  initial begin
    rst=1;
    #2 rst=0;
    #10 rst=1;
    repeat(2)@(posedge clk);
    rst=0;
  end

  initial begin
    clk=1'b0;
    forever 
    #5 clk=~clk;
  end

endmodule
