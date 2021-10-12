library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dummy_lut is
  Port (    a: in std_logic;
            s: in std_logic_vector(1 downto 0);
			e: in std_logic;
            o: out std_logic
            );
			
	attribute syn_keep : boolean;
	attribute syn_keep of s: signal is true; --disable redundant s signal optimization
end dummy_lut;

architecture Behavioral of dummy_lut is
	attribute syn_hier : string;
	attribute syn_hier of Behavioral: architecture is "hard"; --disable cross-boundaries optimization
begin
    o <=  (not a and s(0) and s(1)) or (not a and not s(0) and s(1)) or (not a and s(0) and not s(1)) or (not a and not s(0) and s(1)) or e;

end Behavioral;
