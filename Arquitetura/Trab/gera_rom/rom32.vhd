library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_MI0.all;



entity rom32 is
	port (
		address: in reg32;
		data_out: out reg32
	);
end rom32;

architecture arq_rom32 of rom32 is

	signal mem_offset: std_logic_vector(5 downto 0);
	signal address_select: std_logic;
	

begin
	mem_offset <= address(7 downto 2);
        
	add_sel: process(address)
	begin
		if address(31 downto 8) = x"000000" then 	
			address_select <= '1';
		else
			address_select <= '0';
		end if;
	end process;

	access_rom: process(address_select, mem_offset)
	begin
		if address_select = '1' then
			case mem_offset is
				when 	"000000" => data_out <= "001000" & "00000" & "00001" & x"0001"; -- addi $1, $0, 1
				when 	"000001" => data_out <= "001000" & "00000" & "00010" & x"0002"; -- addi $2, $0, 2
				when 	"000010" => data_out <= "001000" & "00000" & "00011" & x"0003"; -- addi $3, $0, 3
				when 	"000011" => data_out <= "001000" & "00000" & "00100" & x"0004"; -- addi $4, $0, 4
				when 	"000100" => data_out <= "000000" & "00100" & "00001" & "00100" & "00000" & "100000"; -- add $4, $4, $1
				when 	"000101" => data_out <= "000000" & "00100" & "00010" & "00100" & "00000" & "100000"; -- add $4, $4, $2
				when 	"000110" => data_out <= "000000" & "00100" & "00011" & "00100" & "00000" & "100000"; -- add $4, $4, $3
				when 	others  => data_out <= (others => 'X');
			end case;
    		end if;
  	end process; 

end arq_rom32;
