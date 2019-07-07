library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Mux2x1 is
	generic (WSIZE : natural := 32);
	port(
		seletor : in std_logic;
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		saida : out std_logic_vector(WSIZE-1 downto 0)
	);
end Mux2x1;

architecture comportamento of Mux2x1 is
begin
	process(seletor, A, B)
	begin

		if (seletor = '0') then
			saida <= A;
		elsif (seletor = '1') then
			saida <= B;
		else
			saida <= X"00000000";
		end if;

	end process;
end comportamento;