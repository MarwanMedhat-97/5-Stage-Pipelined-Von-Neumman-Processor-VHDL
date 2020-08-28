Library ieee;
Use ieee.std_logic_1164.all;

Entity Register_WriteOne is
	Generic(n : integer := 16);
	port(
		Clk, Rst, enable : in  std_logic;
		d                : in  std_logic_vector(n - 1 downto 0);
		q                : out std_logic_vector(n - 1 downto 0));
end Register_WriteOne;

Architecture Arch_Register_WriteOne of Register_WriteOne is
begin
	Process(clk, enable, d, Rst)
	begin
		if Rst = '1' then
			q <= (others => '0');
		elsif Clk = '1' then
			if (enable = '1') then
				q <= d;
			end if;
		elsif falling_edge(clk) and Rst = '1' then
			q <= (others => '0');
		end if;
	end process;
end Arch_Register_WriteOne;
