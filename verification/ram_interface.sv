interface ram_inf(input bit clk,reset);

		logic [7:0]	data_in, data_out;
		logic		write_enb, read_enb;
		logic [4:0]	address;

		clocking cb_driver@(posedge clk);
			default input #0 output #0;
			output data_in, write_enb, read_enb, address;
			input reset;
		endclocking

		clocking cb_reference@(posedge clk);
			default input #0 output #0;
			//output data_in, write_enb, read_enb, address;
			input reset;
		endclocking

		clocking cb_monitor@(posedge clk);
			default input #0 output #0;
			//output data_in, write_enb, read_enb;
			input data_out, address;
		endclocking

		modport DRIVER(clocking cb_driver);
		modport REFERENCE(clocking cb_reference);
		modport MONITOR(clocking cb_monitor);

endinterface
