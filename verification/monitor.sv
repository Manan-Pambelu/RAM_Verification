class monitor;
	transaction trans_obj;
	mailbox #(transaction)mbx_ms;
	virtual ram_inf.MONITOR vinf;

	covergroup cg_mon;
		DATA_OUT: coverpoint trans_obj.data_out {bins data_out = {[0:255]}; }
	endgroup

	function new(mailbox #(transaction)mbx_ms, virtual ram_inf.MONITOR vinf);
		this.mbx_ms = mbx_ms;
		this.vinf = vinf;	
		cg_mon = new();
	endfunction
	
	task start();
		repeat(4) @(vinf.cb_monitor);
		for(int i=0; i<`num_of_trans; i++ )
		begin	
			trans_obj = new();
			//@(vinf.cb_monitor);
			begin
				trans_obj.data_out = vinf.cb_monitor.data_out; 
				trans_obj.address = vinf.cb_monitor.address;
			end
			$display("MONITOR TO SCOREBOARD data_out=%0d address=%0d",trans_obj.data_out,trans_obj.address,$time); 
			mbx_ms.put(trans_obj);
			cg_mon.sample();
			@(vinf.cb_monitor);
        	//$display("OUTPUT FUNCTIONAL COVERAGE = %0d", cg_mon.get_coverage());
   		end
	endtask

endclass


