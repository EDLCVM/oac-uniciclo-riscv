library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AdderPC is
	port (
		A, B 		: in std_logic_vector(7 downto 0); 
		saida 	: out std_logic_vector(31 downto 0)
	);
end AdderPC;

architecture comportamento of AdderPC is

	begin
	process(A, B)
		begin
		saida <= std_logic_vector(resize(signed(A) + signed(B), 32));
	end process;

end comportamento;