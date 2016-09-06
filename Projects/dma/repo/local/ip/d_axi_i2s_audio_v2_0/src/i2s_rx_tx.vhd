-------------------------------------------------------------------------------
--                                                                 
--  COPYRIGHT (C) 2012, Digilent RO. All rights reserved
--                                                                  
-------------------------------------------------------------------------------
-- FILE NAME            : i2s_rx_tx.vhd
-- MODULE NAME          : I2S Tranceiver
-- AUTHOR               : Mihaita Nagy
-- AUTHOR'S EMAIL       : mihaita.nagy@digilent.ro
-------------------------------------------------------------------------------
-- REVISION HISTORY
-- VERSION  DATE         AUTHOR         DESCRIPTION
-- 1.0 	   2012-25-01   MihaitaN       Created
-- 2.0 	   ?            MihaitaN       ?
-- 3.0 	   2014-12-02   HegbeliC       Integration of the MCLK and Master Mode
-------------------------------------------------------------------------------
-- KEYWORDS : I2S
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VComponents.all;

------------------------------------------------------------------------
-- Module Declaration
------------------------------------------------------------------------
entity i2s_rx_tx is
   generic (      
      -- Width of left/right channel data buses
      C_DATA_WIDTH               : integer := 24
   );
   port (
      -- Global signals
      CLK_I                      : in  std_logic;
      RST_I                      : in  std_logic;
      
      -- Control signals
      TX_RS_I                    : in  std_logic;
      RX_RS_I                    : in  std_logic;
		
		-- CLK input for MCLK rendering
      CLK_100MHZ_I               : in  std_logic;
		
		-- Control signal for setting the sampeling rate
      SAMPLING_RATE_I            : in  std_logic_vector (3 downto 0);
      
		-- Flag for when the Controller is in master mode
	  CTL_MASTER_MODE_I          : in  std_logic;
		
		-- DBG
      DBG_TX_FIFO_RST_I          : out std_logic;
      DBG_TX_FIFO_WR_EN_I        : out std_logic;
      DBG_TX_FIFO_RD_EN_I        : out std_logic;
      DBG_TX_FIFO_EMPTY_O        : out std_logic;
      DBG_TX_FIFO_FULL_O         : out std_logic;
      DBG_TX_FIFO_D_I            : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      DBG_TX_FIFO_D_O            : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      DBG_TX_RS_I                : out std_logic;
      
      DBG_RX_FIFO_RST_I          : out std_logic;                                      
      DBG_RX_FIFO_WR_EN_I        : out std_logic;                                 
      DBG_RX_FIFO_RD_EN_I        : out std_logic;                                 
      DBG_RX_FIFO_FULL_O         : out std_logic;                                
      DBG_RX_FIFO_EMPTY_O        : out std_logic;                                
      DBG_RX_FIFO_D_O            : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      DBG_RX_FIFO_D_I            : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      DBG_RX_RS_I                : out std_logic;
		
      -- Tx FIFO Control signals
      TX_FIFO_RST_I              : in  std_logic;
      TX_FIFO_D_I                : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
      TX_FIFO_WR_EN_I            : in  std_logic;
      
      -- Rx FIFO Control signals
      RX_FIFO_RST_I              : in  std_logic;
      RX_FIFO_RD_EN_I            : in  std_logic;
	  RX_FIFO_D_O                : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      
      -- Tx FIFO Flags
      TX_FIFO_EMPTY_O            : out std_logic;
      TX_FIFO_FULL_O             : out std_logic;
      
      -- Rx FIFO Flags
      RX_FIFO_EMPTY_O            : out std_logic;
      RX_FIFO_FULL_O             : out std_logic;
		
      -- I2S interface signals
      BCLK_O                     : out std_logic;
      BCLK_I                     : in  std_logic;
      BCLK_T                     : out std_logic;
      LRCLK_O                    : out std_logic;
      LRCLK_I                    : in  std_logic;
      LRCLK_T                    : out std_logic;
      MCLK_O                     : out std_logic;
      SDATA_I                    : in  std_logic;
      SDATA_O                    : out std_logic
   );
