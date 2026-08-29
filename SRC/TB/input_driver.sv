class input_driver extends uvm_driver#(trans);
  
  `uvm_component_utils(input_driver)
  
  virtual fifo_if.IN_DRV vif;
  fifo_cfg c_h;
  trans t;//data2drv
  
  function new(string name="input_driver",uvm_component parent);
   super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",c_h))
      `uvm_fatal(get_type_name(),"Input_Driver Getting Failed")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     vif=c_h.vif;
  endfunction

  task run_phase(uvm_phase phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
    end
  
  endtask

  task drive(trans t);
   
    `uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",t.sprint()),UVM_FULL)
    @(vif.inp_drv_cb);

    vif.inp_drv_cb.wr_cs      <= t.wr_cs;
    vif.inp_drv_cb.rd_cs      <= t.rd_cs;
    vif.inp_drv_cb.wr_en      <= t.wr_en;
    vif.inp_drv_cb.rd_en      <= t.rd_en;
    vif.inp_drv_cb.data_in    <= t.data_in;
    
  endtask
  
endclass
