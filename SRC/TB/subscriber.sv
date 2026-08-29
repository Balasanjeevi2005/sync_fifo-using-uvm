class subscriber extends uvm_subscriber#(trans);
  
  `uvm_component_utils(subscriber)
  
  trans t1;
  
  covergroup cg;
    
    wr_cs:coverpoint t1.wr_cs{
      bins low ={0};
      bins high={1};
    }
    
    rd_cs:coverpoint t1.rd_cs{
      bins low ={0};
      bins high={1};
    }
    
    rd_en:coverpoint t1.rd_en{
      bins low ={0};
      bins high={1};
    }
    
    wr_en:coverpoint t1.wr_en{
      bins low ={0};
      bins high={1};
    }
    
    data_in:coverpoint t1.data_in{
      bins all_zero={ {`DATA_WIDTH{1'b0}} };
      bins all_ones={ {`DATA_WIDTH{1'b1}} };
      bins others  = default;
    }
    Wcs_wen:cross wr_cs,wr_en;
    rcs_ren:cross rd_cs,rd_en;
    w_r:cross wr_cs,rd_cs;
    
  endgroup
  
  function new(string name="subscriber",uvm_component parent);
    super.new(name,parent);
    cg=new();
  endfunction
  
  function void write(trans t);
    t1=t;
    cg.sample();
  endfunction
  
endclass
