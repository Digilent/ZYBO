library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d_axi_i2s_audio_v2_0_AXI_L is
	generic (
		-- Stream width constant
        C_AXI_STREAM_DATA_WIDTH        : integer              := 32;
         -- audio data width constant
        C_DATA_WIDTH                   : integer              := 24;
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
	);
	port (
		
		-- I2S
        BCLK_O                         : out std_logic;
        BCLK_I                         : in  std_logic;
        BCLK_T                         : out std_logic;
        LRCLK_O                        : out std_logic;
        LRCLK_I                        : in  std_logic;
        LRCLK_T                        : out std_logic;
        MCLK_O                         : out std_logic;
        SDATA_I                        : in  std_logic;
        SDATA_O                        : out std_logic;
        CLK_100MHZ_I                   : in  std_logic;
         
        -- AXI4-Stream
        S_AXIS_MM2S_ACLK               : in  std_logic;
        S_AXIS_MM2S_ARESETN            : in  std_logic;
        S_AXIS_MM2S_TREADY             : out std_logic;
        S_AXIS_MM2S_TDATA              : in  std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
        S_AXIS_MM2S_TKEEP              : in  std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
        S_AXIS_MM2S_TLAST              : in  std_logic;
        S_AXIS_MM2S_TVALID             : in  std_logic;
         
        M_AXIS_S2MM_ACLK               : in  std_logic;
        M_AXIS_S2MM_ARESETN            : in  std_logic;
        M_AXIS_S2MM_TVALID             : out std_logic;
        M_AXIS_S2MM_TDATA              : out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
        M_AXIS_S2MM_TKEEP              : out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0);
        M_AXIS_S2MM_TLAST              : out std_logic;
        M_AXIS_S2MM_TREADY             : in  std_logic;
		
		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end d_axi_i2s_audio_v2_0_AXI_L;

architecture arch_imp of d_axi_i2s_audio_v2_0_AXI_L is

