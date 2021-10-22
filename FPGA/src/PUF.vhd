library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PUF is
	generic ( n_inverters : integer := 2);
  Port (   	clk, rst: in std_logic; 
			challenge: in std_logic_vector (2*n_inverters-1 downto 0);
			enable: in std_logic;
            response: out std_logic_vector(63 downto 0);
			finished: out std_logic;
			
			challenge_to_metastable: out std_logic_vector (2*n_inverters-1 downto 0);
			enable_to_metastable: out std_logic;
			response_from_counter: in std_logic_vector(15 downto 0);
			response_from_metastable: in std_logic_vector(n_inverters-1 downto 0)
            );

end PUF;



architecture mixed of PUF is

	signal challenge_reg, next_challenge_reg: std_logic_vector(2*n_inverters-1 downto 0);
	signal wait_run, next_wait_run: unsigned(31 downto 0);
	
	
	type puf_state is (IDLE_S, PRELOAD_S, RUN_S, FINISHED_S);
	signal state, next_state : puf_state;
	
	component up_counter is
    port (
        cout   :out std_logic_vector (62 downto 0);  -- Output of the counter
        enable :in  std_logic;                      -- Enable counting
        clk    :in  std_logic;                      -- Input clock
        reset  :in  std_logic                       -- Input reset
    );
	end component;
	
begin

	response(n_inverters-1 downto 0) <= response_from_metastable;
	response(15 downto n_inverters) <= (others => '0');
	response(31 downto 16) <= response_from_counter;
	response(63 downto 32) <= (others => '0'); 
	
	challenge_to_metastable <= challenge_reg;
	
	process(state, challenge_reg, wait_run)
	begin

			-- default
			finished <= '0';
			enable_to_metastable <= '0';
			
			next_challenge_reg <= challenge_reg;
			next_wait_run <= wait_run;
			
			case STATE is		
				when IDLE_S =>
					if(enable = '1') then
						next_state <= PRELOAD_S;
					else
						next_state <= IDLE_S;
					end if;
					next_wait_run <= to_unsigned(2000000,32);
				when PRELOAD_S =>
					enable_to_metastable <= '1';
					next_challenge_reg <= challenge;
					if (wait_run = to_unsigned(0,32)) then
						next_state <= run_S;
						next_wait_run <= to_unsigned(2000000,32);
					else
						next_state <= PRELOAD_S;
						next_wait_run <= wait_run - to_unsigned(1,32);
					end if;
				when RUN_S =>
					next_wait_run <= wait_run - to_unsigned(1,32);
					enable_to_metastable <= '0';
					if (wait_run = to_unsigned(0,32)) then
						next_state <= FINISHED_S;
					else
						next_state <= RUN_S;
					end if;
				when FINISHED_S =>
					finished <= '1';
					
					next_state <= IDLE_S;
				when others =>
					next_state <= IDLE_S;
				end case;


	end process;

	process(clk, rst)
	begin
		if(rst = '1') then
			wait_run <= (others => '0');
			challenge_reg <= (others => '0');
			STATE <= IDLE_S;
		elsif(rising_edge(clk)) then
			wait_run <= next_wait_run;
			challenge_reg <= next_challenge_reg;
			state <= next_state;
		end if;
	end process;
end mixed;