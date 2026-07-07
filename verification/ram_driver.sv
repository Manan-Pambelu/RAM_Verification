class driver;

	transaction trans_obj;
	mailbox #(transaction)mbx_gd;
	mailbox #(transaction)mbx_dr;
	virtual ram_inf.DRIVER vinf ;

	covergroup drv_cg;
  		WRITE:	 coverpoint trans_obj.write_enb { bins wr[]		={0,1};		}
  		READ :   coverpoint trans_obj.read_enb  { bins rd[]		={0,1};		}
  		DATA_IN: coverpoint trans_obj.data_in   { bins data 	={[0:255]};	}
  		ADDRESS: coverpoint trans_obj.address   { bins address	={[0:31]};	}
  		WR_x_RD: cross WRITE,READ ;/*{ illegal_bins wr_rd_high = binsof(WRITE) intersect {1} && binsof(READ)  intersect {1}; }*/
	endgroup

	function new(mailbox #(transaction)mbx_gd, mailbox #(transaction)mbx_dr, virtual ram_inf.DRIVER vinf);
		this.mbx_gd = mbx_gd;
		this.mbx_dr = mbx_dr;
		this.vinf 	= vinf;
		drv_cg 		= new();
	endfunction

	task start();
		repeat(3) @(vinf.cb_driver);
    	for(int i=0; i<`num_of_trans; i++)
      	begin
      		$display("/////////////////////////////////////////////////////////////////////////////////////////////////////////////");
        	$display("/////////////////////////////////////////////////////////////////////////////////////////////////////////////");
        	trans_obj = new();
        	mbx_gd.get(trans_obj);
			$display("%m Driver ran at iteration %0d",i);
        	if(vinf.cb_driver.reset == 0)
          		begin
          			//@(vinf.cb_driver);
           			vinf.cb_driver.write_enb	<=0;
           			vinf.cb_driver.read_enb		<=0;
           			vinf.cb_driver.data_in		<=8'bz;  
           			vinf.cb_driver.address		<=0;
           			mbx_dr.put(trans_obj);
           			
           			drv_cg.sample();
           			@(vinf.cb_driver);
               		//$display("INPUT FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());    
           		end
        	else
          		begin
          			//@(vinf.cb_driver);
               		vinf.cb_driver.write_enb	<=trans_obj.write_enb;
               		vinf.cb_driver.read_enb		<=trans_obj.read_enb;
               		vinf.cb_driver.data_in		<=trans_obj.data_in;  
               		vinf.cb_driver.address		<=trans_obj.address;
               		mbx_dr.put(trans_obj);
               		drv_cg.sample();
               		@(vinf.cb_driver);
               		//$display("INPUT FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
        		end
        		$display("******** driver_sending **********");
				$display("write_enb = %0d",trans_obj.write_enb);
				$display("read_enb  = %0d",trans_obj.read_enb);
				$display("data_in   = %0d",trans_obj.data_in);
				$display("address   = %0d",trans_obj.address);
				$display("*********************************");
     	end
  	endtask

endclass
