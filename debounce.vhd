library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
    Port (
        clk     : in  STD_LOGIC;  -- Entrada de reloj
        btn_in  : in  STD_LOGIC;  -- Entrada del botón
        btn_out : out STD_LOGIC   -- Salida del botón después de eliminar el rebote
    );
end debounce;

-- Definición de la arquitectura Behavioral de debounce
architecture Behavioral of debounce is
    -- Señales internas para la sincronización y eliminación del rebote
    signal btn_sync_0 : STD_LOGIC := '0';  -- Sincroniza la primera etapa del botón
    signal btn_sync_1 : STD_LOGIC := '0';  -- Sincroniza la segunda etapa del botón
    signal btn_debounced : STD_LOGIC := '0';  -- Estado del botón después de eliminar el rebote
    signal counter : integer := 0;  -- Contador para el retardo de eliminación del rebote
    constant DEBOUNCE_DELAY : integer := 6000000; -- Constante para el retardo de eliminación del rebote (20 ms a 50 MHz)
begin

    -- Proceso para sincronizar la entrada del botón con el dominio del reloj
    process(clk)
    begin
        if rising_edge(clk) then
            btn_sync_0 <= btn_in;  -- Captura el estado del botón en la primera etapa
            btn_sync_1 <= btn_sync_0;  -- Transfiere el estado del botón a la segunda etapa
        end if;
    end process;

    -- Proceso para eliminar el rebote del botón
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_sync_1 = btn_debounced then
                counter <= 0; -- Si el estado del botón no cambia, resetea el contador
            else
                if counter = DEBOUNCE_DELAY then
                    btn_debounced <= btn_sync_1; -- Si el estado del botón es estable por suficiente tiempo, actualiza el estado debounced
                    counter <= 0;  -- Resetea el contador
                else
                    counter <= counter + 1; -- Incrementa el contador mientras el estado del botón está cambiando
                end if;
            end if;
        end if;
    end process;

    -- Asigna el estado del botón eliminado el rebote a la salida
    btn_out <= btn_debounced;

end Behavioral;

