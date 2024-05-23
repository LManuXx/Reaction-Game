library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Random is
    Port (
        tiempo: in std_logic_vector(11 downto 0); -- Entrada de 12 bits 
        numero: out std_logic_vector(2 downto 0) -- Salida de 3 bits para generar numeros del 0 al 7
    );
end Random;

architecture Behavioral of Random is
begin
    -- Asigna los 3 bits menos significativos de tiempo a la salida numero
    numero <= tiempo(2 downto 0);
end Behavioral;


