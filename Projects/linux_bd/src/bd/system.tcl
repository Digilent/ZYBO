
################################################################
# This is a generated script based on design: linux_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source linux_bd_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1
#    set_property BOARD_PART digilentinc.com:zybo:part0:1.0 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name linux_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set HDMI_DDC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMI_DDC ]
  set HDMI_HPD [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 HDMI_HPD ]
  set IIC_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 ]
  set TMDS [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS ]
  set Vaux6 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux6 ]
  set Vaux7 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux7 ]
  set Vaux14 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux14 ]
  set Vaux15 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux15 ]
  set btns_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btns_4bits ]
  set jb [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jb ]
  set jc [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jc ]
  set jd [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jd ]
  set je [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 je ]
  set leds_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 leds_4bits ]
  set sws_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 sws_4bits ]

  # Create ports
  set HDMI_OEN [ create_bd_port -dir O -from 0 -to 0 HDMI_OEN ]
  set ac_bclk [ create_bd_port -dir O -from 0 -to 0 ac_bclk ]
  set ac_mclk [ create_bd_port -dir O -type clk ac_mclk ]
  set ac_muten [ create_bd_port -dir O -from 0 -to 0 ac_muten ]
  set ac_pbdat [ create_bd_port -dir O -from 0 -to 0 ac_pbdat ]
  set ac_pblrc [ create_bd_port -dir O -from 0 -to 0 ac_pblrc ]
  set ac_recdat [ create_bd_port -dir I -from 0 -to 0 ac_recdat ]
  set ac_reclrc [ create_bd_port -dir O -from 0 -to 0 ac_reclrc ]
  set sysclk [ create_bd_port -dir I -from 0 -to 0 sysclk ]

  # Create instance: axi_dynclk_0, and set properties
  set axi_dynclk_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 axi_dynclk_0 ]

  # Create instance: axi_gpio_btn, and set properties
  set axi_gpio_btn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_btn ]
  set_property -dict [ list \
CONFIG.GPIO_BOARD_INTERFACE {btns_4bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_btn

  # Create instance: axi_gpio_hdmi, and set properties
  set axi_gpio_hdmi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_hdmi ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {1} \
CONFIG.C_INTERRUPT_PRESENT {1} \
CONFIG.C_IS_DUAL {0} \
 ] $axi_gpio_hdmi

  # Create instance: axi_gpio_iic, and set properties
  set axi_gpio_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_iic ]
  set_property -dict [ list \
CONFIG.C_GPIO2_WIDTH {2} \
CONFIG.C_GPIO_WIDTH {2} \
CONFIG.C_INTERRUPT_PRESENT {0} \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_iic

  # Create instance: axi_gpio_led, and set properties
  set axi_gpio_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_led ]
  set_property -dict [ list \
CONFIG.GPIO_BOARD_INTERFACE {leds_4bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_led

  # Create instance: axi_gpio_spi, and set properties
  set axi_gpio_spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_spi ]
  set_property -dict [ list \
CONFIG.C_ALL_OUTPUTS {0} \
CONFIG.C_GPIO_WIDTH {4} \
 ] $axi_gpio_spi

  # Create instance: axi_gpio_sw, and set properties
  set axi_gpio_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_sw ]
  set_property -dict [ list \
CONFIG.GPIO_BOARD_INTERFACE {sws_4bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_sw

  # Create instance: axi_gpio_uart, and set properties
  set axi_gpio_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_uart ]
  set_property -dict [ list \
CONFIG.C_GPIO2_WIDTH {4} \
CONFIG.C_GPIO_WIDTH {2} \
CONFIG.C_INTERRUPT_PRESENT {0} \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_uart

  # Create instance: axi_i2s_adi_0, and set properties
  set axi_i2s_adi_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi_0 ]
  set_property -dict [ list \
CONFIG.C_DMA_TYPE {1} \
CONFIG.C_S_AXI_ADDR_WIDTH {6} \
 ] $axi_i2s_adi_0

  # Create instance: axi_iic_jc, and set properties
  set axi_iic_jc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_jc ]

  # Create instance: axi_iic_jd, and set properties
  set axi_iic_jd [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_jd ]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.M00_HAS_DATA_FIFO {2} \
