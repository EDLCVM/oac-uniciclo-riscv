library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	port(
		entrada :  in std_logic_vector(7 downto 0) := "00000000";
		saida	  : out std_logic_vector(7 downto 0) := "00000000"
	);
end PC;

architecture comportamento of PC is
	begin
	process(entrada)
		begin

			saida <= entrada;

	end process;
		
end comportamento;