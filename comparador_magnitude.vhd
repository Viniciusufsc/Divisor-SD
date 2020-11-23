library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity comparador_magnitude is
generic (n: natural:= 4);
port(	a: in std_logic_vector(n-1 downto 0);
		b: in std_logic_vector(n-1 downto 0);
		c: out std_logic_vector(2 downto 0)
		);
end entity;

architecture behav of comparador_magnitude is
signal x, y, z: std_logic;
begin
 c(0) <= x;
 c(1) <= y;
 c(2) <= z;
 x <= '1' when a = b	else '0';
 y <= '1' when a > b else '0';
 z <= '1' when a < b else '0';
end behav;