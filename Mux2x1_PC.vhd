library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Mux2x1_PC is
	generic (WSIZE : natural := 32);
	port(
		seletor : in std_logic;
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		saida : out std_logic_vector(7 downto 0)
	);
end Mux2x1_PC;

architecture comportamento of Mux2x1_PC is
begin
	process(seletor, A, B)
	begin

		if (seletor = '0') then
			saida <= std_logic_vector(resize(unsigned(A), 8));
		elsif (seletor = '1') then
			saida <= std_logic_vector(resize(unsigned(B), 8));
		else
			saida <= "00000000";
		end if;

	end process;
end comportamento;