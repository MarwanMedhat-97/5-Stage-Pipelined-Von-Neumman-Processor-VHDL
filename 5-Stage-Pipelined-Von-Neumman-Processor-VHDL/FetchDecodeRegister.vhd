library ieee;
use ieee.std_logic_1164.all;
Entity FD_register is
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
end Entity FD_register;

Architecture Arch_FD_register of FD_register is
	COMPONENT my_nDFF is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;
	signal input, output : std_logic_vector(55 downto 0);   -- msh 42 hatb2a 56 ( 10 PC + 4 EA )
begin
	input             <= Instruction_in & Imm_Eff_value & pc_in;
	Instruction_OUT   <= output(55 downto 40);   -- 16 bits
	Imm_Eff_value_OUT <= output(39 downto 20);
	pc_out            <= output(19 downto 0);
	reg : my_nDFF generic map(56) port map(clk, rst, '1', input, output);
end Arch_FD_register;