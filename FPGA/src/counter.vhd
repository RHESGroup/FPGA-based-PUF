library ieee;
use ieee.std_logic_1164.all;

entity up_counter is
    port (
        cout   :out std_logic_vector (15 downto 0);  -- Output of the counter
        enable :in  std_logic;                      -- Enable counting, active low
        clk    :in  std_logic;                      -- Input clock
        reset  :in  std_logic                       -- Input reset
    );
end entity;

architecture rtl of up_counter is
    signal count :std_logic_vector (15 downto 0);
begin
    process (clk, reset, count) begin
		if(reset = '1') then
			count <= (others => '0')
		else
			if (falling_edge(clk)) then
				count(0) <= not count(0);
			end if;
			for i in 1 to 15 loop
				if (falling_edge(count(i-1)) then
				count(i) <= not count(i);
				end if;
			end loop;
		end;
    end process;
    cout <= count;
end architecture;