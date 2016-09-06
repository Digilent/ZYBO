-------------------------------------------------------------------------------
--                                                                 
--  COPYRIGHT (C) 2014, Digilent RO. All rights reserved
--                                                                  
-------------------------------------------------------------------------------
-- FILE NAME            : i2s_stream.vhd
-- MODULE NAME          : I2S Stream
-- AUTHOR               : Hegbeli Ciprian
-- AUTHOR'S EMAIL       : ciprian.hegbeli@digilent.com
-------------------------------------------------------------------------------
-- REVISION HISTORY
-- VERSION  DATE         AUTHOR            DESCRIPTION
-- 1.0 	   2014-28-03   Hegbeli Ciprian   Created
-------------------------------------------------------------------------------
-- KEYWORDS : Stream
-------------------------------------------------------------------------------
-- DESCRIPTION : This module implements the Stream protocol for sending the
--					  incomming I2S data to the DMA. It implements both the S2MM
--               and the MM2S allowing for a full duplex comunication 
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

------------------------------------------------------------------------
-- Module Declaration
------------------------------------------------------------------------
entity i2s_stream is
	generic (
		-- Stream data width (must be multiple of 8)
		C_AXI_STREAM_DATA_WIDTH    : integer := 32;
		 -- Width of one Slot (24/20/18/16-bit wide)
		C_DATA_WIDTH               : integer := 24
	);
	port (
			
		-- Tx FIFO Flags
		TX_FIFO_FULL_I             : in  std_logic;
		
		-- Rx FIFO Flags
		RX_FIFO_EMPTY_I            : in  std_logic;
		
		-- Tx FIFO Control signals
		TX_FIFO_D_O                : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
		
		-- Rx FIFO Control signals
		RX_FIFO_D_I                : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
		
		NR_OF_SMPL_I               : in  std_logic_vector(20 downto 0);
		
      TX_STREAM_EN_I             : in std_logic;
      RX_STREAM_EN_I             : in std_logic;
		
		-- AXI4-Stream 
		-- Slave
		S_AXIS_MM2S_ACLK_I			: in  std_logic;
		S_AXIS_MM2S_ARESETN			: in  std_logic;
		S_AXIS_MM2S_TREADY_O       : out std_logic;
		S_AXIS_MM2S_TDATA_I        : in  std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		S_AXIS_MM2S_TLAST_I        : in  std_logic;
		S_AXIS_MM2S_TVALID_I       : in  std_logic;
		
		-- Master
		M_AXIS_S2MM_ACLK_I         : in  std_logic;
		M_AXIS_S2MM_ARESETN        : in  std_logic;
		M_AXIS_S2MM_TDATA_O        : out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		M_AXIS_S2MM_TLAST_O        : out std_logic;
		M_AXIS_S2MM_TVALID_O       : out std_logic;
		M_AXIS_S2MM_TREADY_I       : in  std_logic;
		M_AXIS_S2MM_TKEEP_O        : out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0)
	
	);
end i2s_stream;

architecture Behavioral of i2s_stream is

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal nr_of_rd, nr_of_wr       : std_logic_vector (20 downto 0);	
signal tlast                    : std_logic;
signal ready                    : std_logic;

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------
  
begin


------------------------------------------------------------------------ 
-- MM2S protocol imnplementation
------------------------------------------------------------------------	
	S_Control: process (S_AXIS_MM2S_ACLK_I)
	begin
		if (S_AXIS_MM2S_ACLK_I'event and S_AXIS_MM2S_ACLK_I = '0') then
			if (S_AXIS_MM2S_ARESETN = '0') then
				nr_of_rd <= NR_OF_SMPL_I;
			elsif (RX_STREAM_EN_I = '1') then
				if (nr_of_rd > 0) then
					if (S_AXIS_MM2S_TVALID_I = '1' and ready = '1') then
						TX_FIFO_D_O <= S_AXIS_MM2S_TDATA_I(C_DATA_WIDTH-1 downto 0);
						nr_of_rd <= nr_of_rd-1;
					end if;
				end if;
			else
				nr_of_rd <= NR_OF_SMPL_I;
			end if;
		end if;
	end process;
	
	-- ready signal decalaration
	ready <= not TX_FIFO_FULL_I when RX_STREAM_EN_I = '1' else
				'0';
	S_AXIS_MM2S_TREADY_O <= ready;
	
------------------------------------------------------------------------ 
-- S2MM protocol implementation
------------------------------------------------------------------------	
	M_Control: process (M_AXIS_S2MM_ACLK_I)
	begin
		if (M_AXIS_S2MM_ACLK_I'event and M_AXIS_S2MM_ACLK_I = '1') then
			if (M_AXIS_S2MM_ARESETN = '0') THEN				
				tlast <= '0';
				nr_of_wr <= NR_OF_SMPL_I;
			elsif (TX_STREAM_EN_I = '1') then
				if (nr_of_wr > 0) then
					if (M_AXIS_S2MM_TREADY_I = '1' and RX_FIFO_EMPTY_I = '0') then
						nr_of_wr <= nr_of_wr-1;
					end if;
				end if;
				if (nr_of_wr = 0) then
					tlast <= '0';
				end if;
				if (nr_of_wr = 1) then
					tlast <= '1';
				end if;
			else
				tlast <= '0';
				nr_of_wr <= NR_OF_SMPL_I;
			end if;
		end if;		
	end process;
	
	-- S2MM Data signals
	M_AXIS_S2MM_TDATA_O(C_AXI_STREAM_DATA_WIDTH-1 downto C_DATA_WIDTH)   <= (others => '0');
	M_AXIS_S2MM_TDATA_O(C_DATA_WIDTH-1 downto 0)                         <= RX_FIFO_D_I;
	-- S2MM valid signal only active when strea is enabled and not EOL
	M_AXIS_S2MM_TVALID_O  <= not RX_FIFO_EMPTY_I when (nr_of_wr > 0 and TX_STREAM_EN_I = '1') else 
									 '0';
	M_AXIS_S2MM_TLAST_O   <= tlast;
	-- Kepp all incomming samples
	M_AXIS_S2MM_TKEEP_O   <= (others => '1');
	
end Behavioral;