-- Them main control component of the I2S protocol
component i2s_rx_tx
   generic(
      C_DATA_WIDTH               : integer := 24);
   port(
      CLK_I                      : in  std_logic;
      RST_I                      : in  std_logic;
	  TX_RS_I                    : in  std_logic;
      RX_RS_I                    : in  std_logic;
      TX_FIFO_RST_I              : in  std_logic;
      TX_FIFO_D_I                : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
      TX_FIFO_WR_EN_I            : in  std_logic;
      RX_FIFO_RST_I              : in  std_logic;
      RX_FIFO_D_O                : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
      RX_FIFO_RD_EN_I            : in  std_logic;
      TX_FIFO_EMPTY_O            : out std_logic;
      TX_FIFO_FULL_O             : out std_logic;
      RX_FIFO_EMPTY_O            : out std_logic;
      RX_FIFO_FULL_O             : out std_logic;
      CLK_100MHZ_I               : in  std_logic;
      CTL_MASTER_MODE_I          : in  std_logic;
      
      -- DBG
      DBG_TX_FIFO_RST_I          : out std_logic;
      DBG_TX_FIFO_RD_EN_I        : out std_logic;
      DBG_TX_FIFO_WR_EN_I        : out std_logic;
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
      
	  SAMPLING_RATE_I            : in  std_logic_vector(3 downto 0);
      BCLK_O                     : out std_logic;
	  BCLK_I                     : in  std_logic;
	  BCLK_T                     : out std_logic;
	  LRCLK_O                    : out std_logic;
	  LRCLK_I                    : in  std_logic;
	  LRCLK_T                    : out std_logic;
      MCLK_O                     : out std_logic;
      SDATA_I                    : in  std_logic;
      SDATA_O                    : out std_logic);
 end component;
 
 -- the stream module which controls the reciving and transmiting of data
 -- on the AXI stream
 component i2s_stream
	generic(
		C_AXI_STREAM_DATA_WIDTH    : integer := 32;
		C_DATA_WIDTH               : integer := 24

	);
	port(
		TX_FIFO_FULL_I      	   : in  std_logic;
		RX_FIFO_EMPTY_I            : in  std_logic;
		TX_FIFO_D_O                : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
		RX_FIFO_D_I                : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
		NR_OF_SMPL_I               : in  std_logic_vector(20 downto 0);
        TX_STREAM_EN_I             : in std_logic;
        RX_STREAM_EN_I             : in std_logic;
		S_AXIS_MM2S_ACLK_I		   : in  std_logic;
	    S_AXIS_MM2S_ARESETN        : in  std_logic;
		S_AXIS_MM2S_TREADY_O       : out std_logic;
		S_AXIS_MM2S_TDATA_I        : in  std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		S_AXIS_MM2S_TLAST_I        : in  std_logic;
		S_AXIS_MM2S_TVALID_I       : in  std_logic;
		M_AXIS_S2MM_ACLK_I         : in  std_logic;
	    M_AXIS_S2MM_ARESETN        : in  std_logic;
		M_AXIS_S2MM_TDATA_O        : out std_logic_vector(C_AXI_STREAM_DATA_WIDTH-1 downto 0);
		M_AXIS_S2MM_TLAST_O        : out std_logic;
		M_AXIS_S2MM_TVALID_O       : out std_logic;		
		M_AXIS_S2MM_TREADY_I       : in  std_logic;
		M_AXIS_S2MM_TKEEP_O        : out std_logic_vector((C_AXI_STREAM_DATA_WIDTH/8)-1 downto 0)
	);
	end component;
	
	-- Main AXI stream CLK divider (by 4) for generating the TX_FIFO_WR_EN_I signal
	component Div_by_4
	port(
		CE_I                       : in  STD_LOGIC;
		CLK_I                      : in  STD_LOGIC;
        DIV_O                      : out  STD_LOGIC
	);
	end component;
	
	------------------------------------------
      -- Signals for user logic slave model s/w accessible register example
      ------------------------------------------
      
      -- I2S control signals
      signal I2S_RST_I                 : std_logic;
      signal TX_RS_I                   : std_logic;
      signal RX_RS_I                   : std_logic;  
      
      -- TX_FIFO siganals
      signal TX_FIFO_RST_I             : std_logic;
      signal TX_FIFO_WR_EN_I           : std_logic;
      signal TX_FIFO_D_I               : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      signal TX_FIFO_D_O               : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      signal TX_FIFO_EMPTY_O           : std_logic;
      signal TX_FIFO_FULL_O            : std_logic;
      
      -- RX_FIFO siganals
      signal RX_FIFO_RST_I             : std_logic;
      signal RX_FIFO_RD_EN_I           : std_logic;
      signal RX_FIFO_D_O               : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      signal RX_FIFO_EMPTY_O           : std_logic;
      signal RX_FIFO_FULL_O            : std_logic;
      
      -- Clock control signals (BCLK/LRCLK)
      signal CTL_MASTER_MODE_I         : std_logic;
      signal SAMPLING_RATE_I           : std_logic_vector(3 downto 0);
      
      --Stream specific signals
      signal NR_OF_SMPL_I              : std_logic_vector(20 downto 0);
      signal DIV_CE                    : std_logic;
      signal TX_FIFO_WR_EN_STREAM_O    : std_logic;
      signal TX_STREAM_EN_I            : std_logic;
      signal RX_STREAM_EN_I            : std_logic;
      
      
      signal RxFifoRdEn                : std_logic;
      signal RxFifoRdEn_dly            : std_logic;
      signal TxFifoWrEn                : std_logic;
      signal TxFifoWrEn_dly            : std_logic;
      signal M_AXIS_S2MM_TVALID_int    : std_logic;
      
       -- DBG
      signal DBG_TX_FIFO_RST_I          : std_logic;
      signal DBG_TX_FIFO_RD_EN_I        : std_logic;
      signal DBG_TX_FIFO_WR_EN_I        : std_logic;
      signal DBG_TX_FIFO_EMPTY_O        : std_logic;
      signal DBG_TX_FIFO_FULL_O         : std_logic;
      signal DBG_TX_FIFO_D_O            : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      signal DBG_TX_FIFO_D_I            : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      
      signal DBG_RX_FIFO_RST_I          : std_logic;                                      
      signal DBG_RX_FIFO_WR_EN_I        : std_logic;                                
      signal DBG_RX_FIFO_RD_EN_I        : std_logic;                                
      signal DBG_RX_FIFO_FULL_O         : std_logic;                                
      signal DBG_RX_FIFO_EMPTY_O        : std_logic;                                
      signal DBG_RX_FIFO_D_O            : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      signal DBG_RX_FIFO_D_I            : std_logic_vector(C_DATA_WIDTH-1 downto 0);
      
      signal DBG_TX_RS_I                : std_logic;
      signal DBG_RX_RS_I                : std_logic;
      
	-- AXI4LITE signals
	  signal axi_awaddr	               : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	  signal axi_awready	           : std_logic;
	  signal axi_wready	               : std_logic;
	  signal axi_bresp	               : std_logic_vector(1 downto 0);
	  signal axi_bvalid                : std_logic;
	  signal axi_araddr	               : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	  signal axi_arready	           : std_logic;
	  signal axi_rdata	               : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal axi_rresp	               : std_logic_vector(1 downto 0);
	  signal axi_rvalid	               : std_logic;

	  -- Example-specific design signals
	  -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	  -- ADDR_LSB is used for addressing 32/64 bit registers/memories
	  -- ADDR_LSB = 2 for 32 bits (n downto 2)
	  -- ADDR_LSB = 3 for 64 bits (n downto 3)
	  constant ADDR_LSB                : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	  constant OPT_MEM_ADDR_BITS       : integer := 3; 
  	  ------------------------------------------------
	  ---- Signals for user logic register space example
	  --------------------------------------------------
	  ---- Number of Slave Registers 10
	  signal I2S_RESET_REG	            :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_TRANSFER_CONTROL_REG	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_FIFO_CONTROL_REG	    :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_DATA_IN_REG	        :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_DATA_OUT_REG	        :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_STATUS_REG	            :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_CLOCK_CONTROL_REG     	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_PERIOD_COUNT_REG	    :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal I2S_STREAM_CONTROL_REG	    :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal slv_reg9	                :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal slv_reg_rden	            : std_logic;
	  signal slv_reg_wren	            : std_logic;
	  signal reg_data_out	            :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	  signal byte_index	                : integer;
	  
	  attribute KEEP : string; 
	  
      attribute KEEP of DBG_TX_FIFO_RST_I     : signal is "TRUE";
      attribute KEEP of DBG_TX_FIFO_WR_EN_I   : signal is "TRUE";
      attribute KEEP of DBG_TX_FIFO_RD_EN_I   : signal is "TRUE";
      attribute KEEP of DBG_TX_FIFO_EMPTY_O    : signal is "TRUE";
      attribute KEEP of DBG_TX_FIFO_FULL_O    : signal is "TRUE";
      attribute KEEP of DBG_TX_FIFO_D_I       : signal is "TRUE";
      attribute KEEP of DBG_TX_FIFO_D_O       : signal is "TRUE";
      
      attribute KEEP of DBG_RX_FIFO_RST_I     : signal is "TRUE";
      attribute KEEP of DBG_RX_FIFO_WR_EN_I   : signal is "TRUE";
      attribute KEEP of DBG_RX_FIFO_RD_EN_I   : signal is "TRUE";
      attribute KEEP of DBG_RX_FIFO_FULL_O   : signal is "TRUE";
      attribute KEEP of DBG_RX_FIFO_EMPTY_O   : signal is "TRUE";
      attribute KEEP of DBG_RX_FIFO_D_I       : signal is "TRUE";
      attribute KEEP of DBG_RX_FIFO_D_O       : signal is "TRUE";
      
      attribute KEEP of DBG_TX_RS_I           : signal is "TRUE";
      attribute KEEP of DBG_RX_RS_I           : signal is "TRUE";

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	
	I2S_RST_I              <= I2S_RESET_REG(0);
    TX_RS_I                <= I2S_TRANSFER_CONTROL_REG(0);
    RX_RS_I                <= I2S_TRANSFER_CONTROL_REG(1);
    TX_FIFO_WR_EN_I        <= not TX_FIFO_FULL_O when (RX_STREAM_EN_I = '1' and S_AXIS_MM2S_TVALID = '1') else
                                       TxFifoWrEn         when (RX_STREAM_EN_I = '0') else
                                       '0';
    RX_FIFO_RD_EN_I        <= not RX_FIFO_EMPTY_O when (TX_STREAM_EN_I = '1' and M_AXIS_S2MM_TREADY = '1' and M_AXIS_S2MM_TVALID_int = '1') else 
                              RxFifoRdEn          when (TX_STREAM_EN_I = '0') else
                                       '0';
    TX_FIFO_RST_I          <= (not S_AXIS_MM2S_ARESETN) or I2S_FIFO_CONTROL_REG(30);
    RX_FIFO_RST_I          <= (not M_AXIS_S2MM_ARESETN) or I2S_FIFO_CONTROL_REG(31);
    TX_FIFO_D_I            <= TX_FIFO_D_O when RX_STREAM_EN_I = '1' else 
                              I2S_DATA_IN_REG(C_DATA_WIDTH-1 downto 0);
    SAMPLING_RATE_I        <= I2S_CLOCK_CONTROL_REG(3 downto 0);
    CTL_MASTER_MODE_I      <= I2S_CLOCK_CONTROL_REG(16);
    NR_OF_SMPL_I           <= I2S_PERIOD_COUNT_REG(20 downto 0);
    TX_STREAM_EN_I         <= I2S_STREAM_CONTROL_REG(0);
    RX_STREAM_EN_I         <= I2S_STREAM_CONTROL_REG(1);
    DIV_CE                 <= RX_STREAM_EN_I and (S_AXIS_MM2S_TVALID and not TX_FIFO_FULL_O);
    
