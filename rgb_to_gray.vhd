library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RGBtoGray is
    Port ( RGBin : in STD_LOGIC_VECTOR (11 downto 0);
           GrayOut : out STD_LOGIC_VECTOR (11 downto 0));
end RGBtoGray;

architecture Behavioral of RGBtoGray is
signal GrayOut_4bit_tmp,red_temp,blue_temp,green_temp : STD_LOGIC_VECTOR (3 downto 0);
signal red_div,blue_div,green_div : STD_LOGIC_VECTOR (11 downto 0);

begin
-- formula = 0.299 x Red + 0.587 x Green + 0.114 x Blue
-- aproximated as 0.25 x Red + 0.5 x Green + 0.125 x Blue
red_temp <= "00"&RGBin( 11 downto 10 ); -- first two bits set to 0
green_temp <= "0"&RGBin(7 downto 5 ); -- only the first bit is overwritten
blue_temp <= "000"&RGBin(3); -- first 3 bits are overwritten, only last bit matters

GrayOut_4bit_tmp <= red_temp + green_temp+ blue_temp;
GrayOut <= GrayOut_4bit_tmp & GrayOut_4bit_tmp & GrayOut_4bit_tmp; -- update

end Behavioral;
