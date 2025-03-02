module regfile(
    input logic clk,
    input logic we3,
    input logic [4:0] a1, a2, a3,
    input logic [31:0] wd3,
    output logic [31:0] rd1, rd2
);
    logic [31:0] rf[31:0];  // Register file array

    // r0 hardwired to 0
    assign rd1 = (a1 != 0) ? rf[a1] : 32'h0;
    assign rd2 = (a2 != 0) ? rf[a2] : 32'h0;

    // Write logic: write to register only on positive edge and when a3 is not 0
    always_ff @(posedge clk) begin
        if (we3 && a3 != 5'd0) begin
            rf[a3] <= wd3;
        end
    end

    // Initialization: initialize all registers to zero
    initial begin
        for (int i = 0; i < 32; i = i + 1) begin
            rf[i] = 32'h0;
        end
    end
endmodule
