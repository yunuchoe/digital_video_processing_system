library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity negative_image is
    Port (
        pixel_in : in STD_LOGIC_VECTOR (11 downto 0);
        pixel_out : out STD_LOGIC_VECTOR (11 downto 0)
    );
end negative_image;

architecture Behavioral of negative_image is
signal red, green, blue : unsigned( 3 downto 0 );

begin
    -- negative image is max intensity-current intensity
    red <= unsigned( "1111" - pixel_in( 11 downto 8 ) ); -- red lsb
    green <= unsigned( "1111" - pixel_in( 7 downto 4 ) ); -- green middle
    blue <= unsigned(  "1111" - pixel_in( 3 downto 0 ) ); -- blue is rsb

    pixel_out <= std_logic_vector( red & green & blue ); -- update
end Behavioral;
