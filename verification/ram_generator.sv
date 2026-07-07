class generator;
	
	transaction trans_obj;
	mailbox #(transaction)mbx_gd;

	function new(mailbox #(transaction)mbx_gd);
		this.mbx_gd = mbx_gd; 
		trans_obj = new();
	endfunction

	task start();
		for(int i=0; i<`num_of_trans; i++ )
		begin
			trans_obj.randomize();
			mbx_gd.put(trans_obj.copy());
			$display("GENERATOR randomized data_in=%d,write_enb=%d,read_enb=%d,address=%d",trans_obj.data_in, trans_obj.write_enb, trans_obj.read_enb, trans_obj.address, $time);
		end
	endtask
endclass
