`timescale 1ns / 1ps

module c_IM_IW (
    input logic clk, reset, 
    input logic RegWriteM, 
    input logic [1:0] ResultSrcM, 
    output logic RegWriteW, 
    output logic [1:0] ResultSrcW
);

    always_ff @(posedge clk,posedge reset) begin
        if (reset) begin
            RegWriteW  <= 1'b0;
            ResultSrcW <= 2'b00;  // Initialize to 2-bit signal
        end else begin
            RegWriteW  <= RegWriteM;
            ResultSrcW <= ResultSrcM;  // Pass control signal from MEM to WB stage
        end
    end

endmodule
