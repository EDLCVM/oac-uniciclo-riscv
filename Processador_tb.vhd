library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Processador_tb is
end Processador_tb;

architecture comportamento of Processador_tb is

	component Processador is
	port(
		clock 		: in std_logic;
		PC_entrada 	: in std_logic_vector(7 downto 0);
		saidaInstr 	: out std_logic_vector(31 downto 0)
	);
	end component;
	
	signal clock 		: std_logic := '0';
	signal PC_entrada : std_logic_vector(7 downto 0);
	signal saidaInstr : std_logic_vector(31 downto 0);
	
	begin
		i1 : Processador
		port map (
			clock 		=> clock,
			PC_entrada 	=> PC_entrada,
			saidaInstr 	=> saidaInstr
		);
		
		clock <= '1' after 2 ps when clock = '0' else
					'0' after 2 ps when clock = '1';
		
		init: process
			begin
			
			PC_entrada <= "00000000";
			wait for 4 ps;
			
			PC_entrada <= "00000100";
			wait for 4 ps;
			
			PC_entrada <= "00001000";
			wait for 4 ps;
			
			PC_entrada <= "00001100";
			wait for 4 ps;
			
			PC_entrada <= "00010000";
			wait for 4 ps;
			
		end process init;

end comportamento;