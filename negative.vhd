

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

entity negative_image is
    Port (
        pixel_in : in STD_LOGIC_VECTOR (11 downto 0);
        pixel_out : out STD_LOGIC_VECTOR (11 downto 0)
    );
end negative_image;

architecture Behavioral of negative_image is

signal red, green, blue : unsigned( 3 downto 0 );

begin

    red <= unsigned( "1111" - pixel_in( 11 downto 8 ));
    green <= unsigned( "1111" - pixel_in( 7 downto 4 ));
    blue <= unsigned(  "1111" - pixel_in( 3 downto 0 ));


    pixel_out <= std_logic_vector( red & green & blue );

end Behavioral;
