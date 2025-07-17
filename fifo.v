`timescale 1ns / 1ps

module fifo #(
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 64, 
    parameter ALMOST_FULL_THRESH = 56,
    parameter ALMOST_EMPTY_THRESH = 8
)(
    input                   clk,
    input                   rst_n,        
    input                   wr_en,
    input  [DATA_WIDTH-1:0] wr_data,
    input                   rd_en,
    output reg [DATA_WIDTH-1:0] rd_data,
    output                  full,
    output                  empty,
    output                  almost_full,
    output                  almost_empty,
    output                  overflow_err,
    output                  underflow_err,
    output [DATA_WIDTH-1:0] fifo_count
);

    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value-1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction
    localparam ADDR_WIDTH = clog2(DEPTH);

    // Memory declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH-1:0] write_pointer;    
    reg [ADDR_WIDTH-1:0] read_pointer;     
    reg [clog2(DEPTH+1)-1:0] count;        

    reg overflow_flag, underflow_flag;

    assign full         = (count == DEPTH);
    assign empty        = (count == 0);
    assign almost_full  = (count >= ALMOST_FULL_THRESH);
    assign almost_empty = (count <= ALMOST_EMPTY_THRESH);
    assign overflow_err = overflow_flag;
    assign underflow_err= underflow_flag;
    assign fifo_count   = count;

    // Write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pointer <= 0;
        end else if (wr_en) begin
            if (!full) begin
                mem[write_pointer] <= wr_data;
                write_pointer <= write_pointer + 1'b1;
            end else begin
                overflow_flag <= 1'b1;
            end
        end
    end

    // Read logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_pointer <= 0;
            rd_data <= 0;
        end else if (rd_en) begin
            if (!empty) begin
                rd_data <= mem[read_pointer];
                read_pointer <= read_pointer + 1'b1;
            end else begin
                underflow_flag <= 1'b1;
            end
        end
    end

    // counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1'b1; 
                2'b01: count <= count - 1'b1;
                default: count <= count;      
            endcase
        end
    end

    // overflow and underflow flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            overflow_flag  <= 1'b0;
            underflow_flag <= 1'b0;
        end else begin
            if (overflow_flag && rd_en && !empty)
                overflow_flag <= 1'b0;

            if (underflow_flag && wr_en && !full)
                underflow_flag <= 1'b0;
        end
    end

endmodule
