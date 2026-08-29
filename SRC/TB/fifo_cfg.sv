class fifo_cfg extends uvm_object;
  `uvm_object_utils(fifo_cfg)
  //virtual
  virtual fifo_if vif;

  uvm_active_passive_enum inp_agnt_is_active;
  uvm_active_passive_enum out_agnt_is_passive;

  
  function new(string name="fifo_cfg");
	super.new(name);
  endfunction

endclass
