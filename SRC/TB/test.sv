class test extends uvm_test;
  
  `uvm_component_utils(test)
  env e_h;
  fifo_cfg c_h;
  
  function new(string name="test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    c_h=fifo_cfg::type_id::create("c_h");
    
    //virtual_get
    if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",c_h.vif))
      `uvm_fatal(get_type_name,"Can't get the interface");
    
    c_h.inp_agnt_is_active=UVM_ACTIVE;
    c_h.out_agnt_is_passive=UVM_PASSIVE;
    
    uvm_config_db#(fifo_cfg)::set(this,"*","fifo_cfg",c_h);
    
    e_h=env::type_id::create("e_h",this);
  
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass


class test1 extends test;
  
  `uvm_component_utils(test1)
  
  normal_sequence n1;
  boundary_data_sequence bd1;
  
  function new(string name="test1",uvm_component parent);
    super.new(name,parent);
  endfunction

// function void build_phase(uvm_phase phase);
//   super.build_phase(phase);
// endfunction
  
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    
    n1=normal_sequence::type_id::create("n1");
    bd1=boundary_data_sequence::type_id::create("bd1");
    
    n1.start(e_h.inp_agnt_h.sr_h);
    bd1.start(e_h.inp_agnt_h.sr_h);

    #50;
    phase.drop_objection(this);


 endtask

endclass
 

