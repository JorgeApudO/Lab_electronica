----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 17:03:22
-- Design Name: 
-- Module Name: Display_7_segment - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display_7_segment is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           D1 : in STD_LOGIC_VECTOR (7 downto 0);
           D2 : in STD_LOGIC_VECTOR (7 downto 0);
           D3 : in STD_LOGIC_VECTOR (7 downto 0);
           D4 : in STD_LOGIC_VECTOR (7 downto 0);
           catodo : out STD_LOGIC_VECTOR (7 downto 0);
           anodo : out STD_LOGIC_VECTOR (3 downto 0));
end Display_7_segment;

architecture Behavioral of Display_7_segment is

signal state : natural range 0 to 4 := 0;

begin
process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            catodo <= (others => '1');
            anodo <= (others => '1');
            state <= 0;
        else
            case state is
                
                when 0 => 
                    anodo <= "1111";
                    catodo <= (others => '1');
                    state <= 1;
                when 1 => 
                    anodo <= "0111";
                    catodo <= D1;
                    state <= 2;
                when 2 => 
                    anodo <= "1011";
                    catodo <= D2;
                    state <= 3;
                when 3 => 
                    anodo <= "1101";
                    catodo <= D3;
                    state <= 4;    
                when 4 => 
                    anodo <= "1110";
                    catodo <= D4;
                    state <= 1;
                end case;
        end if;
    
    
    end if;

end Behavioral;
