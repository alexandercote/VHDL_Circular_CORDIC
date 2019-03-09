
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Describes mathematical heart of the cordic algorithm
-- mu: boolean, false -> -1, true -> 1

entity cordic_alu is 

	Port (
		trigger							:	in	std_logic;
		x_in, y_in, z_in, theta			:	in	signed ( 15 downto 0 );
		i								:	in 	std_logic_vector(3 downto 0);
		mu								:	in	std_logic;
		x_out, y_out, z_out				:	out	signed ( 15 downto 0 );
		done							:	out std_logic
	);
end cordic_alu;


architecture behav of cordic_alu is
	signal x_done: std_logic;
	signal y_done: std_logic;
	signal z_done: std_logic;
begin

x_calc: process ( trigger ) is
begin	
	if rising_edge(trigger) then
		x_done <= '0';
	
		if (mu = '1') then
			x_out <= x_in - SHIFT_RIGHT(y_in, to_integer(unsigned(i)));
		else
			x_out <= x_in + SHIFT_RIGHT(y_in, to_integer(unsigned(i)));
		end if;
	
		x_done <= '1';
		
	end if;
	
end process;

y_calc: process ( trigger ) is
begin
	
	if rising_edge(trigger) then
		y_done <= '0';
	
		if (mu = '1') then
			y_out <= y_in + SHIFT_RIGHT(x_in, to_integer(unsigned(i)));
		else
			y_out <= y_in - SHIFT_RIGHT(x_in, to_integer(unsigned(i)));
		end if;
	
		y_done <= '1';
	end if;
	
end process;

z_calc: process ( trigger ) is
begin
	if rising_edge(trigger) then
		z_done <= '0';
	
		if (mu = '1') then
			z_out <= z_in - theta;
		else
			z_out <= z_in + theta;
		end if;
	
		z_done <= '1';
	
	end if;
	
end process;

done <= x_done and y_done and z_done;

end;