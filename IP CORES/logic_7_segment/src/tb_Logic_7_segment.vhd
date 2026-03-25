library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Logic_7_segment is
end tb_Logic_7_segment;

architecture Behavioral of tb_Logic_7_segment is

    component Logic_7_segment
        Port (
            dig1 : in STD_LOGIC_VECTOR (3 downto 0);
            dig2 : in STD_LOGIC_VECTOR (3 downto 0);
            dig3 : in STD_LOGIC_VECTOR (3 downto 0);
            dig4 : in STD_LOGIC_VECTOR (3 downto 0);
            clk  : in STD_LOGIC;
            rst  : in STD_LOGIC;
            D1   : out STD_LOGIC_VECTOR (7 downto 0);
            D2   : out STD_LOGIC_VECTOR (7 downto 0);
            D3   : out STD_LOGIC_VECTOR (7 downto 0);
            D4   : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal dig1 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dig2 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dig3 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dig4 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal clk  : STD_LOGIC := '0';
    signal rst  : STD_LOGIC := '0';
    signal D1   : STD_LOGIC_VECTOR(7 downto 0);
    signal D2   : STD_LOGIC_VECTOR(7 downto 0);
    signal D3   : STD_LOGIC_VECTOR(7 downto 0);
    signal D4   : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Logic_7_segment
        port map (
            dig1 => dig1,
            dig2 => dig2,
            dig3 => dig3,
            dig4 => dig4,
            clk  => clk,
            rst  => rst,
            D1   => D1,
            D2   => D2,
            D3   => D3,
            D4   => D4
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
        -- Reset: todos apagados
        ----------------------------------------------------------------
        rst <= '1';
        wait for 2*CLK_PERIOD;

        assert (D1 = "11111111" and D2 = "11111111" and
                D3 = "11111111" and D4 = "11111111")
            report "ERROR: durante reset las salidas no quedan apagadas"
            severity error;

        ----------------------------------------------------------------
        -- Caso 1: 1,2,3,4
        ----------------------------------------------------------------
        rst  <= '0';
        dig1 <= "0001"; -- 1
        dig2 <= "0010"; -- 2
        dig3 <= "0011"; -- 3
        dig4 <= "0100"; -- 4
        wait for CLK_PERIOD;

        assert (D1 = "11111001")
            report "ERROR: D1 no corresponde al digito 1"
            severity error;

        -- LUT(2)=10100100, con dp forzado a 0 -> 00100100
        assert (D2 = "00100100")
            report "ERROR: D2 no corresponde al digito 2 con dp encendido"
            severity error;

        assert (D3 = "10110000")
            report "ERROR: D3 no corresponde al digito 3"
            severity error;

        assert (D4 = "10011001")
            report "ERROR: D4 no corresponde al digito 4"
            severity error;

        ----------------------------------------------------------------
        -- Caso 2: 0,9,8,7
        ----------------------------------------------------------------
        dig1 <= "0000"; -- 0
        dig2 <= "1001"; -- 9
        dig3 <= "1000"; -- 8
        dig4 <= "0111"; -- 7
        wait for CLK_PERIOD;

        assert (D1 = "11000000")
            report "ERROR: D1 no corresponde al digito 0"
            severity error;

        -- LUT(9)=10010000, con dp forzado a 0 -> 00010000
        assert (D2 = "00010000")
            report "ERROR: D2 no corresponde al digito 9 con dp encendido"
            severity error;

        assert (D3 = "10000000")
            report "ERROR: D3 no corresponde al digito 8"
            severity error;

        assert (D4 = "11111000")
            report "ERROR: D4 no corresponde al digito 7"
            severity error;

        ----------------------------------------------------------------
        -- Caso 3: entradas invalidas 10..15 -> apagado
        ----------------------------------------------------------------
        dig1 <= "1010"; -- 10
        dig2 <= "1011"; -- 11
        dig3 <= "1100"; -- 12
        dig4 <= "1111"; -- 15
        wait for CLK_PERIOD;

        assert (D1 = "11111111")
            report "ERROR: D1 no queda apagado para valor invalido"
            severity error;

        -- apagado con dp encendido -> 01111111
        assert (D2 = "01111111")
            report "ERROR: D2 no queda en el patron esperado para valor invalido"
            severity error;

        assert (D3 = "11111111")
            report "ERROR: D3 no queda apagado para valor invalido"
            severity error;

        assert (D4 = "11111111")
            report "ERROR: D4 no queda apagado para valor invalido"
            severity error;

        report "Simulacion de Logic_7_segment finalizada correctamente" severity note;
        wait;
    end process;

end Behavioral;