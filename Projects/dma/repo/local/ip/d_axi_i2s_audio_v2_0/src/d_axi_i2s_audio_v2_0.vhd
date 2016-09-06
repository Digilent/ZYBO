library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d_axi_i2s_audio_v2_0 is
	generic (
		C_DATA_WIDTH : integer := 24;
         
         -- AXI4-Stream parameter
        C_AXI_STREAM_DATA_WIDTH : integer := 32;
        
		-- Parameters of Axi Slave Bus Interface AXI_L
		C_AXI_L_DATA_WIDTH	: integer	:= 32;
		C_AXI_L_ADDR_WIDTH	: integer	:= 6
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


		-- Ports of Axi Slave Bus Interface AXI_L
		AXI_L_aclk	: in std_logic;
		AXI_L_aresetn	: in std_logic;
		AXI_L_awaddr	: in std_logic_vector(C_AXI_L_ADDR_WIDTH-1 downto 0);
		AXI_L_awprot	: in std_logic_vector(2 downto 0);
		AXI_L_awvalid	: in std_logic;
		AXI_L_awready	: out std_logic;
		AXI_L_wdata	: in std_logic_vector(C_AXI_L_DATA_WIDTH-1 downto 0);
		AXI_L_wstrb	: in std_logic_vector((C_AXI_L_DATA_WIDTH/8)-1 downto 0);
		AXI_L_wvalid	: in std_logic;
		AXI_L_wready	: out std_logic;
		AXI_L_bresp	: out std_logic_vector(1 downto 0);
		AXI_L_bvalid	: out std_logic;
		AXI_L_bready	: in std_logic;
		AXI_L_araddr	: in std_logic_vector(C_AXI_L_ADDR_WIDTH-1 downto 0);
		AXI_L_arprot	: in std_logic_vector(2 downto 0);
		AXI_L_arvalid	: in std_logic;
		AXI_L_arready	: out std_logic;
		AXI_L_rdata	: out std_logic_vector(C_AXI_L_DATA_WIDTH-1 downto 0);
		AXI_L_rresp	: out std_logic_vector(1 downto 0);
		AXI_L_rvalid	: out std_logic;
		AXI_L_rready	: in std_logic
	);
end d_axi_i2s_audio_v2_0;

architecture arch_imp of d_axi_i2s_audio_v2_0 is

	-- component declaration
	component d_axi_i2s_audio_v2_0_AXI_L is
		generic (
		-- Stream width constant
        C_AXI_STREAM_DATA_WIDTH        : integer              := 32;
         -- audio data width constant
        C_DATA_WIDTH                   : integer              := 24;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
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
		
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component d_axi_i2s_audio_v2_0_AXI_L;

begin

-- Instantiation of Axi Bus Interface AXI_L
d_axi_i2s_audio_v2_0_AXI_L_inst : d_axi_i2s_audio_v2_0_AXI_L
	generic map (
	    C_DATA_WIDTH                   => C_DATA_WIDTH,
        C_AXI_STREAM_DATA_WIDTH        => C_AXI_STREAM_DATA_WIDTH,
		C_S_AXI_DATA_WIDTH	           => C_AXI_L_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	           => C_AXI_L_ADDR_WIDTH
	)
	port map (
	    BCLK_O                         => BCLK_O,
        BCLK_I                         => BCLK_I,
        BCLK_T                         => BCLK_T,
        LRCLK_O                        => LRCLK_O,
        LRCLK_I                        => LRCLK_I,
        LRCLK_T                        => LRCLK_T,
        MCLK_O                         => MCLK_O,
        SDATA_I                        => SDATA_I,
        SDATA_O                        => SDATA_O,
        CLK_100MHZ_I                   => CLK_100MHZ_I,
            
        S_AXIS_MM2S_ACLK               => S_AXIS_MM2S_ACLK,
        S_AXIS_MM2S_ARESETN            => S_AXIS_MM2S_ARESETN,
        S_AXIS_MM2S_TREADY             => S_AXIS_MM2S_TREADY,
        S_AXIS_MM2S_TDATA              => S_AXIS_MM2S_TDATA,
        S_AXIS_MM2S_TKEEP              => S_AXIS_MM2S_TKEEP,
        S_AXIS_MM2S_TLAST              => S_AXIS_MM2S_TLAST,
        S_AXIS_MM2S_TVALID             => S_AXIS_MM2S_TVALID,
         
        M_AXIS_S2MM_ACLK               => M_AXIS_S2MM_ACLK,
        M_AXIS_S2MM_ARESETN            => M_AXIS_S2MM_ARESETN,
        M_AXIS_S2MM_TDATA              => M_AXIS_S2MM_TDATA,
        M_AXIS_S2MM_TLAST              => M_AXIS_S2MM_TLAST,
        M_AXIS_S2MM_TREADY             => M_AXIS_S2MM_TREADY,
        M_AXIS_S2MM_TKEEP              => M_AXIS_S2MM_TKEEP,
        M_AXIS_S2MM_TVALID             => M_AXIS_S2MM_TVALID,
	    
		S_AXI_ACLK	=> AXI_L_aclk,
		S_AXI_ARESETN	=> AXI_L_aresetn,
		S_AXI_AWADDR	=> AXI_L_awaddr,
		S_AXI_AWPROT	=> AXI_L_awprot,
		S_AXI_AWVALID	=> AXI_L_awvalid,
		S_AXI_AWREADY	=> AXI_L_awready,
		S_AXI_WDATA	=> AXI_L_wdata,
		S_AXI_WSTRB	=> AXI_L_wstrb,
		S_AXI_WVALID	=> AXI_L_wvalid,
		S_AXI_WREADY	=> AXI_L_wready,
		S_AXI_BRESP	=> AXI_L_bresp,
		S_AXI_BVALID	=> AXI_L_bvalid,
		S_AXI_BREADY	=> AXI_L_bready,
		S_AXI_ARADDR	=> AXI_L_araddr,
		S_AXI_ARPROT	=> AXI_L_arprot,
		S_AXI_ARVALID	=> AXI_L_arvalid,
		S_AXI_ARREADY	=> AXI_L_arready,
		S_AXI_RDATA	=> AXI_L_rdata,
		S_AXI_RRESP	=> AXI_L_rresp,
		S_AXI_RVALID	=> AXI_L_rvalid,
		S_AXI_RREADY	=> AXI_L_rready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
