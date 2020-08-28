library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
entity MicroProcessor is
	port(
		reset_SIGNAL     : IN  std_logic;
		interrupt_SIGNAL : IN  STD_LOGIC;
		INPort           : IN  std_logic_vector(15 downto 0);
		OUTPort          : OUT std_logic_vector(15 downto 0);
		clk              : In  std_logic
	);
end entity MicroProcessor;

architecture Arch_MicroProcessor of MicroProcessor is

	component PC_Register is

	port(
		reset, clk                                                                           : IN  std_logic;
		CallSignal, RTISignal, RETSignal, JMP_signal, InterruptSignal, RESETSignal, load_use : IN  std_logic;
		Rdest_value, Mem_value                                                               : IN  std_logic_vector(15 downto 0); -- 16 bits
		InstructionValue                                                                     : IN  STD_LOGIC_VECTOR(15 downto 0);
		instruction_PC                                                                       : OUT std_logic_vector(19 downto 0); --20 bits
		Rdest_c4                                                                             : IN  STD_LOGIC_VECTOR(15 downto 0); --16 bits
		MemoryOf1Out                                                                         : IN  STD_LOGIC_VECTOR(15 downto 0) --16 bits
	);
      end component PC_Register;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	component FD_register is
	port(
		--fd_rst_fall       : in  std_logic;
		--fd_rst            : in  std_logic;
		clk, rst          : in  std_logic;
		Instruction_in    : in  std_logic_vector(15 downto 0);
		Imm_Eff_value     : in  STD_LOGIC_VECTOR(19 downto 0);   -- 20 bits
		PC_in             : in  std_logic_vector(19 downto 0); -- 20 bits
		EN                : in  std_logic;
		Instruction_OUT   : OUT std_logic_vector(15 downto 0);
		Imm_Eff_value_OUT : OUT STD_LOGIC_VECTOR(19 downto 0); --20 bits
		PC_out            : out std_logic_vector(19 downto 0)); -- 20 bits 
      end component FD_register;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT Register_File is
	port(                   -- msh fahem b2a law gatly Imm value ha7otaha feen ?
		Clk, rst, Register_Write : in  std_logic;
		Rdest, Rsrc              : in  std_logic_vector(2 downto 0);  -- anhy registers ely ha3ml el operations 3aleha
		writeData                : in  std_logic_vector(15 downto 0);   -- el data el gayaly mn WB stage
		Rsrc_data, Rdest_data    : out std_logic_vector(15 downto 0);  -- el values bta3et el Registers el hat5osh 3al alu ba3d ma 7atet feha el data
		Rdest_WB                 : in  std_logic_vector(2 downto 0)   -- anhy register el ha7ot fe el writeData el gatly
	);
       end COMPONENT Register_File;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT Control_Unit is
	port(
		SignalInterrupt           : IN  STD_LOGIC;
		SignalReSet               : IN  STD_LOGIC;
		OPcode                    : IN  std_logic_vector(4 downto 0);
                 Imm_EffecativeAdderss     : IN  STD_LOGIC_VECTOR(19 downto 0);  -- size of EA is 20 bits , memory size is 1M
                ALU_Source                : OUT  STD_LOGIC;             
		StackSignal, ALU_Op, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, RegWrite, MemWrite, MemRead : OUT std_logic;
		WB_SGINAL                 : OUT STD_LOGIC_VECTOR(1 downto 0);
		ALU_CONTROL               : OUT STD_LOGIC_VECTOR(3 downto 0);
		CCR_EN                    : OUT STD_LOGIC;
		EA                        : OUT STD_LOGIC_VECTOR(19 downto 0);
		Imm_value                 : OUT STD_LOGIC_VECTOR(15 downto 0);
		JZ_signal, JN_signal, JC_signal, JMP_signal      : OUT STD_LOGIC
	);
end COMPONENT;
	---------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT Hazard_Detection is
	port(
		IF_ID_RS      : IN  std_logic_vector(2 downto 0); --Rsrc_address_c2 (Instr 10 downto 8)
		IF_ID_RD      : IN  std_logic_vector(2 downto 0); --Rdst_address_c2 (Instr 7 downto 5) 
		ID_EX_RD      : IN  std_logic_vector(2 downto 0); --Rdst_address_c3
		ID_EX_WB      : IN  STD_LOGIC_VECTOR(1 downto 0); -- WB_signal when ( LDD or POP ) 
		ALU_Operation : IN  STD_LOGIC;
                Mem_write_c4 , Mem_read_c4 : IN STD_LOGIC;
		Load_Use_Case : OUT STD_LOGIC   -- Happpens when data is ready after memory stage (POP LDD). So we need to stall 1 cycle 
	);
