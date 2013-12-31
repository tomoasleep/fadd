library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity exception_handler is
  Port ( dataA  : in std_logic_vector(31 downto 0); 
         dataB  : in std_logic_vector(31 downto 0);
         flag   : out std_logic;
         result : out std_logic_vector(31 downto 0));
end exception_handler;

architecture main of exception_handler is
begin
  process(dataA, dataB) begin
    if dataA(30 downto 0) = 0 then
      result <= dataB;
      flag <= '1';
    elsif dataB(30 downto 0) = 0 then
      result <= dataA;
      flag <= '1';
    elsif dataA(30 downto 23) = 0 then
      result <= dataA;
      flag <= '1';
    elsif dataB(30 downto 23) = 0 then
      result <= dataB;
      flag <= '1';
    elsif dataA(30 downto 23) = "11111111" then
      if dataA(22 downto 0) = 0 then
        -- inf 
        if dataB(30 downto 23) = "11111111" then
          if dataB(22 downto 0) = 0 then
            -- inf (B)
            if dataA(31) = dataB(31) then
              result <= dataA;
            else
              result(31 downto 0) <= x"11111111";
            end if;
          else
            -- nan (B)
            result <= dataB;
          end if;
        else
          result <= dataA;
        end if;
      else
        -- nan
        result <= dataA;
      end if;
      flag <= '1';

    elsif dataB(30 downto 23) = "11111111" then
      if dataB(22 downto 0) = 0 then
        -- inf 
        if dataA(30 downto 23) = "11111111" then
          if dataA(22 downto 0) = 0 then
            -- inf (A)
            if dataA(31) = dataB(31) then
              result <= dataB;
            else
              result(31 downto 0) <= x"11111111";
            end if;
          else
            -- nan (A)
            result <= dataA;
          end if;
        else
          result <= dataB;
        end if;
      else
        -- nan
        result <= dataB;
      end if;
      flag <= '1';
    else
      flag <= '0';
    end if;
  end process;
end main;