end i2s_rx_tx;

architecture Behavioral of i2s_rx_tx is

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal StartTransaction    : std_logic;
signal StopTransaction     : std_logic;
signal RxEn                : std_logic;
signal TxEn                : std_logic;
signal LRCLK_Int           : std_logic;
signal LR			       : std_logic;
signal Rnw                 : std_logic;
signal RxFifoDataIn        : std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal RxFifoDataInL       : std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal RxFifoDataInR       : std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal RxFifoWrEn          : std_logic;
signal RxFifoWrEnL         : std_logic;
signal RxFifoWrEnR         : std_logic;
signal TxFifoDataOut       : std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal TxFifoRdEn          : std_logic;
signal TxFifoRdEnL         : std_logic;
signal TxFifoRdEnR         : std_logic;
signal TxFifoEmpty         : std_logic;
signal RxFifoFull	       : std_logic;
signal SamplingFrequncy    : std_logic_vector(3 downto 0);
signal Rst_Int             : std_logic;
signal Rst_Int_sync        : std_logic;
signal MM_Int              : std_logic;
signal Rst_interior	       : std_logic;
-- DCM signals
signal RstDcm              : std_logic;
signal LockDcm             : std_logic;
signal CLK_12              : std_logic;

signal TxFifoReset	       : std_logic;
signal RxFifoReset	       : std_logic;

signal TX_FIFO_FULL_int    : std_logic;
signal RX_FIFO_EMPTY_int   : std_logic;
signal RX_FIFO_D_int       : std_logic_vector(C_DATA_WIDTH-1 downto 0);

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
component i2s_ctl
   generic (
      C_DATA_WIDTH: integer := 24);
   port (
      CLK_I       : in  std_logic;
      RST_I       : in  std_logic;
      EN_TX_I     : in  std_logic;
      EN_RX_I     : in  std_logic;
      OE_L_O      : out std_logic;
      OE_R_O      : out std_logic;
      WE_L_O      : out std_logic;
      WE_R_O      : out std_logic;
      D_L_I       : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
      D_R_I       : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
      D_L_O       : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      D_R_O       : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
	  MM_I        : in  std_logic;
	  FS_I	      : in  std_logic_vector(3 downto 0);
      BCLK_O      : out std_logic;
	  BCLK_I      : in  std_logic;
	  BCLK_T      : out std_logic;
	  LRCLK_O     : out std_logic;
	  LRCLK_I     : in  std_logic;
	  LRCLK_T     : out std_logic;
      SDATA_O     : out std_logic;
      SDATA_I     : in  std_logic);
end component;

-- the FIFO used for sample rate bus

component fifo_4
  port (
    rst           : in  std_logic;
    wr_clk        : in  std_logic;
    rd_clk        : in  std_logic;
    din           : in std_logic_vector(3 downto 0);
    wr_en         : in  std_logic;
    rd_en         : in  std_logic;
    dout          : out std_logic_vector(3 downto 0);
    full          : out std_logic;
    empty         : out std_logic
  );
end component;

-- the FIFO, used for Rx and Tx
component fifo_32
   port (
      wr_clk      : in  std_logic;
      rd_clk      : in  std_logic;
      rst         : in  std_logic;
      din         : in  std_logic_vector(23 downto 0);
      wr_en       : in  std_logic;
      rd_en       : in  std_logic;
      dout        : out std_logic_vector(23 downto 0);
      full        : out std_logic;
      empty       : out std_logic);
end component;

-- the DCM for generating 12.288 MHz
component DCM
	port(
		CLK_100		: in  std_logic;
		CLK_12_288	: out std_logic;
		RESET		: in  std_logic;
		LOCKED		: out std_logic
 );
end component;

-- the synchronisation unite for the two CLK domains
component Sync_ff
	port(
        CLK         : in  std_logic;
		D_I			: in  std_logic;
		Q_O			: out std_logic
	);
