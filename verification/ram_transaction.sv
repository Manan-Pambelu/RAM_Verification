class transaction;

	rand bit [7:0]	data_in;
	rand bit [4:0]	address;
	rand bit 	 	write_enb, read_enb;

	bit [7:0]		data_out;
	
	constraint wr_rd_value {{write_enb,read_enb} inside {[0:3]};	}
	//constraint wr_rd_ve { data_in != 0;	}
	//constraint wr_rd_not_equal {{write_enb,read_enb} != 2'b11;		}

	virtual function transaction copy();
		copy = new();
		copy.data_in 	= this.data_in;
		copy.address 	= this.address;
		copy.write_enb 	= this.write_enb;
		copy.read_enb 	= this.read_enb;
		return copy;
	endfunction

endclass

class trans_read extends transaction;

	constraint only_rd { {write_enb,read_enb} == 'b01;	}

	virtual function transaction copy();
		copy = new();
		copy.data_in 	= this.data_in;
		copy.address 	= this.address;
		copy.write_enb 	= this.write_enb;
		copy.read_enb 	= this.read_enb;
		return copy;
	endfunction

endclass

class trans_write extends transaction;

	constraint only_wr { {write_enb,read_enb} == 'b10;	}

	virtual function transaction copy();
		copy = new();
		copy.data_in 	= this.data_in;
		copy.address 	= this.address;
		copy.write_enb 	= this.write_enb;
		copy.read_enb 	= this.read_enb;
		return copy;
	endfunction

endclass