end COMPONENT;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT DE_register is
	port(
		clk, rst                                                                                                                                              : in  std_logic;
               -----------------------------------------------------------------------------------------------------------------------------------------
		Rdest_value                                                                                                                                           : IN  STD_LOGIC_VECTOR(15 downto 0);
		Rsrc_value                                                                                                                                            : IN  STD_LOGIC_VECTOR(15 downto 0);
		Rdest_address                                                                                                                                         : In  STD_LOGIC_VECTOR(2 downto 0);
		Rsrc_address                                                                                                                                          : In  STD_LOGIC_VECTOR(2 downto 0);
		PC_Value                                                                                                                                              : IN  STD_LOGIC_VECTOR(19 downto 0);
		EA                                                                                                                                                    : IN  STD_LOGIC_VECTOR(19 downto 0);
		Imm_value                                                                                                                                             : IN  STD_LOGIC_VECTOR(15 downto 0);
		StackSignal, ALU_Op, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, WriteRegisterSignal, MemWrite, MemRead             : IN  std_logic;
		WB_SGINAL                                                                                                                                             : IN  STD_LOGIC_VECTOR(1 downto 0);
		ALU_CONTROL                                                                                                                                           : IN  STD_LOGIC_VECTOR(3 downto 0);
		CCR_EN                                                                                                                                                : IN  STD_LOGIC;
		JZ, JN, JC, JMP                                                                                                                                       : IN  STD_LOGIC;
		Interrupt, reset                                                                                                                                      : IN  STD_LOGIC;
		ALU_Source                                                                                                                                            : IN  STD_LOGIC;
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		Rdest_valueO                                                                                                                                          : OUT STD_LOGIC_VECTOR(15 downto 0);
		Rsrc_valueO                                                                                                                                           : OUT STD_LOGIC_VECTOR(15 downto 0);
		Rdest_addressO                                                                                                                                        : OUT STD_LOGIC_VECTOR(2 downto 0);
		Rsrc_addressO                                                                                                                                         : OUT STD_LOGIC_VECTOR(2 downto 0);
		PC_ValueO                                                                                                                                             : OUT STD_LOGIC_VECTOR(19 downto 0);
		EAO                                                                                                                                                   : OUT STD_LOGIC_VECTOR(19 downto 0);
		Imm_valueO                                                                                                                                            : OUT STD_LOGIC_VECTOR(15 downto 0);
		StackSignalO, ALU_OpO, CallSignalO, PushSignalO, PopSignalO, InSignalO, OutSignalO, RetSignalO, RT1SignalO, WriteRegisterSignalO, MemWriteO, MemReadO : OUT std_logic;
		WB_SGINALO                                                                                                                                            : OUT STD_LOGIC_VECTOR(1 downto 0);
		ALU_CONTROLO                                                                                                                                          : OUT STD_LOGIC_VECTOR(3 downto 0);
		CCR_ENO                                                                                                                                               : OUT STD_LOGIC;
		JZ_out, JN_out, JC_out, JMP_out                                                                                                                       : OUT STD_LOGIC;
		InterruptO, resetO                                                                                                                                    : OUT STD_LOGIC;
		ALU_SourceO                                                                                                                                           : OUT STD_LOGIC
	);
end COMPONENT DE_register;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
COMPONENT ALU  is port ( 
Op1 : in std_logic_vector (15 downto 0); -- Rsrc  
Op2 : in std_logic_vector(15 downto 0); -- Rdest OR SHIFT AMOUNT -- we add MULTI TO CHOOSE Op2 Is Rdest Value or ShiftAmmount
clk:IN STD_LOGIC; --
ALU_OUTPUT: OUT  STD_LOGIC_VECTOR( 15 downto 0);
ALU_CONTROL : IN STD_LOGIC_VECTOR (3 downto 0);
ZERO_FLAG:OUT STD_LOGIC;
Neg_FLAG:OUT STD_LOGIC;
Carry_FLAG_OUT :OUT STD_LOGIC;
ZERO_FLAGIN:IN STD_LOGIC;
Neg_FLAGIN:IN STD_LOGIC;
Carry_FLAG_IN :IN STD_LOGIC;
RTI: IN STD_LOGIC;
Carry_FLAG_CCR :IN STD_LOGIC
 );
