

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "PmodAMP2" "NUM_INSTANCES" "DEVICE_ID"  "PWM_AXI_BASEADDR" "PWM_AXI_HIGHADDR" "GPIO_AXI_BASEADDR" "GPIO_AXI_HIGHADDR"
}
