library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Controle is

	port(
		opcode 	: in std_logic_vector(6 downto 0);
		Branch,
		MemRead,
		MemtoReg,
		MemWrite,
		ALUSrc,
		RegWrite	: out std_logic;
		ALUOp 	: out ULA_OP
	);

end Controle;

architecture comportamento of Controle is
begin
end comportamento;