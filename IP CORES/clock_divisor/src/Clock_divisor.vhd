library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_divisor is
    generic (
        in_freq_hz : positive := 100_000_000;
        out_freq_hz : positive := 10
        );
    port ( clk_in : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end Clock_divisor;

architecture Behavioral of Clock_divisor is

constant CYCLES : positive := in_freq_hz / (2 * out_freq_hz);
signal counter : natural range 0 to CYCLES - 1 := 0;
signal clk_div : std_logic := '0';

begin
    
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if rst='1' then
                counter <= 0;
                clk_div <= '0';
            else
                if counter = CYCLES - 1 then
                    counter <= 0;
                    clk_div <= not clk_div;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    
    clk_out <= clk_div;
    
end Behavioral;
