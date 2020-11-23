LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY subtrator IS
generic(N : natural := 4);
PORT (a, b : IN std_logic_vector(N-1 DOWNTO 0);
      s : OUT std_logic_vector(N-1 DOWNTO 0));
END subtrator;

ARCHITECTURE estrutura OF subtrator IS
signal s1: std_logic_vector(N-1 downto 0);

BEGIN
         S1 <= a-b;
			s <= S1;
END estrutura;