class normal_sequence extends uvm_sequence#(trans);
  `uvm_object_utils(normal_sequence)
  
  function new(string name="normal_sequence");
    super.new(name);
  endfunction
 
  task body();
    repeat(20)begin
    for(int wc=0;wc<2;wc++)begin
      for(int rc=0;rc<2;rc++)begin
        for(int we=0;we<2;we++)begin
          for(int re=0;re<2;re++)begin
            req = trans::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {
              wr_cs==wc;
              rd_cs==rc;
              wr_en==we;
              rd_en==re;
            });
            finish_item(req);
          end
        end
      end
    end
    end
    
  endtask
endclass


class boundary_data_sequence extends uvm_sequence#(trans);
  `uvm_object_utils(boundary_data_sequence)
  
  function new(string name="boundary_data_sequence");
    super.new(name);
  endfunction
  
  task body();
    
    //ALL ZERO DATA
    for(int wc=0;wc<2;wc++)begin
      for(int rc=0;rc<2;rc++)begin
        for(int we=0;we<2;we++)begin
          for(int re=0;re<2;re++)begin
            req = trans::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {
              wr_cs==wc;
              rd_cs==rc;
              wr_en==we;
              rd_en==re;
              data_in=={`DATA_WIDTH{1'b0}};
            });
            finish_item(req);
          end
        end
      end
    end
    
    //ALL ONES DATA
    for(int wc=0;wc<2;wc++)begin
      for(int rc=0;rc<2;rc++)begin
        for(int we=0;we<2;we++)begin
          for(int re=0;re<2;re++)begin
            req = trans::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {
              wr_cs==wc;
              rd_cs==rc;
              wr_en==we;
              rd_en==re;
              data_in=={`DATA_WIDTH{1'b1}};
            });
            finish_item(req);
          end
        end
      end
    end
   
    //random test
    repeat(2000)begin
      req = trans::type_id::create("req");
        start_item(req);
          assert(req.randomize());
        finish_item(req);
    end

    // Fill FIFO completely
    for(int i = 0; i < (`RAM_DEPTH+3); i++) begin

      req = trans::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {
        wr_cs == 1;
        wr_en == 1;

        rd_cs == 0;
        rd_en == 0;
      });

      finish_item(req);
    end
    // Read until FIFO becomes empty
    for(int i = 0; i < (`RAM_DEPTH+7); i++) begin

      req = trans::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {
        wr_cs == 0;
        wr_en == 0;
        rd_cs == 1;
        rd_en == 1;
      });

      finish_item(req);

    end

  endtask
endclass
