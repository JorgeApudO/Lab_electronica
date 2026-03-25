library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Display_7_segment is
end tb_Display_7_segment;

architecture Behavioral of tb_Display_7_segment is

    component Display_7_segment
        Port (
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            D1     : in STD_LOGIC_VECTOR (7 downto 0);
            D2     : in STD_LOGIC_VECTOR (7 downto 0);
            D3     : in STD_LOGIC_VECTOR (7 downto 0);
            D4     : in STD_LOGIC_VECTOR (7 downto 0);
            catodo : out STD_LOGIC_VECTOR (7 downto 0);
            anodo  : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal clk    : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal D1     : STD_LOGIC_VECTOR(7 downto 0) := "00000001";
    signal D2     : STD_LOGIC_VECTOR(7 downto 0) := "00000010";
    signal D3     : STD_LOGIC_VECTOR(7 downto 0) := "00000100";
    signal D4     : STD_LOGIC_VECTOR(7 downto 0) := "00001000";
    signal catodo : STD_LOGIC_VECTOR(7 downto 0);
    signal anodo  : STD_LOGIC_VECTOR(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Display_7_segment
        port map (
            clk    => clk,
            rst    => rst,
            D1     => D1,
            D2     => D2,
            D3     => D3,
            D4     => D4,
            catodo => catodo,
            anodo  => anodo
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
        wait for 2*CLK_PERIOD;

        assert (anodo = "1111")
            report "ERROR: durante reset, anodo no es 1111"
            severity error;

        assert (catodo = "11111111")
            report "ERROR: durante reset, catodo no es 11111111"
            severity error;

        ----------------------------------------------------------------
        -- Salir de reset
        -- Primer ciclo: state 0 -> todos apagados, luego pasa a 1
        ----------------------------------------------------------------
        rst <= '0';
        wait for CLK_PERIOD;

        assert (anodo = "1111")
            report "ERROR: en state 0, anodo no es 1111"
            severity error;

        assert (catodo = "11111111")
            report "ERROR: en state 0, catodo no es 11111111"
            severity error;

        ----------------------------------------------------------------
        -- Segundo ciclo: muestra D1
        ----------------------------------------------------------------
        wait for CLK_PERIOD;

        assert (anodo = "0111")
            report "ERROR: en state 1, anodo no es 0111"
            severity error;

        assert (catodo = D1)
            report "ERROR: en state 1, catodo no coincide con D1"
            severity error;

        ----------------------------------------------------------------
        -- Tercer ciclo: muestra D2
        ----------------------------------------------------------------
        wait for CLK_PERIOD;

        assert (anodo = "1011")
            report "ERROR: en state 2, anodo no es 1011"
            severity error;

        assert (catodo = D2)
            report "ERROR: en state 2, catodo no coincide con D2"
            severity error;

        ----------------------------------------------------------------
        -- Cuarto ciclo: muestra D3
        ----------------------------------------------------------------
        wait for CLK_PERIOD;

        assert (anodo = "1101")
            report "ERROR: en state 3, anodo no es 1101"
            severity error;

        assert (catodo = D3)
            report "ERROR: en state 3, catodo no coincide con D3"
            severity error;

        ----------------------------------------------------------------
        -- Quinto ciclo: muestra D4
        ----------------------------------------------------------------
        wait for CLK_PERIOD;

        assert (anodo = "1110")
            report "ERROR: en state 4, anodo no es 1110"
            severity error;

        assert (catodo = D4)
            report "ERROR: en state 4, catodo no coincide con D4"
            severity error;

        ----------------------------------------------------------------
        -- Sexto ciclo: vuelve a D1
        ----------------------------------------------------------------
        wait for CLK_PERIOD;

        assert (anodo = "0111")
            report "ERROR: no volvió correctamente a D1"
            severity error;

        assert (catodo = D1)
            report "ERROR: al volver al ciclo, catodo no coincide con D1"
            severity error;

        report "Simulacion de Display_7_segment finalizada correctamente" severity note;
        wait;
    end process;

end Behavioral;