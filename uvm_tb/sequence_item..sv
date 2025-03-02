`include "uvm_macros.svh"
import uvm_pkg::*;
  

 class risc_sequence_item extends uvm_sequence_item;

function new(string name = "risc_sequence_item");
  super.new(name);
  endfunction

    //inputs
   rand logic reset;
   rand bit [6:0] Op;
   rand bit [2:0] funct3;

    //outputs
     logic [31:0] PCF;
     logic MemWriteM;
     logic [31:0] ALUResultM, WriteDataM;
     logic [31:0] ReadDataM;
     logic [31:0] InstrF; 


    //auxillary fields
   rand instr_type inst_type;
   bit lwstall;
   bit beqflush;   

    `uvm_object_utils_begin(risc_sequence_item)
     `uvm_field_int (reset, UVM_DEFAULT)
     `uvm_field_int (Op, UVM_DEFAULT)
     `uvm_field_int (funct3, UVM_DEFAULT)
     `uvm_field_int (MemWriteM, UVM_DEFAULT)
     `uvm_field_int (ALUResultM, UVM_DEFAULT)
     `uvm_field_int (WriteDataM, UVM_DEFAULT)
     `uvm_field_int (lwstall    , UVM_DEFAULT)
     `uvm_field_int (beqflush   , UVM_DEFAULT)
     `uvm_field_enum(instr_type , inst_type , UVM_DEFAULT) 
     `uvm_object_utils_end
     
constraint opcode_range {Op inside {lw, imm,
                                               auipc, sw, 
                                               arith, lui,
                                               brnch, jalr,
                                               jal}; } ;   // op_code in the range of the supported instructions only 

  //constraint opcode_dist {InstrF[6:0] dist{lw:=1, imm:=3, auipc:=1, sw:=1, arith:=2, lui:=1, brnch:=1, jalr:=1, jal:=1}; };
	 
  constraint funct_range { (Op == lw) -> (funct3 == 3'b010) ; // lw funct3 
  
                             
      ((Op == imm) && (funct3 == 3'b101)) -> (InstrF[31:25] inside {7'b0000000, 7'b0100000}) ; // srli and srai funct7  
                              
      ((Op == imm) && (funct3 == 3'b001)) -> (InstrF[31:25] == 7'b0000000) ;// slli funct7  
       
      (Op == imm) -> (funct3 != 3'b011) ; // sltiu is not supported 
       
      (Op == sw) -> (funct3 == 3'b010) ; // sw funct3
                             
      (Op == arith) -> (funct3 inside {add, sll, slt, Xor, srl, Or, And}); // funct3 in range of supported R-type instructions
                             
      ((Op == arith) && (funct3 == add)) -> (InstrF[31:25] inside {7'b0000000, 7'b0100000}); // add and sub funct7
                             
      ((Op == arith) && (funct3==sll || funct3==slt || funct3==Xor || funct3==Or || funct3==And )) -> (InstrF[31:25] == 7'b0000000); 
                             
      ((Op == arith) && (funct3 == sra)) -> (InstrF[31:25] inside {7'b0100000, 7'b0000000}); // sra and srl funct7  
                             
      (Op == brnch) -> (funct3 inside {beq, bne, blt, bge}); // funct3 in range of supported branch instructions 
                             
      (Op == jalr) -> (funct3 == 3'b000); // jalr funct3
					
      ((Op != sw) && (Op != brnch)) -> (InstrF[11:7] != 0) ; // rd is not equal to 0                    
                             } ;
  
  constraint reset_dist {reset dist{1:=1 , 0:=100000}; };
  
   function void Reset();
        Op         = 7'b0;
        funct3     = 3'b0;
        PCF        = 32'b0;
        MemWriteM  = 1'b0;
        ALUResultM = 32'b0;
        WriteDataM = 32'b0;
        ReadDataM  = 32'b0;
        InstrF     = 32'b0;
        lwstall    = 1'b0;
        beqflush   = 1'b0;
        inst_type  = RESET;
      endfunction
      
      // Get Instruction type function  
      function Get_type ;
        case (Op)  
          
          lw    : inst_type = LW    ;
          sw    : inst_type = SW    ;
          lui   : inst_type = LUI   ;
          auipc : inst_type = AUIPC ;
          jalr  : inst_type = JALR  ;
          jal   : inst_type = JAL   ;
          
          imm : begin 
            case(funct3)     
            3'b000 : inst_type = ADDI ;
            3'b001 : inst_type = SLLI ;
            3'b010 : inst_type = SLTI ;
            3'b100 : inst_type = XORI ;
            3'b110 : inst_type = ORI  ; 
            3'b111 : inst_type = ANDI ;    
            3'b101 : begin 
              if (InstrF[30] == 0) inst_type = SRLI ;
              else inst_type = SRAI ;
             end
            endcase 
          end
          
          arith : begin 
            case(funct3)     
            3'b001 : inst_type = SLL ;
            3'b010 : inst_type = SLT ;
            3'b100 : inst_type = XOR ;
            3'b110 : inst_type = OR  ; 
            3'b111 : inst_type = AND ;   
            3'b000 : begin 
              if (InstrF[30] == 0) inst_type = ADD ;
                     else inst_type = SUB ;
                     end
            3'b101 : begin 
              if (InstrF[30] == 0) inst_type = SRL ;
                     else inst_type = SRA ;
                     end  
            endcase   
          end
            
          brnch : begin 
            case(funct3)     
            3'b000 : inst_type = BEQ ;
            3'b001 : inst_type = BNE ;
            3'b100 : inst_type = BLT ;
            3'b101 : inst_type = BGE  ;     
            endcase 
          end 
        default : inst_type = UNKNOWN ; 
        endcase 

      endfunction
  
  
  // Extend Immediate function 
  function [31:0] Extend ;

      case(Op)
        // I-type
        imm, lw, jalr : Extend = {{20{InstrF[31]}}, InstrF[31:20]};
		
        // S-type (stores)
        sw : Extend = {{20{InstrF[31]}}, InstrF[31:25], InstrF[11:7]};
		
        // B-type (branches)
        brnch : Extend = {{20{InstrF[31]}}, InstrF[7], InstrF[30:25], InstrF[11:8], 1'b0};
		
        // J-type (jal)
        jal : Extend = {{12{InstrF[31]}}, InstrF[19:12], InstrF[20], InstrF[30:21], 1'b0};
		
        // U-type
        lui, auipc : Extend = {InstrF[31:12], 12'b0};
		
        default: Extend = 32'bx; // undefined
	endcase  
  endfunction : Extend
  
endclass 
