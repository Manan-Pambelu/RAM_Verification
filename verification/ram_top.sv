`include "../design/ram.v" 
`include "ram_package.sv" 
`include "ram_interface.sv" 

module ram_top(); 

    import ram_package::*;  
    
	logic clk; 
    logic reset; 
 
 	initial clk = 1'b0;
  	initial forever #10 clk = ~clk; // Period is 20ns --> Frequency is 50Mhz 
  
  	initial begin 
  	repeat(2) @(posedge clk);
    reset = 0;
    repeat(40) @(posedge clk);
    reset = 1;
    repeat(150) @(posedge clk);
    reset = 0;
    
    end 

	ram_inf intrf(clk,reset); 
	
	ram RAM(.data_in(intrf.data_in), .write_enb(intrf.write_enb), .read_enb(intrf.read_enb),.data_out(intrf.data_out), .address(intrf.address), .clk(clk), .reset(reset) ); 

	initial begin 
		ram_test test_1;
		test_read test_2;
		test_write test_3; 
		test_1 = new(intrf.DRIVER, intrf.MONITOR, intrf.REFERENCE ); 
		test_1.run(); 
		$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7");
		$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7");
      	test_2 = new(intrf.DRIVER, intrf.MONITOR, intrf.REFERENCE ); 
		test_2.run(); 
		$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7");
		$display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7");
      	test_3 = new(intrf.DRIVER, intrf.MONITOR, intrf.REFERENCE ); 
		test_3.run(); 
		$finish;
	end 

endmodule 
