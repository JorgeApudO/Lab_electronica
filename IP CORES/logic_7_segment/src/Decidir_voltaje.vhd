----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 13:00:27
-- Design Name: 
-- Module Name: Decidir_voltaje - Behavioral
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

entity Decidir_voltaje is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           V0 : in STD_LOGIC_VECTOR (9 downto 0);
           V1 : in STD_LOGIC_VECTOR (9 downto 0);
           enable : in STD_LOGIC;
           Switch : in STD_LOGIC;
           V : out STD_LOGIC_VECTOR (9 downto 0);
           Led : out STD_LOGIC);
end Decidir_voltaje;

architecture Behavioral of Decidir_voltaje is

signal V_reg : std_logic_vector (9 downto 0);

begin

process(clk)
    begin
    
    if rising_edge(clk) then
        if rst = '1' then
            V_reg <= (others => '0');
            Led <= '0';
        else
            if Switch = '0' then
                if enable = '1' then
                    V_reg <= V0;
                end if;
                Led <= '1';
            else
                if enable = '1' then
                    V_reg <= V1;
                end if;
                Led <= '0';
            end if;
        end if;
    end if;
    
    end process;
V <= V_reg;
end Behavioral;
