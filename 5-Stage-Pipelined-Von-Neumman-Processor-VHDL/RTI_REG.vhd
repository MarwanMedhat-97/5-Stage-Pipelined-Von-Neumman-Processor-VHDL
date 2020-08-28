Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity RTI_FLAGS is
	port(
		Clk, Rst                                           : in  std_logic;
		Interrupt_signal                                   : in  std_logic;
		Carry_Flag, Neg_Flag, Zero_flag     : IN  STD_LOGIC;
		Carry_FlagO, Neg_FlagO, Zero_flagO : OUT STD_LOGIC
	);
end RTI_FLAGS;

Architecture Arch_RTI_FLAGS of RTI_FLAGS is
	COMPONENT my_nDFF is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;
	signal input, output : STD_LOGIC_VECTOR(2 downto 0);
begin
	input          <= Carry_Flag & Neg_Flag & Zero_flag;
	Carry_FlagO    <= output(2);
	Neg_FlagO      <= output(1);
	Zero_flagO     <= output(0);
	RTI_reg : my_nDFF generic map(n => 3) port map(Clk, '0', Interrupt_signal, input, output); -- the Interrupt signal is the enable of the Register
end Arch_RTI_FLAGS;