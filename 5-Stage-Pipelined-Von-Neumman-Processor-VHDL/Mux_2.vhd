Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2 is
	port(
		In1       : IN  STD_LOGIC_vector(19 downto 0);
		In2       : IN  STD_LOGIC_vector(19 downto 0);
		Outt      : OUT STD_LOGIC_vector(19 downto 0);
		Selection : IN  std_logic
	);
end entity MUX_2;

architecture mArch_MUX_2 of MUX_2 is
begin
	Outt <= In1 when Selection = '0' else In2;
end architecture mArch_MUX_2;