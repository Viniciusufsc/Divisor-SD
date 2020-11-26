library IEEE;
use IEEE.std_logic_1164.all;

-- Checa se apenas MSB e LSB sao '1'
entity comparadorMSBlsb is
generic (n: integer:= 4);
port (entrada: in std_logic_vector(n-1 downto 0);
		saida: out std_logic
		);
end entity;

architecture behav of comparadorMSBlsb is

signal tmp: std_logic_vector(n-2 downto 1);
signal tmp1: std_logic;
begin
-- nand de 1 ate n-2
gen: for i in 1 to n-3 generate
	tmp1 <= tmp(i+1) nand tmp(i);
end generate;
saida <= tmp1 and entrada(n-1) and entrada(0);	
end behav;
