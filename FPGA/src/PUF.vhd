library ieee;
use ieee.std_logic_1164.all;



entity PUF is
  Port (   	clk, rst: in std_logic; 
			challenge: in std_logic_vector (3 downto 0);
			enable: in std_logic;
            response: out std_logic;
			finished: out std_logic
            );

end PUF;



architecture mixed of PUF is
	component dummy_lut is
	  Port (    a: in std_logic;
				s: in std_logic_vector(1 downto 0);
				e: in std_logic;
				o: out std_logic
				);
	end component;
	signal feedback: std_logic;
	signal a: std_logic;
	
begin

	DL1: dummy_lut port map (a => feedback, s => challenge(3 downto 2), e => enable, o => a);
	DL2: dummy_lut port map (a => a, s => challenge(1 downto 0), e => enable, o => feedback);
	
	
	process
	begin
		if(rst = '1') then
			response <= '0';
			
		elsif(rising_edge(clk)) then
			response <= feedback;
		end if;

	end process;

end mixed;