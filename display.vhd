library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display is
    Generic (speed : integer := 18); -- Par�metro gen�rico para ajustar la velocidad
    Port (
        clk : in std_logic; -- Se�al de reloj
        rst : in std_logic; -- Se�al de reset a�adida
        andis : out std_logic_vector(3 downto 0); -- Salida de �nodo
        segdis : out std_logic_vector(6 downto 0); -- Salida de segmentos del display
        sw : in std_logic_vector(11 downto 0) -- Entrada de 12 bits
    );
end display;

-- Definici�n de la arquitectura Behavioral de display
architecture Behavioral of display is
    signal counter : std_logic_vector(speed downto 0) := (others => '0'); -- Contador para generar los tiempos de refresco del display
    signal sel : std_logic_vector(1 downto 0) := (others => '0'); -- Selector de d�gito actual
    signal num : std_logic_vector(3 downto 0) := (others => '0'); -- N�mero a mostrar en el d�gito actual
    signal bcd : std_logic_vector(15 downto 0) := (others => '0'); -- Se�al BCD de 4 d�gitos
    
    -- Procedimiento para convertir binario a BCD
    procedure bin2bcd(
        signal bin : in std_logic_vector(11 downto 0); -- Entrada binaria de 12 bits
        signal bcd : out std_logic_vector(15 downto 0) -- Salida BCD de 16 bits
    ) is
        variable temp_bin : std_logic_vector(11 downto 0); -- Variable temporal para la entrada binaria
        variable temp_bcd : std_logic_vector(19 downto 0) := (others => '0'); -- Variable temporal para la conversi�n BCD
    begin
        temp_bin := bin;
        for i in 0 to 11 loop
            -- Ajustes necesarios si el valor BCD es mayor que 4
            if temp_bcd(3 downto 0) > "0100" then
                temp_bcd(3 downto 0) := temp_bcd(3 downto 0) + "0011";
            end if;
            if temp_bcd(7 downto 4) > "0100" then
                temp_bcd(7 downto 4) := temp_bcd(7 downto 4) + "0011";
            end if;
            if temp_bcd(11 downto 8) > "0100" then
                temp_bcd(11 downto 8) := temp_bcd(11 downto 8) + "0011";
            end if;
            if temp_bcd(15 downto 12) > "0100" then
                temp_bcd(15 downto 12) := temp_bcd(15 downto 12) + "0011";
            end if;
            -- Desplazamiento a la izquierda y entrada del siguiente bit
            temp_bcd := temp_bcd(18 downto 0) & temp_bin(11);
            temp_bin := temp_bin(10 downto 0) & '0';
        end loop;
        bcd <= temp_bcd(15 downto 0); -- Asignaci�n del valor convertido a la se�al BCD
    end procedure;

begin
    -- Proceso de conteo
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= (others => '0'); -- Resetea el contador
        elsif rising_edge(clk) then
            counter <= counter + 1; -- Incrementa el contador en cada flanco de subida del reloj
        end if;
    end process;
    
    -- Proceso de selecci�n de d�gito
    process(counter(speed), rst)
    begin
        if rst = '1' then
            sel <= (others => '0'); -- Resetea el selector
        elsif rising_edge(counter(speed)) then
            sel <= sel + 1; -- Cambia el d�gito seleccionado en cada ciclo del contador
        end if;
    end process;
    
    -- Proceso de conversi�n de binario a BCD
    process(sw, rst)
    begin
        if rst = '1' then
            bcd <= (others => '0'); -- Resetea la se�al BCD
        else
            bin2bcd(sw, bcd); -- Convierte la entrada binaria a BCD
        end if;
    end process;

    -- Proceso de selecci�n y salida del n�mero en el display
    process(sel, rst)
    begin
        if rst = '1' then
            andis <= "0111"; -- Resetea los �nodos
            num <= "0000"; -- Resetea el n�mero
        else
            case sel is
                when "00" =>
                    andis <= "1110"; -- Selecciona el primer d�gito
                    num <= bcd(3 downto 0); -- Asigna el valor correspondiente al primer d�gito
                when "01" =>
                    andis <= "1101"; -- Selecciona el segundo d�gito
                    num <= bcd(7 downto 4); -- Asigna el valor correspondiente al segundo d�gito
                when "10" =>
                    andis <= "1011"; -- Selecciona el tercer d�gito
                    num <= bcd(11 downto 8); -- Asigna el valor correspondiente al tercer d�gito
                when "11" =>
                    andis <= "0111"; -- Selecciona el cuarto d�gito
                    num <= bcd(15 downto 12); -- Asigna el valor correspondiente al cuarto d�gito
                when others =>
                    andis <= "0111"; -- Valor por defecto de los �nodos
                    num <= "0000"; -- Valor por defecto del n�mero
            end case;
        end if;
    end process;
    
    -- Proceso de asignaci�n de segmentos del display
    process(num, rst)
    begin
        case num is
            when "0000" => segdis <= "1000000"; -- 0
            when "0001" => segdis <= "1111001"; -- 1
            when "0010" => segdis <= "0100100"; -- 2
            when "0011" => segdis <= "0110000"; -- 3
            when "0100" => segdis <= "0011001"; -- 4
            when "0101" => segdis <= "0010010"; -- 5
            when "0110" => segdis <= "0000010"; -- 6
            when "0111" => segdis <= "1111000"; -- 7
            when "1000" => segdis <= "0000000"; -- 8
            when "1001" => segdis <= "0010000"; -- 9
            when others => segdis <= "1111111"; -- Apaga los segmentos
        end case;
    end process;
end Behavioral;

