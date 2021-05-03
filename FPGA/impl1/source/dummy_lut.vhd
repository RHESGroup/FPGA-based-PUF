library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dummy_lut is
  Port (    a: in std_logic;
            s: in std_logic_vector(2 downto 0);
            o: out std_logic
            );
end dummy_lut;

architecture Behavioral of dummy_lut is

begin
    o <=  ((a) and s(0) and s(1) and s(2));

end Behavioral;
