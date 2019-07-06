library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity ULAControle is
	port (
		funct3		: in std_logic_vector(2 downto 0);
		funct7		: in std_logic_vector(6 downto 0);
		ControleOp 	: in Controle_ULA;
		ALUOp 		: out ULA_OP
	);
end ULAControle;

architecture comportamento of ULAControle is
begin
	process(ControleOp)
	begin
		if( ControleOp = ADD ) then
			ALUOp <= ADD_OP;
		end if;
	end process;
end comportamento;