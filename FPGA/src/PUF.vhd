library ieee;
use ieee.std_logic_1164.all;



entity PUF is
  Port (   	clk, rst: in std_logic; 
			challenge: in std_logic_vector (2 downto 0);
			
            response: out std_logic;
			finished: out std_logic
            );

end PUF;



architecture mixed of PUF is
	component dummy_lut is
	  Port (    a: in std_logic;
				s: in std_logic_vector(2 downto 0);
				o: out std_logic
				);
	end component;
	signal feedback: std_logic;
begin

	DL: dummy_lut port map (a => feedback, s => challenge, o => feedback);
	response <= feedback;

end mixed;