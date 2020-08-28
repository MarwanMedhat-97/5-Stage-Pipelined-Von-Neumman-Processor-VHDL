library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
Entity ALU  is port ( 
Op1 : in std_logic_vector (15 downto 0); -- Rsrc  
Op2 : in std_logic_vector(15 downto 0); -- Rdest OR SHIFT AMOUNT -- we add MULTI TO CHOOSE Op2 Is Rdest Value or ShiftAmmount
clk:IN STD_LOGIC; --
ALU_OUTPUT: OUT  STD_LOGIC_VECTOR( 15 downto 0);
ALU_CONTROL : IN STD_LOGIC_VECTOR (3 downto 0);
ZERO_FLAG:OUT STD_LOGIC;
Neg_FLAG:OUT STD_LOGIC;
Carry_FLAG_OUT :OUT STD_LOGIC;
ZERO_FLAGIN:IN STD_LOGIC;
Neg_FLAGIN:IN STD_LOGIC;
Carry_FLAG_IN :IN STD_LOGIC;
RTI: IN STD_LOGIC;
Carry_FLAG_CCR :IN STD_LOGIC
 );
end entity ALU ;
Architecture Arch_ALU of ALU is
signal ALU_OUTPUT_17: STD_LOGIC_VECTOR (16 downto 0); --alu output 
signal ALU_MUL_OUTPUT :STD_LOGIC_VECTOR (31 downto 0);
begin

ALU_MUL_OUTPUT <= STD_LOGIC_VECTOR(unsigned(Op1) * unsigned (Op2));

--put initial carry '0'    
ALU_OUTPUT_17 <= '0'& Op1                                             				       when ALU_CONTROL="0000"   else  -- not to check flags if mov instrc
                  STD_LOGIC_VECTOR(unsigned('0' &Op1) + unsigned ('0' & Op2))                          when ALU_CONTROL="0001"  else -- ADD Check Carry Zero
                  STD_LOGIC_VECTOR(unsigned('0' &Op1) - unsigned ('0' &Op2))                           when ALU_CONTROL="0010"  else -- Sub Check Carry Zero
                                ALU_MUL_OUTPUT (16 downto 0)                                               when ALU_CONTROL="1100"  else -- MuL
                                      '0' & (Op1 AND Op2)                                              when ALU_CONTROL="0011" else -- AND
                                      '0' & (Op1 OR  Op2)                                              when ALU_CONTROL="0100"  else -- OR 
              '0' &  std_logic_vector(shift_left(unsigned(Op1), to_integer(unsigned(Op2))))            when ALU_CONTROL="0111" else-- SHL Op2 is Shift Amount (Imm. Value) Not Rdest
              '0' &  std_logic_vector(shift_right(unsigned(Op1),to_integer(unsigned(Op2))))            when ALU_CONTROL="1000" else-- SHR
              '0' &                       NOT ( Op2)                                                   when ALU_CONTROL="1011" else -- 1's Complment NOT 
      --        '0' &     STD_LOGIC_VECTOR(signed((NOT ( Op2)))+1)                                       when ALU_CONTROL="1100"else  -- 2's Complment NEG 
              '0' &      STD_LOGIC_VECTOR(signed( Op2)       +1)                                       when ALU_CONTROL="1101" else -- INC
              '0' &      STD_LOGIC_VECTOR(signed( Op2)       -1)                                       when ALU_CONTROL="1110" else -- DEC 
                                          (others => '0');                       
                                                                              


---------------------------------------------------------------------------------------------------------------------------------------------
--ALU_OUTPUT_17(16) is carry bit 
Carry_FLAG_OUT <='1'     when ALU_CONTROL="1001" else  --SET CARRY       
                 '0'     when ALU_CONTROL="1010" else -- CLEAR CARRY
                 '1'     when ALU_CONTROL="0001" AND ALU_OUTPUT_17(16)='1' else -- ADD
                 '1'     when ALU_CONTROL="0010" AND ALU_OUTPUT_17(16)='1' else -- SUB 
                 '1'     when ALU_CONTROL="1101" AND ALU_OUTPUT_17(16)='1' else -- INC 
                 '1'     when ALU_CONTROL="1110" AND ALU_OUTPUT_17(16)='1' else-- DEC
                 '0'    when ALU_CONTROL="0001" OR  ALU_CONTROL="0010" OR ALU_CONTROL="1101"OR ALU_CONTROL="1110" else
		-- add,sub,inc,dec
                 Carry_FLAG_IN when RTI='1';   -- to save the old flag with RTI
---------------------------------------------------------------------------------------------------------------------------------------------
ZERO_FLAG <=     '1'  when ALU_CONTROL="0001" AND ALU_OUTPUT_17="00000000000000000" else   -- ADD      
                 '1'  when ALU_CONTROL="0010" AND ALU_OUTPUT_17="00000000000000000"else -- SUB
                 '1'  when ALU_CONTROL="0011" AND ALU_OUTPUT_17="00000000000000000" else -- AND
                 '1'  when ALU_CONTROL="0100" AND ALU_OUTPUT_17="00000000000000000" else -- OR
                 '1'  when ALU_CONTROL="1011" AND ALU_OUTPUT_17="00000000000000000" else -- NOT 
                 '1'  when ALU_CONTROL="1100" AND ALU_OUTPUT_17="00000000000000000" else -- Mul 
                 '1'  when ALU_CONTROL="1101" AND ALU_OUTPUT_17="00000000000000000" else -- INC
                 '1'  when ALU_CONTROL="1110" AND ALU_OUTPUT_17="00000000000000000"  else -- DEC 
-- can be written as ZERO_FLAGIN when RTI='1';
		--else '0';
		
                 '0'  when ALU_CONTROL="0001" OR  ALU_CONTROL="0010" OR ALU_CONTROL="0011" OR ALU_CONTROL="0100" OR ALU_CONTROL="1011" OR ALU_CONTROL="1100" OR ALU_CONTROL="1101"OR ALU_CONTROL="1110" else
                 ZERO_FLAGIN when RTI='1';   -- to save the old flag with RTI

--------------------------------------------------------------------------------------------------------------------------------------------- 
Neg_FLAG <=     --bit 15 (last bit) of output is sign bit as we deal in signed numbers; 
                 '1'  when ALU_CONTROL="0010" AND ALU_OUTPUT_17(15)='1' else -- SUB
                 '1'  when ALU_CONTROL="0011" AND ALU_OUTPUT_17(15)='1' else -- AND
                 '1'  when ALU_CONTROL="0100" AND ALU_OUTPUT_17(15)='1' else -- OR
                 '1'  when ALU_CONTROL="1011" AND ALU_OUTPUT_17(15)='1' else -- NOT 
                 '1'  when ALU_CONTROL="1100" AND ALU_OUTPUT_17(15)='1' else -- Mul 
                 '1'  when ALU_CONTROL="1101" AND ALU_OUTPUT_17(15)='1' else -- INC
                 '1'  when ALU_CONTROL="1110" AND ALU_OUTPUT_17(15)='1' else  -- DEC 
                 '0'  when ALU_CONTROL="0001" OR  ALU_CONTROL="0010" OR ALU_CONTROL="0011" OR ALU_CONTROL="0100" OR ALU_CONTROL="1011" OR ALU_CONTROL="1100" OR ALU_CONTROL="1101"OR ALU_CONTROL="1110" else
                 Neg_FLAGIN when RTI='1';   -- to save the old flag with RTI
--------------------------------------------------------------------------------------------------------------------------------------------- 

ALU_OUTPUT <= ALU_OUTPUT_17(15 downto 0); --- output without flags
end Arch_ALU;