library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Clock_divisor is
end tb_Clock_divisor;

architecture Behavioral of tb_Clock_divisor is

    constant TB_IN_FREQ_HZ  : positive := 100;
    constant TB_OUT_FREQ_HZ : positive := 10;


    constant CLK_PERIOD : time := 10 ns;

    signal clk_in  : std_logic := '0';
    signal rst     : std_logic := '1';
    signal clk_out : std_logic;

begin

    uut : entity work.Clock_divisor
        generic map(
            in_freq_hz  => TB_IN_FREQ_HZ,
            out_freq_hz => TB_OUT_FREQ_HZ
        )
        port map(
            clk_in  => clk_in,
            rst     => rst,
            clk_out => clk_out
        );

    clk_process : process
    begin
        while true loop
            clk_in <= '0';
            wait for CLK_PERIOD/2;
            clk_in <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc : process
    begin
        -- Mantener reset activo al inicio
        rst <= '1';
        wait for 30 ns;

        -- Liberar reset
        rst <= '0';

        -- Dejar correr suficiente tiempo para observar varias conmutaciones
        wait for 300 ns;

        -- Finalizar simulación
        assert false report "Fin de la simulacion" severity failure;
    end process;

end Behavioral;
