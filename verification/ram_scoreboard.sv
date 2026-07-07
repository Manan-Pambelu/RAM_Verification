class scoreboard;
	
	transaction trans_ref, trans_mon;
	mailbox #(transaction)mbx_rs;
	mailbox #(transaction)mbx_ms;

	bit [7:0] ref_mem [31:0]; 
   	bit [7:0] mon_mem [31:0]; 

	int match, miss;
	
	function new(mailbox #(transaction)mbx_rs, mailbox #(transaction)mbx_ms);
		this.mbx_rs = mbx_rs;
		this.mbx_ms = mbx_ms;
	endfunction

	task start();
	for(int i=0; i<`num_of_trans; i++)
		begin
			trans_ref = new();
			trans_mon = new();
			fork
			begin
				mbx_rs.get(trans_ref);
				ref_mem[trans_ref.address] = trans_ref.data_out;
           		$display("############   SCOREBOARD REFdata_out=%0d, ADDRESS=%d    ###############",ref_mem[trans_ref.address],trans_ref.address,$time);
			end
			begin
				mbx_ms.get(trans_mon);
				mon_mem[trans_mon.address] = trans_mon.data_out;
           		$display("!!!!!!!!!!!!!   SCOREBOARD MONdata_out=%0d,  ADDRESS=%d    !!!!!!!!!!!!!!",mon_mem[trans_mon.address],trans_mon.address,$time);
			end
			join
			compare();
		end
	endtask

	task compare();
     	if(ref_mem[trans_ref.address] == mon_mem[trans_mon.address])
          	begin
            	$display("SCOREBOARD REFdata_out=%0d, MONdata_out=%0d",ref_mem[trans_ref.address],mon_mem[trans_mon.address],$time);
    			match++;
            	$display("*********************************************************************************       DATA MATCH SUCCESSFUL MATCH=%d",match);
          	end
		else
          	begin
            	$display("SCOREBOARD REFdata_out=%0d, MONdata_out=%0d",ref_mem[trans_ref.address],mon_mem[trans_mon.address],$time);
            	miss++;
            	$display("*********************************************************************************       DATA MATCH FAILED MISMATCH=%d",miss);
          	end
	endtask
	
	task summary();
          	begin
            	$display("*************************************************************************************************************************************");
            	$display("************************************************************** REF_MEM **************************************************************");
            	$display("*************************************************************************************************************************************");
				foreach (ref_mem[i])	$display("%p",ref_mem[i]);
            	$display("*************************************************************************************************************************************");
            	$display("************************************************************** MON_MEM **************************************************************");
            	$display("*************************************************************************************************************************************");
				foreach (mon_mem[i])	$display("%p",mon_mem[i]);
            	$display("*************************************************************************************************************************************");
            	$display("****************     TOTAL MATCH = %0d        ***************************************    TOTAL MISMATCH = %0d    ***********************",match,miss);
            	$display("*************************************************************************************************************************************");
          	end
	endtask

endclass

