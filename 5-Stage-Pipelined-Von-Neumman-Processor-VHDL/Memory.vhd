library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

Entity Memory is
	port(
		clk     : in  std_logic;
		Mem_write_c4,Mem_read_c4      : in  std_logic;
		PC : in  std_logic_vector(15 downto 0); --20 bits to access 1MB  --16 bits of pc until fixed
		Mem_data_address: in std_logic_vector(15 downto 0);
		datain  : in  std_logic_vector(15 downto 0);
		Inst : out std_logic_vector(15 downto 0);
		dataout : out std_logic_vector(15 downto 0);
		DataOf1 : out STD_LOGIC_VECTOR(15 downto 0);
		Imm_EfffValue : out std_logic_vector(19 downto 0) -- 20 bits
		
	
	);
end entity Memory;

architecture ArchData_MemoryProccesor of Memory is
	type ram_type is array (0 to 1048575) of std_logic_vector(15 downto 0); --1048575 = 1MB (1042*1024)-1
	signal ram      : ram_type;
	signal inst_address : STD_LOGIC_VECTOR(15 downto 0) :=(others => '0'); --19 is log(1024*1024) =20-1 and 524288 is 2^20 *0.5
	signal data_address : STD_LOGIC_VECTOR(15 downto 0) := (others => '1'); -- modify signals to be 19 when fixed
begin
	data_address<= (others => '1') when Is_X(Mem_data_address) else Mem_data_address; --Is_x returns true is data entered is undefine or Z 
	inst_address <= (others => '0') when Is_x(PC) else PC;

	process(clk) is
	begin
		if rising_edge(clk) then
			if (Mem_write_c4 or Mem_read_c4) ='1'   then 

				ram(to_integer(unsigned(data_address))) <= datain;
			
			end if;
		end if;
	end process;
	
	dataout  <= ram(to_integer(unsigned(data_address)));
	Inst <= ram(to_integer(unsigned(inst_address)));
	DataOf1  <= ram(1);
	--Imm_EfffValue <= ram(to_integer(unsigned(rAddress) + 1)); -- ?????????????????

--Imm_EfffValue <= ram(to_integer(unsigned(rPC_value) + 1));    -- bn7ot feha el next memory location 3ashan law 3andena Instruction feha Imm value
                                                                     -- yb2a Total_Instruction = Instru_out & Imm_EfffValue 
                                                                     -- w fe case el EA = Total_Instruction(19 downto 0)
                                                                     -- w Instr = Total_Instruction (31 downto 20)
      
       Imm_EfffValue <= ram(to_integer(unsigned(inst_address)))(3 downto 0) & ram(to_integer(unsigned(inst_address) + 1));

end ArchData_MemoryProccesor;
