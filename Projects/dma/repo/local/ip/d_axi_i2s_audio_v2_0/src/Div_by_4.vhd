----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:49:17 04/02/2014 
-- Design Name: 
-- Module Name:    Div_by_4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Div_by_4 is
    Port 
	 ( 
	   CE_I       : in  STD_LOGIC;
		CLK_I      : in  STD_LOGIC;
      DIV_O      : out  STD_LOGIC
	 );
end Div_by_4;

architecture Behavioral of Div_by_4 is

signal cnt       : integer range 0 to 2 :=0;
signal clk_div   : STD_LOGIC := '0';

begin

process (CLK_I)
begin
    if (CLK_I'event and CLK_I = '1') then
	   if (CE_I = '1') then
		   cnt <= cnt + 1;
		   if cnt = 2 then
				cnt <= 0;
				clk_div <= not clk_div;
			end if;
		else
		   cnt <= 0;
      end if;	
    end if;
end process;

DIV_O <= clk_div;

end Behavioral;

