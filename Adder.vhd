library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
	generic (WSIZE : natural := 32);
	port (
		A, B : in std_logic_vector(WSIZE - 1 downto 0);
		saida : out std_logic_vector(WSIZE - 1 downto 0)
	);
end Adder;

architecture comportamento of Adder is

	begin
	process(A, B)
		begin
		saida <= std_logic_vector(signed(A) + signed(B));
	end process;

end comportamento;