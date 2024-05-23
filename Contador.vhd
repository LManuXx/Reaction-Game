
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contador is
Port (clk1 : in std_logic; -- Entrada del reloj
      reset : in STD_LOGIC;  -- Entrada de la señal de reset
      tiempo : out std_logic_vector(11 downto 0)); -- Salida del contador de tiempo (12 bits)
end Contador;

architecture Behavioral of Contador is
-- Señal interna para contar milisegundos, inicializada a 0
signal ms : std_logic_vector(11 downto 0) := (others => '0');
-- Señal interna para el reloj dividido
signal clock: std_logic;
component  Divisor is 
  port(clk,reset: in std_logic; clock_out: out std_logic);
    
end component;
begin
    divisor1 : Divisor port map(clk=>clk1,reset=>'0',clock_out=>clock);
    process(clock)
        begin
        if(reset = '1' or ms = "111111111111") then  -- Si reset está activo o ms llega a su máximo valor (4095)
            ms <= "000000000000";-- Reinicia el contador a 0
        elsif(rising_edge(clock)) then-- Si hay un flanco ascendente en clock
            ms <= std_logic_vector(unsigned(ms) + 1);-- Incrementa el contador ms en 1
        end if;
    end process;
    -- Asigna el valor del contador ms a la salida tiempo
    tiempo <= ms;
end Behavioral;
