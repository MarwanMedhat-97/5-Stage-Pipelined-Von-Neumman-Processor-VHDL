Library ieee;
Use ieee.std_logic_1164.all;

Entity Register_Reset is
	Generic(n : integer := 8);
	port(
		Clk, Rst, en, rst_clk, rst_fall : in  std_logic;
		d                               : in  std_logic_vector(n - 1 downto 0);
		q                               : out std_logic_vector(n - 1 downto 0));
end Register_Reset;

Architecture Arch_Register_Reset of Register_Reset is
begin
	Process(Clk, Rst)
	begin
		if Rst = '1' then
			q <= (others => '0');
		elsif rising_edge(Clk) and rst_clk = '1' then
			q <= (others => '0');
		elsif rising_edge(Clk) and en = '1' then
			q <= d;
		elsif falling_edge(clk) and rst_fall = '1' then
			q <= (others => '0');
		end if;
	end process;
end Arch_Register_Reset;