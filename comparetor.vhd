library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparetor is
  Port ( dataA  : in std_logic_vector (31 downto 0);
         dataB  : in std_logic_vector (31 downto 0);
         winner : out std_logic_vector(31 downto 0);
         loser  : out std_logic_vector(31 downto 0);
         exp_sub: out std_logic_vector(7 downto 0));
end comparetor;

architecture compare of comparetor is
begin
main: process(dataA, dataB) begin
    if dataA(30 downto 0) < dataB(30 downto 0) then
      winner <= dataB;
      loser <= dataA;
      exp_sub <= dataB(30 downto 23) - dataA(30 downto 23);
    else 
      winner <= dataA;
      loser <= dataB;
      exp_sub <= dataA(30 downto 23) - dataB(30 downto 23);
    end if;
  end process;
end compare;

