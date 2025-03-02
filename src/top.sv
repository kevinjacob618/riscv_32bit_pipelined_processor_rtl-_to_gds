typedef struct packed {
    logic [31:0] PCF;
    logic MemWriteM;
    logic [31:0] ALUResultM, WriteDataM, ReadDataM, InstrD, InstrF;
    logic [1:0] ForwardAE, ForwardBE;
    logic StallD, StallF, FlushD, FlushE;
} cpu_outputs_t;

module top(
    input logic clk, reset,
    input logic [6:0] Op,
    input logic [2:0] funct3,
    output cpu_outputs_t cpu_out
);

    logic ALUSrcAE, RegWriteM, RegWriteW, ZeroE, SignE, PCJalSrcE, PCSrcE, RegWriteE;
    logic [1:0] ALUSrcBE;
    logic ResultSrcE0;
    logic [1:0] ResultSrcW; 
    logic [2:0] ImmSrcD;
    logic [3:0] ALUControlE;
    logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E;
    logic [4:0] RdE, RdM, RdW;

    logic [31:0] alignedALUResultM;
    assign alignedALUResultM = cpu_out.ALUResultM & 32'hFFFFFFFC;

    controller c(
        .clk(clk), 
        .reset(reset), 
        .Op(Op),
        .funct3(funct3),
        .InstrD(cpu_out.InstrD),
        .ZeroE(ZeroE), 
        .SignE(SignE), 
        .FlushE(cpu_out.FlushE),
        .ResultSrcE0(ResultSrcE0), 
        .ResultSrcW(ResultSrcW), 
        .MemWriteM(cpu_out.MemWriteM),
        .PCJalSrcE(PCJalSrcE), 
        .PCSrcE(PCSrcE), 
        .ALUSrcAE(ALUSrcAE), 
        .ALUSrcBE(ALUSrcBE),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW), 
        .ImmSrcD(ImmSrcD), 
        .ALUControlE(ALUControlE)
    );

    hazardunit h(
        .Rs1D(Rs1D), 
        .Rs2D(Rs2D), 
        .Rs1E(Rs1E), 
        .Rs2E(Rs2E), 
        .RdE(RdE), 
        .RdM(RdM), 
        .RdW(RdW),
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW), 
        .ResultSrcE0(ResultSrcE0), 
        .PCSrcE(PCSrcE), 
        .ForwardAE(cpu_out.ForwardAE), 
        .ForwardBE(cpu_out.ForwardBE),
        .StallD(cpu_out.StallD), 
        .StallF(cpu_out.StallF), 
        .FlushD(cpu_out.FlushD), 
        .FlushE(cpu_out.FlushE)
    );

    datapath dp(
        .clk(clk), 
        .reset(reset), 
        .ResultSrcW(ResultSrcW), 
        .PCJalSrcE(PCJalSrcE), 
        .PCSrcE(PCSrcE), 
        .ALUSrcAE(ALUSrcAE), 
        .ALUSrcBE(ALUSrcBE), 
        .RegWriteW(RegWriteW), 
        .ImmSrcD(ImmSrcD), 
        .ALUControlE(ALUControlE),
        .ZeroE(ZeroE), 
        .SignE(SignE), 
        .PCF(cpu_out.PCF), 
        .InstrF(cpu_out.InstrF), 
        .InstrD(cpu_out.InstrD), 
        .ALUResultM(cpu_out.ALUResultM), 
        .WriteDataM(cpu_out.WriteDataM), 
        .ReadDataM(cpu_out.ReadDataM), 
        .ForwardAE(cpu_out.ForwardAE), 
        .ForwardBE(cpu_out.ForwardBE), 
        .Rs1D(Rs1D), 
        .Rs2D(Rs2D), 
        .Rs1E(Rs1E), 
        .Rs2E(Rs2E), 
        .RdE(RdE), 
        .RdM(RdM), 
        .RdW(RdW), 
        .StallD(cpu_out.StallD), 
        .StallF(cpu_out.StallF), 
        .FlushD(cpu_out.FlushD), 
        .FlushE(cpu_out.FlushE)
    );

    dmem dmem(
        .clk(clk), 
        .we(cpu_out.MemWriteM), 
        .a(alignedALUResultM), 
        .wd(cpu_out.WriteDataM), 
        .rd(cpu_out.ReadDataM)
    );

    imem imem(
        .a(cpu_out.PCF), 
        .rd1(cpu_out.InstrF)
    );

    initial begin
        $display("Memory initialized for simulation.");
    end

    always @(posedge clk) begin
        if (cpu_out.MemWriteM) begin
            $display("Writing data %h to address %h at time %0t", cpu_out.WriteDataM, cpu_out.ALUResultM, $time);
        end
    end

endmodule
