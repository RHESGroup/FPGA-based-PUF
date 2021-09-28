library ieee;
use ieee.std_logic_1164.all;



entity PUF is
  Port (   	clk, rst: in std_logic; 
			challenge: in std_logic_vector (2 downto 0);
			RO_challenge: out std_logic_vector (2 downto 0);
			RO_response: in std_logic;
			
            response: out std_logic;
			finished: out std_logic
            );

end PUF;



architecture mixed of PUF

	attribute syn_force_pads;
	attribute syn_force_pads of RO_challenge: integer is 1;
begin

	/* synthesis syn_force_pads=1 syn_noprune=1*/

end mixed;