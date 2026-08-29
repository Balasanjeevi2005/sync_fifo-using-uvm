class input_agent extends uvm_agent;
  
  `uvm_component_utils(input_agent)

  input_driver id_h;
  input_monitor im_h;
  
  sequencer sr_h;
  fifo_cfg c_h;

  function new(string name="input_agent",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",c_h))
      `uvm_fatal(get_type_name(),"Input_agent Getting Failed");
    
    im_h=input_monitor::type_id::create("im_h",this);

    if(c_h.inp_agnt_is_active==UVM_ACTIVE)
    begin
      id_h=input_driver::type_id::create("id_h",this);
      sr_h=sequencer::type_id::create("sr_h",this);
    end

  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(c_h.inp_agnt_is_active==UVM_ACTIVE)
    begin
      id_h.seq_item_port.connect(sr_h.seq_item_export);
    end
  endfunction

 endclass