--    DBG_RX_FIFO_D_O <= I2S_DATA_OUT_REG(C_DATA_WIDTH-1 downto 0);
         
    M_AXIS_S2MM_TVALID     <= M_AXIS_S2MM_TVALID_int;
    
    RDWR_PULSE: process(S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then
        RxFifoRdEn_dly <= I2S_FIFO_CONTROL_REG(1);
        TxFifoWrEn_dly <= I2S_FIFO_CONTROL_REG(0);
      end if;
    end process RDWR_PULSE;
        
    RxFifoRdEn <= I2S_FIFO_CONTROL_REG(1) and not RxFifoRdEn_dly;
    TxFifoWrEn <= I2S_FIFO_CONTROL_REG(0) and not TxFifoWrEn_dly;
    
     ------------------------------------------------------------------------
     -- Instantiaton of the I2S controler
     ------------------------------------------------------------------------
     Inst_I2sCtl: i2s_rx_tx
     generic map(
        C_DATA_WIDTH               => C_DATA_WIDTH)
     port map(
        CLK_I                      => S_AXI_ACLK,
        RST_I                      => I2S_RST_I,
        TX_RS_I                    => TX_RS_I,
        RX_RS_I                    => RX_RS_I,
        TX_FIFO_RST_I              => TX_FIFO_RST_I,
        TX_FIFO_D_I                => TX_FIFO_D_I,
        TX_FIFO_WR_EN_I            => TX_FIFO_WR_EN_I,
        RX_FIFO_RST_I              => RX_FIFO_RST_I,
        RX_FIFO_D_O                => RX_FIFO_D_O,
        RX_FIFO_RD_EN_I            => RX_FIFO_RD_EN_I,
        TX_FIFO_EMPTY_O            => TX_FIFO_EMPTY_O,
        TX_FIFO_FULL_O             => TX_FIFO_FULL_O,
        RX_FIFO_EMPTY_O            => RX_FIFO_EMPTY_O,
        RX_FIFO_FULL_O             => RX_FIFO_FULL_O,
        CLK_100MHZ_I               => CLK_100MHZ_I,
        CTL_MASTER_MODE_I          => CTL_MASTER_MODE_I,
        
        -- DBG
        DBG_TX_FIFO_RST_I          => DBG_TX_FIFO_RST_I,
        DBG_TX_FIFO_RD_EN_I        => DBG_TX_FIFO_RD_EN_I,
        DBG_TX_FIFO_WR_EN_I        => DBG_TX_FIFO_WR_EN_I,
        DBG_TX_FIFO_EMPTY_O        => DBG_TX_FIFO_EMPTY_O,
        DBG_TX_FIFO_FULL_O         => DBG_TX_FIFO_FULL_O,
        DBG_TX_FIFO_D_O            => DBG_TX_FIFO_D_O,
        DBG_TX_FIFO_D_I            => DBG_TX_FIFO_D_I,
        DBG_TX_RS_I                => DBG_TX_RS_I,
        
        DBG_RX_FIFO_RST_I          => DBG_RX_FIFO_RST_I,
        DBG_RX_FIFO_WR_EN_I        => DBG_RX_FIFO_WR_EN_I,
        DBG_RX_FIFO_RD_EN_I        => DBG_RX_FIFO_RD_EN_I,
        DBG_RX_FIFO_FULL_O         => DBG_RX_FIFO_FULL_O,
        DBG_RX_FIFO_EMPTY_O        => DBG_RX_FIFO_EMPTY_O,
        DBG_RX_FIFO_D_I            => DBG_RX_FIFO_D_I,
        DBG_RX_FIFO_D_O            => DBG_RX_FIFO_D_O,
        DBG_RX_RS_I                => DBG_RX_RS_I,
        
        SAMPLING_RATE_I            => SAMPLING_RATE_I,
        BCLK_O                     => BCLK_O,
        BCLK_I                     => BCLK_I,
        BCLK_T                     => BCLK_T,
        LRCLK_O                    => LRCLK_O,
        LRCLK_I                    => LRCLK_I,
        LRCLK_T                    => LRCLK_T,
        MCLK_O                     => MCLK_O,
        SDATA_I                    => SDATA_I,
        SDATA_O                    => SDATA_O);
        
      
        ------------------------------------------------------------------------
        -- Instantiaton of the AXI stream controler
        ------------------------------------------------------------------------  
        Inst_I2sStream: i2s_stream
        generic map(
            C_AXI_STREAM_DATA_WIDTH    => C_AXI_STREAM_DATA_WIDTH,
            C_DATA_WIDTH               => C_DATA_WIDTH
        )
        port map(
            TX_FIFO_FULL_I             => TX_FIFO_FULL_O,
            RX_FIFO_EMPTY_I            => RX_FIFO_EMPTY_O,
            TX_FIFO_D_O                => TX_FIFO_D_O,
            RX_FIFO_D_I                => RX_FIFO_D_O,
            NR_OF_SMPL_I               => NR_OF_SMPL_I,
            TX_STREAM_EN_I             => TX_STREAM_EN_I,
            RX_STREAM_EN_I             => RX_STREAM_EN_I,
            S_AXIS_MM2S_ACLK_I         => S_AXIS_MM2S_ACLK,
            S_AXIS_MM2S_ARESETN        => S_AXIS_MM2S_ARESETN,
            S_AXIS_MM2S_TREADY_O       => S_AXIS_MM2S_TREADY,
            S_AXIS_MM2S_TDATA_I        => S_AXIS_MM2S_TDATA,
            S_AXIS_MM2S_TLAST_I        => S_AXIS_MM2S_TLAST,
            S_AXIS_MM2S_TVALID_I       => S_AXIS_MM2S_TVALID,
            M_AXIS_S2MM_ACLK_I         => M_AXIS_S2MM_ACLK,
            M_AXIS_S2MM_ARESETN        => M_AXIS_S2MM_ARESETN,
            M_AXIS_S2MM_TDATA_O        => M_AXIS_S2MM_TDATA,
            M_AXIS_S2MM_TLAST_O        => M_AXIS_S2MM_TLAST,
            M_AXIS_S2MM_TREADY_I       => M_AXIS_S2MM_TREADY,
            M_AXIS_S2MM_TKEEP_O        => M_AXIS_S2MM_TKEEP,
            M_AXIS_S2MM_TVALID_O       => M_AXIS_S2MM_TVALID_int  
        );
    
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      I2S_RESET_REG <= (others => '0');
	      I2S_TRANSFER_CONTROL_REG <= (others => '0');
	      I2S_FIFO_CONTROL_REG <= (others => '0');
	      I2S_DATA_IN_REG <= (others => '0');
	      I2S_DATA_OUT_REG <= (others => '0');
	      I2S_STATUS_REG <= (others => '0');
	      I2S_CLOCK_CONTROL_REG <= (others => '0');
	      I2S_PERIOD_COUNT_REG <= (others => '0');
	      I2S_STREAM_CONTROL_REG <= (others => '0');
	      slv_reg9 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"0000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                I2S_RESET_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 1
	                I2S_TRANSFER_CONTROL_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 2
	                I2S_FIFO_CONTROL_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                I2S_DATA_IN_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                I2S_CLOCK_CONTROL_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                I2S_PERIOD_COUNT_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                I2S_STREAM_CONTROL_REG(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 9
	                slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            I2S_DATA_OUT_REG(31 downto 31-C_DATA_WIDTH) <= (others => '0');
                I2S_DATA_OUT_REG(C_DATA_WIDTH-1 downto 0) <= RX_FIFO_D_O;
                I2S_STATUS_REG(0) <= TX_FIFO_EMPTY_O;
                I2S_STATUS_REG(1) <= TX_FIFO_FULL_O;
                I2S_STATUS_REG(15 downto 2) <= (others => '0');
                I2S_STATUS_REG(16) <= RX_FIFO_EMPTY_O;
                I2S_STATUS_REG(17) <= RX_FIFO_FULL_O;
                I2S_STATUS_REG(31 downto 18) <= (others => '0');
	        end case;
	      end if;
	      I2S_DATA_OUT_REG(31 downto 31-C_DATA_WIDTH) <= (others => '0');
          I2S_DATA_OUT_REG(C_DATA_WIDTH-1 downto 0) <= RX_FIFO_D_O;
          I2S_STATUS_REG(0) <= TX_FIFO_EMPTY_O;
          I2S_STATUS_REG(1) <= TX_FIFO_FULL_O;
          I2S_STATUS_REG(15 downto 2) <= (others => '0');
          I2S_STATUS_REG(16) <= RX_FIFO_EMPTY_O;
          I2S_STATUS_REG(17) <= RX_FIFO_FULL_O;
          I2S_STATUS_REG(31 downto 18) <= (others => '0');
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (I2S_RESET_REG, I2S_TRANSFER_CONTROL_REG, I2S_FIFO_CONTROL_REG, I2S_DATA_IN_REG, I2S_DATA_OUT_REG, I2S_CLOCK_CONTROL_REG, I2S_STATUS_REG, I2S_PERIOD_COUNT_REG, I2S_STREAM_CONTROL_REG, slv_reg9, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	  if S_AXI_ARESETN = '0' then
	    reg_data_out  <= (others => '1');
	  else
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"0000" =>
	        reg_data_out <= I2S_RESET_REG;
	      when b"0001" =>
	        reg_data_out <= I2S_TRANSFER_CONTROL_REG;
	      when b"0010" =>
	        reg_data_out <= I2S_FIFO_CONTROL_REG;
	      when b"0011" =>
	        reg_data_out <= I2S_DATA_IN_REG;
	      when b"0100" =>
	        reg_data_out <= I2S_DATA_OUT_REG;
	      when b"0101" =>
	        reg_data_out <= I2S_STATUS_REG;
	      when b"0110" =>
	        reg_data_out <= I2S_CLOCK_CONTROL_REG;
	      when b"0111" =>
	        reg_data_out <= I2S_PERIOD_COUNT_REG;
	      when b"1000" =>
	        reg_data_out <= I2S_STREAM_CONTROL_REG;
	      when b"1001" =>
	        reg_data_out <= slv_reg9;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	  end if;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here

	-- User logic ends

end arch_imp;
