module imem(
    input logic [31:0] a,
    output logic [31:0] rd1
);
    logic [7:0] RAM[127:0]; // 128-byte instruction memory (byte-addressable)

    // Combinational instruction fetch
    always_comb begin
        if (^a === 1'bX || ^a === 1'bZ) begin
            rd1 = 32'h00000013; // Return NOP for uninitialized address
            $display("Error: Invalid Address (X/Z) at Time=%0t | Address=%h", $time, a);
        end else if (a[1:0] != 2'b00) begin
            rd1 = 32'h00000013; // Return NOP for misaligned access
            $display("Warning: Misaligned Address at Time=%0t | Address=%h", $time, a);
        end else if (a >= 0 && a < 128) begin
            rd1 = {RAM[a + 3], RAM[a + 2], RAM[a + 1], RAM[a]};
        end else begin
            rd1 = 32'h00000013; // Return NOP for out-of-bounds access
            $display("Warning: Address Out of Bounds at Time=%0t | Address=%h", $time, a);
        end
    end

    // Memory Initialization
    initial begin
        integer i;
        for (i = 0; i < 128; i = i + 1) begin
            RAM[i] = 8'h00;
        end

        // Preloaded Instructions (Little-Endian Order)
        
        // ADDI x1, x0, 15  (Immediate ALU)
        RAM[0]  = 8'h93; RAM[1]  = 8'h00; RAM[2]  = 8'hf0; RAM[3]  = 8'h00; 
        
        // ADDI x2, x1, 22  (Immediate ALU)
        RAM[4]  = 8'h13; RAM[5]  = 8'h01; RAM[6]  = 8'h60; RAM[7]  = 8'h01; 
        
        // ADD x3, x1, x2  (Register ALU)
        RAM[8]  = 8'hb3; RAM[9]  = 8'h81; RAM[10] = 8'h20; RAM[11] = 8'h00; 
        
        // SUB x4, x2, x1  (Register ALU)
        RAM[12] = 8'h33; RAM[13] = 8'h01; RAM[14] = 8'h11; RAM[15] = 8'h40; 
        
        // AND x5, x1, x2  (Register ALU)
        RAM[16] = 8'hb3; RAM[17] = 8'h01; RAM[18] = 8'h61; RAM[19] = 8'h00; 
        
        // OR x6, x2, x3  (Register ALU)
        RAM[20] = 8'hb3; RAM[21] = 8'h81; RAM[22] = 8'h72; RAM[23] = 8'h00; 
        
        // XOR x7, x3, x1  (Register ALU)
        RAM[24] = 8'hb3; RAM[25] = 8'h01; RAM[26] = 8'h43; RAM[27] = 8'h00; 
        
        // SLL x8, x1, x2  (Register ALU)
        RAM[28] = 8'h33; RAM[29] = 8'h81; RAM[30] = 8'h10; RAM[31] = 8'h00; 
        
        // SRL x9, x3, x2  (Register ALU)
        RAM[32] = 8'h33; RAM[33] = 8'h81; RAM[34] = 8'h52; RAM[35] = 8'h00; 
        
        // SRA x10, x4, x1 (Register ALU)
        RAM[36] = 8'h33; RAM[37] = 8'h01; RAM[38] = 8'h5a; RAM[39] = 8'h40; 
        
        // SLT x11, x1, x2 (Set Less Than - Signed)
        RAM[40] = 8'hb3; RAM[41] = 8'h01; RAM[42] = 8'h20; RAM[43] = 8'h00; 
        
        // BEQ x1, x2, 8 (Branch Equal)
        RAM[44] = 8'h63; RAM[45] = 8'h02; RAM[46] = 8'h10; RAM[47] = 8'h00; 
        
        // BNE x2, x3, 12 (Branch Not Equal)
        RAM[48] = 8'h63; RAM[49] = 8'h12; RAM[50] = 8'h21; RAM[51] = 8'h00; 
        
        // BLT x3, x4, 16 (Branch Less Than - Signed)
        RAM[52] = 8'h63; RAM[53] = 8'h42; RAM[54] = 8'h30; RAM[55] = 8'h00; 
        
        // BGE x4, x5, 20 (Branch Greater or Equal - Signed)
        RAM[56] = 8'h63; RAM[57] = 8'h52; RAM[58] = 8'h41; RAM[59] = 8'h00; 
        
        // JAL x6, 24 (Jump and Link)
        RAM[60] = 8'h6f; RAM[61] = 8'h00; RAM[62] = 8'hc0; RAM[63] = 8'h00; 
        
        // JALR x7, x6, 0 (Jump and Link Register)
        RAM[64] = 8'h67; RAM[65] = 8'h00; RAM[66] = 8'hb0; RAM[67] = 8'h00; 
        
        // LUI x8, 0x10000 (Load Upper Immediate)
        RAM[68] = 8'hb7; RAM[69] = 8'h00; RAM[70] = 8'h00; RAM[71] = 8'h10; 
        
        // AUIPC x9, 0x10000 (Add Upper Immediate to PC)
        RAM[72] = 8'h97; RAM[73] = 8'h00; RAM[74] = 8'h00; RAM[75] = 8'h10; 

        // Print memory initialization
        $display("Memory Initialized:");
        for (i = 0; i < 32; i = i + 4) begin
            $display("Memory[%0d]: %h", i, {RAM[i + 3], RAM[i + 2], RAM[i + 1], RAM[i]});
        end
    end
endmodule
