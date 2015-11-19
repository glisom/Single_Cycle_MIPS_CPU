-- hds header_start
--
-- VHDL Entity mips_lib.mips_single_cycle.symbol
--
-- Created:
--          by - aly.UNKNOWN (PANG314A)
--          at - 23:38:29 05/02/2011
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.ALL;


ENTITY mips_single_cycle IS
   PORT(
      clk : IN     std_logic;
      rst : IN     std_logic
   );
END mips_single_cycle ;


ARCHITECTURE struct OF mips_single_cycle IS

   -- Internal signal declarations
   SIGNAL ALUOp                                       : std_logic_vector(1 DOWNTO 0);
   SIGNAL ALUSrc                                      : std_logic;
   SIGNAL ALU_control                                 : std_logic_vector(3 DOWNTO 0);
   SIGNAL ALU_result                                  : std_logic_vector(31 DOWNTO 0);
   SIGNAL Branch                                      : std_logic;
   SIGNAL Instruction                                 : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_15_0_Sign_Extended              : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_15_0_Sign_Extended_Left_Shifted : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_25_0_Left_Shifted               : std_logic_vector(27 DOWNTO 0);
   SIGNAL Jump                                        : std_logic;
   SIGNAL MemRead                                     : std_logic;
   SIGNAL MemToReg                                    : std_logic;
   SIGNAL MemWrite                                    : std_logic;
   SIGNAL PC                                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL PC_icremented                               : std_logic_vector(31 DOWNTO 0);
   SIGNAL PC_next                                     : std_logic_vector(31 DOWNTO 0);
   SIGNAL RegDst                                      : std_logic;
   SIGNAL RegWrite                                    : std_logic;
   SIGNAL adder_second_result                         : std_logic_vector(31 DOWNTO 0);
   SIGNAL alu_second_operand                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL branch_when_equal                           : std_logic;
   SIGNAL dm_ReadData                                 : std_logic_vector(31 DOWNTO 0);
   SIGNAL jump_address                                : std_logic_vector(31 DOWNTO 0);
   SIGNAL mux_second_i3_output                        : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_ReadData_1                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_ReadData_2                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_WriteAddr                           : std_logic_vector(4 DOWNTO 0);
   SIGNAL regfile_WriteData                           : std_logic_vector(31 DOWNTO 0);
   SIGNAL zero                                        : std_logic;


   -- Component Declarations
   COMPONENT ALU
   PORT (
      A           : IN     std_logic_vector (31 DOWNTO 0);
      ALU_control : IN     std_logic_vector (3 DOWNTO 0);
      B           : IN     std_logic_vector (31 DOWNTO 0);
      ALU_result  : OUT    std_logic_vector (31 DOWNTO 0);
      zero        : OUT    std_logic
   );
   END COMPONENT;

   COMPONENT ALU_controller
   PORT (
      ALU_op      : IN     std_logic_vector (1 DOWNTO 0);
      funct       : IN     std_logic_vector (5 DOWNTO 0);
      ALU_control : OUT    std_logic_vector (3 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT DM
   PORT (
      Address   : IN     std_logic_vector (31 DOWNTO 0);
      MemRead   : IN     std_logic ;
      MemWrite  : IN     std_logic ;
      WriteData : IN     std_logic_vector (31 DOWNTO 0);
      clk       : IN     std_logic ;
      rst       : IN     std_logic ;
      ReadData  : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT First_Shift_Left_2
   PORT (
      Instruction_25_0              : IN     std_logic_vector (25 DOWNTO 0);
      Instruction_25_0_Left_Shifted : OUT    std_logic_vector (27 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT IM
   PORT (
      ReadAddress : IN     std_logic_vector (31 DOWNTO 0);
      rst         : IN     std_logic ;
      Instruction : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT Main_Control_Unit
   PORT (
      Instruction_31_26 : IN     std_logic_vector (5 DOWNTO 0);
      ALUOp             : OUT    std_logic_vector (1 DOWNTO 0);
      ALUSrc            : OUT    std_logic ;
      Branch            : OUT    std_logic ;
      Jump              : OUT    std_logic ;
      MemRead           : OUT    std_logic ;
      MemToReg          : OUT    std_logic ;
      MemWrite          : OUT    std_logic ;
      RegDst            : OUT    std_logic ;
      RegWrite          : OUT    std_logic
   );
   END COMPONENT;

   COMPONENT PC_register
   PORT (
      PC_next : IN     std_logic_vector (31 DOWNTO 0);
      clk     : IN     std_logic ;
      rst     : IN     std_logic ;
      PC      : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT RegFile
   PORT (
      ReadAddr_1 : IN     std_logic_vector (4 DOWNTO 0);
      ReadAddr_2 : IN     std_logic_vector (4 DOWNTO 0);
      RegWrite   : IN     std_logic ;
      WriteAddr  : IN     std_logic_vector (4 DOWNTO 0);
      WriteData  : IN     std_logic_vector (31 DOWNTO 0);
      clk        : IN     std_logic ;
      rst        : IN     std_logic ;
      ReadData_1 : OUT    std_logic_vector (31 DOWNTO 0);
      ReadData_2 : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT Second_Shift_Left_2
   PORT (
      Instruction_15_0_Sign_Extended              : IN     std_logic_vector (31 DOWNTO 0);
      Instruction_15_0_Sign_Extended_Left_Shifted : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT adder_first
   PORT (
      PC            : IN     std_logic_vector (31 DOWNTO 0);
      PC_icremented : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT adder_second
   PORT (
      A          : IN     std_logic_vector (31 DOWNTO 0);
      B          : IN     std_logic_vector (31 DOWNTO 0);
      add_result : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT mux_first
   PORT (
      instruction_15_11 : IN     std_logic_vector (4 DOWNTO 0);
      instruction_20_16 : IN     std_logic_vector (4 DOWNTO 0);
      sel               : IN     std_logic ;
      output            : OUT    std_logic_vector (4 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT mux_second
   PORT (
      input_0 : IN     std_logic_vector (31 DOWNTO 0);
      input_1 : IN     std_logic_vector (31 DOWNTO 0);
      sel     : IN     std_logic ;
      output  : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT sign_extend
   PORT (
      Instruction_15_0               : IN     std_logic_vector (15 DOWNTO 0);
      Instruction_15_0_Sign_Extended : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;


BEGIN
-- Branch When Equal
branch_when_equal <= zero AND Branch;
jump_address <= PC_icremented(31 downto 28) & Instruction_25_0_Left_Shifted; 
-- output of adder one and Instruction_25_0_Left_Shifted 

-- ALU
alu1 : ALU Port Map (regfile_ReadData_1, ALU_control, alu_second_operand, ALU_result, zero);
-- ALU Control
ALU_Control1 : ALU_controller Port Map (ALUOp, Instruction(5 downto 0), ALU_control);
-- DM
dm_i1 : DM Port Map (ALU_result, MemRead, MemWrite, regfile_ReadData_2, clk, rst, dm_ReadData);
-- First Shift Left 2
FSL2 : First_Shift_Left_2 Port Map (Instruction(25 downto 0), Instruction_25_0_Left_Shifted);
-- IM
im_i1 : IM Port Map (PC, rst, Instruction);
-- Main Control Unit
Main_Cntrl_Unit : Main_Control_Unit Port Map (Instruction(31 downto 26), ALUOp, ALUSrc, Branch, Jump, MemRead, MemToReg, MemWrite, RegDst, RegWrite);
-- PC Register
PC_Reg : PC_Register Port Map (PC_next, clk, rst, PC);
-- Register File
regfile_i1 : RegFile Port Map (Instruction(25 downto 21), Instruction(20 downto 16), RegWrite, regfile_WriteAddr, regfile_WriteData, clk, rst, regfile_ReadData_1, regfile_ReadData_2);
-- Second Shift Left 2
SSL2 : Second_Shift_Left_2 Port Map (Instruction_15_0_Sign_Extended, Instruction_15_0_Sign_Extended_Left_Shifted);
-- Adder First
Adder_First1 : adder_first Port Map (PC, PC_icremented);
-- Adder Second
Adder_Second1 : adder_second Port Map (PC_icremented, Instruction_15_0_Sign_Extended_Left_Shifted, adder_second_result);
-- Mux First
Mux_First1 : mux_first Port Map (Instruction(15 downto 11), Instruction(20 downto 16), RegDst, regfile_WriteAddr);
-- Mux Second
Mux_Second1 : mux_second Port Map (regfile_ReadData_2, Instruction_15_0_Sign_Extended, ALUSrc, alu_second_operand);
-- Mux Third
Mux_Third : mux_second Port Map (ALU_result, dm_ReadData, MemToReg, regfile_WriteData);
-- Mux Forth
Mux_Fourth : mux_second Port Map (PC_icremented, adder_second_result, branch_when_equal, mux_second_i3_output);
-- Mux Fifth
Mux_Fifth : mux_second Port Map (mux_second_i3_output, jump_address, jump, PC_next);
-- Sign Extend
sign_extend1 : sign_extend Port Map (Instruction(15 downto 0), Instruction_15_0_Sign_Extended);

END struct;
