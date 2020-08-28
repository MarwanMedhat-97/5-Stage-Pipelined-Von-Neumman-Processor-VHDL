Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_16_4 is
	port(
		In1       : IN  STD_LOGIC_VECTOR(15 downto 0); -- Register value out from DE buffer ( normal case )
		In2       : IN  STD_LOGIC_VECTOR(15 downto 0); -- output from the EM buffer Ex to EX Forwarding
		In3       : IN  STD_LOGIC_VECTOR(15 downto 0); -- output from the WB stage M to EX Forwarding
		Outt      : OUT STD_LOGIC_VECTOR(15 downto 0);
		Selection : IN  std_logic_VECTOR(1 downto 0) --Forward selector
	);
end entity MUX_16_4;

architecture Arch_MUX_16_4 of MUX_16_4 is
begin
	Outt <= In1 when Selection = "00"
		else In2 when Selection = "01"
		else In3 when Selection = "10"
		else In1;
end architecture Arch_MUX_16_4;