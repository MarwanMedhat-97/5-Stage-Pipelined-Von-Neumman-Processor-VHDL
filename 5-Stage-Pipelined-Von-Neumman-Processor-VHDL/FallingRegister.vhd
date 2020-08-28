Library ieee;
Use ieee.std_logic_1164.all;

Entity FallingRegister is
	Generic(n : integer := 16);
	port(
		Clk, Rst, enable : in  std_logic;
		d                : in  std_logic_vector(n - 1 downto 0);
		q                : out std_logic_vector(n - 1 downto 0)
	);
end FallingRegister;

Architecture Arch_FallingRegister of FallingRegister is
begin
	Process(Clk, Rst)
	begin
		if Rst = '1' then
			q <= (others => '0');
		elsif falling_edge(Clk) then
			if (enable = '1') then
				q <= d;
			end if;
		end if;
	end process;
end Arch_FallingRegister;
