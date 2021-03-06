
Library ieee;
use ieee.std_logic_1164.all;
entity Control_Unit is
	port(
		SignalInterrupt           : IN  STD_LOGIC;
		SignalReSet               : IN  STD_LOGIC;
		OPcode                    : IN  std_logic_vector(4 downto 0);
                 Imm_EffecativeAdderss     : IN  STD_LOGIC_VECTOR(19 downto 0);  -- size of EA is 20 bits , memory size is 1M
                ALU_Source                : OUT  STD_LOGIC;             
		StackSignal, ALU_Op, CallSignal, PushSignal, PopSignal, InSignal, OutSignal, RetSignal, RT1Signal, RegWrite, MemWrite, MemRead : OUT std_logic;
		WB_SGINAL                 : OUT STD_LOGIC_VECTOR(1 downto 0);
		ALU_CONTROL               : OUT STD_LOGIC_VECTOR(3 downto 0);
		CCR_EN                    : OUT STD_LOGIC;
		EA                        : OUT STD_LOGIC_VECTOR(19 downto 0);
		Imm_value                 : OUT STD_LOGIC_VECTOR(15 downto 0);
		JZ_signal, JN_signal, JC_signal, JMP_signal      : OUT STD_LOGIC
	);
end entity;
Architecture Arch_Control_Unit of Control_Unit is
	signal NOP, SETC, CLRC, NOTT, INC, DEC, OUTT, INN, MOV, ADD, MUL, SUB, ANDD, ORR, SHL, SHR, PUSH, POP, LDM, LDD, STDD, JZ, JN, JC, JMP, CALL, RET, RTI : STD_LOGIC;
	signal X     : std_logic_vector(29 downto 0);
	signal S     : std_logic_vector(3 downto 0);
begin
	X <=     "000000000000000000000000000001" when OPcode = "00000" 
		else "000000000000000000000000000010" when OPcode = "00001" 
		else "000000000000000000000000000100" when OPcode = "00010" 
		else "000000000000000000000000001000" when OPcode = "00011" 
		else "000000000000000000000000010000" when OPcode = "00100" 
		else "000000000000000000000000100000" when OPcode = "00101" 
		else "000000000000000000000001000000" when OPcode = "00110" 
		else "000000000000000000000010000000" when OPcode = "00111" 
		else "000000000000000000000100000000" when OPcode = "01000" 
		else "000000000000000000001000000000" when OPcode = "01001" 
		else "000000000000000000010000000000" when OPcode = "01010" 
		else "000000000000000000100000000000" when OPcode = "01011" 
		else "000000000000000001000000000000" when OPcode = "01100" 
		else "000000000000000010000000000000" when OPcode = "01101" 
		else "000000000000000100000000000000" when OPcode = "01110" 
		else "000000000000001000000000000000" when OPcode = "01111" 
		else "000000000000010000000000000000" when OPcode = "10000" 
		else "000000000000100000000000000000" when OPcode = "10001" 
		else "000000000001000000000000000000" when OPcode = "10010" 
		else "000000000010000000000000000000" when OPcode = "10011" 
		else "000000000100000000000000000000" when OPcode = "10100" 
		else "000000001000000000000000000000" when OPcode = "10101" 
		else "000000010000000000000000000000" when OPcode = "10110" 
		else "000000100000000000000000000000" when OPcode = "10111" 
		else "000001000000000000000000000000" when OPcode = "11000" 
		else "000010000000000000000000000000" when OPcode = "11001" 
		else "000100000000000000000000000000" when OPcode = "11010" 
		else "001000000000000000000000000000" when OPcode = "11011" 
		else "010000000000000000000000000000" when OPcode = "11100" 
		else "100000000000000000000000000000" when OPcode = "11101" 
		else "000000000000000000000000000001"; -- Any other combination are considered no operation

        NOP         <= X(0);
	SETC         <= X(1);
	CLRC         <= X(2);
	NOTT         <= X(3);
	INC        <= X(4);
	DEC        <= X(5);
	OUTT         <= X(6);
	INN         <= X(7);
	MOV         <= X(8);
	ADD         <= X(9);
	MUL        <= X(10);
	SUB        <= X(11);
	ANDD        <= X(12);
	ORR         <= X(13);
	SHL        <= X(14);
	SHR         <= X(15);
	PUSH        <= X(16);
	POP        <= X(17);
	LDM         <= X(18);
	LDD         <= X(19);
	STDD          <= X(20);
	JZ          <= X(21);
	JN          <= X(22);
	JC         <= X(23);
        JMP        <= X(24);
	CALL        <= X(25);
	RET         <= X(26);
	RTI         <= X(27);
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

