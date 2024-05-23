library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity salidas is
    Port (
        reseteosalida: in std_logic := '0';  -- Entrada para resetear la salida, inicializada a '0'
        numerorandom : in std_logic_vector(2 downto 0);  -- Entrada del número aleatorio de 3 bits
        salidaa : out std_logic_vector(7 downto 0)  -- Salida de 8 bits
    );
end salidas;

-- Definición de la arquitectura Behavioral de salidas
architecture Behavioral of salidas is
begin
    -- Proceso sensitivo a reseteosalida y numerorandom
    process (reseteosalida, numerorandom)
    begin
        if reseteosalida = '1' then    
            salidaa <= "00000000";  -- Resetea todos los bits de salida a 0
        else
            salidaa <= "00000000";  -- Inicializa la salida a 0
            case numerorandom is
                when "000" =>                   
                    salidaa(0) <= '1';  -- Activa el bit 0 de salidaa
                when "001" =>
                    salidaa(1) <= '1';  -- Activa el bit 1 de salidaa
                when "010" =>
                    salidaa(2) <= '1';  -- Activa el bit 2 de salidaa
                when "011" =>
                    salidaa(3) <= '1';  -- Activa el bit 3 de salidaa
                when "100" =>
                    salidaa(4) <= '1';  -- Activa el bit 4 de salidaa
                when "101" =>
                    salidaa(5) <= '1';  -- Activa el bit 5 de salidaa
                when "110" =>
                    salidaa(6) <= '1';  -- Activa el bit 6 de salidaa
                when "111" =>
                    salidaa(7) <= '1';  -- Activa el bit 7 de salidaa
                when others =>
                    salidaa <= "00000000";  -- Para cualquier otro valor, resetea la salida a 0
            end case;
        end if;
    end process;
end Behavioral;

