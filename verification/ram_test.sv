class ram_test; 
  	virtual ram_inf vif_drv; 
  	virtual ram_inf vif_mon; 
  	virtual ram_inf vif_ref; 

  	environment env; 
	
  	function new(virtual ram_inf vif_drv, virtual ram_inf vif_mon, virtual ram_inf vif_ref ); 
    	this.vif_drv = vif_drv; 
    	this.vif_mon = vif_mon; 
    	this.vif_ref = vif_ref; 
  	endfunction 

  	task run(); 
     	env = new(vif_drv, vif_mon, vif_ref ); 
     	env.build; 
     	env.start; 
  	endtask 

endclass 

class test_read extends ram_test; 
	trans_read trans_objj;
	
  	function new(virtual ram_inf vif_drv, virtual ram_inf vif_mon, virtual ram_inf vif_ref ); 
    	super.new(vif_drv, vif_mon, vif_ref ); 
  	endfunction 

  	task run(); 
     	env = new(vif_drv, vif_mon, vif_ref ); 
     	env.build; 
     	begin
     		trans_objj = new();
     		env.gen.trans_obj = trans_objj;
     	end
     	env.start; 
  	endtask 

endclass 

class test_write extends ram_test; 
	trans_write trans_objj;
	
  	function new(virtual ram_inf vif_drv, virtual ram_inf vif_mon, virtual ram_inf vif_ref ); 
    	super.new(vif_drv, vif_mon, vif_ref ); 
  	endfunction 

  	task run(); 
     	env = new(vif_drv, vif_mon, vif_ref ); 
     	env.build; 
     	begin
     		trans_objj = new();
     		env.gen.trans_obj = trans_objj;
     	end
     	env.start; 
  	endtask 

endclass 
