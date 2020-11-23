library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

entity bo is
generic (n: natural:= 8);
port (clk: in std_logic;
		DIVIDENDO, DIVISOR: in std_logic_vector(n-1 downto 0); -- Entradas
		shDIV, shREM, shQUO: in std_logic; 		 					 -- Enable shift
		cargaDIV, cargaQUO, cargaREM, cargaCONT: in std_logic; -- Carga dos 4 reg
		selMUX: in std_logic;										 	 -- Seletor mux
		saiCOMPARADOR: out std_logic;									 -- Saida comparador de magnitude
		outREM, outQUO: out std_logic_vector(n-1 downto 0); 	 -- Resultados
		outCount: out std_logic											 -- Saida comparador de CONT
		);
end entity;

architecture behav of bo is

component registrador_sh is
generic(N: natural:= 4);
PORT (clk, carga, in_shift, shift: IN std_logic;
	  d : IN std_logic_vector(N-1 DOWNTO 0);
	  q : OUT std_logic_vector(N-1 DOWNTO 0);
	  out_shift : out std_logic);
end component;

component registrador_sh_r is
generic(N: natural:= 4);
PORT (clk, carga, in_shift, shift: IN std_logic;
	  d : IN std_logic_vector(N-1 DOWNTO 0);
	  q : OUT std_logic_vector(N-1 DOWNTO 0);
	  out_shift : out std_logic);
end component;

component registrador is
generic(N: natural:= 4);
PORT (clk, carga : IN std_logic;
	  d : IN std_logic_vector(N-1 DOWNTO 0);
	  q : OUT std_logic_vector(N-1 DOWNTO 0));
end component;

component comparador_magnitude is
generic (n: natural:= 4);
port(	a: in std_logic_vector(n-1 downto 0);
		b: in std_logic_vector(n-1 downto 0);
		c: out std_logic_vector(2 downto 0)
		);
end component;

component subtrator is
generic(N : natural := 4);
PORT (a, b : IN std_logic_vector(N-1 DOWNTO 0);
      s : OUT std_logic_vector(N-1 DOWNTO 0));
end component;

component somador is
generic(N : natural := 4);
PORT (a, b : IN std_logic_vector(N-1 DOWNTO 0);
      s : OUT std_logic_vector(N-1 DOWNTO 0));
end component;

component mux2para1 is
generic(N: natural:= 4);
  PORT ( a, b : IN std_logic_vector(N-1 DOWNTO 0);
         sel: IN std_logic;
         y : OUT std_logic_vector(N-1 DOWNTO 0));
end component;

component comparadorMSBlsb is
generic (n: integer:= 4);
port (entrada: in std_logic_vector(n-1 downto 0);
		saida: out std_logic
		);
end component;

-- Sinais principais
signal saiDIV, saiREM, zero_vec: std_logic_vector(n-1 downto 0);
signal zero, um: std_logic;
signal compDIV: std_logic_vector((n/2)-1 downto 0) := (others=>'0');
signal entDIV, outDIV: std_logic_vector(2*n-1 downto 0);
signal entMUX, saiMUX: std_logic_vector(n-1 downto 0);
signal outCOMP: std_logic_vector(2 downto 0);
-- Sinais contador
constant j: integer:=(log2(n)+1);
signal um_vec, saiSOMA: std_logic_vector(j downto 0); -- log2
signal entCont, saiCont, soma_um: std_logic_vector(j downto 0);

begin
-- Sinais preenchidos
zero <= '0';
um <= '1';
zero_vec <= (others=>'0');
um_vec <= (others=>'1');
soma_um <= (others=>'0');
soma_um(0) <= '1';
-- Sinais dos componentes
entDIV <= DIVISOR & compDIV;
saiCOMPARADOR <= outCOMP(2);
outREM <= saiREM;

-- Divisor
muxREM: mux2para1 generic map(n) port map(DIVIDENDO, entMUX, selMUX, saiMUX);
divisor: registrador_sh_r generic map(2*n) port map(clk, cargaDIV, zero, shDIV, entDIV, outDIV); -- DIVISOR
quociente: registrador_sh generic map(n) port map(clk, cargaQUO, outCOMP(2), shQUO, zero_vec, outQUO); -- QUOCIENTE
resto: registrador generic map(2*n) port map(clk, cargaREM, saiMUX, saiREM); -- DIVIDENDO
sub: subtrator generic map(n) port map(saiREM, outDIV(n-1 downto 0), entMUX);
mag: comparador_magnitude generic map(2*n) port map(outDIV(n-1 downto 0), saiREM, outCOMP(0), outCOMP(1), outCOMP(2));
-- Contador
muxCONT: mux2para1 generic map(j) port map(zero_vec, saiSOMA, selMUX, entCont);
contador: registrador generic map(j) port map(clk, cargaCONT, entCont, saiCont);
soma: somador generic map(j) port map(soma_um, saiCont, saiSOMA);
compCONT: comparadorMSBlsb generic map(j) port map(saiCont, outCont);
end behav;
