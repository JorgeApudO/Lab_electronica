library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decidir_voltaje is
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        V0     : in  STD_LOGIC_VECTOR (11 downto 0);
        V1     : in  STD_LOGIC_VECTOR (11 downto 0);
        enable : in  STD_LOGIC;
        Switch : in  STD_LOGIC;
        V      : out STD_LOGIC_VECTOR (9 downto 0);
        Led    : out STD_LOGIC
    );
end Decidir_voltaje;

architecture Behavioral of Decidir_voltaje is

    signal V_reg : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');

    function scale_12_to_10(
        raw_in         : unsigned(11 downto 0);
        full_scale_out : natural
    ) return unsigned is
        variable raw_i    : integer range 0 to 4095;
        variable scaled_i : integer;
    begin
        raw_i := to_integer(raw_in);

        -- Reescalamiento con redondeo:
        -- salida = round(raw_i * full_scale_out / 4095)
        scaled_i := (raw_i * full_scale_out + 2047) / 4095;

        return to_unsigned(scaled_i, 10);
    end function;

begin

    process(clk)
        variable V_scaled : unsigned(9 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                V_reg <= (others => '0');
                Led   <= '0';
            else
                if Switch = '0' then
                    Led <= '1';
                else
                    Led <= '0';
                end if;

                -- solo actualiza V cuando llega un nuevo paquete completo
                if enable = '1' then
                    if Switch = '0' then
                        V_scaled := scale_12_to_10(unsigned(V0), 330);
                    else
                        V_scaled := scale_12_to_10(unsigned(V1), 1000);
                    end if;

                    V_reg <= std_logic_vector(V_scaled);
                end if;
            end if;
        end if;
    end process;

    V <= V_reg;

end Behavioral;