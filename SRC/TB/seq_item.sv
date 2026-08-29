class trans extends uvm_sequence_item;
  
  rand bit rst;
  rand bit wr_cs;
  rand bit rd_cs;
  rand bit wr_en;
  rand bit rd_en;
  rand bit [`DATA_WIDTH-1:0]data_in;

  logic full,empty;
  logic [`DATA_WIDTH-1:0]data_out;

  localparam bit [`DATA_WIDTH-1:0] MAX_VAL = {`DATA_WIDTH{1'b1}};

  constraint c0{soft wr_cs dist {1:=2,0:=1};}
  constraint c1{soft rd_cs dist {1:=2,0:=1};}
  constraint c2{soft wr_en dist {1:=2,0:=1};}
  constraint c3{soft rd_en dist {1:=2,0:=1};}
  
  constraint c4{soft data_in inside {[1:MAX_VAL]};}
  
  `uvm_object_utils_begin(trans)
  
  `uvm_field_int(rst ,UVM_ALL_ON)
  `uvm_field_int(wr_cs ,UVM_ALL_ON)
  `uvm_field_int(rd_cs,UVM_ALL_ON)
  `uvm_field_int(data_in,UVM_ALL_ON)
  
  `uvm_field_int(rd_en,UVM_ALL_ON)
  `uvm_field_int(wr_en,UVM_ALL_ON)
  `uvm_field_int(data_out,UVM_ALL_ON)
  
  `uvm_field_int(empty,UVM_ALL_ON)
  `uvm_field_int(full ,UVM_ALL_ON)
  
  `uvm_object_utils_end
  
  function new(string name="trans");
    super.new(name);
  endfunction
  
endclass

	


 
