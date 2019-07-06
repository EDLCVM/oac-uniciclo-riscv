library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XREGS is
	generic (WSIZE : natural := 32);
	port (
		clock,
		wren,		-- sinal de escrita
		rst		-- sinal de reset
		:  in std_logic;
		
		rs1, rs2, rd		:  in std_logic_vector(4 downto 0);
		data					:  in std_logic_vector(WSIZE - 1 downto 0);
		ro1, ro2				: out std_logic_vector(WSIZE - 1 downto 0));
end entity;

architecture comp of XREGS is

	type array_reg is array (integer range <>) of std_logic_vector(WSIZE - 1 downto 0);
	signal xreg: array_reg(WSIZE - 1 downto 0);

	begin
	-- leitura dos registradores
	ro1 <= X"00000000" when (rs1 = "00000") else xreg(to_integer(unsigned(rs1)));
	ro2 <= x"00000000" when (rs2 = "00000") else xreg(to_integer(unsigned(rs2)));
	
	process(clock)
	begin
		if (rising_edge(clock)) then

			if ( wren = '1' and rd /= "00000") then
				xreg(to_integer(unsigned(rd))) <= data;
			elsif ( rst = '1' ) then
				-- zerar todos os registradores
				for ii in 0 to WSIZE - 1 loop
					xreg(ii) <= X"00000000";
				end loop;
			end if;

		end if;
	end process;
end comp;