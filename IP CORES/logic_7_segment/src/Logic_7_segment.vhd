library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Logic_7_segment is
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
end Logic_7_segment;

architecture Behavioral of Logic_7_segment is

    -- Formato: dp g f e d c b a
    -- Activo en bajo
    type seg_lut_t is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);

    constant SEG_LUT : seg_lut_t := (
        0  => "11000000", -- 0
        1  => "11111001", -- 1
        2  => "10100100", -- 2
        3  => "10110000", -- 3
        4  => "10011001", -- 4
        5  => "10010010", -- 5
        6  => "10000010", -- 6
        7  => "11111000", -- 7
        8  => "10000000", -- 8
        9  => "10010000", -- 9
        10 => "11111111", -- apagado
        11 => "11111111", -- apagado
        12 => "11111111", -- apagado
        13 => "11111111", -- apagado
        14 => "11111111", -- apagado
        15 => "11111111"  -- apagado
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Display activo en bajo
                D1 <= (others => '1');
                D2 <= (others => '1');
                D3 <= (others => '1');
                D4 <= (others => '1');
            else
                D1 <= SEG_LUT(to_integer(unsigned(dig1)));
                D2 <= '0' & SEG_LUT(to_integer(unsigned(dig2)))(6 downto 0); -- dp encendido
                D3 <= SEG_LUT(to_integer(unsigned(dig3)));
                D4 <= SEG_LUT(to_integer(unsigned(dig4)));
            end if;
        end if;
    end process;

end Behavioral;