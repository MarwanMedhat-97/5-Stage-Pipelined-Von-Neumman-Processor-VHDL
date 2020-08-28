Library ieee;
Use ieee.std_logic_1164.all;

Entity WB_STAGE is
	port(
		 ALU_output   : IN  std_logic_vector(15 downto 0);
	     Rsrc         : IN  std_logic_vector(15 downto 0); -- OR Immediate Value 
	     MEM_OUTPUT   : IN  std_logic_vector(15 downto 0);
	     INPORT_Value : IN  std_logic_vector(15 downto 0);
	     WB_signal    : IN  STD_LOGIC_VECTOR(1 downto 0);
	     Y            : OUT std_logic_vector(15 downto 0));
end WB_STAGE;

Architecture Arch_WB_STAGE of WB_STAGE is
Begin
	Y <= 	 ALU_output 	when WB_signal = "00"
		else Rsrc   		when WB_signal = "01"
		else MEM_OUTPUT 	when WB_signal = "10"
		else INPORT_Value;
end Arch_WB_STAGE;
