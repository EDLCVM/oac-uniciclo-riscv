library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity ULA is
	generic (WSIZE : natural := 32);
	port(
		opcode :  in ULA_OP;
		A, B 	 :  in std_logic_vector(WSIZE-1 downto 0);
		Z		 : out std_logic_vector(WSIZE-1 downto 0);
		zero	 : out std_logic := '0'
		);
end ULA;

architecture comportamento of ULA is
	
	-- sinal interno. Z nÃ£o pode ser lido
	signal resultado : std_logic_vector(WSIZE-1 downto 0) := X"00000000";
	constant um_32   : std_logic_vector := X"00000001";
	constant zero_32 : std_logic_vector := X"00000000";
begin
process(opcode, A, B, resultado)
begin

	Z <= resultado;
	
	case opcode is
		when ADD_OP =>
			resultado <= std_logic_vector(signed(A) + signed(B));
		when SUB_OP =>
			resultado <= std_logic_vector(signed(A) - signed(B));
		when AND_OP =>
			resultado <= std_logic_vector(A and B);
		when OR_OP =>
			resultado <= std_logic_vector(A or B);
		when XOR_OP =>
			resultado <= std_logic_vector(A xor B);
		when SLL_OP =>
			resultado <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
		when SRL_OP =>
			resultado <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
		when SRA_OP =>
			resultado <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
		when SLT_OP =>
			if ( signed(A) < signed(B) ) then
				resultado <= um_32;
			else
				resultado <= zero_32;
			end if;
		when SLTU_OP =>
			if ( unsigned(A) < unsigned(B) ) then
				resultado <= um_32;
			else
				resultado <= zero_32;
			end if;
		when SGE_OP =>
			if ( signed(A) >= signed(B) ) then
				resultado <= um_32;
			else
				resultado <= zero_32;
			end if;
		when SGEU_OP =>
			if ( unsigned(A) >= unsigned(B) ) then
				resultado <= um_32;
			else
				resultado <= zero_32;
			end if;
		when SEQ_OP =>
			if ( A = B ) then
				resultado <= um_32;
			else
				resultado <= zero_32;
			end if;
		when SNE_OP =>
			if ( A /= B ) then
				resultado <= um_32;
			else
				resultado <= zero_32;
			end if;
		when others =>
	end case;
	
	if (unsigned(resultado) = 0) then -- == X"00000000"
		zero <= '1';
	else
		zero <= '0';
	end if;
	
end process;

end comportamento;