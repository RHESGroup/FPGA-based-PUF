library ieee;
use ieee.std_logic_1164.all;

entity up_counter is
    port (
        cout   :out std_logic_vector (62 downto 0);  -- Output of the counter
        enable :in  std_logic;                      -- Enable counting, active low
        clk    :in  std_logic;                      -- Input clock
        reset  :in  std_logic                       -- Input reset
    );
end entity;

architecture rtl of up_counter is
    signal count :std_logic_vector (62 downto 0);
begin
    process (clk, reset) begin
		if (reset = '1') then
				count <= (others=>'0');
        elsif (rising_edge(clk)) then

            if (enable = '1') then
                count(62 downto 1) <= count(61 downto 0);
				count(0) <= '1';
            end if;
        end if;
    end process;
    cout <= count;
end architecture;