end COMPONENT ALU ;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT CCR_Register is
	port(
		Clk, Carry_Flag, Neg_Flag, Zero_flag : IN  STD_LOGIC;
		Carry_FlagO                                         : OUT STD_LOGIC
	);
end COMPONENT;

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT RTI_FLAGS is
	port(
		Clk, Rst                                           : in  std_logic;
		Interrupt_signal                                   : in  std_logic;
		Carry_Flag, Neg_Flag, Zero_flag     : IN  STD_LOGIC;
		Carry_FlagO, Neg_FlagO, Zero_flagO : OUT STD_LOGIC
	);
end COMPONENT;
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT BranchUnit is
	port(
		Zero_flag, Negative_flag, Carry_flag, JZ, JN, JC, JMP : in  std_logic;
		Sig_jmp                                               : out std_logic
		--Reset_RegisterSignal                                  : out std_logic
	);
end COMPONENT;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT Forwading_Unit is
		port(
			ID_EX_RS             : in  std_logic_vector(2 downto 0);
			ID_EX_RD             : in  std_logic_vector(2 downto 0);
			EX_MEM_RD            : in  std_logic_vector(2 downto 0);
			MEM_WB_RD            : in  std_logic_vector(2 downto 0);
			EX_MEM_WriteRegister : in  STD_LOGIC;
			MEM_WB_WriteRegister : in  STD_LOGIC;
			ForwardA, ForwardB   : out STD_LOGIC_VECTOR(1 downto 0) -- forward A for Rsrc forward B for Rdest
		);

	end COMPONENT;
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT EM_register is
	port(
		--em_rst_fall                                                                                                                                  : in  std_logic;
		--em_rst                                                                                                                                       : in  std_logic;
		clk, rst                                                                                                                                     : in  std_logic;
                --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		Rdest_value                                                                                                                                  : IN  STD_LOGIC_VECTOR(15 downto 0);
		ALU_OUTPUT                                                                                                                                   : IN  STD_LOGIC_VECTOR(15 downto 0);
		Rdest_address                                                                                                                                : In  STD_LOGIC_VECTOR(2 downto 0);
		PC_Value                                                                                                                                     : IN  STD_LOGIC_VECTOR(19 downto 0);
		EA                                                                                                                                           : IN  STD_LOGIC_VECTOR(19 downto 0);
		Imm_value                                                                                                                                    : IN  STD_LOGIC_VECTOR(15 downto 0);
		StackSignal, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, WriteRegisterSignal, MemWrite, MemRead            : IN  std_logic;
		WB_SGINAL                                                                                                                                    : IN  STD_LOGIC_VECTOR(1 downto 0);
		Interrupt, reset                                                                                                                             : IN  STD_LOGIC;
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		Rdest_valueO                                                                                                                                 : OUT STD_LOGIC_VECTOR(15 downto 0);
		ALU_OUTPUTO                                                                                                                                  : OUT STD_LOGIC_VECTOR(15 downto 0);
		Rdest_addressO                                                                                                                               : OUT STD_LOGIC_VECTOR(2 downto 0);
		PC_ValueO                                                                                                                                    : OUT STD_LOGIC_VECTOR(19 downto 0);
		EAO                                                                                                                                          : OUT STD_LOGIC_VECTOR(19 downto 0);
		Imm_valueO                                                                                                                                   : OUT STD_LOGIC_VECTOR(15 downto 0);
		StackSignalO, CallSignalO, PushSignalO, PopSignalO, InSignalO, OutSignalO, RetSignalO, RT1SignalO, WriteRegisterSignalO, MemWriteO, MemReadO : OUT std_logic;
		WB_SGINALO                                                                                                                                   : OUT STD_LOGIC_VECTOR(1 downto 0);
		InterruptO, resetO                                                                                                                           : OUT STD_LOGIC
	);
end COMPONENT EM_register;
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT StackRegister is
		port(
			StackSignal : in  STD_LOGIC;
			Signal_push : in  std_logic;
			Signal_pop  : in  STD_LOGIC;
			Clk, Rst    : in  std_logic;
			X_Address   : out std_logic_vector(19 downto 0));
	end COMPONENT;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	
---------------------------------------------------------------------------------------------------------------------------
COMPONENT Memory is
	port(
		clk     : in  std_logic;
		Mem_write_c4,Mem_read_c4      : in  std_logic;
		PC : in  std_logic_vector(15 downto 0); --20 bits to access 1MB  --16 bits of pc until fixed
		Mem_data_address: in std_logic_vector(15 downto 0);
		datain  : in  std_logic_vector(15 downto 0);
		Inst : out std_logic_vector(15 downto 0);
		dataout : out std_logic_vector(15 downto 0);
		DataOf1 : out STD_LOGIC_VECTOR(15 downto 0);
		Imm_EfffValue : out std_logic_vector(19 downto 0)
		
	
	);
