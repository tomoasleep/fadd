library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bshifter_right is
  Port ( dataI : in std_logic_vector(31 downto 0); 
         op    : in std_logic_vector(7 downto 0);
         dataO : out std_logic_vector(31 downto 0));
end bshifter_right;

architecture shifter of bshifter_right is

  signal data1: std_logic_vector(31 downto 0);
  signal data2: std_logic_vector(31 downto 0);
  signal data4: std_logic_vector(31 downto 0);
  signal data8: std_logic_vector(31 downto 0);
  signal data16: std_logic_vector(31 downto 0);

  signal op765 : std_logic;

  component right_shift_cell 
    generic ( shift : integer := 0);
    Port ( doShift  : in std_logic;
           dataI    : in std_logic_vector(31 downto 0); 
           dataO    : out std_logic_vector(31 downto 0));
  end component;
begin 
  shift1: right_shift_cell generic map (shift => 1)
  port map(
    doShift => op(0),
    dataI => dataI,
    dataO => data1);

  shift2: right_shift_cell generic map (shift => 2)
  port map(
    doShift => op(1),
    dataI => data1,
    dataO => data2);

  shift4: right_shift_cell generic map (shift => 4)
  port map(
    doShift => op(2),
    dataI => data2,
    dataO => data4);

  shift8: right_shift_cell generic map (shift => 8)
  port map(
    doShift => op(3),
    dataI => data4,
    dataO => data8);

  shift16: right_shift_cell generic map (shift => 16)
  port map(
    doShift => op(4),
    dataI => data8,
    dataO => data16);

  shift32: right_shift_cell generic map (shift => 32)
  port map(
    doShift => op765,
    dataI => data16,
    dataO => dataO);

  op_gather: process(op) begin
    op765 <= op(7) or op(6) or op(5);
  end process;

end shifter;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity right_shift_cell is generic ( shift : integer := 1);
  Port ( doShift  : in std_logic;
         dataI    : in std_logic_vector(31 downto 0); 
         dataO    : out std_logic_vector(31 downto 0));
end right_shift_cell;

architecture main of right_shift_cell is
begin
  shifter: process(dataI, doShift) begin
    if doShift = '1' then
      dataO(31 downto 1) <= SHR(dataI(31 downto 1),
        conv_std_logic_vector(shift, 10));

      if dataI((shift - 1) downto 0) = 0 then
        dataO(0) <= '0';
      else
        dataO(0) <= '1';
      end if;
    else
      dataO <= dataI;
    end if;
  end process;
end main; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity left_shift_cell is
  generic ( shift : integer := 0);
  Port ( doShift  : in std_logic;
         dataI    : in std_logic_vector(31 downto 0); 
         dataO    : out std_logic_vector(31 downto 0));
end left_shift_cell;

architecture main of left_shift_cell is
begin
  shifter: process(dataI, doShift) begin
    if doShift = '1' then
      dataO(31 downto 1) <= SHL(dataI(31 downto 1), 
        conv_std_logic_vector(shift, 10));

      dataO(0) <= dataI(0);
    else
      dataO <= dataI;
    end if;
  end process;
end main; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bshifter_left is
  Port ( dataI : in std_logic_vector(31 downto 0); 
         op    : in std_logic_vector(7 downto 0);
         dataO : out std_logic_vector(31 downto 0));
end bshifter_left;

architecture shifter of bshifter_left is

  signal data1: std_logic_vector(31 downto 0);
  signal data2: std_logic_vector(31 downto 0);
  signal data4: std_logic_vector(31 downto 0);
  signal data8: std_logic_vector(31 downto 0);
  signal data16: std_logic_vector(31 downto 0);

  signal op765 : std_logic;

  component left_shift_cell 
    generic ( shift : integer := 0);
    Port ( doShift  : in std_logic;
           dataI    : in std_logic_vector(31 downto 0); 
           dataO    : out std_logic_vector(31 downto 0));
  end component;
begin 
  shift1: left_shift_cell generic map (shift => 1)
  port map(
    doShift => op(0),
    dataI => dataI,
    dataO => data1);

  shift2: left_shift_cell generic map (shift => 2)
  port map(
    doShift => op(1),
    dataI => data1,
    dataO => data2);

  shift4: left_shift_cell generic map (shift => 4)
  port map(
    doShift => op(2),
    dataI => data2,
    dataO => data4);

  shift8: left_shift_cell generic map (shift => 8)
  port map(
    doShift => op(3),
    dataI => data4,
    dataO => data8);

  shift16: left_shift_cell generic map (shift => 16)
  port map(
    doShift => op(4),
    dataI => data8,
    dataO => data16);

  shift32: left_shift_cell generic map (shift => 32)
  port map(
    doShift => op765,
    dataI => data16,
    dataO => dataO);

  op_gather: process(op) begin
    op765 <= op(7) or op(6) or op(5);
  end process;

end shifter;

