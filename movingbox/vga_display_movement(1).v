//////////////////////////////////////////////////////////////////////////////////
// Company: 		Boston University
// Engineer:		Zafar Takhirov
// 
// Create Date:		11/18/2015
// Design Name: 	EC311 Support Files
// Module Name:    	vga_display
// Project Name: 	Lab5 / Project
// Description:
//					This module is the modified version of the vga_display that
//					includes the movement of the box. In addition to the inputs
//					in the original file, this file also receives the directional
//					controls: up, down, left, right
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: INCOMPLETE CODE
//
//////////////////////////////////////////////////////////////////////////////////

module vga_display(rst, clk, R, G, B, HS, VS, up);

	input rst;	// global reset
	input clk;	// 100MHz clk
	
	// color inputs for a given pixel
	//input [2:0] R_control, G_control;
	//input [1:0] B_control; 
	
	// color outputs to show on display (current pixel)
	output reg [2:0] R, G;
	output reg [1:0] B;
	
	// Synchronization signals
	output HS;
	output VS;
	
	wire [10:0] hcount, vcount;	// coordinates for the current pixel
	wire blank;	// signal to indicate the current coordinate is blank
	wire figure;	// the figure you want to display
	wire floor;
	
	reg gameover;

	/////////////////////////////////////////
	// State machine parameters	
	parameter S_IDLE = 0;	// 0000 - no button pushed
	parameter S_UP = 1;		// 0001 - the first button pushed	


	reg state, next_state;
	////////////////////////////////////////	

	input up; 	// 1 bit inputs	
	reg [10:0] x, y;								//currentposition variables
	//obstacle coordinates
	reg [10:0] a, b, a1, b1, a2, b2, a3, b3, a4, b4, a5, b5, a6, b6, a7, b7, a8, b8, a9, b9;
	reg slow_clk;									// clock for position update,	
														// if it’s too fast, every push
													// of a button willmake your object fly away.

	initial begin					// initial position of the box	
		x = 200; y = 100;
		a = 400; b = 150;
		//a1 = 350; b1 = 220;
		//a2 = 600; b2 = 400;
		a3 = 10; b3 = 350;
	/*	a4 = 75; b4 = 20;
		a5 = 175; b5 = 200;
		a6 = 257; b6 = 275;
	*/	
		a7 = 520; b7 = 75;
	/*	b8 = 620; b8 = 120;
		a9 = 300; b9 = 180;*/
		
		gameover = 1'b0;
	end	

	////////////////////////////////////////////	
	// slow clock for position update - optional
	reg [18:0] slow_count;	
	always @ (posedge clk)begin
		slow_count = slow_count + 1'b1;	
		slow_clk = slow_count[18];
	end	
	/////////////////////////////////////////
		// Begin clock division
	parameter N = 2;	// parameter for clock division
	reg clk_25Mhz;
	reg [N-1:0] count;
	always @ (posedge clk) begin
		count <= count + 1'b1;
		clk_25Mhz <= count[N-1];
	end
	// End clock division
	///////////////////////////////////////////
	// State Machine	
	always @ (posedge slow_clk)begin
		state = next_state;
		
	end

	always @ (posedge slow_clk) begin

		//obstacle
		a = a-1;
		if (a <= 1)
		begin
			a = 10'd679;
		end
		
		a1 = a1-1;
		if (a1 <= 1)
		begin
			a1 = 10'd679;
		end
//		
//		a2 = a2-1;
//		if (a2 <= 1)
//		begin
//			a2 = 10'd679;
//			b2 = 10'd400;
//		end
////
		a3 = a3-1;
		if (a3 <= 1)
		begin
			a3 = 10'd679;
			b3 = 10'd270;
		end
//		
//		a4 = a4-1;
//		if (a4 <= 1)
//		begin
//			a4 = 10'd679;
//			b4 = 10'd425;
//		end
//
//		a5 = a5-1;
//		if (a5 <= 1)
//		begin
//			a5 = 10'd679;
//			b5 = 10'd175;
//		end
//
//		a6 = a6-1;
//		if (a6 <= 1)
//		begin
//			a6 = 10'd679;
//			b6 = 10'd311;
//		end
//
//		a8 = a8-1;
//		if (a8 <= 1)
//		begin
//			a8 = 10'd679;
//		end
//
		a7 = a7-1;
		if (a7 <= 1)
		begin
			a7 = 10'd679;
		end
//
//		a9 = a9-1;
//		if (a9 <= 1)
//		begin
//			a9 = 10'd679;
//		end
		
		case (state)
			S_IDLE: begin
				y = y + 1; // if input is 0000
				next_state = {up};
				end
			S_UP: begin	// if input is 0001
				y = y - 2;	
				next_state = S_IDLE;
				end
			endcase
	

	end
	// ..............................	
	vga_controller_640_60 vc(
		.rst(rst), 
		.pixel_clk(clk_25Mhz), 
		.HS(HS), 
		.VS(VS), 
		.hcounter(hcount), 
		.vcounter(vcount), 
		.blank(blank));
	// .........................................	
	
	assign figure = ~blank & (hcount >= x-10 & hcount <= x+10 & vcount >= y-10 & vcount <= y+10);
	assign floor = ~blank 	& (
										(hcount >= a-3 & hcount <= a+2 & vcount >= b-30 & vcount <= b+30)
								/*	||	(hcount >= a1-3 & hcount <= a1+2 & vcount >= b1-30 & vcount <= b1+30)
									||	(hcount >= a2-3 & hcount <= a2+2 & vcount >= b2-30 & vcount <= b2+30)
								*/	||	(hcount >= a3-3 & hcount <= a3+2 & vcount >= b3-30 & vcount <= b3+30)
								/*	|| (hcount >= a4-3 & hcount <= a4+2 & vcount >= b4-30 & vcount <= b4+30)
									||	(hcount >= a5-3 & hcount <= a5+2 & vcount >= b5-30 & vcount <= b5+30)
									||	(hcount >= a6-3 & hcount <= a6+2 & vcount >= b6-30 & vcount <= b6+30)									
								*/	|| (hcount >= a7-3 & hcount <= a7+2 & vcount >= b7-30 & vcount <= b7+30)
								/*	||	(hcount >= a8-3 & hcount <= a8+2 & vcount >= b8-30 & vcount <= b8+30)
									||	(hcount >= a9-3 & hcount <= a9+2 & vcount >= b9-30 & vcount <= b9+30)*/										
									);
									

	
	// send colors:
	//blue = bird
	//red = obstacles
	//green = not used
	always @ (posedge clk) begin
		if (figure && floor) begin
			gameover = 1'b1;
		end
		
		if (gameover == 1'b0) begin
			if (figure) begin	// if you are within the valid region
				B = 3'b111;
				G = 3'b000;
			end
			else begin
				B = 3'b000;
				G = 3'b000;
			end		
			if (floor) begin
				R = 3'b111;
			end
			else begin	// if you are outside the valid region
				R = 3'b000;
				G = 3'b000;
			end
		end	//end if
		
		else if (gameover == 1'b1) begin
			if (figure) begin	// if you are within the valid region
				B = 3'b000;
				G = 3'b000;
			end
			else begin
				B = 3'b000;
				G = 3'b000;
			end		
			if (floor) begin
				R = 3'b000;
			end
			else begin	// if you are outside the valid region
				R = 3'b000;
				G = 3'b000;
			end
		end	//end if
	end //end always
	
endmodule
