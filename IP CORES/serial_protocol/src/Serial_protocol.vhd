library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Serial_protocol is
    Port ( 
        clk        : in  std_logic;
        rst        : in  std_logic;
        serial_in  : in  std_logic;
        num_out    : out std_logic_vector(7 downto 0)
    );
end Serial_protocol;

architecture Behavioral of Serial_protocol is

    type state_t is (IDLE, DATA, STOP); 
    signal state : state_t := IDLE;

    signal bit_index    : natural range 0 to 7 := 0;
    signal serial_shift : std_logic_vector(7 downto 0) := (others => '0');
    signal data_reg     : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                bit_index <= 0;
                serial_shift <= (others => '0');
                data_reg <= (others => '0');
            else

                case state is

                    when IDLE =>
                        bit_index <= 0;

                        if serial_in = '0' then
                            state <= DATA;
                        end if;

                    when DATA =>
                        serial_shift(bit_index) <= serial_in;

                        if bit_index = 7 then
                            bit_index <= 0;
                            state <= STOP;
                        else
                            bit_index <= bit_index + 1;
                        end if;

                    when STOP =>
                        if serial_in = '1' then
                            data_reg <= serial_shift;
                        end if;

                        state <= IDLE;

                end case;
            end if;
        end if;
    end process;

    num_out <= data_reg;

end Behavioral;