library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Para trabajar con unsigned

entity tiempomedio is
    Port (
        resettm        : in  STD_LOGIC;                   -- Señal de reset
        valor_nuevo    : in  STD_LOGIC_VECTOR(11 downto 0); -- Entrada de 12 bits
        n              : in  INTEGER;                      -- Número de muestras como INTEGER
        media_nueva    : out STD_LOGIC_VECTOR(11 downto 0) -- Salida de 12 bits
    );
end tiempomedio;

-- Definición de la arquitectura Behavioral de tiempomedio
architecture Behavioral of tiempomedio is
    -- Declaración de señales internas
    signal incremento : UNSIGNED(15 downto 0) := (others => '0'); -- Hasta 10 valores de 12 bits requieren 16 bits para la suma
    signal temp_media : UNSIGNED(15 downto 0) := (others => '0'); -- Misma longitud que incremento para evitar problemas de tamaño
    signal n_unsigned : UNSIGNED(15 downto 0); -- Misma longitud que incremento
begin
    -- Proceso principal que calcula la media
    process(resettm, valor_nuevo, n_unsigned)
    begin
        if resettm = '1' then
            -- Si la señal de reset está activa, se reinician las señales internas
            incremento <= (others => '0');
            temp_media <= (others => '0');
        else
            if n_unsigned /= 0 then
                -- Si n_unsigned no es cero, realiza los cálculos
                incremento <= incremento + unsigned(valor_nuevo); -- Acumula la suma de los valores nuevos

                -- División de incremento por n_unsigned
                temp_media <= incremento / n_unsigned;

                -- Asigna la nueva media a la salida, truncando a 12 bits
                media_nueva <= std_logic_vector(temp_media(11 downto 0));
            end if;
        end if;
    end process;

    -- Conversión de n de INTEGER a UNSIGNED
    n_unsigned <= to_unsigned(n, 16);
end Behavioral;