end COMPONENT;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT M_WB_register is
	port(
		--em_rst_fall                                 : in  std_logic;
		--em_rst                                      : in  std_logic;
		clk, rst                                    : in  std_logic;
		Rdest_value                                 : IN  STD_LOGIC_VECTOR(15 downto 0);
		ALU_OUTPUT                                  : IN  STD_LOGIC_VECTOR(15 downto 0);
		Rdest_address                               : In  STD_LOGIC_VECTOR(2 downto 0);
		Imm_value                                   : IN  STD_LOGIC_VECTOR(15 downto 0);
		MemoryDataOut                               : IN  STD_LOGIC_VECTOR(15 downto 0);
		InSignal, OutSignal, WriteRegisterSignal    : IN  std_logic;
		WB_SGINAL                                   : IN  STD_LOGIC_VECTOR(1 downto 0);
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		Rdest_valueO                                : out STD_LOGIC_VECTOR(15 downto 0);
		ALU_OUTPUTO                                 : out STD_LOGIC_VECTOR(15 downto 0);
		Rdest_addressO                              : out STD_LOGIC_VECTOR(2 downto 0);
		Imm_valueO                                  : out STD_LOGIC_VECTOR(15 downto 0);
		MemoryDataOutO                              : OUT STD_LOGIC_VECTOR(15 downto 0);
		InSignalO, OutSignalO, WriteRegisterSignalO : out std_logic;
		WB_SGINALO                                  : out STD_LOGIC_VECTOR(1 downto 0)
	);