end component;

component rst_sync 
    Port ( 
           RST_I    : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           Q_O      : out STD_LOGIC
    );
end component;

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin

------------------------------------------------------------------------
-- Instantiate the I2S transmitter module
------------------------------------------------------------------------
   Inst_I2sRxTx: i2s_ctl
   generic map(
      C_DATA_WIDTH   => C_DATA_WIDTH)
   port map(
      CLK_I          => CLK_12,
      RST_I          => Rst_Int_sync,
      EN_TX_I        => TxEn,
      EN_RX_I        => RxEn,
      OE_L_O         => TxFifoRdEnL,
      OE_R_O         => TxFifoRdEnR,
      WE_L_O         => RxFifoWrEnL,
      WE_R_O         => RxFifoWrEnR,
      D_L_I          => TxFifoDataOut,
      D_R_I          => TxFifoDataOut,
      D_L_O          => RxFifoDataInL,
      D_R_O          => RxFifoDataInR,
	  MM_I			 => MM_Int,
	  FS_I			 => SamplingFrequncy,
      BCLK_O         => BCLK_O,
      BCLK_I         => BCLK_I,
      BCLK_T         => BCLK_T,
      LRCLK_O        => LRCLK_Int,
      LRCLK_I        => LRCLK_I,
      LRCLK_T        => LRCLK_T,
      SDATA_O        => SDATA_O,
      SDATA_I        => SDATA_I);
   
   TxFifoRdEn <= TxFifoRdEnL or TxFifoRdEnR;
   RxFifoWrEn <= RxFifoWrEnL or RxFifoWrEnR;
   LRCLK_O <= LRCLK_Int;
	
------------------------------------------------------------------------
-- Instantiate the transmitter fifo
------------------------------------------------------------------------
   Inst_Sampling: fifo_4
   port map (
      rst       => RST_I,
      wr_clk    => CLK_I,
      rd_clk    => CLK_12,
      din       => SAMPLING_RATE_I,
      wr_en     => '1',
      rd_en     => '1',
      dout      => SamplingFrequncy,
      full      => open,
      empty     => open);
   
------------------------------------------------------------------------
-- Instantiate the transmitter fifo
------------------------------------------------------------------------
   Inst_I2sTxFifo: fifo_32
   port map(
      wr_clk    => CLK_I,
      rd_clk    => CLK_12,
      rst   	=> TxFifoReset,
      din   	=> TX_FIFO_D_I,
      wr_en 	=> TX_FIFO_WR_EN_I,
      rd_en 	=> TxFifoRdEn,
      dout  	=> TxFifoDataOut,
      full  	=> TX_FIFO_FULL_int,
      empty 	=> TxFifoEmpty); 
      
      DBG_TX_FIFO_RST_I <= TxFifoReset;
      DBG_TX_FIFO_RD_EN_I <= TxFifoRdEn;
      DBG_TX_FIFO_WR_EN_I <= TX_FIFO_WR_EN_I;
      DBG_TX_FIFO_FULL_O <= TX_FIFO_FULL_int;
      DBG_TX_FIFO_EMPTY_O <= TxFifoEmpty;
      DBG_TX_FIFO_D_I <= TX_FIFO_D_I;
      DBG_TX_FIFO_D_O <= TxFifoDataOut;
      DBG_TX_RS_I <= TxEn; 
      
--      TX_FIFO_EMPTY_O <= TxFifoEmpty;
      TX_FIFO_FULL_O <= TX_FIFO_FULL_int;
		
