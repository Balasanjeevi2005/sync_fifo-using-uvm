 class output_monitor extends uvm_monitor;
   
   `uvm_component_utils(output_monitor)
   
   uvm_analysis_port#(trans) out_mon_port;
   
   virtual fifo_if.OUT_MON vif;
   fifo_cfg c_h;
   trans t;//rd_data;
   
   function new(string name="output_monitor",uvm_component parent);
     super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
     
     super.build_phase(phase);
     if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",c_h))
       `uvm_fatal(get_type_name(),"Output_Monitor Getting Failed");
     
     out_mon_port=new("out_mon_port",this);
   
   endfunction
   
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     vif=c_h.vif;
   endfunction
   
   task run_phase(uvm_phase phase);
     @(vif.out_mon_cb);
     forever begin	 
       collect_data();
       `uvm_info("OUTPUT_MONITOR",$sformatf("OUTPUT MONITOR\n%s",t.sprint()),UVM_FULL);
     end
   
   endtask
   
   virtual task collect_data();
     
     t=trans::type_id::create("t");
     @(vif.out_mon_cb);
     
     t.full     = vif.out_mon_cb.full;
     t.empty    = vif.out_mon_cb.empty;
     t.data_out = vif.out_mon_cb.data_out;
     
     out_mon_port.write(t);
   
   endtask


 endclass

