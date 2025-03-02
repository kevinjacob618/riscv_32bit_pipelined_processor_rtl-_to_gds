`timescale 1ns / 1ps

module flopenr (
    input logic clk, reset, en,
    input logic [31:0] d,
    output logic [31:0] q
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            q <= 32'h00000000;
            $display("Resetting PCF to 0");
        end else if (en) begin
            q <= d;
            $display("Updating PCF to %h at time %0t", d, $time);

            // Check for PC word alignment (PC must be a multiple of 4)
            if (d % 4 != 0) begin
               $fatal(0, "Error message"); // Use 0, 1, or 2 as the first argument

            end
        end else begin
            $display("PCF remains %h at time %0t (Stalled)", q, $time);
        end
    end

endmodule