CONFIG.M00_HAS_REGSLICE {4} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S00_HAS_REGSLICE {4} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_REGSLICE {4} \
CONFIG.STRATEGY {0} \
 ] $axi_mem_intercon

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_0 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s_dre {0} \
CONFIG.c_include_s2mm {0} \
CONFIG.c_include_s2mm_dre {0} \
CONFIG.c_m_axi_mm2s_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {32} \
CONFIG.c_mm2s_genlock_mode {0} \
CONFIG.c_mm2s_linebuffer_depth {4096} \
CONFIG.c_mm2s_max_burst_length {16} \
CONFIG.c_num_fstores {1} \
 ] $axi_vdma_0

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
CONFIG.M_TDATA_NUM_BYTES {3} \
CONFIG.M_TUSER_WIDTH {1} \
CONFIG.S_TDATA_NUM_BYTES {4} \
CONFIG.S_TUSER_WIDTH {1} \
CONFIG.TDATA_REMAP {tdata[23:16],tdata[7:0],tdata[15:8]} \
CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKOUT1_JITTER {473.813} \
CONFIG.CLKOUT1_PHASE_ERROR {351.816} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288} \
CONFIG.MMCM_CLKFBOUT_MULT_F {42.750} \
CONFIG.MMCM_CLKIN1_PERIOD {8.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {62.125} \
CONFIG.MMCM_DIVCLK_DIVIDE {7} \
CONFIG.PRIM_IN_FREQ {125.000} \
CONFIG.PRIM_SOURCE {No_buffer} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: pmod_bridge_jb, and set properties
  set pmod_bridge_jb [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge:1.0 pmod_bridge_jb ]
  set_property -dict [ list \
CONFIG.Bottom_Row_Interface {GPIO} \
CONFIG.PMOD {jb} \
CONFIG.Top_Row_Interface {SPI} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $pmod_bridge_jb

  # Create instance: pmod_bridge_jc, and set properties
  set pmod_bridge_jc [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge:1.0 pmod_bridge_jc ]
  set_property -dict [ list \
CONFIG.Bottom_Row_Interface {Disabled} \
CONFIG.PMOD {jc} \
CONFIG.Top_Row_Interface {I2C} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $pmod_bridge_jc

  # Create instance: pmod_bridge_jd, and set properties
  set pmod_bridge_jd [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge:1.0 pmod_bridge_jd ]
  set_property -dict [ list \
CONFIG.Bottom_Row_Interface {Disabled} \
CONFIG.PMOD {jd} \
CONFIG.Top_Row_Interface {I2C} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $pmod_bridge_jd

  # Create instance: pmod_bridge_je, and set properties
  set pmod_bridge_je [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge:1.0 pmod_bridge_je ]
  set_property -dict [ list \
CONFIG.Bottom_Row_Interface {GPIO} \
CONFIG.PMOD {je} \
CONFIG.Top_Row_Interface {UART} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $pmod_bridge_je

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {650} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {50.000000} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {140} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_PULLUP {enabled} \
CONFIG.PCW_MIO_10_PULLUP {enabled} \
CONFIG.PCW_MIO_11_PULLUP {enabled} \
CONFIG.PCW_MIO_12_PULLUP {enabled} \
CONFIG.PCW_MIO_16_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {fast} \
CONFIG.PCW_MIO_17_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_1_PULLUP {disabled} \
CONFIG.PCW_MIO_1_SLEW {fast} \
CONFIG.PCW_MIO_20_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {fast} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {fast} \
CONFIG.PCW_MIO_2_SLEW {fast} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {fast} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {fast} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {fast} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {fast} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {fast} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {fast} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {fast} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {fast} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {fast} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {fast} \
CONFIG.PCW_MIO_3_SLEW {fast} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {fast} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {fast} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {fast} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {fast} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {fast} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {fast} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_48_PULLUP {disabled} \
CONFIG.PCW_MIO_49_PULLUP {disabled} \
CONFIG.PCW_MIO_4_SLEW {fast} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_SLEW {fast} \
CONFIG.PCW_MIO_6_SLEW {fast} \
CONFIG.PCW_MIO_8_SLEW {fast} \
CONFIG.PCW_MIO_9_PULLUP {enabled} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_SPI1_IO {MIO 10 .. 15} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.176} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.159} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.162} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.187} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.034} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.03} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.082} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {525} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K128M16 JT-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 46} \
CONFIG.PCW_USE_DMA0 {1} \
CONFIG.PCW_USE_DMA1 {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {Default} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {14} \
 ] $processing_system7_0_axi_periph

  # Create instance: rgb2dvi_0, and set properties
  set rgb2dvi_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.3 rgb2dvi_0 ]
  set_property -dict [ list \
CONFIG.kClkRange {2} \
CONFIG.kGenerateSerialClk {false} \
CONFIG.kRstActiveHigh {false} \
 ] $rgb2dvi_0

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_0

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list \
CONFIG.C_ADDR_WIDTH {12} \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
CONFIG.C_S_AXIS_VIDEO_FORMAT {2} \
CONFIG.C_VTG_MASTER_SLAVE {1} \
 ] $v_axi4s_vid_out_0

  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
  set_property -dict [ list \
CONFIG.enable_detection {false} \
 ] $v_tc_0

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.2 xadc_wiz_0 ]
  set_property -dict [ list \
CONFIG.CHANNEL_ENABLE_CALIBRATION {true} \
CONFIG.CHANNEL_ENABLE_TEMPERATURE {true} \
CONFIG.CHANNEL_ENABLE_VAUXP14_VAUXN14 {true} \
CONFIG.CHANNEL_ENABLE_VAUXP15_VAUXN15 {true} \
CONFIG.CHANNEL_ENABLE_VAUXP6_VAUXN6 {true} \
CONFIG.CHANNEL_ENABLE_VAUXP7_VAUXN7 {true} \
CONFIG.CHANNEL_ENABLE_VBRAM {true} \
CONFIG.CHANNEL_ENABLE_VCCAUX {true} \
CONFIG.CHANNEL_ENABLE_VCCDDRO {true} \
CONFIG.CHANNEL_ENABLE_VCCINT {true} \
CONFIG.CHANNEL_ENABLE_VCCPAUX {true} \
CONFIG.CHANNEL_ENABLE_VCCPINT {true} \
CONFIG.CHANNEL_ENABLE_VP_VN {false} \
CONFIG.CHANNEL_ENABLE_VREFN {true} \
CONFIG.CHANNEL_ENABLE_VREFP {true} \
CONFIG.ENABLE_VCCDDRO_ALARM {false} \
CONFIG.ENABLE_VCCPAUX_ALARM {false} \
CONFIG.ENABLE_VCCPINT_ALARM {false} \
CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} \
CONFIG.OT_ALARM {false} \
CONFIG.SEQUENCER_MODE {Continuous} \
CONFIG.SINGLE_CHANNEL_SELECTION {TEMPERATURE} \
CONFIG.USER_TEMP_ALARM {false} \
CONFIG.VCCAUX_ALARM {false} \
CONFIG.VCCINT_ALARM {false} \
CONFIG.XADC_STARUP_SELECTION {channel_sequencer} \
 ] $xadc_wiz_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Vaux14_1 [get_bd_intf_ports Vaux14] [get_bd_intf_pins xadc_wiz_0/Vaux14]
  connect_bd_intf_net -intf_net Vaux15_1 [get_bd_intf_ports Vaux15] [get_bd_intf_pins xadc_wiz_0/Vaux15]
  connect_bd_intf_net -intf_net Vaux6_1 [get_bd_intf_ports Vaux6] [get_bd_intf_pins xadc_wiz_0/Vaux6]
  connect_bd_intf_net -intf_net Vaux7_1 [get_bd_intf_ports Vaux7] [get_bd_intf_pins xadc_wiz_0/Vaux7]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports btns_4bits] [get_bd_intf_pins axi_gpio_btn/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO1 [get_bd_intf_ports sws_4bits] [get_bd_intf_pins axi_gpio_sw/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports HDMI_HPD] [get_bd_intf_pins axi_gpio_hdmi/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO3 [get_bd_intf_pins axi_gpio_uart/GPIO] [get_bd_intf_pins pmod_bridge_je/UART_GPIO_Top_Row]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO4 [get_bd_intf_pins axi_gpio_uart/GPIO2] [get_bd_intf_pins pmod_bridge_je/GPIO_Bottom_Row]
  connect_bd_intf_net -intf_net axi_gpio_iic_GPIO [get_bd_intf_pins axi_gpio_iic/GPIO] [get_bd_intf_pins pmod_bridge_jd/I2C_GPIO_Top_Row]
  connect_bd_intf_net -intf_net axi_gpio_iic_GPIO2 [get_bd_intf_pins axi_gpio_iic/GPIO2] [get_bd_intf_pins pmod_bridge_jc/I2C_GPIO_Top_Row]
  connect_bd_intf_net -intf_net axi_gpio_led_GPIO [get_bd_intf_ports leds_4bits] [get_bd_intf_pins axi_gpio_led/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_spi_GPIO [get_bd_intf_pins axi_gpio_spi/GPIO] [get_bd_intf_pins pmod_bridge_jb/GPIO_Bottom_Row]
  connect_bd_intf_net -intf_net axi_i2s_adi_0_DMA_REQ_RX [get_bd_intf_pins axi_i2s_adi_0/DMA_REQ_RX] [get_bd_intf_pins processing_system7_0/DMA1_REQ]
  connect_bd_intf_net -intf_net axi_i2s_adi_0_DMA_REQ_TX [get_bd_intf_pins axi_i2s_adi_0/DMA_REQ_TX] [get_bd_intf_pins processing_system7_0/DMA0_REQ]
  connect_bd_intf_net -intf_net axi_iic_jc_IIC [get_bd_intf_pins axi_iic_jc/IIC] [get_bd_intf_pins pmod_bridge_jc/I2C_Top_Row]
  connect_bd_intf_net -intf_net axi_iic_jd_IIC [get_bd_intf_pins axi_iic_jd/IIC] [get_bd_intf_pins pmod_bridge_jd/I2C_Top_Row]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
  connect_bd_intf_net -intf_net pmod_bridge_jb_Pmod_out [get_bd_intf_ports jb] [get_bd_intf_pins pmod_bridge_jb/Pmod_out]
  connect_bd_intf_net -intf_net pmod_bridge_jc_Pmod_out [get_bd_intf_ports jc] [get_bd_intf_pins pmod_bridge_jc/Pmod_out]
  connect_bd_intf_net -intf_net pmod_bridge_jd_Pmod_out [get_bd_intf_ports jd] [get_bd_intf_pins pmod_bridge_jd/Pmod_out]
  connect_bd_intf_net -intf_net pmod_bridge_je_Pmod_out [get_bd_intf_ports je] [get_bd_intf_pins pmod_bridge_je/Pmod_out]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_DMA0_ACK [get_bd_intf_pins axi_i2s_adi_0/DMA_ACK_TX] [get_bd_intf_pins processing_system7_0/DMA0_ACK]
  connect_bd_intf_net -intf_net processing_system7_0_DMA1_ACK [get_bd_intf_pins axi_i2s_adi_0/DMA_ACK_RX] [get_bd_intf_pins processing_system7_0/DMA1_ACK]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_1 [get_bd_intf_ports HDMI_DDC] [get_bd_intf_pins processing_system7_0/IIC_1]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_SPI_0 [get_bd_intf_pins pmod_bridge_jb/SPI_Top_Row] [get_bd_intf_pins processing_system7_0/SPI_0]
  connect_bd_intf_net -intf_net processing_system7_0_UART_0 [get_bd_intf_pins pmod_bridge_je/UART_Top_Row] [get_bd_intf_pins processing_system7_0/UART_0]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_led/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_btn/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_gpio_sw/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI] [get_bd_intf_pins v_tc_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_dynclk_0/s00_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins axi_gpio_hdmi/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M07_AXI [get_bd_intf_pins axi_i2s_adi_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M08_AXI [get_bd_intf_pins axi_gpio_spi/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M09_AXI [get_bd_intf_pins axi_gpio_uart/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M10_AXI [get_bd_intf_pins axi_iic_jc/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M11_AXI [get_bd_intf_pins axi_iic_jd/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M12_AXI [get_bd_intf_pins axi_gpio_iic/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M13_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M13_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net rgb2dvi_0_TMDS [get_bd_intf_ports TMDS] [get_bd_intf_pins rgb2dvi_0/TMDS]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins rgb2dvi_0/RGB] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]

  # Create port connections
  connect_bd_net -net BUFG_I_1 [get_bd_ports sysclk] [get_bd_pins util_ds_buf_0/BUFG_I]
  connect_bd_net -net SDATA_I_1 [get_bd_ports ac_recdat] [get_bd_pins axi_i2s_adi_0/SDATA_I]
  connect_bd_net -net axi_dynclk_0_LOCKED_O [get_bd_pins axi_dynclk_0/LOCKED_O] [get_bd_pins rgb2dvi_0/aRst_n]
  connect_bd_net -net axi_dynclk_0_PXL_CLK_5X_O [get_bd_pins axi_dynclk_0/PXL_CLK_5X_O] [get_bd_pins rgb2dvi_0/SerialClk]
  connect_bd_net -net axi_dynclk_0_PXL_CLK_O [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins rgb2dvi_0/PixelClk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
  connect_bd_net -net axi_gpio_0_ip2intc_irpt [get_bd_pins axi_gpio_hdmi/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_i2s_adi_0_BCLK_O [get_bd_ports ac_bclk] [get_bd_pins axi_i2s_adi_0/BCLK_O]
  connect_bd_net -net axi_i2s_adi_0_LRCLK_O [get_bd_ports ac_pblrc] [get_bd_ports ac_reclrc] [get_bd_pins axi_i2s_adi_0/LRCLK_O]
  connect_bd_net -net axi_i2s_adi_0_SDATA_O [get_bd_ports ac_pbdat] [get_bd_pins axi_i2s_adi_0/SDATA_O]
  connect_bd_net -net axi_iic_jc_iic2intc_irpt [get_bd_pins axi_iic_jc/iic2intc_irpt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_iic_jd_iic2intc_irpt [get_bd_pins axi_iic_jd/iic2intc_irpt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins axi_vdma_0/mm2s_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports ac_mclk] [get_bd_pins axi_i2s_adi_0/DATA_CLK_I] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins axi_dynclk_0/s00_axi_aclk] [get_bd_pins axi_gpio_btn/s_axi_aclk] [get_bd_pins axi_gpio_hdmi/s_axi_aclk] [get_bd_pins axi_gpio_iic/s_axi_aclk] [get_bd_pins axi_gpio_led/s_axi_aclk] [get_bd_pins axi_gpio_spi/s_axi_aclk] [get_bd_pins axi_gpio_sw/s_axi_aclk] [get_bd_pins axi_gpio_uart/s_axi_aclk] [get_bd_pins axi_i2s_adi_0/DMA_REQ_RX_ACLK] [get_bd_pins axi_i2s_adi_0/DMA_REQ_TX_ACLK] [get_bd_pins axi_i2s_adi_0/S_AXI_ACLK] [get_bd_pins axi_iic_jc/s_axi_aclk] [get_bd_pins axi_iic_jd/s_axi_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/DMA0_ACLK] [get_bd_pins processing_system7_0/DMA1_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/M07_ACLK] [get_bd_pins processing_system7_0_axi_periph/M08_ACLK] [get_bd_pins processing_system7_0_axi_periph/M09_ACLK] [get_bd_pins processing_system7_0_axi_periph/M10_ACLK] [get_bd_pins processing_system7_0_axi_periph/M11_ACLK] [get_bd_pins processing_system7_0_axi_periph/M12_ACLK] [get_bd_pins processing_system7_0_axi_periph/M13_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins v_tc_0/s_axi_aclk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins v_axi4s_vid_out_0/aclk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins processing_system7_0_axi_periph/ARESETN]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_dynclk_0/s00_axi_aresetn] [get_bd_pins axi_gpio_btn/s_axi_aresetn] [get_bd_pins axi_gpio_hdmi/s_axi_aresetn] [get_bd_pins axi_gpio_iic/s_axi_aresetn] [get_bd_pins axi_gpio_led/s_axi_aresetn] [get_bd_pins axi_gpio_spi/s_axi_aresetn] [get_bd_pins axi_gpio_sw/s_axi_aresetn] [get_bd_pins axi_gpio_uart/s_axi_aresetn] [get_bd_pins axi_i2s_adi_0/DMA_REQ_RX_RSTN] [get_bd_pins axi_i2s_adi_0/DMA_REQ_TX_RSTN] [get_bd_pins axi_i2s_adi_0/S_AXI_ARESETN] [get_bd_pins axi_iic_jc/s_axi_aresetn] [get_bd_pins axi_iic_jd/s_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M07_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M08_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M09_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M10_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M11_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M12_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M13_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins v_tc_0/s_axi_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net rst_processing_system7_0_150M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_150M_peripheral_aresetn [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net util_ds_buf_0_BUFG_O [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins util_ds_buf_0/BUFG_O]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken]
  connect_bd_net -net v_tc_0_irq [get_bd_pins v_tc_0/irq] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net xadc_wiz_0_ip2intc_irpt [get_bd_pins xadc_wiz_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports HDMI_OEN] [get_bd_ports ac_muten] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dynclk_0/s00_axi/reg0] SEG_axi_dynclk_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x41230000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_hdmi/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41240000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_uart/S_AXI/Reg] SEG_axi_gpio_0_Reg1
  create_bd_addr_seg -range 0x10000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_btn/S_AXI/Reg] SEG_axi_gpio_btn_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41250000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_iic/S_AXI/Reg] SEG_axi_gpio_iic_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_led/S_AXI/Reg] SEG_axi_gpio_led_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41260000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_spi/S_AXI/Reg] SEG_axi_gpio_spi_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41220000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_sw/S_AXI/Reg] SEG_axi_gpio_sw_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_i2s_adi_0/S_AXI/reg0] SEG_axi_i2s_adi_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x41610000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_jc/S_AXI/Reg] SEG_axi_iic_jc_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41620000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_jd/S_AXI/Reg] SEG_axi_iic_jd_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_tc_0/ctrl/Reg] SEG_v_tc_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   DisplayTieOff: "1",
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port btns_4bits -pg 1 -y 1300 -defaultsOSRD
preplace port DDR -pg 1 -y 780 -defaultsOSRD
preplace port TMDS -pg 1 -y 1030 -defaultsOSRD
preplace port jb -pg 1 -y 860 -defaultsOSRD
preplace port HDMI_HPD -pg 1 -y 1150 -defaultsOSRD
preplace port jc -pg 1 -y 1790 -defaultsOSRD
preplace port sws_4bits -pg 1 -y 1580 -defaultsOSRD
preplace port jd -pg 1 -y 1690 -defaultsOSRD
preplace port je -pg 1 -y 700 -defaultsOSRD
preplace port leds_4bits -pg 1 -y 1420 -defaultsOSRD
preplace port IIC_0 -pg 1 -y 940 -defaultsOSRD
preplace port HDMI_DDC -pg 1 -y 960 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 800 -defaultsOSRD
preplace port ac_mclk -pg 1 -y 1850 -defaultsOSRD
preplace port Vaux6 -pg 1 -y 1050 -defaultsOSRD
preplace port Vaux7 -pg 1 -y 1070 -defaultsOSRD
preplace port Vaux14 -pg 1 -y 1090 -defaultsOSRD
preplace port Vaux15 -pg 1 -y 1110 -defaultsOSRD
preplace portBus ac_reclrc -pg 1 -y 530 -defaultsOSRD
preplace portBus ac_muten -pg 1 -y 1980 -defaultsOSRD
preplace portBus ac_recdat -pg 1 -y 690 -defaultsOSRD
preplace portBus ac_pbdat -pg 1 -y 550 -defaultsOSRD
preplace portBus sysclk -pg 1 -y 1900 -defaultsOSRD
preplace portBus ac_bclk -pg 1 -y 490 -defaultsOSRD
preplace portBus ac_pblrc -pg 1 -y 510 -defaultsOSRD
preplace portBus HDMI_OEN -pg 1 -y 1960 -defaultsOSRD
preplace inst axi_gpio_iic -pg 1 -lvl 7 -y 1760 -defaultsOSRD
preplace inst axi_iic_jd -pg 1 -lvl 7 -y 1640 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 7 -y 1110 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 6 -y 1180 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 5 -y 1000 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 8 -y 1980 -defaultsOSRD
preplace inst xadc_wiz_0 -pg 1 -lvl 1 -y 1080 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 5 -y 1120 -defaultsOSRD
preplace inst axi_gpio_sw -pg 1 -lvl 8 -y 1580 -defaultsOSRD
preplace inst axi_gpio_btn -pg 1 -lvl 8 -y 1300 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 2 -y 1290 -defaultsOSRD
preplace inst proc_sys_reset_0 -pg 1 -lvl 3 -y 590 -defaultsOSRD
preplace inst axi_gpio_led -pg 1 -lvl 8 -y 1420 -defaultsOSRD
preplace inst pmod_bridge_jb -pg 1 -lvl 8 -y 860 -defaultsOSRD
preplace inst rgb2dvi_0 -pg 1 -lvl 8 -y 1030 -defaultsOSRD
preplace inst proc_sys_reset_1 -pg 1 -lvl 1 -y 810 -defaultsOSRD
preplace inst axi_gpio_hdmi -pg 1 -lvl 8 -y 1160 -defaultsOSRD
preplace inst pmod_bridge_jc -pg 1 -lvl 8 -y 1790 -defaultsOSRD
preplace inst axi_dynclk_0 -pg 1 -lvl 5 -y 1260 -defaultsOSRD
preplace inst axis_subset_converter_0 -pg 1 -lvl 6 -y 970 -defaultsOSRD
preplace inst pmod_bridge_jd -pg 1 -lvl 8 -y 1690 -defaultsOSRD
preplace inst axi_i2s_adi_0 -pg 1 -lvl 7 -y 490 -defaultsOSRD
preplace inst pmod_bridge_je -pg 1 -lvl 8 -y 700 -defaultsOSRD
preplace inst axi_gpio_spi -pg 1 -lvl 7 -y 870 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 8 -y 1900 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 2 -y 600 -defaultsOSRD
preplace inst axi_iic_jc -pg 1 -lvl 7 -y 1480 -defaultsOSRD
preplace inst axi_gpio_uart -pg 1 -lvl 7 -y 690 -defaultsOSRD
preplace inst util_ds_buf_0 -pg 1 -lvl 7 -y 1900 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 4 -y 370 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 3 -y 940 -defaultsOSRD
preplace netloc axi_vdma_0_M_AXI_MM2S 1 1 5 410 720 NJ 720 NJ 810 NJ 810 2010
preplace netloc axi_gpio_iic_GPIO2 1 7 1 2770
preplace netloc processing_system7_0_axi_periph_M08_AXI 1 4 3 NJ 410 NJ 410 2470
preplace netloc processing_system7_0_FIXED_IO 1 3 6 NJ 790 NJ 790 NJ 790 NJ 790 NJ 790 NJ
preplace netloc rst_processing_system7_0_150M_peripheral_aresetn 1 1 1 360
preplace netloc axi_i2s_adi_0_SDATA_O 1 7 2 NJ 530 NJ
preplace netloc pmod_bridge_jb_Pmod_out 1 8 1 NJ
preplace netloc axi_vdma_0_M_AXIS_MM2S 1 5 1 2020
preplace netloc xlconcat_0_dout 1 2 1 760
preplace netloc axi_gpio_led_GPIO 1 8 1 NJ
preplace netloc v_tc_0_vtiming_out 1 6 1 2470
preplace netloc axi_iic_jc_iic2intc_irpt 1 1 7 400 1400 NJ 1400 NJ 1400 NJ 1400 NJ 1400 NJ 1400 2770
preplace netloc axi_gpio_0_GPIO 1 8 1 NJ
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 4 4 NJ 340 NJ 340 NJ 340 NJ
preplace netloc axi_i2s_adi_0_DMA_REQ_TX 1 2 6 770 710 NJ 760 NJ 760 NJ 760 NJ 760 2770
preplace netloc BUFG_I_1 1 0 7 NJ 1900 NJ 1900 NJ 1900 NJ 1900 NJ 1900 NJ 1900 NJ
preplace netloc axi_gpio_0_GPIO1 1 8 1 NJ
preplace netloc processing_system7_0_DDR 1 3 6 NJ 780 NJ 780 NJ 780 NJ 780 NJ 780 NJ
preplace netloc axi_gpio_0_GPIO2 1 8 1 NJ
preplace netloc pmod_bridge_je_Pmod_out 1 8 1 NJ
preplace netloc axi_gpio_0_GPIO3 1 7 1 N
preplace netloc axi_gpio_0_GPIO4 1 7 1 N
preplace netloc xlconstant_1_dout 1 5 1 NJ
preplace netloc Vaux15_1 1 0 1 NJ
preplace netloc axi_gpio_spi_GPIO 1 7 1 N
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 4 1 1600
preplace netloc axi_iic_jd_IIC 1 7 1 2780
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 4 20 910 NJ 910 710 680 1200
preplace netloc pmod_bridge_jc_Pmod_out 1 8 1 NJ
preplace netloc processing_system7_0_axi_periph_M10_AXI 1 4 3 NJ 440 NJ 440 NJ
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 4 4 NJ 280 NJ 280 NJ 280 NJ
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 4 2 NJ 300 NJ
preplace netloc axi_gpio_0_ip2intc_irpt 1 1 8 390 1390 NJ 1390 NJ 1390 NJ 1390 NJ 1390 NJ 1390 NJ 1490 3160
preplace netloc axi_i2s_adi_0_LRCLK_O 1 7 2 NJ 510 NJ
preplace netloc processing_system7_0_axi_periph_M07_AXI 1 4 3 NJ 380 NJ 380 NJ
preplace netloc Vaux7_1 1 0 1 N
preplace netloc processing_system7_0_axi_periph_M09_AXI 1 4 3 NJ 420 NJ 420 NJ
preplace netloc processing_system7_0_axi_periph_M11_AXI 1 4 3 NJ 470 NJ 470 NJ
preplace netloc processing_system7_0_axi_periph_M13_AXI 1 0 5 0 720 NJ 730 NJ 730 NJ 750 1580
preplace netloc axi_vdma_0_mm2s_introut 1 1 5 370 1160 NJ 1160 NJ 1160 NJ 1170 2010
preplace netloc processing_system7_0_DMA1_ACK 1 3 4 NJ 960 NJ 400 NJ 400 NJ
preplace netloc pmod_bridge_jd_Pmod_out 1 8 1 NJ
preplace netloc SDATA_I_1 1 0 7 NJ 690 NJ 740 NJ 690 NJ 770 NJ 460 NJ 460 NJ
preplace netloc processing_system7_0_IIC_0 1 3 6 NJ 840 NJ 840 NJ 840 NJ 800 NJ 800 NJ
preplace netloc processing_system7_0_axi_periph_M12_AXI 1 4 3 NJ 480 NJ 480 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 4 4 NJ 260 NJ 260 NJ 260 NJ
preplace netloc util_ds_buf_0_BUFG_O 1 7 1 NJ
preplace netloc processing_system7_0_IIC_1 1 3 6 NJ 890 NJ 890 NJ 890 NJ 950 NJ 950 NJ
preplace netloc processing_system7_0_SPI_0 1 3 5 NJ 880 NJ 880 NJ 880 NJ 940 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 8 10 1200 NJ 1020 730 500 1260 980 1650 1350 2060 1350 2440 1260 2860
preplace netloc axi_iic_jc_IIC 1 7 1 2790
preplace netloc processing_system7_0_DMA0_ACK 1 3 4 NJ 940 NJ 430 NJ 430 NJ
preplace netloc axi_dynclk_0_PXL_CLK_O 1 5 3 2040 1040 2360 1240 NJ
preplace netloc processing_system7_0_FCLK_CLK1 1 0 7 10 900 350 750 750 700 1220 910 1660 910 2080 900 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 3 1 1200
preplace netloc axi_gpio_iic_GPIO 1 7 1 2860
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 4 4 NJ 240 NJ 240 NJ 240 NJ
preplace netloc v_tc_0_irq 1 1 6 380 1170 NJ 1180 NJ 1180 NJ 1180 NJ 1050 2350
preplace netloc xadc_wiz_0_ip2intc_irpt 1 1 1 340
preplace netloc Vaux6_1 1 0 1 N
preplace netloc rst_processing_system7_0_150M_interconnect_aresetn 1 1 1 340
preplace netloc axi_dynclk_0_LOCKED_O 1 5 3 2020 1310 NJ 1250 NJ
preplace netloc processing_system7_0_UART_0 1 3 5 NJ 800 NJ 770 NJ 770 NJ 770 NJ
preplace netloc Vaux14_1 1 0 1 NJ
preplace netloc v_axi4s_vid_out_0_vtg_ce 1 5 3 2080 1330 NJ 1330 2770
preplace netloc clk_wiz_0_clk_out1 1 6 3 2480 1850 NJ 1850 3170
preplace netloc processing_system7_0_M_AXI_GP0 1 3 1 1240
preplace netloc xlconstant_0_dout 1 8 1 NJ
preplace netloc axi_i2s_adi_0_BCLK_O 1 7 2 NJ 490 NJ
preplace netloc rgb2dvi_0_TMDS 1 8 1 NJ
preplace netloc axi_mem_intercon_M00_AXI 1 2 1 740
preplace netloc axis_subset_converter_0_M_AXIS 1 6 1 2380
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 4 1 1620
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 0 8 20 1210 NJ 1190 NJ 1190 1230 1040 1640 1340 2070 1340 2450 1410 2870
preplace netloc axi_iic_jd_iic2intc_irpt 1 1 7 410 1550 NJ 1550 NJ 1550 NJ 1550 NJ 1550 NJ 1550 2770
preplace netloc axi_dynclk_0_PXL_CLK_5X_O 1 5 3 NJ 1320 NJ 1320 NJ
preplace netloc v_axi4s_vid_out_0_vid_io_out 1 7 1 2770
preplace netloc axi_i2s_adi_0_DMA_REQ_RX 1 2 6 760 -10 NJ -10 NJ -10 NJ -10 NJ -10 2770
levelinfo -pg 1 -20 180 560 990 1430 1850 2220 2630 3020 3190 -top -20 -bot 2030
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


