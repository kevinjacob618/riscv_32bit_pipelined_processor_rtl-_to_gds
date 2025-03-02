`timescale 1ns / 1ps


module c_ID_IEx (
    input logic clk, reset, clear,
    input logic RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcAD,
    input logic [1:0] ALUSrcBD,
    input logic [1:0] ResultSrcD, 
    input logic [3:0] ALUControlD,  
    output logic RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcAE,
    output logic [1:0] ALUSrcBE,
    output logic [1:0] ResultSrcE,
    output logic [3:0] ALUControlE
);

always_ff @(posedge clk,posedge reset) begin
    if (reset ) begin  
        RegWriteE   <= 1'b0;
        MemWriteE   <= 1'b0;
        JumpE       <= 1'b0;
        BranchE     <= 1'b0; 
        ALUSrcAE    <= 1'b0;
        ALUSrcBE    <= 2'b00;  
        ResultSrcE  <= 2'b00;  
        ALUControlE <= 4'b0000;   
    end 
    else if (clear)  begin
        RegWriteE   <= 1'b0;
        MemWriteE   <= 1'b0;
        JumpE       <= 1'b0;
        BranchE     <= 1'b0; 
        ALUSrcAE    <= 1'b0;
        ALUSrcBE    <= 2'b00;  
        ResultSrcE  <= 2'b00;  
        ALUControlE <= 4'b0000;
      end
    else begin
        RegWriteE   <= RegWriteD;
        MemWriteE   <= MemWriteD;
        JumpE       <= JumpD;
        BranchE     <= BranchD; 
        ALUSrcAE    <= ALUSrcAD;
        ALUSrcBE    <= ALUSrcBD;
        ResultSrcE  <= ResultSrcD;
        ALUControlE <= ALUControlD;   
    end
end

endmodule

