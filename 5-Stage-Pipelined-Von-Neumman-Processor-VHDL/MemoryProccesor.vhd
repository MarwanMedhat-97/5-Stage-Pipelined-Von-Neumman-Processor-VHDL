library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
Entity Data_MemoryProccesor is
	port(
		clk     : in  std_logic;
		we      : in  std_logic;
		address : in  std_logic_vector(19 downto 0);
		datain  : in  std_logic_vector(15 downto 0);  -- kant 15
		dataout : out std_logic_vector(15 downto 0);
		DataOf1 : out STD_LOGIC_VECTOR(15 downto 0)
	);
end entity Data_MemoryProccesor;

architecture ArchData_MemoryProccesor of Data_MemoryProccesor is
	type ram_type is array (0 to 1048575) of std_logic_vector(15 downto 0);
	signal ram      : ram_type;
	signal rAddress : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
begin
	rAddress <= (others => '0') when Is_X(address) else address;
	process(clk) is
	begin
		if rising_edge(clk) then
			if we = '1' then
				ram(to_integer(unsigned(rAddress))) <= datain;
                               -- ram(to_integer(unsigned(rAddress)+1)) <= "000000000000"& datain(19 downto 16);  -- to save PC we need two memory locations
			end if;
		end if;
	end process;
	dataout  <= ram(to_integer(unsigned(rAddress)));
	DataOf1  <= ram(1);
end ArchData_MemoryProccesor;