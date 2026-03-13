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
           Switch : in STD_LOGIC;
           V : out STD_LOGIC_VECTOR (9 downto 0);
           Led : out STD_LOGIC);
end Decidir_voltaje;

architecture Behavioral of Decidir_voltaje is

begin

process(clk)
    begin
    
    if rising_edge(clk) then
        if rst = '1' then
            V <= (others => '0');
            Led <= '0';
        else
            if Switch = '0' then
                V <= V0;
                Led <= '1';
            else
                V <= V1;
                Led <= '0';
            
            end if;
        
        end if;
    
    end if;
    
    
    end process;

end Behavioral;
