library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ImmGen is
	generic (WSIZE : natural := 32);
	port (
		instrucao 	:  in std_logic_vector(WSIZE - 1 downto 0);
		imm32 		: out std_logic_vector(WSIZE - 1 downto 0)
);
end ImmGen;

architecture comportamento of ImmGen is

signal opcode  : std_logic_vector(6 downto 0);
signal funct3	: std_logic_vector(2 downto 0);
signal funct7  : std_logic_vector(6 downto 0);
signal funct6  : std_logic_vector(5 downto 0);

begin

	funct3 <= instrucao(14 downto 12);
	funct7 <= instrucao(31 downto 25);
	funct6 <= instrucao(31 downto 26);

	process(instrucao, opcode, funct3, funct6, funct7)
	begin
	opcode <= instrucao(6 downto 0);
	
	-- tipo R
	if opcode = "0110011" then
		imm32 <= X"00000000";

	-- tipo I
	elsif (opcode = "0000011" or opcode = "0010011" or opcode = "1100111") then
		if ( funct3 = "101" and funct6 = "010000" ) then
			imm32 <= std_logic_vector(resize(signed(instrucao(25 downto 20)), 32));
		else
			imm32 <= std_logic_vector(resize(signed(instrucao(31 downto 20)), 32));
		end if;

	-- tipo S
	elsif opcode = "0100011" then
		imm32 <= std_logic_vector(resize(signed(instrucao(31 downto 25) & instrucao(11 downto 7)), 32));

	-- tipo SB
	elsif opcode = "1100011" then
		imm32 <= std_logic_vector(resize(signed(instrucao(31) & instrucao(7) & instrucao(30 downto 25) & instrucao(11 downto 8) & '0'), 32));

	-- tipo U
	elsif opcode = "0110111" then
		imm32	<= std_logic_vector(resize(signed(instrucao(31 downto 12) & "000000000000"), 32));

	-- tipo UJ
	elsif opcode = "1101111" then
		imm32 <= std_logic_vector(resize(signed(instrucao(31) & instrucao(19 downto 12) & instrucao(20) & instrucao(30 downto 21) & '0'), 32));
	else
		imm32 <= X"00000000";
	end if;
	
	end process;
end comportamento;