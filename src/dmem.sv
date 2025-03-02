module dmem(input logic clk, we, 
            input logic [31:0] a, wd, 
            output logic [31:0] rd);
    
    logic [31:0] RAM[63:0]; // 64 x 32-bit memory

    // Initialize memory to zeros (or load from a file)
    initial begin
        integer i;
        for (i = 0; i < 64; i = i + 1) begin
            RAM[i] = 32'b0; // Initialize with zeros, or use $readmemh for initialization
        end
    end
    
    // Combined read and write logic to avoid multiple drivers on 'rd'
    always_ff @(posedge clk) begin
        if (we) begin
            $display("Writing data %h to address %h", wd, a);
            RAM[a[31:2]] <= wd;
        end
        rd <= RAM[a[31:2]]; // Read happens on every clock cycle
        $display("Reading data %h from address %h", rd, a);
    end

endmodule
