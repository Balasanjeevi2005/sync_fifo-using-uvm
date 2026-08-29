class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  uvm_tlm_analysis_fifo #(trans)inp_mon_fifo;
  uvm_tlm_analysis_fifo #(trans)out_mon_fifo;

  
  
  bit[`DATA_WIDTH-1:0]mem[`RAM_DEPTH];
  bit [`ADDR_WIDTH-1:0] wr_pointer;
  bit [`ADDR_WIDTH-1:0] rd_pointer;
  bit [`ADDR_WIDTH  :0] status_cnt;
  bit [`DATA_WIDTH-1:0] data_ram ;
  bit full,hold;
  bit empty=1'b1;
  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
    inp_mon_fifo=new("inp_mon_fifo",this);
    out_mon_fifo=new("out_mon_fifo",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    trans inp_mon_xn,inp_mon_xn_hold;
    trans out_mon_xn;
    forever begin
      fork 
      inp_mon_fifo.get(inp_mon_xn);
      out_mon_fifo.get(out_mon_xn);
      join
      if(hold==0)begin
        hold=1'b1;
        inp_mon_xn_hold=inp_mon_xn;
      end
      else begin
        expected_output(inp_mon_xn_hold);
        `uvm_info("expected_output",$sformatf("expected_output\n%s",inp_mon_xn.sprint()),UVM_HIGH);
      
        check_Data(inp_mon_xn_hold,out_mon_xn);
        `uvm_info("CHECKING OUTPUT ",$sformatf("CHECKING OUTPUT\n%s",out_mon_xn.sprint()),UVM_HIGH);
        inp_mon_xn_hold=inp_mon_xn;
      end
		 
   end
  
  endtask
  
      task check_Data(trans tin,trans tout);
    
        if(tin.full == tout.full)
      $display("\n full IS  MATCHING");
    else
      $display("\n full IS NOT MATCHING");
    
        if(tin.empty == tout.empty)
      $display("\n empty IS  MATCHING");
    else
      $display("\n empty IS NOT MATCHING");
    
        if(tin.data_out == tout.data_out)
      $display("\n data_out IS  MATCHING");
    else
      $display("\n data_out IS NOT MATCHING");
    
  endtask
	
    virtual task expected_output(trans t);
    if(t.rst)begin
      
      full=1'b0;
      empty=1'b1;
      
      //t.data_out={`DATA_WIDTH{1'b0}};
      
      wr_pointer={`ADDR_WIDTH{1'b0}};
      rd_pointer={`ADDR_WIDTH{1'b0}};
      
      status_cnt={(`ADDR_WIDTH+1){1'b0}};
      for(int i=0;i<`RAM_DEPTH;i++)begin
        mem[i]={`DATA_WIDTH{1'b0}};
      end
      
    end
    if(!t.rst) begin
      //both read/write
      if( (t.wr_cs && t.wr_en) && (t.rd_cs && t.rd_en) )begin
        
        if(!empty)begin
          data_ram=mem[rd_pointer];
          rd_pointer++;
          status_cnt--;
        end
        
        if(!full)begin
          mem[wr_pointer]=t.data_in;
          wr_pointer++;
          status_cnt++;
        end
        
      end
      //only write
      else if( (t.wr_cs && t.wr_en && !full))begin
        mem[wr_pointer]=t.data_in;
        wr_pointer++;
        status_cnt++;
        empty=1'b0;
      end
      //only read
      else if( (t.rd_cs && t.rd_en && !empty) )begin
        data_ram=mem[rd_pointer];
        rd_pointer++;
        status_cnt--;
        full=1'b0;
      end
    end
    if(status_cnt == `RAM_DEPTH)
      full=1'b1;
    else if(status_cnt == 0)
      empty=1'b1;
    else begin
      full=1'b0;
      empty=1'b0;
    end
    t.full=full;
    t.empty=empty;
    t.data_out=data_ram;
      
  endtask


endclass
