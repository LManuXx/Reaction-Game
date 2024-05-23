library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Descomentar si se requieren operaciones aritméticas.

entity Sistema is
    Port (
        clksistema : in std_logic;
        entrada : in std_logic_vector(7 downto 0);
        leds : out std_logic_vector(7 downto 0);
        LED : out std_logic_vector(7 downto 0);
        salida : out std_logic_vector(7 downto 0);
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        sonido : out std_logic
    );
end Sistema;

architecture Behavioral of Sistema is
    component Random is 
        Port (
            tiempo: in std_logic_vector(11 downto 0);
            numero: out std_logic_vector(2 downto 0)
        );   
    end component;

    component Contador is 
        Port (
            clk1 : in std_logic;
            reset : in STD_LOGIC;
            tiempo : out std_logic_vector(11 downto 0)
        );   
    end component;
    
    component entradas is 
        Port (
        reseteo: in std_logic := '0';
        numerorandom : in std_logic_vector(2 downto 0);
        entradaa : in std_logic_vector(7 downto 0);
        victoria: out std_logic;
        espera: out std_logic;
        clkentrada : in std_logic
    );
    end component;
    
    component salidas is 
    Port (
        reseteosalida: in std_logic := '0';
        numerorandom : in std_logic_vector(2 downto 0);
        salidaa : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component display is 
        Port ( clk : in std_logic;
           rst : in std_logic;
           andis : out std_logic_vector(3 downto 0);
           segdis : out std_logic_vector(6 downto 0);
           sw : in std_logic_vector(11 downto 0) );
    end component;
    
    component tiempomedio is 
        Port (
            resettm         : in  STD_LOGIC;
            valor_nuevo   : in  STD_LOGIC_VECTOR(11 downto 0);  -- Entrada de 12 bits
            n             : in  INTEGER;                     -- Número de muestras
            media_nueva   : out STD_LOGIC_VECTOR(11 downto 0)  -- Salida de 12 bits
        );
    end component; 

    signal tiempo2 : std_logic_vector(11 downto 0) := (others => '0');
    signal numero2 : std_logic_vector(2 downto 0):= (others => '0');
    signal randomreg : std_logic_vector(2 downto 0):= (others => '0');
    signal reset_cont : std_logic := '0'; 
    signal reset_entsal: std_logic := '0';
    signal reset_media: std_logic := '0';
    signal victoriasys: std_logic;
    signal esperasys: std_logic;
    signal comienzo: std_logic := '1';
    signal contadorvictorias: integer := 0;
    signal tiempomedia: STD_LOGIC_VECTOR(11 downto 0):= (others => '0');
    signal media: integer:= 0; 
    signal tm : std_logic_vector(11 downto 0):= (others => '0');
    signal tmnueva : std_logic_vector(11 downto 0):= (others => '0');


begin
    -- Instanciación del contador
    contador1 : Contador port map(
        clk1 => clksistema,
        reset => reset_cont,
        tiempo => tiempo2
    );

    -- Instanciación del componente aleatorio
    random2 : Random port map(
        tiempo => tiempo2,
        numero => numero2
    );
    
    salidas1 : salidas port map (
        reseteosalida => reset_entsal,
        numerorandom => randomreg,
        salidaa => salida
    );
    
    entrada1 : entradas port map(
        reseteo => reset_entsal,
        numerorandom => randomreg,
        entradaa => not entrada,
        victoria => victoriasys, 
        espera => esperasys,
        clkentrada => clksistema
    );
    
    tm1 : tiempomedio port map(
        resettm => reset_media,
        valor_nuevo => tiempomedia,
        n => contadorvictorias,
        media_nueva => tmnueva
    );
    
    display1 : display port map(
        clk=> clksistema,
        rst => reset_media,
        andis=> an,
        segdis=> seg,
        sw => tm
    );
    
process(clksistema,numero2,victoriasys,esperasys,tiempo2,contadorvictorias, tmnueva)
begin
    if rising_edge(clksistema) then
        if comienzo = '1' then --Inicializacion del juego y reset de variables
            tiempomedia <= (others => '0'); --reset tiempo media
            contadorvictorias <= 0; --reset contador
            reset_media <= '1'; --reset tiempo medio
            reset_entsal <= '1'; --reset componentes entrada y salida
            reset_cont <= '1';  --reset del tiempo
            randomreg <= "111"; --Inicializar el juego a 8
            comienzo <= '0';  --Comienzo a 0 para comenzar el juego
            sonido <= '1'; --Pitido de inicio o reset del juego
            
        elsif victoriasys = '1' and esperasys = '0' then --Si pulsas un boton correcto
            sonido <= '0'; --Se apaga el sonido
            tiempomedia <= tiempo2; --Se actualiza el tiempo para la media
            reset_entsal <= '1'; --se resetean las entradas y salidas
            reset_cont <= '1'; --Se resetea el tiempo de reaccion
            randomreg <= numero2; --se genera un numero random para el siguiente boton
            contadorvictorias <= contadorvictorias + 1;
            LED <= std_logic_vector(to_unsigned(contadorvictorias, 8));                 
        elsif (tiempo2 = "011111010000") then --si pasan 2 segundos sin que hayas tocado nada pierdes y se reinicia el juego
            contadorvictorias <= 0;                 
            comienzo <= '1';
        elsif contadorvictorias = 11 then --Ganas 11 veces seguidas entonces actualiza la media en el display y vuelve a empezar el juego
            tm <=  tiempomedia;
            comienzo <= '1';
        elsif (tiempo2 = "001111101000") then --Al segundo para el pitido del sonido
            sonido <= '0';
        else --Por temas tecnicos del process por defecto se quita el reset de todos los compontentes en cada ciclo de reloj
            reset_media <= '0';
            reset_entsal <= '0';
            reset_cont <= '0'; 
        end if;
    end if;
end process;
end Behavioral;