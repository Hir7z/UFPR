--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Registrador genérico sensível à borda de subida do clock
-- com possibilidade de inicialização de valor
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.std_logic_1164.all;
use work.p_MI0.all;

entity reg is
	generic( 
		width : integer := 32
	);

	port(  	ck, rst : in std_logic;
								W : in std_logic; --Sinal de escrita para PC
               	D : in  std_logic_vector(width-1 downto 0);--PC+4 ou Branch
               	E : in  std_logic_vector(width-1 downto 0);--PC,em caso de Hazard
               	Q : out std_logic_vector(width-1 downto 0)
        );
end reg;

architecture arq_reg of reg is 
begin

  process(ck, rst,W)
  begin
       if rst = '1' then
              Q <= (others => '0');
       elsif ck'event and ck = '1' and W = '0'  then
              Q <= D; 
			 elsif W = '1' then
				 Q <= E;
       end if;
  end process;
        
end arq_reg;
