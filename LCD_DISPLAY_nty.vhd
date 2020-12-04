LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY LCD_DISPLAY_nty IS
   
   PORT( 
      reset              : IN     std_logic;  
      clk                : IN     std_logic;  -- in order to Genreate the 400Hz signal... clk_count_400hz reset count value must be set to:  <= x"0F424" (62500)   x"1E848"--- (125000), x"3D090" ---(250000) for 100Mhz 
      temp_dec_in        : IN     STD_LOGIC_VECTOR (20 downto 0);
      
      lcd_rs             : OUT    std_logic;
      lcd_e              : OUT    std_logic;
      lcd_rw             : OUT    std_logic;   
      

      
      data_bus_0         : INOUT  STD_LOGIC;
      data_bus_1         : INOUT  STD_LOGIC;
      data_bus_2         : INOUT  STD_LOGIC;
      data_bus_3         : INOUT  STD_LOGIC;
      data_bus_4         : INOUT  STD_LOGIC;
      data_bus_5         : INOUT  STD_LOGIC;
      data_bus_6         : INOUT  STD_LOGIC;
      data_bus_7         : INOUT  STD_LOGIC                
   );

-- Declarations

END LCD_DISPLAY_nty ;


ARCHITECTURE LCD_DISPLAY_arch OF LCD_DISPLAY_nty IS
  type character_string is array ( 0 to 15 ) of STD_LOGIC_VECTOR( 7 downto 0 );
  
  type state_type is (hold, func_set, display_on, mode_set, print_string,
                      line2, return_home, drop_lcd_e, reset1, reset2,
                       reset3, display_off, display_clear);
                       
  signal state, next_command         : state_type;
  
  
  signal lcd_display_string          : character_string;
  
  signal lcd_display_string_01       : character_string;
  signal lcd_display_string_02       : character_string;
  signal lcd_display_string_03       : character_string;
  signal lcd_display_string_04       : character_string;
  signal lcd_display_string_05       : character_string;
  signal lcd_display_string_06       : character_string;
  signal lcd_display_string_07       : character_string;
  signal lcd_display_string_08       : character_string;
  signal lcd_display_string_09       : character_string;
  signal lcd_display_string_10       : character_string;
  signal lcd_display_string_11       : character_string;
  
  signal data_bus_value, next_char   : STD_LOGIC_VECTOR(7 downto 0);
  signal clk_count_400hz             : STD_LOGIC_VECTOR(19 downto 0);
  
  signal char_count                  : STD_LOGIC_VECTOR(3 downto 0);--16 characters totally, 4bits
  signal clk_400hz_enable,lcd_rw_int : std_logic;
  
  signal data_bus                    : STD_LOGIC_VECTOR(7 downto 0);  
  signal signbit		     : std_logic;
  signal signald1                    : STD_LOGIC_VECTOR(3 downto 0); 
  signal signald2                    : STD_LOGIC_VECTOR(3 downto 0);
  signal signald3                    : STD_LOGIC_VECTOR(3 downto 0);
  signal signald4                    : STD_LOGIC_VECTOR(3 downto 0);
  signal signald5                    : STD_LOGIC_VECTOR(3 downto 0);
  
  signal out_data_ascii_d1           : STD_LOGIC_VECTOR(7 downto 0); 
  signal out_data_ascii_d2           : STD_LOGIC_VECTOR(7 downto 0);
  signal out_data_ascii_d3           : STD_LOGIC_VECTOR(7 downto 0);
  signal out_data_ascii_d4           : STD_LOGIC_VECTOR(7 downto 0);
  signal out_data_ascii_d5           : STD_LOGIC_VECTOR(7 downto 0);




