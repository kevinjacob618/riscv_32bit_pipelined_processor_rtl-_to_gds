module hazardunit(
    input logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
    input logic [4:0] RdE, RdM, RdW,
    input logic  RegWriteM, RegWriteW,
    input logic ResultSrcE0, PCSrcE,
    output logic [1:0] ForwardAE, ForwardBE,
    output logic StallD, StallF, FlushD, FlushE
);

// RAW Hazard Handling (Forwarding)
always_comb begin
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;
    
    if ((Rs1E == RdM) && RegWriteM && (Rs1E != 0))
        ForwardAE = 2'b10; // Forward from Memory Stage
    else if ((Rs1E == RdW) && RegWriteW && (Rs1E != 0))
        ForwardAE = 2'b01; // Forward from WriteBack Stage
    
    if ((Rs2E == RdM) && RegWriteM && (Rs2E != 0))
        ForwardBE = 2'b10; // Forward from Memory Stage
    else if ((Rs2E == RdW) && RegWriteW && (Rs2E != 0))
        ForwardBE = 2'b01; // Forward from WriteBack Stage
end

// Load-Use Hazard Detection (Stalling)
logic lwStall;
assign lwStall = (ResultSrcE0 == 1) && ((RdE == Rs1D && Rs1D != 0) || (RdE == Rs2D && Rs2D != 0));

// Stall Fetch & Decode Stages
assign StallF = lwStall;
assign StallD = lwStall;

// Flush Execute Stage when necessary (Load-Use or Control Hazard)
assign FlushE = lwStall | PCSrcE;
assign FlushD = PCSrcE;

endmodule
