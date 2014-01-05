library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_exception_handler is
  Port ( dataA  : in std_logic_vector(31 downto 0); 
         dataB  : in std_logic_vector(31 downto 0);
         flag   : out std_logic;
         result : out std_logic_vector(31 downto 0));
end fadd_exception_handler;

architecture main of fadd_exception_handler is
  constant zero : std_logic_vector(31 downto 0) := (others => '0');
  constant exp_max : std_logic_vector(7 downto 0) := (others => '1');
  constant pos_inf : std_logic_vector(31 downto 0)
    := (31 => '0', 30 downto 23 => '1', 22 downto 0 => '0');
  constant neg_inf : std_logic_vector(31 downto 0)
    := (31 => '1', 30 downto 23 => '1', 22 downto 0 => '0');
  constant nan_value : std_logic_vector(31 downto 0) := (others => '1');

  signal is_all_zero : std_logic := '0';
  signal is_zero_A : std_logic := '0';
  signal is_zero_B : std_logic := '0';

  signal is_exp_zero_A : std_logic := '0';
  signal is_exp_zero_B : std_logic := '0';

  signal is_exp_max_A : std_logic := '0';
  signal is_exp_max_B : std_logic := '0';

  signal is_frac_zero_A : std_logic := '0';
  signal is_frac_zero_B : std_logic := '0';

  signal is_inf_A : std_logic := '0';
  signal is_inf_B : std_logic := '0';

  signal is_pos_inf_A : std_logic := '0';
  signal is_pos_inf_B : std_logic := '0';

  signal is_neg_inf_A : std_logic := '0';
  signal is_neg_inf_B : std_logic := '0';

  signal is_nan_A : std_logic := '0';
  signal is_nan_B : std_logic := '0';

  signal is_non_regular_A : std_logic := '0';
  signal is_non_regular_B : std_logic := '0';

  signal is_exception_A : std_logic := '0';
  signal is_exception_B : std_logic := '0';

  signal isnt_pos_inf : std_logic := '0';
  signal isnt_neg_inf : std_logic := '0';
begin
  is_frac_zero_A <= '1' when dataA(22 downto 0) = 0 else '0';
  is_frac_zero_B <= '1' when dataB(22 downto 0) = 0 else '0';
  
  is_exp_zero_A <= '1' when dataA(30 downto 23) = 0 else '0';
  is_exp_zero_B <= '1' when dataB(30 downto 23) = 0 else '0';
  
  is_exp_max_A <= '1' when dataA(30 downto 23) = exp_max else '0';
  is_exp_max_B <= '1' when dataB(30 downto 23) = exp_max else '0';
  
  is_zero_A <= '1' when dataA(30 downto 0) = 0 else '0';
  is_zero_B <= '1' when dataB(30 downto 0) = 0 else '0';

  is_inf_A <= is_exp_max_A and is_frac_zero_A;
  is_inf_B <= is_exp_max_B and is_frac_zero_B;

  is_nan_A <= is_exp_max_A and (not is_frac_zero_A);
  is_nan_B <= is_exp_max_B and (not is_frac_zero_B);

  is_non_regular_A <= is_exp_zero_A and (not is_frac_zero_A);
  is_non_regular_B <= is_exp_zero_B and (not is_frac_zero_B);

  is_exception_A <= is_zero_A or is_inf_A or is_nan_A or is_non_regular_A;
  is_exception_B <= is_zero_B or is_inf_B or is_nan_B or is_non_regular_B;

  is_pos_inf_A <= is_inf_A and (not dataA(31));
  is_pos_inf_B <= is_inf_B and (not dataB(31));

  is_neg_inf_A <= is_inf_A and dataA(31);
  is_neg_inf_B <= is_inf_B and dataB(31);

  isnt_pos_inf <= (not is_pos_inf_A) and (not is_pos_inf_B);
  isnt_neg_inf <= (not is_neg_inf_A) and (not is_neg_inf_B);

  is_all_zero <= is_zero_A and is_zero_B;

  flag <= is_exception_A or is_exception_B;
  result <= zero    when is_all_zero = '1' else
            dataB   when is_zero_A = '1' else
            dataA   when is_zero_B = '1' else
            dataA   when (is_nan_A or is_non_regular_A) = '1' else
            dataB   when (is_nan_B or is_non_regular_B) = '1' else
            neg_inf when isnt_pos_inf = '1' else
            pos_inf when isnt_neg_inf = '1' else
            nan_value;
end main;