------------------------------------------------------------------------
-- Instantiate the receiver fifo
------------------------------------------------------------------------
   Inst_I2sRxFifo: fifo_32
   port map(
      wr_clk   => CLK_12,
      rd_clk   => CLK_I,
      rst   	=> RX_FIFO_RST_I,
      din   	=> RxFifoDataIn,
      wr_en 	=> RxFifoWrEn,
      rd_en 	=> RX_FIFO_RD_EN_I,
      dout  	=> RX_FIFO_D_int,
      full  	=> RxFifoFull,
      empty 	=> RX_FIFO_EMPTY_int);
      
      DBG_RX_FIFO_RST_I <= RX_FIFO_RST_I;
      DBG_RX_FIFO_WR_EN_I <= RxFifoWrEn;
      DBG_RX_FIFO_RD_EN_I <= RX_FIFO_RD_EN_I;
      DBG_RX_FIFO_EMPTY_O <=RX_FIFO_EMPTY_int;
      DBG_RX_FIFO_D_O <= RX_FIFO_D_int;
      DBG_RX_FIFO_D_I <= RxFifoDataIn;
      DBG_RX_RS_I <= RxEn;


      RX_FIFO_EMPTY_O <= RX_FIFO_EMPTY_int;
--      RX_FIFO_FULL_O <= RxFifoFull;
      RX_FIFO_D_O <= RX_FIFO_D_int;
		
	--	input selct between audio controler in master or in slave
	LR <= LRCLK_Int when MM_Int = '0' else LRCLK_I;	
   RxFifoDataIn <= RxFifoDataInR when LR = '1' else RxFifoDataInL;
	

------------------------------------------------------------------------
-- Instantiate DCM
------------------------------------------------------------------------
	Inst_Dcm : DCM
	port map(
		CLK_100		=> CLK_100MHZ_I,
		CLK_12_288	=> CLK_12,
		RESET			=> Rst_Int,
		LOCKED		=> LockDcm);
	
	Rst_Int <= RST_I and not LockDcm;

------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_SyncBit_RX_RS: Sync_ff	
	port map(
	  CLK    		=> CLK_12,
      D_I 			=> RX_RS_I,
      Q_O 			=> RxEn); 		
		
------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_SyncBit_TX_RS: Sync_ff	
	port map(
      CLK           => CLK_12,
      D_I 			=> TX_RS_I,
      Q_O 			=> TxEn);
      		
------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_SyncBit_CTL_MM: Sync_ff	
	port map(
      CLK           => CLK_12,
      D_I 			=> CTL_MASTER_MODE_I,
      Q_O 			=> MM_Int); 
 
------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_Rst_Sync_TX_RST: rst_sync	
	port map(
      CLK           => CLK_12,
      RST_I			=> TX_FIFO_RST_I,
      Q_O 			=> TxFifoReset);  
 
------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_Rst_Sync_RST: rst_sync	
	port map(
      CLK           => CLK_12,
      RST_I			=> Rst_Int,
      Q_O 			=> Rst_Int_sync); 
 
------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_SyncBit_Tx_Empty: Sync_ff	
	port map(
      CLK           => CLK_I,
      D_I 			=> TxFifoEmpty,
      Q_O 			=> TX_FIFO_EMPTY_O); 
 
------------------------------------------------------------------------
-- Instantiate BusSync for the sample rate read out (100 -> 12)
------------------------------------------------------------------------		
	Inst_SyncBit_Rx_Full: Sync_ff	
	port map(
      CLK           => CLK_I,
      D_I 			=> RxFifoFull,
      Q_O 			=> RX_FIFO_FULL_O); 
 
------------------------------------------------------------------------
-- Instantiaton of the ODDR for the Output MCLK
------------------------------------------------------------------------
   ODDR_inst : ODDR
   generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",	 -- "OPPOSITE_EDGE" or "SAME_EDGE" 
      INIT => '0',  							 -- Initial value for Q port ('1' or '0')
      SRTYPE => "SYNC")						 -- Reset Type ("ASYNC" or "SYNC")
   port map (
      Q => MCLK_O,  							 -- 1-bit DDR output
      C => CLK_12,   						 -- 1-bit clock input
      CE => '1',  							 -- 1-bit clock enable input
      D1 => '1',								 -- 1-bit data input (positive edge)
      D2 => '0', 								 -- 1-bit data input (negative edge)
      R => '0',   							 -- 1-bit reset input
      S => '0');   							 -- 1-bit set input
   
end Behavioral;
