-- Importa las librerías necesarias para tipos de datos y funciones estándar de VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Declaración de la entidad Divisor
entity Divisor is
    port (
        clk, reset: in std_logic;     -- Entradas del reloj y reset
        clock_out: out std_logic      -- Salida del reloj dividido
    );
end Divisor;

-- Definición de la arquitectura del divisor de frecuencia
architecture bhv of Divisor is

    -- Declaración de señales internas
    signal count: integer := 0;       -- Contador inicializado a 0
    signal tmp : std_logic := '0';    -- Señal temporal inicializada a '0'

begin

    -- Proceso sensitivo a los cambios en clk y reset
    process(clk, reset)
    begin
        if reset = '1' then            -- Si reset está activo (reset = '1')
            count <= 0;                -- Reinicia el contador a 0
            tmp <= '0';                -- Reinicia la señal temporal a '0'
        elsif rising_edge(clk) then    -- Si hay un flanco ascendente en clk
            if count = 50000 then      -- Si el contador llega a 50000
                tmp <= NOT tmp;        -- Invierte el valor de la señal temporal
                count <= 0;            -- Reinicia el contador a 0
            else
                count <= count + 1;    -- Incrementa el contador en 1
            end if;
        end if;
        clock_out <= tmp;              -- Asigna el valor de la señal temporal a la salida
    end process;

end bhv;
