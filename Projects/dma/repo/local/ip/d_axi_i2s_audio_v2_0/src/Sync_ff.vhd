-------------------------------------------------------------------------------
--                                                                 
--  COPYRIGHT (C) 2012, Digilent RO. All rights reserved
--                                                                  
-------------------------------------------------------------------------------
-- FILE NAME            : Sync_ff.vhd
-- MODULE NAME          : Synchornisation Flip-Flops
-- AUTHOR               : Hegbeli Ciprian
-- AUTHOR'S EMAIL       : ciprian.hegbeli@digilent.ro
-------------------------------------------------------------------------------
-- REVISION HISTORY
-- VERSION  DATE         AUTHOR         DESCRIPTION
-- 1.0 	   2014-04-02   CiprianH       Created
-------------------------------------------------------------------------------
-- KEYWORDS : Sync
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------------------
-- Module Declaration
------------------------------------------------------------------------
entity Sync_ff is
    Port ( 
		-- Input Clock
      CLK : in  STD_LOGIC;
		-- Asynchorn signal
      D_I : in  STD_LOGIC;
		-- Sync signal
      Q_O : out  STD_LOGIC
	);
end Sync_ff;

architecture Behavioral of Sync_ff is

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal sreg : std_logic_vector(1 downto 0);

attribute ASYNC_REG : string;
attribute ASYNC_REG of sreg : signal is "TRUE";

attribute TIG : string;
attribute TIG of D_I: signal is "TRUE";

begin

------------------------------------------------------------------------
-- Output synchro with second CLK
------------------------------------------------------------------------
sync_b_proc_2: process(CLK)
begin
	if rising_edge(CLK) then
		Q_O <= sreg(1);
		sreg <= sreg(0) & D_I;
	end if;
end process;

end Behavioral;

