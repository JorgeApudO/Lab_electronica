library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Serial_protocol is
end tb_Serial_protocol;

architecture Behavioral of tb_Serial_protocol is

    component Serial_protocol
        Port ( 
            clk        : in  std_logic;
            rst        : in  std_logic;
            serial_in  : in  std_logic;
            data_valid : out std_logic;
            num_out    : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal serial_in  : std_logic := '1';
    signal data_valid : std_logic;
    signal num_out    : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure send_frame(
        signal s_in    : out std_logic;
        constant data  : in  std_logic_vector(7 downto 0);
        constant stopb : in  std_logic := '1'
    ) is
    begin
        s_in <= '1';
        wait for CLK_PERIOD;

        s_in <= '0';
        wait for CLK_PERIOD;

        for i in 0 to 7 loop
            s_in <= data(i);
            wait for CLK_PERIOD;
        end loop;

        s_in <= stopb;
        wait for CLK_PERIOD;

        s_in <= '1';
        wait for CLK_PERIOD;
    end procedure;

begin

    uut: Serial_protocol
        port map (
            clk        => clk,
            rst        => rst,
            serial_in  => serial_in,
            data_valid => data_valid,
            num_out    => num_out
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

    stim_proc: process
    begin
        -- 0 ns a 50 ns
        rst <= '1';
        serial_in <= '1';
        wait for 3*CLK_PERIOD;
        rst <= '0';
        wait for 2*CLK_PERIOD;

        -- 50 ns a 160 ns
        send_frame(serial_in, x"A5", '1');
        wait for CLK_PERIOD;
        assert (data_valid = '1')
            report "ERROR: data_valid no se activo para A5"
            severity error;
        assert (num_out = x"A5")
            report "ERROR: num_out no coincide con A5"
            severity error;

        -- 170 ns a 280 ns
        send_frame(serial_in, x"3C", '1');
        wait for CLK_PERIOD;
        assert (data_valid = '1')
            report "ERROR: data_valid no se activo para 3C"
            severity error;
        assert (num_out = x"3C")
            report "ERROR: num_out no coincide con 3C"
            severity error;

        -- 290 ns a 400 ns
        send_frame(serial_in, x"F0", '0');
        wait for CLK_PERIOD;
        assert (data_valid = '0')
            report "ERROR: data_valid se activo con stop bit invalido"
            severity error;

        -- 410 ns a 520 ns
        send_frame(serial_in, x"55", '1');
        wait for CLK_PERIOD;
        assert (data_valid = '1')
            report "ERROR: data_valid no se activo para 55"
            severity error;
        assert (num_out = x"55")
            report "ERROR: num_out no coincide con 55"
            severity error;

        report "Simulacion finalizada correctamente antes de 1000 ns" severity note;
        wait;
    end process;

end Behavioral;