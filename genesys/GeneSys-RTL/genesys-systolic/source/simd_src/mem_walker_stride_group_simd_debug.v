`timescale 1ns/1ps
module mem_walker_stride_group_simd_debug #(
    // Internal Parameters
    parameter integer  ADDR_WIDTH                   = 48,
    parameter integer  ADDR_STRIDE_W                = 16,
    parameter integer  LOOP_ID_W                    = 5,
    parameter integer  GROUP_ID_W                   = 2,
    parameter integer  GROUP_ENABLED                = 1,
    parameter integer  NUM_MAX_LOOPS                = (1 << LOOP_ID_W),
    parameter integer  NUM_MAX_GROUPS               = (1 << GROUP_ID_W)
) (
    input  wire                                         clk,
    input  wire                                         reset,
    input  wire                                         isBase,

    input  wire  [ ADDR_WIDTH           -1 : 0 ]        base_addr,
    input  wire  [ NUM_MAX_LOOPS		   : 0 ] 		iter_done,
    input  wire                                		    start,
    input  wire                                         block_done,
    input  wire                                         base_addr_v,
    
    input  wire                                		    stall,
    // Address offset - from instruction decoder
    input  wire  [ LOOP_ID_W        -1 : 0 ]            cfg_loop_id,
    input  wire                                         cfg_addr_stride_v,
    input  wire  [ ADDR_STRIDE_W        -1 : 0 ]        cfg_addr_stride,
    
    input  wire  [ GROUP_ID_W           -1 : 0 ]        cfg_loop_group_id,
    input  wire  [ GROUP_ID_W           -1 : 0 ]        loop_group_id,
    
    
    output wire  [ ADDR_WIDTH           -1 : 0 ]        addr_out,
    output wire                                         addr_out_valid
);

//=============================================================
// Wires/Regs
//=============================================================
    localparam MAX_GROUPS = (GROUP_ENABLED == 1) ? NUM_MAX_GROUPS : 1 ;
    
	reg loop_done, stall_d, start_d, iter_done_d;
	reg [ADDR_STRIDE_W-1:0] group_loop_stride[0:MAX_GROUPS-1][0:NUM_MAX_LOOPS-1];

	reg [ADDR_WIDTH-1:0] group_curr_address[0:MAX_GROUPS-1][0:NUM_MAX_LOOPS-1];
	reg [ADDR_WIDTH-1:0] loop_address[0:NUM_MAX_LOOPS-1];
	reg [ADDR_WIDTH-1:0] loop_address_d[0:NUM_MAX_LOOPS-1];
    
    reg [LOOP_ID_W-1 : 0]    counter[0:MAX_GROUPS-1];
//  reg  [ LOOP_ID_W            -1 : 0 ]        addr_stride_wr_ptr;
	reg addr_gen_valid;
	reg [ GROUP_ID_W           -1 : 0 ]        prev_group_id;
	wire load_new_group;
	wire done;
	wire  [ GROUP_ID_W           -1 : 0 ]        cfg_loop_group_id_in;
  
    wire  [ GROUP_ID_W           -1 : 0 ]        loop_group_id_in;
    wire  [ ADDR_WIDTH           -1 : 0 ]        addr_out_d;
    wire                                         addr_out_valid_d;

    generate
        if(GROUP_ENABLED == 1) begin
            assign cfg_loop_group_id_in = cfg_loop_group_id;
            assign loop_group_id_in = loop_group_id;
        end
        else begin
            assign cfg_loop_group_id_in = 'b0;
            assign loop_group_id_in = 'b0;
        end
    endgenerate
      
	always @(posedge clk) begin
        start_d <= start;
        iter_done_d <= iter_done[0];
	    prev_group_id <= loop_group_id_in;
	end
	assign load_new_group = loop_group_id_in != prev_group_id;
	
	generate
	for (genvar g = 0 ; g< MAX_GROUPS; g=g+1) begin
        always @(posedge clk) begin
           if(reset) begin
               counter[g] <= 'd0;
           end
           else begin
               counter[g] <=  block_done ? 'd0 : (( cfg_addr_stride_v &&  g == cfg_loop_group_id_in )? counter[g] +'d1 : counter[g]) ;
           end
        end
	end
	endgenerate
	
    for (genvar g = 0 ; g< MAX_GROUPS; g=g+1) begin
        for (genvar l = 0 ; l< NUM_MAX_LOOPS; l=l+1) begin
            always @(posedge clk) begin
                if(reset) begin
                    group_loop_stride[g][l] <= 'd0;
                end
                else if( cfg_addr_stride_v ) begin
                    group_loop_stride[g][l] <= (l == counter[g] && g == cfg_loop_group_id_in ) ? cfg_addr_stride : group_loop_stride[g][l] ;
                end
            end

        end
	end

//=============================================================

	always @(posedge clk) begin
        if(reset)
            loop_done <= 1'b0;
        else if (start)
            loop_done <= 1'b0;
        else if(iter_done[0])
            loop_done <= 1'b1;
    end
    assign done = iter_done_d; // DEBUG iter_done && ~loop_done;

    always @(posedge clk) begin
        stall_d <= stall;
        if (reset)
            addr_gen_valid <= 1'b0;
        else if (start_d)
            addr_gen_valid <= 1'b1;
        else if(iter_done[0] && ~stall) // DEBUG
            addr_gen_valid <= 1'b0;
    end
    
    wire stall_final;
    assign stall_final = isBase ? stall_d : stall;

    assign addr_out_valid_d = (addr_gen_valid  && ~stall_final);
    //assign addr_out_valid_d = addr_gen_valid && ~stall; // rohan added

    generate
    for(genvar i=0; i < NUM_MAX_LOOPS; i=i+1) begin
        always @(*) begin
            if (start_d || iter_done[0] || base_addr_v) begin
                loop_address[i] = base_addr;
            end else if( load_new_group ) begin
                loop_address[i] = group_curr_address[loop_group_id_in][i];
            end else if (~stall) begin
                if (iter_done[i]) begin
                    loop_address[i] = (i == 0) ? 'd0 : loop_address[i-1];
                end else if (iter_done[i+1]) begin
                    loop_address[i] = loop_address_d[i] + group_loop_stride[loop_group_id_in][i];
                end else 
                    loop_address[i] = loop_address_d[i];
            end else begin
                loop_address[i] = loop_address_d[i];
            end
        end
        
        always @(posedge clk) begin
            //if ( load_new_group || base_addr_v ||(~loop_done && ~stall_d))      // rohan: make stall_d instead of stall;
            if ( load_new_group || base_addr_v || (~loop_done && ~stall))
                loop_address_d[i] <= loop_address[i];
        end
        
    end
    endgenerate
    
    generate
    for(genvar l =0 ; l < NUM_MAX_LOOPS ; l = l +1) begin
        for(genvar g = 0 ; g < MAX_GROUPS ; g = g+1) begin
            always @(posedge clk) begin
                if(reset) begin
                    group_curr_address[g][l] <= base_addr;
                end
                else if(load_new_group || done) begin
                    group_curr_address[g][l] <= (g == prev_group_id) ? loop_address_d[l] : group_curr_address[g][l];
                end
            end
        end
    end
    endgenerate
    
    assign addr_out_d = loop_address_d[NUM_MAX_LOOPS-1];

    //register_sync #(1) addr_out_valid_reg (clk, reset, addr_out_valid_d, addr_out_valid);
    //register_sync #(ADDR_WIDTH) addr_out_reg (clk, reset, addr_out_d, addr_out);
    assign addr_out = addr_out_d;
    assign addr_out_valid = addr_out_valid_d;
 /*   
 ila_0 simd_ila (
  .clk(clk),
  // 1 bit width
  .probe0(cfg_addr_stride_v),
  .probe1(block_done),
  .probe2(),
  .probe3(),
  .probe4(0),
  .probe5(0),
  // 8 bit width
  .probe6(),
  .probe7(iter_done),
  .probe8({4'b0,counter[0][3:0]}),
  .probe9(loop_done),
  .probe10(0),
  // 32 bit width
  .probe11({group_loop_stride[0][2][15:0],group_loop_stride[0][1][15:0]}),
  .probe12(0),
  .probe13(0),
  .probe14(0),
  .probe15(0),
  .probe16(0),
  .probe17(0),
  .probe18(0),
  .probe19(0)
  );
*/

endmodule
