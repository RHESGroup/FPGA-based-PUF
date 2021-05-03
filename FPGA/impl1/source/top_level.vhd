library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port(	
			cpu_fpga_bus_a		: in std_logic_vector(5 downto 0);
			cpu_fpga_bus_d		: in std_logic_vector(15 downto 0);
			cpu_fpga_bus_noe    : in std_logic;	
			cpu_fpga_bus_nwe    : in std_logic;		
			cpu_fpga_bus_ne1    : in std_logic;		
			cpu_fpga_clk		: in std_logic;
			cpu_fpga_int_n      : out std_logic;
			cpu_fpga_rst		: in std_logic;
			fpga_io_gp			: out std_logic_vector(7 downto 0)
		);
end top_level;

architecture BEHAVIORAL of top_level is
	
	-- FSM STATES
	type input_detector_state_type is (OFF, IDLE, WAIT_ADDSET, WAIT_DATAST);
	signal STATE : input_detector_state_type;

	 
begin

	process(cpu_fpga_clk) 
	begin

		if(cpu_fpga_rst = '1') then
			STATE 			<= IDLE;
			cpu_fpga_int_n  <= '0';
			fpga_io_gp		<= (others => '1');

		elsif(rising_edge(cpu_fpga_clk)) then

			-- FSM behavior
			case STATE is
			
				when IDLE =>
					if(cpu_fpga_bus_ne1 = '0') then 
						STATE <= WAIT_ADDSET;
					end if;

				when WAIT_ADDSET => 
					if(cpu_fpga_bus_nwe = '0') then
						STATE <= WAIT_DATAST;	
					else
						STATE <= WAIT_ADDSET;
					end if;

				when WAIT_DATAST =>
					if(cpu_fpga_bus_nwe = '1') then
						fpga_io_gp	<= not(cpu_fpga_bus_d(7 downto 0));
						STATE 		<= IDLE;
					else
						STATE 	<= WAIT_DATAST;
					end if;

				when others =>
					STATE <= OFF;

			end case;
		end if;
	end process; 

end BEHAVIORAL;