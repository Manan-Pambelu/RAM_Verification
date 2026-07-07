class reference_model;
   	
	transaction trans_obj;
   	mailbox #(transaction) mbx_dr;
   	mailbox #(transaction) mbx_rs;
   	virtual ram_inf.REFERENCE vinf ;
   	
	bit [7:0] MEM [31:0];

  	function new(mailbox #(transaction) mbx_dr, mailbox #(transaction) mbx_rs, virtual ram_inf.REFERENCE vinf );
    	this.mbx_dr = mbx_dr;
    	this.mbx_rs = mbx_rs;
    	this.vinf 	= vinf;
   	endfunction

  	task start();
  		repeat(3) @(vinf.cb_reference);
    	for(int i=0; i<`num_of_trans; i++)
     	begin
      		trans_obj = new();
      		if (vinf.cb_reference.reset == 0) 
      		begin
      			foreach (MEM[i])	MEM[i] = 0;
      			//trans_obj.data_out = 'z;
      		end
      		mbx_dr.get(trans_obj);
      		if (vinf.cb_reference.reset == 0) 
      		begin
      		    @(vinf.cb_reference);
      			foreach (MEM[i])	MEM[i] = 0;
      			trans_obj.data_out = 'z;
      		end
      		else
       		begin
       			@(vinf.cb_reference);
        		if(trans_obj.write_enb)
         		begin
         			MEM[trans_obj.address] = trans_obj.data_in;
        			$display("REFERENCE MODEL WRITE MEM[%d]=%0d ",trans_obj.address,MEM[trans_obj.address],$time);
        		end
        		if(trans_obj.read_enb)
         		begin
         			trans_obj.data_out = MEM[trans_obj.address];
        			$display("REFERENCE MODEL READ data_out=%0d FROM address=%0d",trans_obj.data_out,trans_obj.address,$time);
       			end
       			
       		end
       		mbx_rs.put(trans_obj);
		end 
  	endtask

endclass
