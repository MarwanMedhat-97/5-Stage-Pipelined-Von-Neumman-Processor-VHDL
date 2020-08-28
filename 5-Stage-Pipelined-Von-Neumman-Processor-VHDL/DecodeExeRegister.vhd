library ieee;
use ieee.std_logic_1164.all;
Entity DE_register is
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
end Entity DE_register;

Architecture Arch_DE_register of DE_register is
	COMPONENT my_nDFF is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;
	signal input, output : std_logic_vector(119 downto 0); -- 120 not 100 ( +10 PC) , ( +10 EA)
begin
	input                <= Interrupt & reset & ALU_Source & JZ & JN & JC & JMP & Rdest_value & Rsrc_value & Rdest_address & Rsrc_address & PC_Value & EA & Imm_value & StackSignal & ALU_Op & CallSignal & PushSignal & PopSignal & InSignal & OutSignal & RetSignal & RT1Signal & WriteRegisterSignal & MemWrite & MemRead & WB_SGINAL & ALU_CONTROL & CCR_EN;
	InterruptO           <= output(119);
	resetO               <= output(118);
	ALU_SourceO          <= output(117);
	JZ_out               <= output(116);
	JN_out               <= output(115);
	JC_out               <= output(114);
	JMP_out              <= output(113);
	Rdest_valueO         <= output(112 downto 97);
	Rsrc_valueO          <= output(96 downto 81);
	Rdest_addressO       <= output(80 downto 78);
	Rsrc_addressO        <= output(77 downto 75);
	PC_ValueO            <= output(74 downto 55);   -- 20 bits
	EAO                  <= output(54 downto 35);   --  20 bits 
	Imm_valueO           <= output(34 downto 19);
	StackSignalO         <= output(18);
	ALU_OpO              <= output(17);
	CallSignalO          <= output(16);
	PushSignalO          <= output(15);
	PopSignalO           <= output(14);
	InSignalO            <= output(13);
	OutSignalO           <= output(12);
	RetSignalO           <= output(11);
	RT1SignalO           <= output(10);
	WriteRegisterSignalO <= output(9);
	MemWriteO            <= output(8);
	MemReadO             <= output(7);
	WB_SGINALO           <= output(6 downto 5);
	ALU_CONTROLO         <= output(4 downto 1);
	CCR_ENO              <= output(0);
	De_ex : my_nDFF generic map(120) port map(clk, rst, '1', input, output);
end Arch_DE_register;