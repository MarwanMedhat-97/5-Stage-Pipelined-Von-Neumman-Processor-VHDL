library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Register is

	port(
		reset, clk                                                                           : IN  std_logic;
		CallSignal, RTISignal, RETSignal, JMP_signal, InterruptSignal, RESETSignal, load_use : IN  std_logic;
		Rdest_value, Mem_value                                                               : IN  std_logic_vector(15 downto 0); -- 16 bits
		InstructionValue                                                                     : IN  STD_LOGIC_VECTOR(15 downto 0);
		instruction_PC                                                                       : OUT std_logic_vector(19 downto 0); --20 bits
		Rdest_c4                                                                             : IN  STD_LOGIC_VECTOR(15 downto 0); --16 bits
		MemoryOf1Out                                                                         : IN  STD_LOGIC_VECTOR(15 downto 0) --16 bits
	);
end entity PC_Register;

architecture Arch_PC_Register of PC_Register is
	COMPONENT FallingRegister is
		Generic(n : integer := 16);
		port(
			Clk, Rst, enable : in  std_logic;
			d                : in  std_logic_vector(n - 1 downto 0);
			q                : out std_logic_vector(n - 1 downto 0)
		);
	end COMPONENT;

	signal PC_out                          : std_logic_vector(19 downto 0) := "00000000000000000000";
	signal default_PC, out_1, out_2, out_3 : std_logic_vector(19 downto 0);
	signal not_load_use                    : std_logic;
	signal PC_in                           : std_logic_vector(19 downto 0) := "00000000000000000000";
	signal incremented_PC                  : std_logic_vector(19 downto 0);
	signal op_code_readI                   : STD_LOGIC_VECTOR(4 downto 0);
	
begin
	op_code_readI <= InstructionValue(15 downto 11);
	not_load_use  <= not load_use;  -- if no load use
	PC_register : FallingRegister generic map(n => 20) port map(clk, '0', not_load_use, PC_in, PC_out);
	--default_PC;
	PC_in <= PC_in when (load_use = '1')     -- stall when there is a hazard
		else ("0000" & Rdest_value)    when (JMP_signal = '1')
		else ("0000" & Rdest_c4) 	    when (CallSignal = '1')
		else ("0000" & Mem_value) 	    when (RESETSignal = '1' OR RTISignal = '1' OR RETSignal = '1')
		else ("0000" & MemoryOf1Out)   when (InterruptSignal = '1')               -- memory of 1
		else incremented_PC when rising_edge(clk)
	;

	incremented_PC <= std_logic_vector(signed(PC_in) + 2) when (op_code_readI = "01110" OR op_code_readI = "01111" OR op_code_readI = "10010" OR op_code_readI = "10011" OR op_code_readI = "10100") else std_logic_vector(signed(PC_in) + 1);

	instruction_PC <= PC_out;           -- I removed when loaduse = 0

end Arch_PC_Register;
