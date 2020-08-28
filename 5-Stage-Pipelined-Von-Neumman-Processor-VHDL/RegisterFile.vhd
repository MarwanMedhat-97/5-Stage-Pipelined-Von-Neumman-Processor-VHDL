Library IEEE;
use IEEE.std_logic_1164.all;

Entity Register_File is
	port(                   -- msh fahem b2a law gatly Imm value ha7otaha feen ?
		Clk, rst, Register_Write : in  std_logic;
		Rdest, Rsrc              : in  std_logic_vector(2 downto 0);  -- anhy registers ely ha3ml el operations 3aleha
		writeData                : in  std_logic_vector(15 downto 0);   -- el data el gayaly mn WB stage
		Rsrc_data, Rdest_data    : out std_logic_vector(15 downto 0);  -- el values bta3et el Registers el hat5osh 3al alu ba3d ma 7atet feha el data
		Rdest_WB                 : in  std_logic_vector(2 downto 0)   -- anhy register el ha7ot fe el writeData el gatly
	);
end entity Register_File;

architecture Arch_Register_File of Register_File is

	COMPONENT Register_WriteOne is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0));
	end COMPONENT;

	signal R0_data, R1_data, R2_data, R3_data, R4_data, R5_data,R6_data : std_logic_vector(15 downto 0);
	signal en0, en1, en2, en3, en4, en5,en6                         : std_logic;

begin
	-------------------------------- CREATING 6 INSTANCES Registers ------------------------
	R0 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en0, writeData, R0_data);
	R1 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en1, writeData, R1_data);
	R2 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en2, writeData, R2_data);
	R3 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en3, writeData, R3_data);
	R4 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en4, writeData, R4_data);
	R5 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en5, writeData, R5_data);
        R6 : Register_WriteOne generic map(n => 16) port map(Clk, rst, en6, writeData, R6_data);

	--- only enable the registerwrite that we need to wb stage only otherwise enable zero (read mode)
	en0       <= '1' when Rdest_WB = "000" and Register_Write = '1' else '0';
	en1       <= '1' when Rdest_WB = "001" and Register_Write = '1' else '0';
	en2       <= '1' when Rdest_WB = "010" and Register_Write = '1' else '0';
	en3       <= '1' when Rdest_WB = "011" and Register_Write = '1' else '0';
	en4       <= '1' when Rdest_WB = "100" and Register_Write = '1' else '0';
	en5       <= '1' when Rdest_WB = "101" and Register_Write = '1' else '0';
        en6       <= '1' when Rdest_WB = "110" and Register_Write = '1' else '0';

	--GET The DataOut as The address are Selected
	Rsrc_data <= R0_data when Rsrc = "000"
		else R1_data when Rsrc = "001"
		else R2_data when Rsrc = "010"
		else R3_data when Rsrc = "011"
		else R4_data when Rsrc = "100"
		else R5_data when Rsrc = "101"
                else R6_data when Rsrc = "110"
		else (others => '0');

	Rdest_data <= R0_data when Rdest = "000"
		else R1_data when Rdest = "001"
		else R2_data when Rdest = "010"
		else R3_data when Rdest = "011"
		else R4_data when Rdest = "100"
		else R5_data when Rdest = "101"
                else R6_data when Rdest = "110"
		else (others => '0');

end architecture Arch_Register_File;