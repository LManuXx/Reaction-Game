library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
    Port (
        clk     : in  STD_LOGIC;  -- Entrada de reloj
        btn_in  : in  STD_LOGIC;  -- Entrada del bot�n
        btn_out : out STD_LOGIC   -- Salida del bot�n despu�s de eliminar el rebote
    );
end debounce;

-- Definici�n de la arquitectura Behavioral de debounce
architecture Behavioral of debounce is
    -- Se�ales internas para la sincronizaci�n y eliminaci�n del rebote
    signal btn_sync_0 : STD_LOGIC := '0';  -- Sincroniza la primera etapa del bot�n
    signal btn_sync_1 : STD_LOGIC := '0';  -- Sincroniza la segunda etapa del bot�n
    signal btn_debounced : STD_LOGIC := '0';  -- Estado del bot�n despu�s de eliminar el rebote
    signal counter : integer := 0;  -- Contador para el retardo de eliminaci�n del rebote
    constant DEBOUNCE_DELAY : integer := 6000000; -- Constante para el retardo de eliminaci�n del rebote (20 ms a 50 MHz)
begin

    -- Proceso para sincronizar la entrada del bot�n con el dominio del reloj
    process(clk)
    begin
        if rising_edge(clk) then
            btn_sync_0 <= btn_in;  -- Captura el estado del bot�n en la primera etapa
            btn_sync_1 <= btn_sync_0;  -- Transfiere el estado del bot�n a la segunda etapa
        end if;
    end process;

    -- Proceso para eliminar el rebote del bot�n
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_sync_1 = btn_debounced then
                counter <= 0; -- Si el estado del bot�n no cambia, resetea el contador
            else
                if counter = DEBOUNCE_DELAY then
                    btn_debounced <= btn_sync_1; -- Si el estado del bot�n es estable por suficiente tiempo, actualiza el estado debounced
                    counter <= 0;  -- Resetea el contador
                else
                    counter <= counter + 1; -- Incrementa el contador mientras el estado del bot�n est� cambiando
                end if;
            end if;
        end if;
    end process;

    -- Asigna el estado del bot�n eliminado el rebote a la salida
    btn_out <= btn_debounced;

end Behavioral;

