`timescale 1ns / 1ps

module c_IEx_IM (
    input logic clk, reset,
    input logic RegWriteE, MemWriteE,
    input logic [1:0] ResultSrcE,  
    output logic RegWriteM, MemWriteM,
    output logic [1:0] ResultSrcM
);

    always_ff @(posedge clk,posedge reset) begin
        if (reset) begin
            RegWriteM  <= 1'b0;
            MemWriteM  <= 1'b0;
            ResultSrcM <= 2'b00; // Explicitly initialize 2-bit signal
        end else begin
            RegWriteM  <= RegWriteE;
            MemWriteM  <= MemWriteE;
            ResultSrcM <= ResultSrcE; 
        end
    end

endmodule

