library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Bi_to_BCD is
end tb_Bi_to_BCD;

architecture Behavioral of tb_Bi_to_BCD is

    component Bi_to_BCD
        Port ( 
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            Bus_in : in  STD_LOGIC_VECTOR(9 downto 0);
            dig1   : out STD_LOGIC_VECTOR(3 downto 0);
            dig2   : out STD_LOGIC_VECTOR(3 downto 0);
            dig3   : out STD_LOGIC_VECTOR(3 downto 0);
            dig4   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal clk    : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal Bus_in : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal dig1   : STD_LOGIC_VECTOR(3 downto 0);
    signal dig2   : STD_LOGIC_VECTOR(3 downto 0);
    signal dig3   : STD_LOGIC_VECTOR(3 downto 0);
    signal dig4   : STD_LOGIC_VECTOR(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Bi_to_BCD
        port map (
            clk    => clk,
            rst    => rst,
            Bus_in => Bus_in,
            dig1   => dig1,
            dig2   => dig2,
            dig3   => dig3,
            dig4   => dig4
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
        -- Reset inicial
        ----------------------------------------------------------------
        rst <= '1';
        Bus_in <= (others => '0');
        wait for 2*CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;

        assert (dig1 = "0000" and dig2 = "0000" and dig3 = "0000" and dig4 = "0000")
            report "ERROR: Reset no deja las salidas en 0000"
            severity error;

        ----------------------------------------------------------------
        -- Caso 1: 0 -> 0000
        ----------------------------------------------------------------
        Bus_in <= std_logic_vector(to_unsigned(0, 10));
        wait for CLK_PERIOD;

        assert (dig1 = "0000" and dig2 = "0000" and dig3 = "0000" and dig4 = "0000")
            report "ERROR: 0 no se convierte a 0000"
            severity error;

        ----------------------------------------------------------------
        -- Caso 2: 9 -> 0009
        ----------------------------------------------------------------
        Bus_in <= std_logic_vector(to_unsigned(9, 10));
        wait for CLK_PERIOD;

        assert (dig1 = "0000" and dig2 = "0000" and dig3 = "0000" and dig4 = "1001")
            report "ERROR: 9 no se convierte a 0009"
            severity error;

        ----------------------------------------------------------------
        -- Caso 3: 42 -> 0042
        ----------------------------------------------------------------
        Bus_in <= std_logic_vector(to_unsigned(42, 10));
        wait for CLK_PERIOD;

        assert (dig1 = "0000" and dig2 = "0000" and dig3 = "0100" and dig4 = "0010")
            report "ERROR: 42 no se convierte a 0042"
            severity error;

        ----------------------------------------------------------------
        -- Caso 4: 255 -> 0255
        ----------------------------------------------------------------
        Bus_in <= std_logic_vector(to_unsigned(255, 10));
        wait for CLK_PERIOD;

        assert (dig1 = "0000" and dig2 = "0010" and dig3 = "0101" and dig4 = "0101")
            report "ERROR: 255 no se convierte a 0255"
            severity error;

        ----------------------------------------------------------------
        -- Caso 5: 999 -> 0999
        ----------------------------------------------------------------
        Bus_in <= std_logic_vector(to_unsigned(999, 10));
        wait for CLK_PERIOD;

        assert (dig1 = "0000" and dig2 = "1001" and dig3 = "1001" and dig4 = "1001")
            report "ERROR: 999 no se convierte a 0999"
            severity error;

        ----------------------------------------------------------------
        -- Caso 6: 1023 -> 1023
        ----------------------------------------------------------------
        Bus_in <= std_logic_vector(to_unsigned(1023, 10));
        wait for CLK_PERIOD;

        assert (dig1 = "0001" and dig2 = "0000" and dig3 = "0010" and dig4 = "0011")
            report "ERROR: 1023 no se convierte a 1023"
            severity error;

        report "Simulacion de Bin_to_BCD finalizada correctamente" severity note;
        wait;
    end process;

end Behavioral;