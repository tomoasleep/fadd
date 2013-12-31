library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd is
  Port ( clk   : in std_logic;
         inputA : in std_logic_vector (31 downto 0);
         inputB : in std_logic_vector (31 downto 0);
         result: out std_logic_vector(31 downto 0));

end fadd;

architecture adder of fadd is

  signal winner     : std_logic_vector(31 downto 0);
  signal loser      : std_logic_vector(31 downto 0);
  signal exp_sub    : std_logic_vector(7 downto 0);
  signal loser_frac : std_logic_vector(26 downto 0);
  signal sign_reverse : std_logic;
  signal frac_sum   : std_logic_vector(27 downto 0); 
  signal shift      : std_logic_vector(5 downto 0);

  signal dataA      : std_logic_vector (31 downto 0);
  signal dataB      : std_logic_vector (31 downto 0);

  signal normalized_result : std_logic_vector (30 downto 0);

  signal exception_result : std_logic_vector(31 downto 0);
  signal exception_flag : std_logic;
  -- signal result_sign : std_logic; 

  signal notuse : std_logic_vector(4 downto 0);

  component exception_handler
    Port ( dataA  : in std_logic_vector(31 downto 0); 
           dataB  : in std_logic_vector(31 downto 0);
           flag   : out std_logic;
           result : out std_logic_vector(31 downto 0));
  end component;

  component comparetor
    Port ( dataA  : in std_logic_vector (31 downto 0);
           dataB  : in std_logic_vector (31 downto 0);
           winner : out std_logic_vector(31 downto 0);
           loser  : out std_logic_vector(31 downto 0);
           exp_sub: out std_logic_vector(7 downto 0));
  end component;

  component bshifter_right
    Port ( dataI : in std_logic_vector(31 downto 0); 
           op    : in std_logic_vector(7 downto 0);
           dataO : out std_logic_vector(31 downto 0));
  end component;

  component frac_adder
    Port ( winner_sign : in  std_logic;
           loser_sign  : in  std_logic;
           winner_frac : in  std_logic_vector(26 downto 0);
           loser_frac  : in  std_logic_vector(26 downto 0);
           frac_out    : out std_logic_vector(27 downto 0);
           minus_frag  : out std_logic);
  end component;

  component msb_finder
    Port ( data : in  STD_LOGIC_VECTOR (27 downto 0);
           shift  : out std_logic_vector(5 downto 0));
  end component;

  component normalizer
    Port ( frac  : in  std_logic_vector (27 downto 0);
           exp   : in  std_logic_vector (7 downto 0);
           shift : in  std_logic_vector (5 downto 0);
           expO  : out std_logic_vector (7 downto 0);
           fracO : out std_logic_vector (22 downto 0));
  end component;
begin

  dataA <= inputA;
  dataB <= inputB;

  exception: exception_handler
  port map(
    dataA => dataA,
    dataB => dataB,
    flag => exception_flag, 
    result => exception_result);

  compare: comparetor
  port map(
    dataA => dataA,
    dataB => dataB,
    winner => winner,
    loser => loser,
    exp_sub => exp_sub);

  fix_frac: bshifter_right 
  port map(
    dataI(31 downto 27) => "00000",
    dataI(26) => '1',
    dataI(25 downto 3)  => loser(22 downto 0),
    dataI(2 downto 0)   => "000",
    op => exp_sub,
    dataO(31 downto 27) => notuse,
    dataO(26 downto 0) => loser_frac);

  frac_add: frac_adder
  port map(
    winner_sign => winner(31),
    loser_sign => loser(31),
    winner_frac(26) => '1',
    winner_frac(25 downto 3) => winner(22 downto 0),
    winner_frac(2 downto 0) => "000",
    loser_frac => loser_frac,
    frac_out => frac_sum,
    minus_frag => sign_reverse);

  find_msb: msb_finder
  port map(
    data => frac_sum,
    shift => shift);

  normalize: normalizer
  port map(
    frac => frac_sum,
    exp => winner(30 downto 23),
    shift => shift,
    expO => normalized_result(30 downto 23),
    fracO => normalized_result(22 downto 0));

  gen_result: process(winner, sign_reverse, normalized_result, 
    exception_flag, exception_result) begin
    if exception_flag = '0' then
      result(31) <= winner(31) xor sign_reverse; 
      result(30 downto 0) <= normalized_result;
    else
      result <= exception_result;
    end if;
  end process;
end adder;

