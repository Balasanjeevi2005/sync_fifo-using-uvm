 class output_agent extends uvm_agent;
   
   `uvm_component_utils(output_agent)
   
   output_monitor om_h;
   fifo_cfg c_h;
   
   function new(string name="output_agent",uvm_component parent);
     super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
     
     super.build_phase(phase);
     
     if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",c_h))
       `uvm_fatal(get_type_name(),"Output_agent Getting Failed");
     
     if(c_h.out_agnt_is_passive==UVM_PASSIVE)
       om_h=output_monitor::type_id::create("om_h",this); 

  endfunction

 endclass
