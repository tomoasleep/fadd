library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity msb_finder is
  Port ( data    : in  STD_LOGIC_VECTOR (27 downto 0);
         shift   : out std_logic_vector(5 downto 0)
       );
end msb_finder;

architecture blackbox of msb_finder is
begin
  process (data) begin
    if    (data(27) = '1') then shift <= "100001";
    elsif (data(26) = '1') then shift <= "000000";
    elsif (data(25) = '1') then shift <= "000001";
    elsif (data(24) = '1') then shift <= "000010";
    elsif (data(23) = '1') then shift <= "000011";
    elsif (data(22) = '1') then shift <= "000100";
    elsif (data(21) = '1') then shift <= "000101";
    elsif (data(20) = '1') then shift <= "000110";
    elsif (data(19) = '1') then shift <= "000111";
    elsif (data(18) = '1') then shift <= "001000";
    elsif (data(17) = '1') then shift <= "001001";
    elsif (data(16) = '1') then shift <= "001010";
    elsif (data(15) = '1') then shift <= "001011";
    elsif (data(14) = '1') then shift <= "001100";
    elsif (data(13) = '1') then shift <= "001101";
    elsif (data(12) = '1') then shift <= "001110";
    elsif (data(11) = '1') then shift <= "001111";
    elsif (data(10) = '1') then shift <= "010000";
    elsif (data(9) = '1')  then shift <= "010001";
    elsif (data(8) = '1')  then shift <= "010010";
    elsif (data(7) = '1')  then shift <= "010011";
    elsif (data(6) = '1')  then shift <= "010100";
    elsif (data(5) = '1')  then shift <= "010101";
    elsif (data(4) = '1')  then shift <= "010110";
    elsif (data(3) = '1')  then shift <= "010111";
    elsif (data(2) = '1')  then shift <= "011000";
    elsif (data(1) = '1')  then shift <= "011001";
    elsif (data(0) = '1')  then shift <= "011010";
    else                        shift <= "011011";
    end if;
  end process;
end blackbox;

