#First run source -notrace C:/Xilinx/SDSoC/2015.4/scripts/vivado/sdsoc_pfm.tcl

set pfm [sdsoc::create_pfm zybo_hdmi_in_hw.pfm]
sdsoc::pfm_name $pfm "digilentinc.com" "xd" "zybo_hdmi_in" "1.0"
sdsoc::pfm_description $pfm "ZYBO Development Platform with HDMI-in/VGA-out"
sdsoc::pfm_clock $pfm FCLK_CLK0 processing_system7_0 0 true proc_sys_reset_0
sdsoc::pfm_clock $pfm FCLK_CLK1 processing_system7_0 1 false proc_sys_reset_1
sdsoc::pfm_clock $pfm FCLK_CLK3 processing_system7_0 3 false proc_sys_reset_3
sdsoc::pfm_axi_port $pfm M_AXI_GP1 processing_system7_0 M_AXI_GP
sdsoc::pfm_axi_port $pfm S_AXI_ACP processing_system7_0 S_AXI_ACP
sdsoc::pfm_axi_port $pfm S_AXI_HP2 processing_system7_0 S_AXI_HP
sdsoc::pfm_axi_port $pfm S_AXI_HP3 processing_system7_0 S_AXI_HP
for {set i 5} {$i < 16} {incr i} {
sdsoc::pfm_irq $pfm In$i xlconcat_0
}
sdsoc::pfm_iodev $pfm S_AXI axi_gpio_sw uio
sdsoc::pfm_iodev $pfm S_AXI axi_gpio_led uio
sdsoc::generate_hw_pfm $pfm
