library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frac_adder is
  Port ( winner_sign : in  std_logic;
         loser_sign  : in  std_logic;
         winner_frac : in  std_logic_vector(26 downto 0);
         loser_frac  : in  std_logic_vector(26 downto 0);
         frac_out    : out std_logic_vector(27 downto 0);
         minus_frag  : out std_logic);
end frac_adder;

architecture blackbox of frac_adder is
begin
  main: process(winner_frac, loser_frac, winner_sign, loser_sign) begin
    if winner_sign = loser_sign then
      frac_out <= ('0' & winner_frac) + ('0' & loser_frac);
      minus_frag <= '0';
    else
      if winner_frac < loser_frac then
        frac_out <= ('0' & loser_frac) - ('0' & winner_frac);
        minus_frag <= '1';
      else 
        frac_out <= ('0' & winner_frac) - ('0' & loser_frac);
        minus_frag <= '0';
      end if;
    end if;
  end process;
end blackbox;

