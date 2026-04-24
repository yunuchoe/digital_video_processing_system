library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all; 

entity sobel_filter is
    generic (
        SCREEN_X_SIZE : UNSIGNED( 10 downto 0 );
        SCREEN_Y_SIZE : UNSIGNED( 9 downto 0 )
    );
    port (
        video_clock : in STD_LOGIC;
        visible_frame : in STD_LOGIC;
        filter_options : in STD_LOGIC_VECTOR( 1 downto 0 );
        v_sync : in STD_LOGIC;
        gray_pixel_in : in STD_LOGIC_VECTOR( 3 downto 0 );

        pixel_out : out STD_LOGIC_VECTOR( 11 downto 0 )
    );
end sobel_filter;

architecture Behavioral of sobel_filter is

type sobel_line_buffer_type is array(( to_integer( SCREEN_X_SIZE ) * 3 ) - 1 downto 0 ) of STD_LOGIC_VECTOR( 3 downto 0 );
type sobel_window_3_by_3_type is array (0 to 2, 0 to 2 ) of std_logic_vector(3 downto 0);

signal sobel_line_buffer : sobel_line_buffer_type;
signal sobel_window_3_by_3 : sobel_window_3_by_3_type;

signal temp_y_1: std_logic_vector(5 downto 0);
signal temp_y_2: std_logic_vector(5 downto 0);
signal temp_x_1: std_logic_vector(5 downto 0);
signal temp_x_2: std_logic_vector(5 downto 0);

signal datax : std_logic_vector(6 downto 0);
signal datay : std_logic_vector(6 downto 0);
signal dataxy : std_logic_vector(7 downto 0);


begin
do_sobel_shift : process( 
    video_clock,
    v_sync,
    visible_frame,
    sobel_line_buffer,
    gray_pixel_in( 3 downto 0 )
)
variable position : integer := 0;


begin
    if ( rising_edge( video_clock )) then
        if (( visible_frame = '1' ) or ( v_sync = '0' )) then
             
            for position in (( to_integer( SCREEN_X_SIZE ) * 3 ) - 1) downto 1 loop
                sobel_line_buffer( position ) <= sobel_line_buffer( position - 1 );
            end loop;
            
            if ( v_sync = '0' ) then
                sobel_line_buffer( 0 ) <= "0000";
            else
                sobel_line_buffer( 0 ) <= gray_pixel_in( 3 downto 0 );
            end if;

        end if;
    end if;
end process;
    
sobel_window_3_by_3( 0, 0 ) <= sobel_line_buffer( 0 + 0 );
sobel_window_3_by_3( 0, 1 ) <= sobel_line_buffer( 1 + 0 );
sobel_window_3_by_3( 0, 2 ) <= sobel_line_buffer( 2 + 0 );

sobel_window_3_by_3( 1, 0 ) <= sobel_line_buffer( 0 + 640 );
sobel_window_3_by_3( 1, 1 ) <= sobel_line_buffer( 1 + 640 );
sobel_window_3_by_3( 1, 2 ) <= sobel_line_buffer( 2 + 640 );

sobel_window_3_by_3( 2, 0 ) <= sobel_line_buffer( 0 + 1280 );
sobel_window_3_by_3( 2, 1 ) <= sobel_line_buffer( 1 + 1280 );
sobel_window_3_by_3( 2, 2 ) <= sobel_line_buffer( 2 + 1280 );


-- y direction
temp_y_1 <= ( '0' & sobel_window_3_by_3(0,0) & '0') + ( sobel_window_3_by_3(0,1) & "00") + ( '0' & sobel_window_3_by_3(0,2) & '0'); 
temp_y_2 <= ( '0' & sobel_window_3_by_3(2,0) & '0') + ( sobel_window_3_by_3(2,1) & "00") + ( '0' & sobel_window_3_by_3(2,2) & '0'); 

datay <= (('0' & temp_y_2) - ( '0' & temp_y_1)) when ( temp_y_2 > temp_y_1) else (( '0' & temp_y_1) - ( '0' & temp_y_2));

--  x direction
temp_x_1 <= ( '0' & sobel_window_3_by_3(0,0) & '0') + ( sobel_window_3_by_3(1,0) & "00") + ( '0' & sobel_window_3_by_3(2,0) & '0');
temp_x_2 <= ( '0' & sobel_window_3_by_3(0,2) & '0') + ( sobel_window_3_by_3(1,2) & "00") + ( '0' & sobel_window_3_by_3(2,2) & '0');

datax <= (( '0' & temp_x_2) - ( '0' & temp_x_1)) when ( temp_x_2 > temp_x_1) else (( '0' & temp_x_1) - ( '0' & temp_x_2));
    
-- x and y
dataxy <= ( '0' & datay ) + ( '0' & datax );


pixel_out <= -- update
        datax(6 downto 3) & datax(6 downto 3) & datax(6 downto 3)  when filter_options ="10" else
        datay(6 downto 3) & datay(6 downto 3) & datay(6 downto 3)  when filter_options ="01" else
        dataxy(7 downto 4) & dataxy(7 downto 4) & dataxy(7 downto 4)  when filter_options ="11" else
        dataxy(3 downto 0) & dataxy(3 downto 0) & dataxy(3 downto 0);

end Behavioral;
