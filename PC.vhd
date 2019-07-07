library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	port(
		clock   :  in std_logic;
		entrada :  in std_logic_vector(7 downto 0);
		saida	  : out std_logic_vector(7 downto 0)
	);
end PC;

architecture comportamento of PC is

	signal pc_interno : std_logic_vector(7 downto 0) := "00000000";
	
	begin
	saida <= pc_interno;
	
	process(clock)
		begin
		if ( rising_edge(clock) ) then
			pc_interno <= entrada;
		end if;

	end process;
		
end comportamento;