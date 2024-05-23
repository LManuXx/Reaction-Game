library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Descomentar si se requieren operaciones aritméticas.

entity entradas is
    Port (
        reseteo: in std_logic := '0';  -- Entrada para resetear las salidas, inicializada a '0'
        numerorandom : in std_logic_vector(2 downto 0);  -- Entrada del número aleatorio de 3 bits
        entradaa : in std_logic_vector(7 downto 0);  -- Entrada de 8 bits
        victoria: out std_logic;  -- Salida que indica victoria
        espera: out std_logic;  -- Salida que indica espera
        clkentrada : in std_logic  -- Entrada del reloj
    );
end entradas;

-- Definición de la arquitectura Behavioral de entradas
architecture Behavioral of entradas is

    -- Señal para almacenar las entradas después de eliminar el rebote (debouncing)
    signal debounced_entradaa : std_logic_vector(7 downto 0);

    -- Declaración de la entidad del componente debounce
    component debounce
        Port (
            clk     : in  STD_LOGIC;  -- Entrada de reloj
            btn_in  : in  STD_LOGIC;  -- Entrada del botón
            btn_out : out STD_LOGIC   -- Salida del botón después de eliminar el rebote
        );
    end component;

begin

    -- Instancias de debounce para cada bit de entradaa
    debounce_0: debounce Port map (clk => clkentrada, btn_in => entradaa(0), btn_out => debounced_entradaa(0));
    debounce_1: debounce Port map (clk => clkentrada, btn_in => entradaa(1), btn_out => debounced_entradaa(1));
    debounce_2: debounce Port map (clk => clkentrada, btn_in => entradaa(2), btn_out => debounced_entradaa(2));
    debounce_3: debounce Port map (clk => clkentrada, btn_in => entradaa(3), btn_out => debounced_entradaa(3));
    debounce_4: debounce Port map (clk => clkentrada, btn_in => entradaa(4), btn_out => debounced_entradaa(4));
    debounce_5: debounce Port map (clk => clkentrada, btn_in => entradaa(5), btn_out => debounced_entradaa(5));
    debounce_6: debounce Port map (clk => clkentrada, btn_in => entradaa(6), btn_out => debounced_entradaa(6));
    debounce_7: debounce Port map (clk => clkentrada, btn_in => entradaa(7), btn_out => debounced_entradaa(7));

    -- Proceso principal
    process (reseteo, debounced_entradaa, numerorandom, clkentrada)
    begin
        if reseteo = '1' then
            victoria <= '0';  -- Resetea la señal de victoria a '0'
            espera <= '1';  -- Activa la señal de espera
        elsif rising_edge(clkentrada) then
            -- Evalúa la entrada debounced_entradaa
            case debounced_entradaa is
                when "00000001" =>
                    if numerorandom = "000" then
                        victoria <= '1';  -- Victoria si numerorandom es "000"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "00000010" =>
                    if numerorandom = "001" then
                        victoria <= '1';  -- Victoria si numerorandom es "001"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "00000100" =>
                    if numerorandom = "010" then
                        victoria <= '1';  -- Victoria si numerorandom es "010"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "00001000" =>
                    if numerorandom = "011" then
                        victoria <= '1';  -- Victoria si numerorandom es "011"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "00010000" =>
                    if numerorandom = "100" then
                        victoria <= '1';  -- Victoria si numerorandom es "100"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "00100000" =>
                    if numerorandom = "101" then
                        victoria <= '1';  -- Victoria si numerorandom es "101"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "01000000" =>
                    if numerorandom = "110" then
                        victoria <= '1';  -- Victoria si numerorandom es "110"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "10000000" =>
                    if numerorandom = "111" then
                        victoria <= '1';  -- Victoria si numerorandom es "111"
                        espera <= '0';  -- Desactiva espera
                    end if;
                when "00000000" =>
                    victoria <= '0';  -- No victoria si debounced_entradaa es "00000000"
                    espera <= '1';  -- Activa espera
                when others =>
                    victoria <= '1';  -- Para cualquier otro valor, victoria
                    espera <= '0';  -- Desactiva espera
            end case;
        end if;
    end process;

end Behavioral;