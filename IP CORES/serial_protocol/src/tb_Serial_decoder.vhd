library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Serial_decoder is
end tb_Serial_decoder;

architecture Behavioral of tb_Serial_decoder is

    component Serial_decoder
        Port (
            Bus_in : in STD_LOGIC_VECTOR (7 downto 0);
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            enable : out STD_LOGIC;
            V0     : out STD_LOGIC_VECTOR (9 downto 0);
            V1     : out STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;

    signal Bus_in : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal clk    : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal enable : STD_LOGIC;
    signal V0     : STD_LOGIC_VECTOR(9 downto 0);
    signal V1     : STD_LOGIC_VECTOR(9 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Serial_decoder
        port map (
            Bus_in => Bus_in,
            clk    => clk,
            rst    => rst,
            enable => enable,
            V0     => V0,
            V1     => V1
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc : process
    begin
        ----------------------------------------------------------------
        -- Reset
        ----------------------------------------------------------------
        rst <= '1';
        Bus_in <= (others => '0');
        wait for 2*CLK_PERIOD;

        assert (V0 = "0000000000")
            report "ERROR: V0 no queda en 0 durante reset"
            severity error;

        assert (V1 = "0000000000")
            report "ERROR: V1 no queda en 0 durante reset"
            severity error;

        assert (enable = '0')
            report "ERROR: enable no queda en 0 durante reset"
            severity error;

        rst <= '0';

        ----------------------------------------------------------------
        -- Caso 1: H1=0 H2=0 H3=0 -> cargar V0(9 downto 5)=10101
        -- Bus_in = 00010101
        ----------------------------------------------------------------
        Bus_in <= "00010101";
        wait for CLK_PERIOD;

        assert (V0(9 downto 5) = "10101")
            report "ERROR: no se cargo correctamente la parte alta de V0"
            severity error;

        assert (V0(4 downto 0) = "00000")
            report "ERROR: la parte baja de V0 cambio indebidamente"
            severity error;

        assert (enable = '0')
            report "ERROR: enable se activo incorrectamente en carga alta de V0"
            severity error;

        ----------------------------------------------------------------
        -- Caso 2: H1=0 H2=1 H3=1 -> cargar V0(4 downto 0)=01011
        -- Se cambia H3 para comprobar que por ahora no altera la logica
        -- Bus_in = 01101011
        ----------------------------------------------------------------
        Bus_in <= "01101011";
        wait for CLK_PERIOD;

        assert (V0 = "1010101011")
            report "ERROR: V0 no coincide con el valor esperado 1010101011"
            severity error;

        assert (enable = '0')
            report "ERROR: enable se activo incorrectamente en carga baja de V0"
            severity error;

        ----------------------------------------------------------------
        -- Caso 3: H1=1 H2=0 H3=0 -> cargar V1(9 downto 5)=11100
        -- Bus_in = 10011100
        ----------------------------------------------------------------
        Bus_in <= "10011100";
        wait for CLK_PERIOD;

        assert (V1(9 downto 5) = "11100")
            report "ERROR: no se cargo correctamente la parte alta de V1"
            severity error;

        assert (V1(4 downto 0) = "00000")
            report "ERROR: la parte baja de V1 cambio indebidamente"
            severity error;

        assert (enable = '0')
            report "ERROR: enable se activo incorrectamente en carga alta de V1"
            severity error;

        ----------------------------------------------------------------
        -- Caso 4: H1=1 H2=1 H3=1 -> cargar V1(4 downto 0)=00110 y enable=1
        -- H3 se deja en 1 para validar retrocompatibilidad futura
        -- Bus_in = 11100110
        ----------------------------------------------------------------
        Bus_in <= "11100110";
        wait for CLK_PERIOD;

        assert (V1 = "1110000110")
            report "ERROR: V1 no coincide con el valor esperado 1110000110"
            severity error;

        assert (enable = '1')
            report "ERROR: enable no se activo al completar V1"
            severity error;

        ----------------------------------------------------------------
        -- Caso 5: ciclo siguiente -> enable vuelve a 0
        ----------------------------------------------------------------
        Bus_in <= "00000000";
        wait for CLK_PERIOD;

        assert (enable = '0')
            report "ERROR: enable no volvio a 0 en el ciclo siguiente"
            severity error;

        report "Simulacion de Serial_decoder finalizada correctamente" severity note;
        wait;
    end process;

end Behavioral;