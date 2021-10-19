library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	generic ( n_inverters : integer := 2);
	port(	
			cpu_fpga_bus_a		: in std_logic_vector(5 downto 0);
			cpu_fpga_bus_d		: inout std_logic_vector(15 downto 0);
			cpu_fpga_bus_noe    : in std_logic;	
			cpu_fpga_bus_nwe    : in std_logic;		
			cpu_fpga_bus_ne1    : in std_logic;		
			cpu_fpga_clk		: in std_logic;
			cpu_fpga_int_n      : out std_logic;
			cpu_fpga_rst		: in std_logic;
			fpga_io_gp			: out std_logic_vector(7 downto 0);
			
			challenge_to_metastable: out std_logic_vector (2*n_inverters-1 downto 0);
			enable_to_metastable: out std_logic;
			response_from_metastable: in std_logic := '0'
		);
end top_level;

architecture BEHAVIORAL of top_level is
	
	-- FSM STATES
	type input_detector_state_type is (OFF, IDLE, WAIT_ADDSET, WAIT_DATAST_W, WAIT_DATAST_R);
	signal STATE : input_detector_state_type;
	
	type buffer_type is array (15 downto 0) of std_logic_vector(15 downto 0);
	signal BUFF: buffer_type;
	signal address : std_logic_vector(3 downto 0);
	signal led_output : std_logic_vector(15 downto 0);
	signal puf_response: std_logic_vector(63 downto 0);
	signal update_puf_response: std_logic;
	signal challenge: std_logic_vector(63 downto 0);
	
	component PUF is
		generic ( n_inverters : integer := 2);
	  Port (   	clk, rst: in std_logic;
				challenge: in std_logic_vector (2*n_inverters-1 downto 0);
				enable: in std_logic;
				response: out std_logic_vector(63 downto 0);
				finished: out std_logic;
				
			challenge_to_metastable: out std_logic_vector (2*n_inverters-1 downto 0);
			enable_to_metastable: out std_logic;
			response_from_metastable: in std_logic := '0'
	);
	end component;
begin

	PUF1: PUF 
	generic map (n_inverters => 2)
	port map (clk => cpu_fpga_clk, rst => cpu_fpga_rst, challenge => buff(5)(3 downto 0), enable=> buff(1)(4), response => puf_response, finished => update_puf_response,
				challenge_to_metastable => challenge_to_metastable, enable_to_metastable => enable_to_metastable, response_from_metastable => response_from_metastable);

	fpga_io_gp(7 downto 0) <= (others => '1');
	challenge(63 downto 48) <= buff(2);
	challenge(47 downto 32) <= buff(3);
	challenge(31 downto 16) <= buff(4);
	challenge(15 downto 0) <= buff(5);
	process(cpu_fpga_clk, cpu_fpga_rst) 
	begin
	
		-- Default

		if(cpu_fpga_rst = '1') then
			STATE 			<= IDLE;
			cpu_fpga_int_n  <= '0';
			BUFF <= (others => (others => '0'));
			address <= (others => '0');
			cpu_fpga_bus_d <= (others => 'Z');
			

		elsif(rising_edge(cpu_fpga_clk)) then
			-- default
			cpu_fpga_bus_d <= (others => 'Z');
			
			-- update internal signals
			if (update_puf_response = '1') then
				BUFF(6) <= puf_response(63 downto 48);
				BUFF(7) <= puf_response(47 downto 32);
				BUFF(8) <= puf_response(31 downto 16);
				BUFF(9) <= puf_response(15 downto 0);
				buff(1)(4) <= '0';
			end if;
			
			-- FSM behavior
			case STATE is
		
				when IDLE =>
					if(cpu_fpga_bus_ne1 = '0') then 
						STATE <= WAIT_ADDSET;
					end if;

				when WAIT_ADDSET => 
					if(cpu_fpga_bus_nwe = '0') then
						STATE <= WAIT_DATAST_W;
						address <= cpu_fpga_bus_a(3 downto 0);
					elsif(cpu_fpga_bus_noe = '0') then	
						STATE <= WAIT_DATAST_R;
						address <= cpu_fpga_bus_a(3 downto 0);
					else
						STATE <= WAIT_ADDSET;
					end if;

				when WAIT_DATAST_W =>
					if(cpu_fpga_bus_nwe = '1') then
						BUFF(to_integer(unsigned(address)))	<= cpu_fpga_bus_d;
						STATE 		<= IDLE;
					else
						STATE 	<= WAIT_DATAST_W;
					end if;
					
				when WAIT_DATAST_R =>
					if(cpu_fpga_bus_noe = '0') then
						cpu_fpga_bus_d <= BUFF(to_integer(unsigned(address)));
						STATE 		<= WAIT_DATAST_R;
					else
						STATE 	<= IDLE;
					end if;

				when others =>
					STATE <= OFF;

			end case;
		end if;
	end process;

end BEHAVIORAL;