s     <= "0000" when MOV  = '1'
		else "0001" when ADD  = '1'
		else "0010" when SUB  = '1'
		else "0011" when ANDD = '1'
		else "0100" when ORR  = '1'
		else "0111" when SHL  = '1'
		else "1000" when SHR  = '1'
		else "1001" when SETC = '1'
		else "1010" when CLRC = '1'
		else "1011" when NOTT = '1'
		else "1100" when MUL  = '1'
		else "1101" when INC  = '1'
		else "1110" when DEC  = '1'
		else "1111";
	ALU_CONTROL <= s;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	StackSignal <= '1' when (PUSH = '1' OR POP = '1' OR RET = '1' OR RTI = '1' OR CALL = '1' OR SignalInterrupt = '1') else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	ALU_Op      <= '1' when (MOV = '1' OR ADD = '1' OR SUB = '1' OR ANDD = '1' OR ORR = '1' OR SHL = '1' OR SHR = '1' OR SETC = '1' OR CLRC = '1' OR NOTT = '1' OR MUL = '1' OR INC = '1' OR DEC = '1') else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	ALU_Source  <= '1' when (SHL OR SHR OR LDM) = '1' else '0'; -- This signal to indicate Rsource is register or Imm
				                                       -- Pass the Rsouce Value

	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	JZ_signal           <= JZ;
	JN_signal           <= JN;
	JC_signal           <= JC;
	JMP_signal          <= JMP;
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CallSignal          <= '1' when CALL = '1' else '0';
	PushSignal          <= '1' when (PUSH OR CALL OR SignalInterrupt) = '1' else '0'; -- need to ask ;
						   
	PopSignal           <= '1' when (POP OR RET OR RTI) = '1' else '0'; -- need to ask  
						   
	InSignal            <= '1' when INN = '1' else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	OutSignal           <= '1' when OUTT = '1' else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	RetSignal           <= '1' when RET = '1' else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	RT1Signal           <= '1' when RTI = '1' else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	RegWrite <= '1' when (MOV OR ADD OR SUB OR ANDD OR ORR OR  SHL OR SHR OR POP OR INN OR NOTT OR INC OR DEC OR LDM OR LDD OR MUL) = '1' else '0';
        -------------------------------------------------------------------------------------------------------------------------------------------------
      --  RegWriteMUL <= '1' when MUL = '1' else '0';    -- because in MUL w write highest 16 bit in Rsrc and lowest 16 bit in Rdst
        ----------------------------------------------------------------------------------------------------------------------------------------------
	MemWrite            <= '1' when (PUSH OR CALL OR STDD OR SignalInterrupt) = '1' else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	MemRead             <= '1' when (POP OR RET OR RTI OR LDD) = '1' else '0';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	WB_SGINAL  <= "00" when MOV = '1' OR ADD = '1' OR SUB = '1' OR ANDD = '1' OR ORR = '1'  OR SHL = '1' OR SHR = '1' OR NOTT = '1' OR INC = '1' OR DEC = '1' OR MUL='1'
		else "01" when LDM = '1' 
		else "10" when LDD = '1' OR POP = '1'
		else "11" when INN = '1'
		else "00";                      -- anyother instruction wont affect Rdst since  no RegWrite  with it
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CCR_EN    <= '1' when (ADD or SUB or DEC or ANDD or ORR  or NOTT or INC  or CLRC or SETC or RTI) = '1' else '0'; --enable to take alu flags in this cass only
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	EA  <= Imm_EffecativeAdderss when (LDD OR STDD) = '1'
		else "00000000000000000000" when SignalReSet = '1'
		else "00000000000000000001" when SignalInterrupt = '1'        --go to address 1 if there is an interrupt
		else "00000000000000000000";
	Imm_value <= Imm_EffecativeAdderss(15 downto 0) when (SHL OR SHR OR LDM) = '1' else "0000000000000000";
end Arch_Control_Unit;