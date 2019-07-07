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
	process(ControleOp, funct3, funct7)
	begin
		if( ControleOp = ADD ) then
			ALUOp <= ADD_OP;
		end if;
		
		if ( ControleOp = TIPO_I ) then
			case funct3 is
				-- addi
				when "000" =>
					ALUOp <= ADD_OP;
					
				-- ANDI
				when "111" =>
					ALUOp <= AND_OP;
				
				-- ORI
				when "110" =>
					ALUOp <= OR_OP;
					
				-- XORI
				when "100" =>
					ALUOp <= XOR_OP;

				-- SLLI
				when "001" =>
					ALUOp <= SLL_OP;
				
				-- SRLI / SRAI
				when "101" =>
					if ( funct7 = "000000") then
						ALUOp <= SRL_OP;
					else
						ALUOp <= SRA_OP;
					end if;

				-- SLTI
				when "010" =>
					ALUOp <= SLT_OP;
				
				-- SLTIU
				when "011" =>
					ALUOp <= SLTU_OP;
				
				when others =>
					ALUOp <= ADD_OP;
			end case;
		end if;
	end process;
end comportamento;