COMPONENT LCD_to_Ascii
  PORT(
	data: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	out_data_ascii: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT LCD_to_Ascii;

BEGIN
  

--===================================================--  
-- SIGNAL STD_LOGIC_VECTORS assigned to OUTPUT PORTS 
--===================================================-- 
--DECIMAL D1 D2 D3 . D4 D5   
signbit	<= temp_dec_in(20);
signald1 <= temp_dec_in(19 DOWNTO 16); --D1
signald2 <= temp_dec_in(15 DOWNTO 12); --D2
signald3 <= temp_dec_in(11 DOWNTO 8);  --D3
signald4 <= temp_dec_in(7 DOWNTO 4);--D4
signald5 <= temp_dec_in(3 DOWNTO 0);--D5



data_bus_0 <= data_bus(0);
data_bus_1 <= data_bus(1);
data_bus_2 <= data_bus(2);
data_bus_3 <= data_bus(3);
data_bus_4 <= data_bus(4);
data_bus_5 <= data_bus(5);
data_bus_6 <= data_bus(6);
data_bus_7 <= data_bus(7);


--out_data_ascii_d1,2,3,4,5 are ascii code 8bits
D1: LCD_to_Ascii PORT MAP(
				data => signald1,
				out_data_ascii =>out_data_ascii_d1);
D2: LCD_to_Ascii PORT MAP(
				data => signald2,
				out_data_ascii =>out_data_ascii_d2);
D3: LCD_to_Ascii PORT MAP(
				data => signald3,
				out_data_ascii =>out_data_ascii_d3);
D4: LCD_to_Ascii PORT MAP(
				data => signald4,
				out_data_ascii =>out_data_ascii_d4);
D5: LCD_to_Ascii PORT MAP(
				data => signald5,
				out_data_ascii =>out_data_ascii_d5);
 
-- ASCII hex values for LCD Display
-- Enter Live Hex Data Values from hardware here

-- LCD DISPLAYS THE FOLLOWING:

------------------------------
--| Count=XX |
--| DE2 |
------------------------------


-- Accessing the Input Switches for 2 digit HEX Display 
-------------------------------------------------------------------------
 --   x"0"&hex_display_data(7 downto 4),x"0"&hex_display_data(3 downto 0), 

--   = x"20",
-- ! = x"21",
-- " = x"22",
-- # = x"23",
-- $ = x"24",
-- % = x"25",
-- & = x"26",
-- ' = x"27",
-- ( = x"28",
-- ) = x"29",
-- * = x"2A",
-- + = x"2B",
-- , = x"2C",
-- - = x"2D",
-- . = x"2E",
-- / = x"2F",



-- 0 = x"30",
-- 1 = x"31",
-- 2 = x"32",
-- 3 = x"33",
-- 4 = x"34",
-- 5 = x"35",
-- 6 = x"36",
-- 7 = x"37",
-- 8 = x"38",
-- 9 = x"39",
-- : = x"3A",
-- ; = x"3B",
-- < = x"3C",
-- = = x"3D",
-- > = x"3E",
-- ? = x"3F",




-- Q = x"40",
-- A = x"41",
-- B = x"42",
-- C = x"43",
-- D = x"44",
-- E = x"45",
-- F = x"46",
-- G = x"47",
-- H = x"48",
-- I = x"49",
-- J = x"4A",
-- K = x"4B",
-- L = x"4C",
-- M = x"4D",
-- N = x"4E",
-- O = x"4F",



-- P = x"50",
-- Q = x"51",
-- R = x"52",
-- S = x"53",
-- T = x"54",
-- U = x"55",
-- V = x"56",
-- W = x"57",
-- X = x"58",
-- Y = x"59",
-- Z = x"5A",
-- [ = x"5B",
-- Y! = x"5C",
-- ] = x"5D",
-- ^ = x"5E",
-- _ = x"5F",



-- \ = x"60",
-- a = x"61",
-- b = x"62",
-- c = x"63",
-- d = x"64",
-- e = x"65",
-- f = x"66",
-- g = x"67",
-- h = x"68",
-- i = x"69",
-- j = x"6A",
-- k = x"6B",
-- l = x"6C",
-- m = x"6D",
-- n = x"6E",
-- o = x"6F",



-- p = x"70",
-- q = x"71",
-- r = x"72",
-- s = x"73",
-- t = x"74",
-- u = x"75",
-- v = x"76",
-- w = x"77",
-- x = x"78",
-- y = x"79",
-- z = x"7A",
-- { = x"7B",
-- | = x"7C",
-- } = x"7D",
-- -> = x"7E",
-- <- = x"7F",


 lcd_display_string_01 <= 
  (
-- Line 1  
          x"2E",out_data_ascii_d4,out_data_ascii_d5,x"20",x"20",x"20",x"20",x"20",x"74",x"65",x"6D", x"70",x"3A",out_data_ascii_d1,out_data_ascii_d2,out_data_ascii_d3
        --.        d4                D5                                            t    e      m       p     :     d1                       d2             d3
   );
-------------------------------------------------------------------------------------------------------
-- BIDIRECTIONAL TRI STATE LCD DATA BUS
   data_bus <= data_bus_value when lcd_rw_int = '0' else "ZZZZZZZZ";
   
-- LCD_RW PORT is assigned to it matching SIGNAL 
   lcd_rw <= lcd_rw_int;
 
 
 
 
 
 

------------------------------------ STATE MACHINE FOR LCD SCREEN MESSAGE SELECT -----------------------------
---------------------------------------------------------------------------------------------------------------
  

          
          -- Bluetooth Disconnected
            next_char <= lcd_display_string_01(CONV_INTEGER(char_count));

  
  
  
--=====================================================================-- 
--======================= CLOCK #1 SIGNALS ============================--  
--=====================================================================-- 
process(clk)
begin
      if (rising_edge(clk)) then
         if (reset = '0') then
            clk_count_400hz <= x"00000";
            clk_400hz_enable <= '0';
         else
            if (clk_count_400hz <= x"0F424") then         -- C96A8=> 120Hz    1E848---800HZ for half clock 
                   clk_count_400hz <= clk_count_400hz + 1;                                   
                   clk_400hz_enable <= '0';                
            else
                   clk_count_400hz <= x"00000";
                   clk_400hz_enable <= '1';
            end if;
         end if;
      end if;
end process;  
--==================================================================--    
  --======================== LCD DRIVER CORE ==============================--   
--                     STATE MACHINE WITH RESET                          -- 
--===================================================-----===============--  
process (clk, reset)
begin
 
  
        if reset = '0' then
           state <= reset1;
           data_bus_value <= x"38"; -- RESET
           next_command <= reset2;
           lcd_e <= '1';
           lcd_rs <= '0';
           lcd_rw_int <= '0';  
        
    
    
        elsif rising_edge(clk) then
             if clk_400hz_enable = '1' then  
                 
                 
                 
              --========================================================--                 
              -- State Machine to send commands and data to LCD DISPLAY
              --========================================================--
                 case state is
                 -- Set Function to 8-bit transfer and 2 line display with 5x8 Font size
                 -- see Hitachi HD44780 family data sheet for LCD command and timing details
                       
                       
                       
--======================= INITIALIZATION START ============================--
                       when reset1 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= reset2;
                            char_count <= "0000";
  
                       when reset2 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= reset3;
                            
                       when reset3 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= func_set;
            
            
                       -- Function Set
                       --==============--
                       when func_set =>                
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38";  -- **Set Function to 8-bit transfer, 2-line display
                            state <= drop_lcd_e;
                            next_command <= display_off;
                            
                            
                            
                       -- Turn off Display
                       --==============-- 
                       when display_off =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"08"; -- Turns OFF the Display, Cursor OFF and Blinking Cursor Position OFF.......(0F = Display ON and Cursor ON, Blinking cursor position ON)
                            state <= drop_lcd_e;
                            next_command <= display_clear;
                           
                           
                       -- Clear Display 
                       --==============--
                       when display_clear =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"01"; -- Clears the Display    
                            state <= drop_lcd_e;
                            next_command <= display_on;
                           
                           
                           
                       -- Turn on Display and Turn off cursor
                       --===================================--
                       when display_on =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"0C"; -- Turns on the Display (0E = Display ON, Cursor ON and Blinking cursor OFF) 
                            state <= drop_lcd_e;
                            next_command <= mode_set;
                          
                          
                       -- Set write mode to auto increment address and move cursor to the right
                       --====================================================================--
                       when mode_set =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"06"; -- Auto increment address and move cursor to the right
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                            
                                
--======================= INITIALIZATION END ============================--                          
                          
                          
                          
                          
--=======================================================================--                           
--               Write ASCII hex character Data to the LCD
--=======================================================================--
                       when print_string =>          
                            state <= drop_lcd_e;
                            lcd_e <= '1';
                            lcd_rs <= '1';
                            lcd_rw_int <= '0';
                          
                          
                               -- ASCII character to output
                               if (next_char(7 downto 4) /= x"0") then
                                  data_bus_value <= next_char;
                               else
                             
                                    -- Convert 4-bit value to an ASCII hex digit
                                    if next_char(3 downto 0) >9 then 
                              
                                    -- ASCII A...F
                                      data_bus_value <= x"4" & (next_char(3 downto 0)-9); 
                                    else 
                                
                                    -- ASCII 0...9
                                      data_bus_value <= x"3" & next_char(3 downto 0);
                                    end if;
                               end if;
                          
                            state <= drop_lcd_e; 
                          
                          
                            -- Loop to send out 16 characters to LCD Display (16 by 2 lines)
                               --if (char_count < 15) AND (next_char /= x"fe") then
                               if (char_count < 15) then
                                   char_count <= char_count +1;                           
                               else
                                   char_count <= "0000";
                               end if;
                               
                               -- Jump to second line?
                               if char_count = 7 then 
                                  next_command <= line2;
                                 
                            -- Return to first line?
                              -- elsif (char_count = 15) or (next_char = x"fe") then
                              elsif (char_count = 15)  then
                                     next_command <= return_home;
                               else
                                     next_command <= print_string; 
                               end if; 
                      
                     
                     
                       -- Return write address to first character position on line 1
                       --=========================================================--
                                              -- Set write address to line 2 character 1
                       --======================================--
                       when line2 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"80";
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                            
                       when return_home =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"c0";
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                    
                    
                       -- lcd_e will match clk_CUSTOM_hz_enable line when instructed to go LOW, however, if the clk_CUSTOM_hz_enable source clock must be a lower count value or it will reset LOW anyhow.
                       -- The next states occur at the end of each command or data transfer to the LCD
                       -- Drop LCD E line - falling edge loads inst/data to LCD controller
                       --============================================================================--
                       when drop_lcd_e =>
                            lcd_e <= '0';
                            state <= hold;
                   
                       -- Hold LCD inst/data valid after falling edge of E line
                       --====================================================--
                       when hold =>
                            state <= next_command;     
    
    end case;




             end if;-- CLOSING STATEMENT FOR "IF clk_400hz_enable = '1' THEN"
             
      end if;-- CLOSING STATEMENT FOR "IF reset = '0' THEN" 
      
end process;                                                            
  
END ARCHITECTURE LCD_DISPLAY_arch;
