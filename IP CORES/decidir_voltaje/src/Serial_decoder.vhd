----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 14:58:05
-- Design Name: 
-- Module Name: Serial_decoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Serial_decoder is
    Port ( Bus_in : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : out STD_LOGIC;
           V0 : out STD_LOGIC_VECTOR (9 downto 0);
           V1 : out STD_LOGIC_VECTOR (9 downto 0));
end Serial_decoder;

architecture Behavioral of Serial_decoder is

signal V0_reg : std_logic_vector (9 downto 0) := (others => '0');
signal V1_reg : std_logic_vector (9 downto 0) := (others => '0');
signal enable_reg : std_logic := '0';

begin

process(clk)
variable H1_v : std_logic;
variable H2_v : std_logic;
variable H3_v : std_logic;
variable data_v : std_logic_vector (4 downto 0);
begin

if rising_edge(clk) then
    if rst = '1' then
        V0_reg <= (others => '0');
        V1_reg <= (others => '0');
        enable_reg <= '0';
    else
        H1_v := Bus_in(7);
        H2_v := Bus_in(6);
        H3_v := Bus_in(5);
        data_v := Bus_in(4 downto 0);
        enable_reg <= '0';
        if H1_v = '0' then
            if H2_v = '0' then
                V0_reg(9 downto 5) <= data_v;
            else
                V0_reg(4 downto 0) <= data_v;
                -- Añadir paridad ? 
            end if;
        
        else
            if H2_v = '0' then
                V1_reg(9 downto 5) <= data_v;
            else
                V1_reg(4 downto 0) <= data_v;
                -- Añadir paridad ? 
                enable_reg <= '1';
            end if;
        end if;
    end if;
end if;
end process;

V0 <= V0_reg;
V1 <= V1_reg;
enable <= enable_reg;


end Behavioral;