end COMPONENT M_WB_register;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT WB_STAGE is
		port(ALU_output   : IN  std_logic_vector(15 downto 0);
		     Rsrc         : IN  std_logic_vector(15 downto 0); -- OR Immediate Value 
		     MEM_OUTPUT   : IN  std_logic_vector(15 downto 0);
		     INPORT_Value : IN  std_logic_vector(15 downto 0);
		     WB_signal    : IN  STD_LOGIC_VECTOR(1 downto 0);
		     Y            : OUT std_logic_vector(15 downto 0)
		    );

	END COMPONENT;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	Component MUX_16 is
		port(
			In1       : IN  STD_LOGIC_VECTOR(15 downto 0);
			In2       : IN  STD_LOGIC_VECTOR(15 downto 0);
			Outt      : OUT STD_LOGIC_VECTOR(15 downto 0);
			Selection : IN  std_logic
		);

	END COMPONENT;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	COMPONENT MUX_2 is
		port(
			In1       : IN  STD_LOGIC_vector(19 downto 0);
			In2       : IN  STD_LOGIC_vector(19 downto 0);
			Outt      : OUT STD_LOGIC_vector(19 downto 0);
			Selection : IN  std_logic
		);

	end COMPONENT;
	------------------------------------------------------------------------------------------------------------------------------------------------------------- 
	COMPONENT MUX_16_4 is
		port(
			In1       : IN  STD_LOGIC_VECTOR(15 downto 0);
			In2       : IN  STD_LOGIC_VECTOR(15 downto 0);
			In3       : IN  STD_LOGIC_VECTOR(15 downto 0);
			Outt      : OUT STD_LOGIC_VECTOR(15 downto 0);
			Selection : IN  std_logic_VECTOR(1 downto 0)
		);

	end COMPONENT;

	-------------------------------------------------------------------------------------------------------------------------------------------------------------Â
	--FirstCycle Signals
	signal Memory_PC_OUT                                                                                                                                                                       : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
	signal StackSignal, ALU_Op, ALU_Source, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, WriteRegisterSignal, MemWrite, MemRead                               : STD_LOGIC                    := '0';
	signal JZ_signal, JN_signal, JC_signal, JMP_signal                                                                                                                                         : STD_LOGIC;
	signal WB_SGINAL                                                                                                                                                                           : STD_LOGIC_VECTOR(1 downto 0);
	signal ALU_Souce_2                                                                                                                                                                         : STD_LOGIC;
	signal ALU_CONTROL                                                                                                                                                                         : STD_LOGIC_VECTOR(3 downto 0);
	signal CCR_EN                                                                                                                                                                              : STD_LOGIC;
	signal PC_INSTRCUTION                                                                                                                                                                      : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
	signal Inst                                                                                                                                                                                : STD_LOGIC_VECTOR(15 downto 0);
	signal Imm_EfffValue                                                                                                                                                                       : std_logic_vector(19 downto 0);
	signal Rdest_value                                                                                                                                                                         : STD_logic_Vector(15 downto 0);
	signal Memory_Output_Value                                                                                                                                                                 : STD_LOGIC_VECTOR(15 downto 0);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	--- 2nd cycle signals
	signal Instr_2                                                                                                                                                                             : STD_LOGIC_VECTOR(15 downto 0);
	signal pc_instr_2                                                                                                                                                                          : STD_LOGIC_VECTOR(19 downto 0);
	signal Imm_eff_2                                                                                                                                                                           : STD_LOGIC_VECTOR(19 downto 0);
	signal Write_back_data                                                                                                                                                                     : STD_LOGIC_VECTOR(15 downto 0);
	signal Rdest_value_c2                                                                                                                                                                      : STD_LOGIC_VECTOR(15 downto 0);
	signal Rsrc_value_c2                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0);
	signal Rdest_value_c2_2                                                                                                                                                                    : STD_LOGIC_VECTOR(15 downto 0);
	signal Rsrc_value_c2_2                                                                                                                                                                     : STD_LOGIC_VECTOR(15 downto 0);
	signal Eff_c2                                                                                                                                                                              : STD_LOGIC_VECTOR(19 downto 0);
	signal Imm_c2                                                                                                                                                                              : STD_LOGIC_VECTOR(15 downto 0);
	signal Load_use                                                                                                                                                                            : STD_LOGIC;
	signal Write_register_Signal                                                                                                                                                               : STD_LOGIC;
	signal dummyRdstAddrs, dummyRsrcAddrs                                                                                                                                                      : STD_LOGIC_VECTOR(2 downto 0);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 3rd cycle signals
	signal Rdest_value_c3                                                                                                                                                                      : STD_LOGIC_VECTOR(15 downto 0);
	signal Rsrc_value_c3                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0);
	signal Rdest_address_c3                                                                                                                                                                    : STD_LOGIC_VECTOR(2 downto 0);
	signal Rsrc_address_c3                                                                                                                                                                     : STD_LOGIC_VECTOR(2 downto 0);
	signal Rdest_value_c3_2                                                                                                                                                                    : STD_LOGIC_VECTOR(15 downto 0);
	signal Rsrc_value_c3_2                                                                                                                                                                     : STD_LOGIC_VECTOR(15 downto 0);
	signal ForwardA, ForwardB                                                                                                                                                                  : STD_LOGIC_VECTOR(1 downto 0);
	signal Rdest_value_c3_3                                                                                                                                                                    : STD_LOGIC_VECTOR(15 downto 0);
	signal pc_instr_c3                                                                                                                                                                         : STD_LOGIC_VECTOR(19 downto 0);
	signal Eff_c3                                                                                                                                                                              : STD_LOGIC_VECTOR(19 downto 0);
	signal Imm_c3                                                                                                                                                                              : STD_LOGIC_VECTOR(15 downto 0);
	signal stackSignal_c3, ALU_Op_c3, CallSignal_c3, PushSignal_c3, PopSignal_c3, InSignal_c3, OutSignal_c3, RetSignal_c3, RT1Signal_c3, WriteRegisterSignal_c3, MemWrite_c3, MemRead_c3       : STD_LOGIC;
	signal WB_SGINAL_c3                                                                                                                                                                        : STD_LOGIC_VECTOR(1 downto 0);
	signal ALU_CONTROL_c3                                                                                                                                                                      : STD_LOGIC_VECTOR(3 downto 0);
	signal ALU_Source_c3                                                                                                                                                                       : STD_LOGIC;
	signal Interrupt_c3, Reset_c3                                                                                                                                                              : STD_LOGIC;
	signal Rdest_Valueee                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0);
	signal CCR_EN_c3                                                                                                                                                                           : STD_LOGIC;
	signal ALU_OUTPUT_C3                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0);
	signal ZERO_flag_c3, CARRY_Flag_c3, Neg_FLAG_c3                                                                                                                             : STD_LOGIC;
	signal ZERO_flag_c3_cin, Neg_FLAG_c3_cin, CARRY_Flag_c3_cin                                                                                                             : STD_LOGIC;
	signal CARRYIN_Flag_c3                                                                                                                                                                     : STD_LOGIC                    := '0';
	signal JZ_c3, JN_c3, JC_c3, JMP_c3, goJMP, reset_JMPexist                                                                                                                                  : STD_LOGIC                    := '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 4th cycle signals
	signal Rdest_value_c4                                                                                                                                                                      : STD_LOGIC_VECTOR(15 downto 0);
	signal Rdest_address_c4                                                                                                                                                                    : STD_LOGIC_VECTOR(2 downto 0);
	signal pc_instr_c4                                                                                                                                                                         : STD_LOGIC_VECTOR(19 downto 0);
	signal Eff_c4                                                                                                                                                                              : STD_LOGIC_VECTOR(19 downto 0);
	signal Imm_c4                                                                                                                                                                              : STD_LOGIC_VECTOR(15 downto 0);
	signal stackSignal_c4, BranchSignal_c4, CallSignal_c4, PushSignal_c4, PopSignal_c4, InSignal_c4, OutSignal_c4, RetSignal_c4, RT1Signal_c4, WriteRegisterSignal_c4, MemWrite_c4, MemRead_c4 : STD_LOGIC;
	signal WB_SGINAL_c4                                                                                                                                                                        : STD_LOGIC_VECTOR(1 downto 0);
	signal Interrupt_c4, Reset_c4                                                                                                                                                              : STD_LOGIC;
	signal ALU_OUTPUT_C4                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0); -- need to remove branch signal from register useless signal here
	signal Stack_Address                                                                                                                                                                       : STD_LOGIC_VECTOR(19 downto 0);
	signal Memory_Address                                                                                                                                                                      : STD_LOGIC_VECTOR(19 downto 0) := (others => '1');
	signal Memory_DataIn                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0);
	signal Memory_DataOut_c4                                                                                                                                                                   : STD_LOGIC_VECTOR(15 downto 0);
	signal pc_instr_c4_2                                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0); -- need to be 20 bits
	signal PC_memory_value                                                                                                                                                                     : STD_LOGIC_VECTOR(15 downto 0);
	signal Data_PC_Selector                                                                                                                                                                    : STD_LOGIC;
	signal MemoryOf1Out                                                                                                                                                                        : STD_LOGIC_VECTOR(15 downto 0);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	--5th cycle 
	signal Rdest_value_c5, ALU_OUTPUT_C5                                                                                                                                                       : STD_LOGIC_VECTOR(15 downto 0);
	signal FLASH_PC_CHAGED                                                                                                                                                                     : STD_LOGIC; -- FOR FD DE EM
	signal FLASH_PC_CHANGED                                                                                                                                                                    : STD_LOGIC; -- for FD DE
	signal Rdest_address_c5                                                                                                                                                                    : STD_LOGIC_VECTOR(2 downto 0);
	signal Imm_c5, Memory_DataOut_c5                                                                                                                                                           : STD_LOGIC_VECTOR(15 downto 0);
	signal InSignal_c5, OutSignal_c5, WriteRegisterSignal_c5                                                                                                                                   : STD_LOGIC;
	signal WB_SGINAL_c5                                                                                                                                                                        : STD_LOGIC_VECTOR(1 downto 0);
	signal Rdst_DataIN_c5                                                                                                                                                                      : std_logic_vector(15 downto 0);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------

