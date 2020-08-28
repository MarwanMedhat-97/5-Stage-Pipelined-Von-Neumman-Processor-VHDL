library ieee;
use ieee.std_logic_1164.all;

Entity EM_register is
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
end Entity EM_register;

Architecture Arch_EM_register of EM_register is
	COMPONENT my_nDFF is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;
	signal input, output : std_logic_vector(105 downto 0);  -- 105
begin

	input                <= Interrupt & reset & Rdest_value & ALU_OUTPUT & Rdest_address & PC_Value & EA & Imm_value & StackSignal & CallSignal & PushSignal & PopSignal & InSignal & OutSignal & RetSignal & RT1Signal & WriteRegisterSignal & MemWrite & MemRead & WB_SGINAL;
	InterruptO           <= output(105);
	resetO               <= output(104);
	Rdest_valueO         <= output(103 downto 88);
	ALU_OUTPUTO          <= output(87 downto 72);
	Rdest_addressO       <= output(71 downto 69);
	PC_ValueO            <= output(68 downto 49);
	EAO                  <= output(48 downto 29);
	Imm_valueO           <= output(28 downto 13);
	StackSignalO         <= output(12);
	CallSignalO          <= output(11);
	PushSignalO          <= output(10);
	PopSignalO           <= output(9);
	InSignalO            <= output(8);
	OutSignalO           <= output(7);
	RetSignalO           <= output(6);
	RT1SignalO           <= output(5);
	WriteRegisterSignalO <= output(4);
	MemWriteO            <= output(3);
	MemReadO             <= output(2);
	WB_SGINALO           <= output(1 downto 0);
	ex_mem : my_nDFF generic map(106) port map(clk, rst, '1', input, output);
end Arch_EM_register;