library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frac_adder is
  Port ( winner_sign : in  std_logic;
         loser_sign  : in  std_logic;
         winner_frac : in  std_logic_vector(26 downto 0);
         loser_frac  : in  std_logic_vector(26 downto 0);
         frac_out    : out std_logic_vector(27 downto 0));
end frac_adder;

architecture blackbox of frac_adder is
begin
  main: process(winner_frac, loser_frac, winner_sign, loser_sign) begin
    if winner_sign = loser_sign then
      frac_out <= ('0' & winner_frac) + ('0' & loser_frac);
    else
      frac_out <= ('0' & winner_frac) - ('0' & loser_frac);
    end if;
  end process;
end blackbox;