begin

	f1 : PC_Register port map(reset_SIGNAL, clk, CallSignal_c4, RT1Signal_c4, RetSignal_c4, goJMP, Interrupt_c4, Reset_c4, Load_use, Rdest_value_c3_3, Memory_DataOut_c4, Inst, PC_INSTRCUTION, Rdest_value_c4, MemoryOf1Out);
	
    f1_1:Memory port map(clk,MemWrite_c4,MemRead_c4,PC_INSTRCUTION (15 downto 0),Memory_Address (15 downto 0),Memory_DataIn,Inst,Memory_DataOut_c4,MemoryOf1Out,Imm_EfffValue);
	
---------------------------------------------------------------------------------------------------------------------------------------------  
	f2 : FD_register PORT MAP(clk, FLASH_PC_CHANGED, Inst, Imm_EfffValue, PC_INSTRCUTION, '1', Instr_2, Imm_eff_2, pc_instr_2);
	f2_1 : Register_File PORT MAP(clk,reset_SIGNAL, WriteRegisterSignal_c5, Instr_2(10 downto 8), Instr_2(7 downto 5), Rdst_DataIN_c5, Rsrc_value_c2, Rdest_value_c2, Rdest_address_c5);
	f2_2 : Control_Unit PORT MAP(interrupt_SIGNAL, reset_SIGNAL, Instr_2(15 downto 11), Imm_eff_2 ,ALU_Source,stackSignal, ALU_Op, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, WriteRegisterSignal, MemWrite, MemRead, WB_SGINAL, ALU_CONTROL, CCR_EN, Eff_c2, Imm_c2, JZ_signal, JN_signal, JC_signal, JMP_signal);
	--f2_2 : Control_Unit PORT MAP(interrupt_SIGNAL, reset_SIGNAL, '0', Instr_2(15 downto 11), Imm_eff_2, stackSignal, ALU_Op, ALU_Source, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, WriteRegisterSignal, MemWrite, MemRead, WB_SGINAL, ALU_CONTROL, CCR_EN, Eff_c2, Imm_c2, JZ_signal, JN_signal, JC_signal, JMP_signal);
	
        f2_3 : Hazard_Detection Port Map(Instr_2(10 downto 8), Instr_2(7 downto 5), Rdest_address_c3, WB_SGINAL_c3, ALU_Op,MemWrite_c4,MemRead_c4, Load_use); --Detect Load-Use case              
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	f3 : DE_register Port Map(clk, FLASH_PC_CHAGED, Rdest_value_c2, Rsrc_value_c2, dummyRdstAddrs, dummyRsrcAddrs, pc_instr_2, Eff_c2, Imm_c2, stackSignal, ALU_Op, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, Write_register_Signal, MemWrite, MemRead, WB_SGINAL, ALU_CONTROL, CCR_EN, JZ_signal, JN_signal, JC_signal, JMP_signal, interrupt_SIGNAL, reset_SIGNAL, ALU_Source, Rdest_value_c3, Rsrc_value_c3, Rdest_address_c3, Rsrc_address_c3, pc_instr_c3, Eff_c3, Imm_c3, stackSignal_c3, ALU_Op_c3, CallSignal_c3, PushSignal_c3, PopSignal_c3, InSignal_c3, OutSignal_c3, RetSignal_c3, RT1Signal_c3, WriteRegisterSignal_c3, MemWrite_c3, MemRead_c3, WB_SGINAL_c3, ALU_CONTROL_c3, CCR_EN_c3, JZ_c3, JN_c3, JC_c3, JMP_c3, Interrupt_c3, Reset_c3, ALU_Source_c3);
	f3_1 : MUX_16_4 port map(Rsrc_value_c3, Rdest_value_c4, Rdst_DataIN_c5, Rsrc_value_c3_2, ForwardA); -- FORWADING RSRC VALUE
	f3_2 : MUX_16_4 port map(Rdest_value_c3, Rdest_value_c4, Rdst_DataIN_c5, Rdest_value_c3_2, ForwardB); -- FORWADING RDEST VALUE											
	f3_3 : Forwading_Unit port map(Rsrc_address_c3, Rdest_address_c3, Rdest_address_c4, Rdest_address_c5, WriteRegisterSignal_c4, WriteRegisterSignal_c5, ForwardA, ForwardB);
	f3_4 : MUX_16 port map(Rdest_value_c3_2, Imm_c3, Rdest_value_c3_3, ALU_Source_c3); -- In Case of Shift or LDM i want to pass immValue not RdestValue 
	--f3_5 : ALU PORT MAP(Rsrc_value_c3_2, Rdest_value_c3_3, clk, ALU_OUTPUT_C3, ALU_CONTROL_c3, ZERO_flag_c3, Neg_FLAG_c3, CARRY_Flag_c3, CARRY_Flag_c3_cin,ZERO_flag_c3_cin,Neg_FLAG_c3_cin, RT1Signal_c3, CARRYIN_Flag_c3);
	f3_5 : ALU PORT MAP(Rsrc_value_c3_2, Rdest_value_c3_3, clk, ALU_OUTPUT_C3, ALU_CONTROL_c3, ZERO_flag_c3, Neg_FLAG_c3, CARRY_Flag_c3, ZERO_flag_c3_cin, Neg_FLAG_c3_cin, CARRY_Flag_c3_cin, RT1Signal_c3, CARRYIN_Flag_c3);
	f3_6 : CCR_Register PORT MAP(clk, CARRY_Flag_c3, Neg_FLAG_c3, ZERO_flag_c3, CARRYIN_Flag_c3); -- Flag Register takes the output flags from ALU aand save it into a Register
	f3_7 : RTI_FLAGS PORT MAP(clk, '0', Interrupt_c3, CARRY_Flag_c3, Neg_FLAG_c3, ZERO_flag_c3,  CARRY_Flag_c3_cin, Neg_FLAG_c3_cin, ZERO_flag_c3_cin); -- Flags store the flags when an interrupt occurs ( Flags Preserved )
	f3_8 : BranchUnit PORT MAP(ZERO_flag_c3, Neg_FLAG_c3, CARRY_Flag_c3, JZ_c3, JN_c3, JC_c3, JMP_c3, goJMP); -- to check flags with the fetched instructon
	f3_9 : MUX_16 Port Map(Rdest_value_c3_3, ALU_OUTPUT_C3, Rdest_Valueee, ALU_Op_c3); --fit the right data in Rdest as Forwading always take the val in Rdst not ALUOUTPOT
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	f4 : EM_register PORT MAP(clk,reset_SIGNAL, Rdest_Valueee, ALU_OUTPUT_C3, Rdest_address_c3, pc_instr_c3, Eff_c3, Imm_c3, stackSignal_c3, CallSignal_c3, PushSignal_c3, PopSignal_c3, InSignal_c3, OutSignal_c3, RetSignal_c3, RT1Signal_c3, WriteRegisterSignal_c3, MemWrite_c3, MemRead_c3, WB_SGINAL_c3, Interrupt_c3, Reset_c3, Rdest_value_c4, ALU_OUTPUT_C4, Rdest_address_c4, pc_instr_c4, Eff_c4, Imm_c4, stackSignal_c4, CallSignal_c4, PushSignal_c4, PopSignal_c4, InSignal_c4, OutSignal_c4, RetSignal_c4, RT1Signal_c4, WriteRegisterSignal_c4, MemWrite_c4, MemRead_c4, WB_SGINAL_c4, Interrupt_c4, Reset_c4);
	f4_1 : StackRegister PORT MAP(stackSignal_c4, PushSignal_c4, PopSignal_c4, clk, '0', Stack_Address);
	f4_2 : MUX_2 PORT MAP(Eff_c4, Stack_Address, Memory_Address, stackSignal_c4); -- Choose Effective Instr Address OR Stack Adress
	f4_3 : MUX_16 PORT MAP(Rdest_value_c4, PC_memory_value, Memory_DataIn, Data_PC_Selector); -- choose writee data PC or Rdst valuee-- interrupt
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	f5 : M_WB_register PORT MAP(clk,reset_SIGNAL, Rdest_value_c4, ALU_OUTPUT_C4, Rdest_address_c4, Imm_c4, Memory_DataOut_c4, InSignal_c4, OutSignal_c4, WriteRegisterSignal_c4, WB_SGINAL_c4, Rdest_value_c5, ALU_OUTPUT_C5, Rdest_address_c5, Imm_c5, Memory_DataOut_c5, InSignal_c5, OutSignal_c5, WriteRegisterSignal_c5, WB_SGINAL_c5);
	f5_1 : WB_STAGE PORT MAP(ALU_OUTPUT_C5, Rdest_value_c5, Memory_DataOut_c5, INPort, WB_SGINAL_c5, Rdst_DataIN_c5);
        -------------------------------------------------------------------------------------------------------------------------------
	f5_2 : OUTPort <= Rdest_value_c5 when OutSignal_c5 = '1' else (others => '0');   
	-------------------------------------------------------------------------------------------------------------------------------------------------------------

	Write_register_Signal <= '0' when Load_use = '1' else                          -- here i want to avoid writing if load use case
	WriteRegisterSignal;
	dummyRdstAddrs        <= "111" when Load_use = '1' else Instr_2(10 downto 8);
	dummyRsrcAddrs        <= "111" when Load_use = '1' else Instr_2(7 downto 5);
	-- Needed to Flash the pipelineRegister if PC changes
	--Need to make 2 Reset 	
	FLASH_PC_CHAGED       <= '1' when (CallSignal_c4 = '1' OR RT1Signal_c4 = '1' OR RetSignal_c4 = '1') else '0';
	FLASH_PC_CHANGED      <= '1' when (FLASH_PC_CHAGED = '1' OR goJMP = '1') else '0';
	pc_instr_c4_2         <=  pc_instr_c4 (15 downto 0); -- to resize in memory of width word in case i want to save PC ( feha 7eta 8alat )

	PC_memory_value <= pc_instr_c4_2 when (Interrupt_c4 = '1') else STD_LOGIC_VECTOR(signed(pc_instr_c4_2) + 1); -- call signal

	Data_PC_Selector <= '1' when Interrupt_c4 = '1' OR CallSignal_c4 = '1' else '0';  -- to save PC in memory if there is a call or interrupt

end Arch_MicroProcessor;