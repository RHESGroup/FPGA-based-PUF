library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PUF is
  Port (   	clk, rst: in std_logic; 
			challenge: in std_logic_vector (3 downto 0);
			enable: in std_logic;
            response: out std_logic_vector(31 downto 0);
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
	signal enable_counter: std_logic;
	signal reset_counter: std_logic;
	signal challenge_reg, next_challenge_reg: std_logic_vector(3 downto 0);
	signal wait_run, next_wait_run: unsigned(31 downto 0);
	signal response_reg, next_response_reg: std_logic;
	signal counter_clk: std_logic;
	
	type puf_state is (IDLE_S, PRELOAD_S, RUN_S, FINISHED_S);
	signal state, next_state : puf_state;
	
	component up_counter is
    port (
        cout   :out std_logic_vector (30 downto 0);  -- Output of the counter
        enable :in  std_logic;                      -- Enable counting
        clk    :in  std_logic;                      -- Input clock
        reset  :in  std_logic                       -- Input reset
    );
	end component;
	
begin

	DL1: dummy_lut port map (a => feedback, s => challenge_reg(3 downto 2), e => enable_counter, o => a);
	DL2: dummy_lut port map (a => a, s => challenge_reg(1 downto 0), e => enable_counter, o => feedback);
	
	COUNT_1: up_counter port map (cout => response(31 downto 1), enable => enable_counter, clk => counter_clk, reset => reset_counter);
	response(0) <= response_reg;
	
	next_response_reg <= feedback;
	
	process(feedback)
	begin
		if (rising_edge(feedback)) then
			counter_clk <= not counter_clk;
		end if;
	end process;
	
	process(state, challenge_reg, wait_run)
	begin

			-- default
			finished <= '0';
			enable_counter <= '1';
			reset_counter <= '0';
			
			next_challenge_reg <= challenge_reg;
			next_wait_run <= wait_run;
			
			case STATE is		
				when IDLE_S =>
					if(enable = '1') then
						next_state <= PRELOAD_S;
					else
						next_state <= IDLE_S;
					end if;
				when PRELOAD_S =>
					reset_counter <= '1';
					next_challenge_reg <= challenge;
					enable_counter <= '1';
					next_wait_run <= to_unsigned(20000000,32);
					next_state <= RUN_S;
				when RUN_S =>
					next_wait_run <= wait_run - to_unsigned(1,32);
					enable_counter <= '0';
					if (wait_run = to_unsigned(0,22)) then
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
			response_reg <= '0';
			STATE <= IDLE_S;
		elsif(rising_edge(clk)) then
			wait_run <= next_wait_run;
			challenge_reg <= next_challenge_reg;
			response_reg <= next_response_reg;
			state <= next_state;
		end if;
	end process;
end mixed;