----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: RGBtoGray - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RGBtoGray is
    Port ( RGBin : in STD_LOGIC_VECTOR (11 downto 0);
           GrayOut : out STD_LOGIC_VECTOR (11 downto 0));
end RGBtoGray;

architecture Behavioral of RGBtoGray is

signal GrayOut_4bit_tmp,red_temp,blue_temp,green_temp : STD_LOGIC_VECTOR (3 downto 0);
signal red_div,blue_div,green_div : STD_LOGIC_VECTOR (11 downto 0);
begin


-----GrayScaleImage =  0.299 x Red + 0.587 x Green + 0.114 x Blue
red_temp <= "00"&RGBin( 11 downto 10 );
green_temp <= "0"&RGBin(7 downto 5 );
blue_temp <= "000"&RGBin(3);

GrayOut_4bit_tmp <= red_temp + green_temp+ blue_temp;
GrayOut <= GrayOut_4bit_tmp & GrayOut_4bit_tmp & GrayOut_4bit_tmp; --- 0.25 x red + 0.5 x green + 0.125 x blue

end Behavioral;
