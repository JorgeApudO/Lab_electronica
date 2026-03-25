library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Decidir_voltaje is
end tb_Decidir_voltaje;

architecture Behavioral of tb_Decidir_voltaje is

    component Decidir_voltaje
        Port (
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            V0     : in STD_LOGIC_VECTOR (9 downto 0);
            V1     : in STD_LOGIC_VECTOR (9 downto 0);
            enable : in STD_LOGIC;
            Switch : in STD_LOGIC;
            V      : out STD_LOGIC_VECTOR (9 downto 0);
            Led    : out STD_LOGIC
        );
    end component;

    signal clk    : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal V0     : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal V1     : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal enable : STD_LOGIC := '0';
    signal Switch : STD_LOGIC := '0';
    signal V      : STD_LOGIC_VECTOR(9 downto 0);
    signal Led    : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Decidir_voltaje
        port map (
            clk    => clk,
            rst    => rst,
            V0     => V0,
            V1     => V1,
            enable => enable,
            Switch => Switch,
            V      => V,
            Led    => Led
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
        rst    <= '1';
        enable <= '0';
        Switch <= '0';
        V0     <= std_logic_vector(to_unsigned(100, 10));
        V1     <= std_logic_vector(to_unsigned(700, 10));
        wait for 2*CLK_PERIOD;

        assert (V = "0000000000")
            report "ERROR: durante reset, V no es 0"
            severity error;

        assert (Led = '0')
            report "ERROR: durante reset, Led no es 0"
            severity error;

        ----------------------------------------------------------------
        -- Caso 1: Switch = 0, enable = 1 -> carga V0, Led = 1
        ----------------------------------------------------------------
        rst    <= '0';
        enable <= '1';
        Switch <= '0';
        wait for CLK_PERIOD;

        assert (V = std_logic_vector(to_unsigned(100, 10)))
            report "ERROR: no se cargo V0 cuando Switch=0 y enable=1"
            severity error;

        assert (Led = '1')
            report "ERROR: Led no vale 1 cuando Switch=0"
            severity error;

        ----------------------------------------------------------------
        -- Caso 2: Switch = 1, enable = 1 -> carga V1, Led = 0
        ----------------------------------------------------------------
        Switch <= '1';
        wait for CLK_PERIOD;

        assert (V = std_logic_vector(to_unsigned(700, 10)))
            report "ERROR: no se cargo V1 cuando Switch=1 y enable=1"
            severity error;

        assert (Led = '0')
            report "ERROR: Led no vale 0 cuando Switch=1"
            severity error;

        ----------------------------------------------------------------
        -- Caso 3: enable = 0 -> V debe mantenerse, Led depende de Switch
        ----------------------------------------------------------------
        enable <= '0';
        Switch <= '0';
        wait for CLK_PERIOD;

        assert (V = std_logic_vector(to_unsigned(700, 10)))
            report "ERROR: V cambio aunque enable=0"
            severity error;

        assert (Led = '1')
            report "ERROR: Led no vale 1 cuando Switch=0 y enable=0"
            severity error;

        ----------------------------------------------------------------
        -- Caso 4: enable = 0, Switch = 1 -> V sigue igual, Led = 0
        ----------------------------------------------------------------
        Switch <= '1';
        wait for CLK_PERIOD;

        assert (V = std_logic_vector(to_unsigned(700, 10)))
            report "ERROR: V cambio aunque enable=0 y Switch=1"
            severity error;

        assert (Led = '0')
            report "ERROR: Led no vale 0 cuando Switch=1 y enable=0"
            severity error;

        ----------------------------------------------------------------
        -- Caso 5: cambiar V0 y volver a cargarlo
        ----------------------------------------------------------------
        V0     <= std_logic_vector(to_unsigned(512, 10));
        enable <= '1';
        Switch <= '0';
        wait for CLK_PERIOD;

        assert (V = std_logic_vector(to_unsigned(512, 10)))
            report "ERROR: no se cargo el nuevo valor de V0"
            severity error;

        assert (Led = '1')
            report "ERROR: Led no vale 1 en la carga final de V0"
            severity error;

        report "Simulacion de Decidir_voltaje finalizada correctamente" severity note;
        wait;
    end process;

end Behavioral;