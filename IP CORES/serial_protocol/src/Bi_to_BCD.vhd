library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bi_to_BCD is
    Port ( 
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        Bus_in : in  STD_LOGIC_VECTOR(9 downto 0);
        dig1   : out STD_LOGIC_VECTOR(3 downto 0);
        dig2   : out STD_LOGIC_VECTOR(3 downto 0);
        dig3   : out STD_LOGIC_VECTOR(3 downto 0);
        dig4   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Bi_to_BCD;

architecture Behavioral of Bi_to_BCD is

    signal dig1_reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dig2_reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dig3_reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dig4_reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin

    process(clk)
        variable shift_reg : unsigned(25 downto 0);  
        -- [25:22] dig1, [21:18] dig2, [17:14] dig3, [13:10] dig4, [9:0] binario
    begin
        if rising_edge(clk) then
            if rst = '1' then
                dig1_reg <= (others => '0');
                dig2_reg <= (others => '0');
                dig3_reg <= (others => '0');
                dig4_reg <= (others => '0');
            else
                shift_reg := (others => '0');
                shift_reg(9 downto 0) := unsigned(Bus_in);

                -- Algoritmo Double Dabble para 10 bits
                for i in 0 to 9 loop

                    -- Ajuste de cada dígito BCD si es mayor o igual a 5
                    if shift_reg(25 downto 22) >= 5 then
                        shift_reg(25 downto 22) := shift_reg(25 downto 22) + 3;
                    end if;

                    if shift_reg(21 downto 18) >= 5 then
                        shift_reg(21 downto 18) := shift_reg(21 downto 18) + 3;
                    end if;

                    if shift_reg(17 downto 14) >= 5 then
                        shift_reg(17 downto 14) := shift_reg(17 downto 14) + 3;
                    end if;

                    if shift_reg(13 downto 10) >= 5 then
                        shift_reg(13 downto 10) := shift_reg(13 downto 10) + 3;
                    end if;

                    -- Shift a la izquierda
                    shift_reg := shift_reg sll 1;
                end loop;

                -- Guardar salida BCD
                dig1_reg <= std_logic_vector(shift_reg(25 downto 22));
                dig2_reg <= std_logic_vector(shift_reg(21 downto 18));
                dig3_reg <= std_logic_vector(shift_reg(17 downto 14));
                dig4_reg <= std_logic_vector(shift_reg(13 downto 10));
            end if;
        end if;
    end process;

    dig1 <= dig1_reg;
    dig2 <= dig2_reg;
    dig3 <= dig3_reg;
    dig4 <= dig4_reg;

end Behavioral;