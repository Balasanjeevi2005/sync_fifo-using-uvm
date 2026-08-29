class input_monitor extends uvm_monitor;
  
  `uvm_component_utils(input_monitor)
  
  uvm_analysis_port#(trans) inp_mon_port;
  
  virtual fifo_if.IN_MON vif;
  fifo_cfg c_h;
  trans t;//drv2mon
  
  function new(string name="input_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
   
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",c_h))
      `uvm_fatal(get_type_name(),"Input_Monitor Getting Failed");
    inp_mon_port=new("inp_mon_port",this);
  
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=c_h.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    @(vif.inp_mon_cb);
    forever begin
      collect_input_monitor();
      `uvm_info("INPUT_MONITOR",$sformatf("Input_MONITOR\n%s",t.sprint()),UVM_FULL);
    end
  
  endtask
  
  virtual task collect_input_monitor();
    
    t=trans::type_id::create("t");
    @(vif.inp_mon_cb);
    
    t.rst       =   vif.inp_mon_cb.rst;
    t.wr_cs     =   vif.inp_mon_cb.wr_cs; 
    t.rd_cs     =   vif.inp_mon_cb.rd_cs;
    t.wr_en     =   vif.inp_mon_cb.wr_en;
    t.rd_en     =   vif.inp_mon_cb.rd_en;
    t.data_in   =   vif.inp_mon_cb.data_in;
    
    inp_mon_port.write(t);
  
  endtask

endclass

