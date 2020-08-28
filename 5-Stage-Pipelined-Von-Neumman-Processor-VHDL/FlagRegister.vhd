Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity CCR_Register is
	port(
		Clk, Carry_Flag, Neg_Flag, Zero_flag : IN  STD_LOGIC;
		Carry_FlagO                                         : OUT STD_LOGIC
	);
end CCR_Register;

Architecture Arch_FlagRegister of CCR_Register is
	COMPONENT my_nDFF is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;
	signal input, output : STD_LOGIC_VECTOR(2 downto 0);
begin
	input       <= Carry_Flag & Neg_Flag & Zero_flag ;
	Carry_FlagO <= output(2);
	CRR_reg : my_nDFF generic map(n => 3) port map(Clk, '0', '1', input, output);
end Arch_FlagRegister;