
`timescale 1ns/1ps

module tb_fifo;

   
    parameter DATA_WIDTH = 16;
    parameter DEPTH = 64;
    parameter ALMOST_FULL_THRESH = 56;
    parameter ALMOST_EMPTY_THRESH = 8;

 
    reg clk;
    reg rst_n;
    reg wr_en;
    reg [DATA_WIDTH-1:0] wr_data;
    reg rd_en;
    wire [DATA_WIDTH-1:0] rd_data;
    wire full, empty, almost_full, almost_empty;
    wire overflow_err, underflow_err;
    wire [DATA_WIDTH-1:0] fifo_count;

   
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ALMOST_FULL_THRESH(ALMOST_FULL_THRESH),
        .ALMOST_EMPTY_THRESH(ALMOST_EMPTY_THRESH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .overflow_err(overflow_err),
        .underflow_err(underflow_err),
        .fifo_count(fifo_count)
    );

   
    initial clk = 0;
    always #5 clk = ~clk;


    initial begin
      
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

     
        #20;
        rst_n = 1;
        #10;

       
        $display("\n--- Filling FIFO ---");
        repeat (DEPTH) begin
            @(negedge clk);
            wr_en = 1;
            wr_data = $random;
            rd_en = 0;
        end
        @(negedge clk);
        wr_en = 0;

    
        $display("\n--- Testing Overflow ---");
        @(negedge clk);
        wr_en = 1;
        wr_data = 16'hBEEF;
        @(negedge clk);
        wr_en = 0;

      
        $display("\n--- Emptying FIFO ---");
        repeat (DEPTH) begin
            @(negedge clk);
            rd_en = 1;
            wr_en = 0;
        end
        @(negedge clk);
        rd_en = 0;

       
        $display("\n--- Testing Underflow ---");
        @(negedge clk);
        rd_en = 1;
        @(negedge clk);
        rd_en = 0;

      
        $display("\n--- Simultaneous Read and Write ---");
        @(negedge clk);
        wr_en = 1;
        rd_en = 1;
        wr_data = 16'h1234;
        @(negedge clk);
        wr_en = 0;
        rd_en = 0;


        #30;
        $finish;
    end

    initial begin
        $display("Time wr_en rd_en wr_data  rd_data  full empty almost_full almost_empty ovf_err unf_err count");
        $monitor("%4t   %b     %b    %h   %h   %b    %b      %b           %b         %b      %b     %d",
            $time, wr_en, rd_en, wr_data, rd_data, full, empty, almost_full, almost_empty, overflow_err, underflow_err, fifo_count);
    end

endmodule

