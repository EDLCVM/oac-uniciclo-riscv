library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is
type ULA_OP is (ADD_OP, SUB_OP, AND_OP,   OR_OP,  XOR_OP, SLL_OP, SRL_OP,
                SRA_OP, SLT_OP, SLTU_OP, SGE_OP, SGEU_OP, SEQ_OP, SNE_OP);
					 
-- inserir component aqui.

component Adder
	generic (WSIZE : natural := 32);
	port (
		A, B : in std_logic_vector(WSIZE - 1 downto 0);
		saida : out std_logic_vector(WSIZE - 1 downto 0)
	);
end component;

end riscv_pkg;