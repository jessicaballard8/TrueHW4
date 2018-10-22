`timescale 1ps / 1ps
`define NULL 0
module msdap_tb();

	parameter RUN_NUMBER = 2; //Used for switching between data1 and data2

	reg clock;
	reg reset;
	reg inputFrame; //Should we (shift, input, and output) or just output
	reg [15:0] data_in;
	wire outputFrame;
	wire [39:0] data_out;

	defparam uut.RUN_NUMBER = RUN_NUMBER;
	msdap uut(clock, reset, inputFrame, data_in, outputFrame, data_out);

	integer data_file; // file handler
	integer out_file; // file handler
	integer scan_file; // file handler

	initial begin
		inputFrame = 0;
		data_in = 0;
		reset = 1;
		#4;
		reset=0;
		#4;
		
		if(RUN_NUMBER == 1) begin
			data_file = $fopen("data1.in", "r");
		end
		if(RUN_NUMBER == 2) begin
			data_file = $fopen("data2.in", "r");
		end
		if (data_file == `NULL) begin
			$display("data_file handle was NULL");
			$finish;
		end
		if(RUN_NUMBER == 1) begin
			out_file = $fopen("data1.out", "w");
		end
		if(RUN_NUMBER == 2) begin
			out_file = $fopen("data2.out", "w");
		end
		if (out_file == `NULL) begin
			$display("out_file handle was NULL");
			$finish;
		end
		scan_file = $fscanf(data_file, "%x\n", data_in);
		inputFrame = 1;
		#6;
		inputFrame = 0;
	end

	initial begin
		clock = 0;
		#4;
		forever begin
			clock = #4 !clock;
		end
	end

	/*initial begin
		#22;
		addr_in = 1;
	end*/
	
	always @(posedge outputFrame) begin
		$fwrite(out_file,"%X\n",data_out);
	end
	
	always @(negedge outputFrame) begin
		if(!reset) begin
			if (!$feof(data_file)) begin
				scan_file = $fscanf(data_file, "%x\n", data_in);
				#2
				inputFrame = 1;
				#6;
				inputFrame = 0;
				//$display(data_in);
			end
			else begin
				data_in = 0;
				$fclose(data_file);
				$fclose(out_file);
				$finish;
			end
		end
	end
endmodule
