/* Authors: Jessica Ballard, Mauhib Iqbal */

module msdap(clock, reset, inputFrame, data_in, outputFrame, data_out);
	parameter X_LEN = 16; //Bits in each slot
	parameter FILTER_ORDER = 256;
	parameter ADDR_LEN = 8; //Address of slot
	parameter DATA_NUM = 2**ADDR_LEN; //Number of slots
	parameter OUTPUT_LEN = 40;
	parameter PRECISION = 16;
	parameter RUN_NUMBER = 1;

	//IO
	input wire clock;
	input wire reset;
	input wire inputFrame;
	input wire [X_LEN-1:0] data_in;
	output reg outputFrame;
	output reg [OUTPUT_LEN-1:0] data_out;

	//Memory for X
	reg [X_LEN-1:0] x_memory [0:DATA_NUM-1];
	//Rj
	reg [7:0] rj [0:PRECISION-1];
	initial begin
		
		if(RUN_NUMBER == 1) begin
			//Rj1.in
			rj[ 1-1]=8'h0B;
			rj[ 2-1]=8'h0F;
			rj[ 3-1]=8'h0E;
			rj[ 4-1]=8'h0D;
			rj[ 5-1]=8'h08;
			rj[ 6-1]=8'h0D;
			rj[ 7-1]=8'h0D;
			rj[ 8-1]=8'h06;
			rj[ 9-1]=8'h05;
			rj[10-1]=8'h06;
			rj[11-1]=8'h04;
			rj[12-1]=8'h06;
			rj[13-1]=8'h09;
			rj[14-1]=8'h0B;
			rj[15-1]=8'h14;
			rj[16-1]=8'h05;
		end
		
		if(RUN_NUMBER == 2) begin
			//Rj2.in
			rj[0]=	8'h0C;
			rj[1]=	8'h16;
			rj[2]=	8'h0A;
			rj[3]=	8'h14;
			rj[4]=	8'h0B;
			rj[5]=	8'h0E;
			rj[6]=	8'h0D;
			rj[7]=	8'h16;
			rj[8]=	8'h00;
			rj[9]=	8'h01;
			rj[10]=	8'h0B;
			rj[11]=	8'h0F;
			rj[12]=	8'h09;
			rj[13]=	8'h06;
			rj[14]=	8'h14;
			rj[15]=	8'h03;
		end

	end
	//Coeff
	reg [8:0] coeff [0:199];
	initial begin
		
		if(RUN_NUMBER == 1) begin
			//Coeff1.in
			coeff[0]  =17'h038;
			coeff[1]  =17'h18C;
			coeff[2]  =17'h00F;
			coeff[3]  =17'h096;
			coeff[4]  =17'h16A;
			coeff[5]  =17'h130;
			coeff[6]  =17'h110;
			coeff[7]  =17'h013;
			coeff[8]  =17'h14F;
			coeff[9]  =17'h1F1;
			coeff[10] =17'h0FA;
			coeff[11] =17'h08E;
			coeff[12] =17'h1FC;
			coeff[13] =17'h1B0;
			coeff[14] =17'h13E;
			coeff[15] =17'h0CF;
			coeff[16] =17'h0EE;
			coeff[17] =17'h021;
			coeff[18] =17'h1AF;
			coeff[19] =17'h04C;
			coeff[20] =17'h0A5;
			coeff[21] =17'h076;
			coeff[22] =17'h0EB;
			coeff[23] =17'h13E;
			coeff[24] =17'h0A8;
			coeff[25] =17'h055;
			coeff[26] =17'h17A;
			coeff[27] =17'h078;
			coeff[28] =17'h0B4;
			coeff[29] =17'h03D;
			coeff[30] =17'h0B7;
			coeff[31] =17'h1DD;
			coeff[32] =17'h169;
			coeff[33] =17'h16C;
			coeff[34] =17'h1F3;
			coeff[35] =17'h0E1;
			coeff[36] =17'h0B2;
			coeff[37] =17'h14E;
			coeff[38] =17'h1D3;
			coeff[39] =17'h0F8;
			coeff[40] =17'h14D;
			coeff[41] =17'h1FF;
			coeff[42] =17'h170;
			coeff[43] =17'h002;
			coeff[44] =17'h04A;
			coeff[45] =17'h1B0;
			coeff[46] =17'h17E;
			coeff[47] =17'h115;
			coeff[48] =17'h132;
			coeff[49] =17'h1F9;
			coeff[50] =17'h15D;
			coeff[51] =17'h024;
			coeff[52] =17'h104;
			coeff[53] =17'h1A3;
			coeff[54] =17'h1BC;
			coeff[55] =17'h007;
			coeff[56] =17'h01A;
			coeff[57] =17'h1E4;
			coeff[58] =17'h0C3;
			coeff[59] =17'h095;
			coeff[60] =17'h0AF;
			coeff[61] =17'h1F7;
			coeff[62] =17'h08C;
			coeff[63] =17'h1C6;
			coeff[64] =17'h19C;
			coeff[65] =17'h0FC;
			coeff[66] =17'h00C;
			coeff[67] =17'h0FB;
			coeff[68] =17'h134;
			coeff[69] =17'h1E9;
			coeff[70] =17'h1AA;
			coeff[71] =17'h176;
			coeff[72] =17'h01C;
			coeff[73] =17'h075;
			coeff[74] =17'h0CC;
			coeff[75] =17'h14A;
			coeff[76] =17'h1B1;
			coeff[77] =17'h142;
			coeff[78] =17'h1B6;
			coeff[79] =17'h1B8;
			coeff[80] =17'h1BB;
			coeff[81] =17'h09F;
			coeff[82] =17'h1FC;
			coeff[83] =17'h027;
			coeff[84] =17'h134;
			coeff[85] =17'h0D1;
			coeff[86] =17'h00F;
			coeff[87] =17'h189;
			coeff[88] =17'h130;
			coeff[89] =17'h199;
			coeff[90] =17'h04B;
			coeff[91] =17'h017;
			coeff[92] =17'h081;
			coeff[93] =17'h0E1;
			coeff[94] =17'h09D;
			coeff[95] =17'h10C;
			coeff[96] =17'h1F3;
			coeff[97] =17'h02B;
			coeff[98] =17'h1D3;
			coeff[99] =17'h09C;
			coeff[100]=17'h1D8;
			coeff[101]=17'h01D;
			coeff[102]=17'h0A6;
			coeff[103]=17'h02D;
			coeff[104]=17'h179;
			coeff[105]=17'h0AE;
			coeff[106]=17'h122;
			coeff[107]=17'h076;
			coeff[108]=17'h012;
			coeff[109]=17'h094;
			coeff[110]=17'h090;
			coeff[111]=17'h141;
			coeff[112]=17'h13D;
			coeff[113]=17'h104;
			coeff[114]=17'h062;
			coeff[115]=17'h0C1;
			coeff[116]=17'h093;
			coeff[117]=17'h068;
			coeff[118]=17'h132;
			coeff[119]=17'h183;
			coeff[120]=17'h0B6;
			coeff[121]=17'h0DD;
			coeff[122]=17'h0BD;
			coeff[123]=17'h1FE;
			coeff[124]=17'h0DD;
			coeff[125]=17'h07C;
			coeff[126]=17'h0E6;
			coeff[127]=17'h105;
			coeff[128]=17'h1A2;
			coeff[129]=17'h0F1;
			coeff[130]=17'h00A;
			coeff[131]=17'h049;
			coeff[132]=17'h0AD;
			coeff[133]=17'h095;
			coeff[134]=17'h011;
			coeff[135]=17'h0E0;
			coeff[136]=17'h17C;
			coeff[137]=17'h1E3;
			coeff[138]=17'h1C2;
			coeff[139]=17'h0A7;
			coeff[140]=17'h1F8;
			coeff[141]=17'h12C;
			coeff[142]=17'h123;
			coeff[143]=17'h0C1;
			coeff[144]=17'h050;
			coeff[145]=17'h176;
			coeff[146]=17'h057;
			coeff[147]=17'h102;
			coeff[148]=17'h155;
			coeff[149]=17'h13F;
			coeff[150]=17'h1FD;
			coeff[151]=17'h1E7;
			coeff[152]=17'h159;
			coeff[153]=17'h047;
			coeff[154]=17'h018;
			coeff[155]=17'h13D;
			coeff[156]=17'h1E6;
			coeff[157]=17'h053;
			coeff[158]=17'h192;
		end
		
		if(RUN_NUMBER == 2) begin
			//Coeff2.in
			coeff[0]=	17'h033;
			coeff[1]=	17'h125;
			coeff[2]=	17'h0DD;
			coeff[3]=	17'h05F;
			coeff[4]=	17'h14C;
			coeff[5]=	17'h0ED;
			coeff[6]=	17'h0C4;
			coeff[7]=	17'h027;
			coeff[8]=	17'h142;
			coeff[9]=	17'h082;
			coeff[10]=	17'h1D0;
			coeff[11]=	17'h134;
			coeff[12]=	17'h0A0;
			coeff[13]=	17'h1CB;
			coeff[14]=	17'h045;
			coeff[15]=	17'h04D;
			coeff[16]=	17'h125;
			coeff[17]=	17'h0C6;
			coeff[18]=	17'h101;
			coeff[19]=	17'h18E;
			coeff[20]=	17'h11A;
			coeff[21]=	17'h0E4;
			coeff[22]=	17'h109;
			coeff[23]=	17'h1AB;
			coeff[24]=	17'h139;
			coeff[25]=	17'h154;
			coeff[26]=	17'h0B7;
			coeff[27]=	17'h149;
			coeff[28]=	17'h0C7;
			coeff[29]=	17'h17C;
			coeff[30]=	17'h1AD;
			coeff[31]=	17'h156;
			coeff[32]=	17'h049;
			coeff[33]=	17'h130;
			coeff[34]=	17'h1BB;
			coeff[35]=	17'h141;
			coeff[36]=	17'h088;
			coeff[37]=	17'h1DB;
			coeff[38]=	17'h1A5;
			coeff[39]=	17'h146;
			coeff[40]=	17'h13E;
			coeff[41]=	17'h1C0;
			coeff[42]=	17'h044;
			coeff[43]=	17'h132;
			coeff[44]=	17'h050;
			coeff[45]=	17'h02D;
			coeff[46]=	17'h008;
			coeff[47]=	17'h030;
			coeff[48]=	17'h1BE;
			coeff[49]=	17'h1A5;
			coeff[50]=	17'h037;
			coeff[51]=	17'h031;
			coeff[52]=	17'h0C2;
			coeff[53]=	17'h0BC;
			coeff[54]=	17'h1BC;
			coeff[55]=	17'h129;
			coeff[56]=	17'h12B;
			coeff[57]=	17'h163;
			coeff[58]=	17'h0ED;
			coeff[59]=	17'h1BC;
			coeff[60]=	17'h0B7;
			coeff[61]=	17'h19D;
			coeff[62]=	17'h0B5;
			coeff[63]=	17'h199;
			coeff[64]=	17'h028;
			coeff[65]=	17'h01D;
			coeff[66]=	17'h1C7;
			coeff[67]=	17'h00F;
			coeff[68]=	17'h151;
			coeff[69]=	17'h035;
			coeff[70]=	17'h1AA;
			coeff[71]=	17'h150;
			coeff[72]=	17'h1BD;
			coeff[73]=	17'h1FD;
			coeff[74]=	17'h188;
			coeff[75]=	17'h0B9;
			coeff[76]=	17'h1F9;
			coeff[77]=	17'h0F0;
			coeff[78]=	17'h154;
			coeff[79]=	17'h066;
			coeff[80]=	17'h15C;
			coeff[81]=	17'h13F;
			coeff[82]=	17'h15E;
			coeff[83]=	17'h033;
			coeff[84]=	17'h02C;
			coeff[85]=	17'h0A1;
			coeff[86]=	17'h106;
			coeff[87]=	17'h1C9;
			coeff[88]=	17'h10A;
			coeff[89]=	17'h0F9;
			coeff[90]=	17'h1EC;
			coeff[91]=	17'h107;
			coeff[92]=	17'h078;
			coeff[93]=	17'h193;
			coeff[94]=	17'h126;
			coeff[95]=	17'h0E2;
			coeff[96]=	17'h00E;
			coeff[97]=	17'h165;
			coeff[98]=	17'h0C1;
			coeff[99]=	17'h05D;
			coeff[100]=	17'h04E;
			coeff[101]=	17'h00F;
			coeff[102]=	17'h17D;
			coeff[103]=	17'h067;
			coeff[104]=	17'h048;
			coeff[105]=	17'h012;
			coeff[106]=	17'h1F5;
			coeff[107]=	17'h194;
			coeff[108]=	17'h18C;
			coeff[109]=	17'h115;
			coeff[110]=	17'h186;
			coeff[111]=	17'h11A;
			coeff[112]=	17'h149;
			coeff[113]=	17'h105;
			coeff[114]=	17'h15E;
			coeff[115]=	17'h133;
			coeff[116]=	17'h1C3;
			coeff[117]=	17'h039;
			coeff[118]=	17'h0DF;
			coeff[119]=	17'h02B;
			coeff[120]=	17'h16B;
			coeff[121]=	17'h1B2;
			coeff[122]=	17'h1DF;
			coeff[123]=	17'h010;
			coeff[124]=	17'h012;
			coeff[125]=	17'h17A;
			coeff[126]=	17'h123;
			coeff[127]=	17'h0EE;
			coeff[128]=	17'h18E;
			coeff[129]=	17'h1D2;
			coeff[130]=	17'h1AC;
			coeff[131]=	17'h0B7;
			coeff[132]=	17'h155;
			coeff[133]=	17'h185;
			coeff[134]=	17'h125;
			coeff[135]=	17'h122;
			coeff[136]=	17'h19C;
			coeff[137]=	17'h1CE;
			coeff[138]=	17'h01B;
			coeff[139]=	17'h15B;
			coeff[140]=	17'h1C6;
			coeff[141]=	17'h043;
			coeff[142]=	17'h079;
			coeff[143]=	17'h037;
			coeff[144]=	17'h024;
			coeff[145]=	17'h1CD;
			coeff[146]=	17'h1B2;
			coeff[147]=	17'h18E;
			coeff[148]=	17'h01A;
			coeff[149]=	17'h00B;
			coeff[150]=	17'h109;
			coeff[151]=	17'h02E;
			coeff[152]=	17'h03D;
			coeff[153]=	17'h063;
			coeff[154]=	17'h18F;
			coeff[155]=	17'h195;
			coeff[156]=	17'h12A;
			coeff[157]=	17'h153;
			coeff[158]=	17'h02C;
			coeff[159]=	17'h17B;
			coeff[160]=	17'h031;
			coeff[161]=	17'h09B;
			coeff[162]=	17'h0A5;
			coeff[163]=	17'h061;
			coeff[164]=	17'h155;
			coeff[165]=	17'h027;
			coeff[166]=	17'h067;
			coeff[167]=	17'h122;
			coeff[168]=	17'h1C2;
			coeff[169]=	17'h1D7;
			coeff[170]=	17'h0CA;
			coeff[171]=	17'h05C;
			coeff[172]=	17'h023;
			coeff[173]=	17'h1E6;
			coeff[174]=	17'h110;
			coeff[175]=	17'h036;
			coeff[176]=	17'h078;
			coeff[177]=	17'h033;
			coeff[178]=	17'h009;
			coeff[179]=	17'h1CA;
			coeff[180]=	17'h05B;
			coeff[181]=	17'h153;
			coeff[182]=	17'h07C;
			coeff[183]=	17'h11D;
			coeff[184]=	17'h198;
			coeff[185]=	17'h0F9;
			coeff[186]=	17'h1AF;
			coeff[187]=	17'h00B;
			coeff[188]=	17'h0CB;
		end
	end

	//For internal computation
	reg [23:0] ui [0:PRECISION-1];
	reg [OUTPUT_LEN-1:0] y_internal;
	reg u_computed;
	//reg [7:0] rj_remaining [0:PRECISION-1];
	//reg [7:0] rj_done [0:PRECISION-1];
	reg [7:0] rj_remaining;
	//reg [7:0] rj_done;
	//reg [11:0] offset;
	reg [7:0] n;
	reg [7:0] m;
	reg [7:0] k;
	//reg [39:0] temp;
	reg [4:0] counter;

	//loop variables
	integer i;
	integer j;

	//FSM States
	parameter SIZE = 			3;
	parameter IDLE = 			3'd0;
	parameter INPUT_X = 		3'd1;
	parameter COMPUTE_U = 		3'd2;
	parameter COMPUTE_Y_ADD =	3'd3;
	parameter COMPUTE_Y_SHIFT =	3'd4;
	parameter OUTPUT_Y = 		3'd5;

	//FSM Variables
	reg [SIZE-1:0] state     ;
	reg [SIZE-1:0] next_state;

	//always block to update state
	always @(negedge clock or negedge reset) begin
		if (reset) begin
			 state <= IDLE;
			 for(i=0;i<DATA_NUM;i=i+1) begin
				x_memory[i] <= 0;
			end
		end
		else begin
			state <= next_state;
		end
	end

	// always block to compute output
	always @(state)
	begin
		case(state)
			IDLE: begin
				for(i=0; i<PRECISION; i=i+1) begin
					ui[i] = 0;
					//rj_remaining[i] = rj[i];
					//rj_done[i] = 0;
				end
				//data_out = 0;
				outputFrame = 0;
			end

			INPUT_X: begin
				outputFrame = 0;
				y_internal = 0;
				//Shift X into our FIFO Structure
				for(i=DATA_NUM-1;i>0;i=i-1) begin
					x_memory[i] <= x_memory[i-1];
				end
				  x_memory[0] <= data_in;
			end

			COMPUTE_U: begin
				u_computed = 0;
				m = 0;
				for(j=0; j<PRECISION; j=j+1) begin
				  ui[j] = 0;
				  rj_remaining = rj[j];
				  k = 0;
				  while (k<rj_remaining)begin
				    n = coeff[m][7:0];
				    if(coeff[m][8]) ui[j] = (ui[j] - {x_memory[n][15] ? 8'hFF : 8'h00,x_memory[n]});
				    else ui[j] = (ui[j] + {x_memory[n][15] ? 8'hFF : 8'h00,x_memory[n]});
				    m = m+1;
				    k = k+1;
				   end
				   //$display ("ui[%d] = %x", j, ui[j]);
				 end
				 /*
				for(j=0; j<PRECISION; j=j+1) begin
				  rj_remaining = rj[j];
				  while(rj_remaining != 8'd0)begin
					   if(coeff[(offset + rj_done)][8]) ui[j] = ui[j] - x_memory[(coeff[(offset+rj_done)][7:0])];
					   else ui[j] = ui[j] + x_memory[(coeff[(offset+rj_done)][7:0])];
					   rj_done = rj_done+1;
					   rj_remaining = rj_remaining - 1;
					end
					offset = offset + rj[j];
				end
				*/
				u_computed = 1;
				counter = 0;
			end

			COMPUTE_Y_ADD: begin
				y_internal = (y_internal+{ui[counter],16'd0}); // Add
			end

			COMPUTE_Y_SHIFT: begin
			  y_internal = {y_internal[39],y_internal[39:1]}; //Shift
			  counter = counter + 1;
			end
			
			OUTPUT_Y: begin
				for(i=0; i<PRECISION; i=i+1) begin
					ui[i] = 0;
				end
				data_out = y_internal;
				outputFrame = 1;
			end

		endcase
	end

	// always block to compute next_state
	always @(state or inputFrame)
	begin
		case(state)
		   IDLE: 		if(inputFrame) next_state = INPUT_X;
						else next_state = IDLE;

		   INPUT_X: 	next_state = COMPUTE_U;

		   COMPUTE_U: 	if(u_computed) next_state = COMPUTE_Y_ADD;
						else next_state = COMPUTE_U;

			COMPUTE_Y_ADD: 	next_state = COMPUTE_Y_SHIFT;
			
		   COMPUTE_Y_SHIFT: if(counter == PRECISION) next_state = OUTPUT_Y;
							else next_state = COMPUTE_Y_ADD;

		   OUTPUT_Y: 	if(inputFrame) next_state = INPUT_X;
						else next_state = IDLE;
		endcase
	end

endmodule
