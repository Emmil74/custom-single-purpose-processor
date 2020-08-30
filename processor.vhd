library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Processor is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           B : in  STD_LOGIC;
			  D : in STD_LOGIC;
           C : out  STD_LOGIC_VECTOR (7 downto 0));
end Processor;

architecture Behavioral of Processor is
type statetype is (start, Swait, count,count2, Bdwait);
signal state, nextstate: statetype;

signal counter, counternext: STD_LOGIC_VECTOR (7 downto 0);

begin
--state register
process(clk, reset) 
begin
if(reset ='0') then
state <= start;
counter <= "00000000";
elsif (clk' event and clk='1') then
state <= nextstate;
counter <=counternext;
end if;
end process;

--combinational logic
process(state, B, D, counter)
begin 
case (state) is
when start =>
counternext <="00000000";
nextstate <= Swait;

when Swait =>
counternext <=counter;
if (B='0') then
nextstate <= count;
elsif (D = '0') then 
nextstate <= count2;
else
nextstate <= Swait;
end if;

when count =>
counternext <= counter + 1;
if (B='0') then
nextstate <= Bdwait;
else
nextstate<= Swait;
end if;

when count2 =>
counternext <= counter - 1;
if (D='0') then
nextstate <= Bdwait;
else
nextstate<= Swait;
end if;

when Bdwait =>
counternext <=counter;
if (B='0' or D = '0') then
nextstate <= Bdwait;
else 
nextstate<= Swait;
end if;

end case;
end process;
c <= counter;

end Behavioral;
