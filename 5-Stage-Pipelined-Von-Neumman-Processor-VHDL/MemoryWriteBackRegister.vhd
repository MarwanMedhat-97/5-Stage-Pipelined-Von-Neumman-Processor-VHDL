library ieee;
use ieee.std_logic_1164.all;
Entity M_WB_register is
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
end Entity M_WB_register;

Architecture Arch_M_WB_register of M_WB_register is
	COMPONENT my_nDFF is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;
	signal input, output : std_logic_vector(71 downto 0);
begin
	input                <= Rdest_value & ALU_OUTPUT & Rdest_address & Imm_value & MemoryDataOut & InSignal & OutSignal & WriteRegisterSignal & WB_SGINAL;
	Rdest_valueO         <= output(71 downto 56);
	ALU_OUTPUTO          <= output(55 downto 40);
	Rdest_addressO       <= output(39 downto 37);
	Imm_valueO           <= output(36 downto 21);
	MemoryDataOutO       <= output(20 downto 5);
	InSignalO            <= output(4);
	OutSignalO           <= output(3);
	WriteRegisterSignalO <= output(2);
	WB_SGINALO           <= output(1 downto 0);
	ex_mem : my_nDFF generic map(72) port map(clk, rst, '1', input, output);
end Arch_M_WB_register;
