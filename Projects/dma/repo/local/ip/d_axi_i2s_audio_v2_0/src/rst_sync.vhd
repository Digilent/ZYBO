----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/29/2014 12:36:46 PM
-- Design Name: 
-- Module Name: rst_sync - Behavioral
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

Library UNISIM;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rst_sync is
    Port ( RST_I : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Q_O : out STD_LOGIC);
end rst_sync;

architecture Behavioral of rst_sync is

signal d_int: std_logic;
signal q_int: std_logic;

begin

FDRE_inst_1 : FDPE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q => d_int,      -- Data output
      C => CLK,      -- Clock input
      CE => '1',    -- Clock enable input
      PRE => RST_I,      -- Synchronous reset input
      D => '0'       -- Data input
   );
   
FDRE_inst_2 : FDPE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q => q_int,      -- Data output
      C => CLK,      -- Clock input
      CE => '1',    -- Clock enable input
      PRE => RST_I,      -- Synchronous reset input
      D => d_int       -- Data input
   );

Q_O <= q_int;
end Behavioral;
