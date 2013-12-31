library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity normalizer is
  Port ( frac  : in  std_logic_vector (27 downto 0);
         exp   : in  std_logic_vector (7 downto 0);
         shift : in  std_logic_vector (5 downto 0);
         expO  : out std_logic_vector (7 downto 0);
         fracO : out std_logic_vector (22 downto 0));
end normalizer;

architecture main of normalizer is
  component bshifter_right
    Port ( dataI : in std_logic_vector(31 downto 0); 
           op    : in std_logic_vector(7 downto 0);
           dataO : out std_logic_vector(31 downto 0));
  end component;
  
  component bshifter_left
    Port ( dataI : in std_logic_vector(31 downto 0); 
           op    : in std_logic_vector(7 downto 0);
           dataO : out std_logic_vector(31 downto 0));
  end component;

  signal left_shift_frac : std_logic_vector(31 downto 0);
  signal right_shift_frac : std_logic_vector(31 downto 0);
  signal shift_frac : std_logic_vector(27 downto 0);
  signal normalized_exp : std_logic_vector(9 downto 0);

  signal rounded_frac : std_logic_vector(27 downto 0);
  signal reshifted_frac : std_logic_vector(23 downto 0);
  signal rounded_exp  : std_logic_vector(9 downto 0);

  alias shift_direction : std_logic is shift(5);
  alias shift_amount : std_logic_vector(4 downto 0) is shift(4 downto 0);
begin
  left_shift: bshifter_left
  port map(
    dataI(31 downto 28) => "0000",
    dataI(27 downto 0) => frac,
    op(7 downto 5) => "000",
    op(4 downto 0)    => shift_amount,
    dataO => left_shift_frac);

  right_shift: bshifter_right
  port map(
    dataI(31 downto 28) => "0000",
    dataI(27 downto 0) => frac,
    op(7 downto 5) => "000",
    op(4 downto 0)    => shift_amount,
    dataO => right_shift_frac);

  shift_selector: process(left_shift_frac, right_shift_frac, exp, shift) begin
    case shift_direction is
      when '0' => 
        shift_frac <= left_shift_frac(27 downto 0);
        normalized_exp <= ("00" & exp) - shift_amount;
      when others => 
        shift_frac <= right_shift_frac(27 downto 0);
        normalized_exp <= ("00" & exp) + shift_amount;
    end case;
  end process;

  rounding: process(shift_frac) begin
    if (shift_frac(2) and 
      (shift_frac(3) or shift_frac(1) or shift_frac(0))) = '1' then
      rounded_frac <= shift_frac + "1000";
    else
      rounded_frac <= shift_frac;
    end if;
  end process;

  reshift: process(rounded_frac, normalized_exp) begin
    if rounded_frac(27) = '1' then
      reshifted_frac <= rounded_frac(27 downto 4);
      rounded_exp <= normalized_exp + 1;
    else 
      reshifted_frac <= rounded_frac(26 downto 3);
      rounded_exp <= normalized_exp;
    end if;
  end process;

  flowcheck: process(rounded_exp, reshifted_frac) begin
    if rounded_exp(9) = '1' then
      
      expO  <= (others => '0');
      fracO  <= (others => '0');
    elsif rounded_exp(8) = '1' then
      expO  <= (others => '1');
      fracO  <= (others => '0');
    elsif reshifted_frac = 0 then
      expO  <= (others => '0');
      fracO  <= (others => '0');
    else
      expO  <= rounded_exp(7 downto 0);
      fracO <= reshifted_frac(22 downto 0);
    end if;
  end process;
end main;



