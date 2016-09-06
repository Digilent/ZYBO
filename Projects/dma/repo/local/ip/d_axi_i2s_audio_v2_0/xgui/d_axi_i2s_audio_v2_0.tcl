# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set_property tooltip {Page 0} ${Page_0}
  ipgui::add_param $IPINST -name "C_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_STREAM_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_L_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_L_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ENABLE_STREAM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BIDIRECTIONAL_CLK" -parent ${Page_0}


}

proc update_PARAM_VALUE.BIDIRECTIONAL_CLK { PARAM_VALUE.BIDIRECTIONAL_CLK } {
	# Procedure called to update BIDIRECTIONAL_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIDIRECTIONAL_CLK { PARAM_VALUE.BIDIRECTIONAL_CLK } {
	# Procedure called to validate BIDIRECTIONAL_CLK
	return true
}

proc update_PARAM_VALUE.C_AXI_L_ADDR_WIDTH { PARAM_VALUE.C_AXI_L_ADDR_WIDTH } {
	# Procedure called to update C_AXI_L_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_L_ADDR_WIDTH { PARAM_VALUE.C_AXI_L_ADDR_WIDTH } {
	# Procedure called to validate C_AXI_L_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_L_DATA_WIDTH { PARAM_VALUE.C_AXI_L_DATA_WIDTH } {
	# Procedure called to update C_AXI_L_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_L_DATA_WIDTH { PARAM_VALUE.C_AXI_L_DATA_WIDTH } {
	# Procedure called to validate C_AXI_L_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH { PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH } {
	# Procedure called to update C_AXI_STREAM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH { PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH } {
	# Procedure called to validate C_AXI_STREAM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.ENABLE_STREAM { PARAM_VALUE.ENABLE_STREAM } {
	# Procedure called to update ENABLE_STREAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_STREAM { PARAM_VALUE.ENABLE_STREAM } {
	# Procedure called to validate ENABLE_STREAM
	return true
}

proc update_PARAM_VALUE.C_AXI_L_BASEADDR { PARAM_VALUE.C_AXI_L_BASEADDR } {
	# Procedure called to update C_AXI_L_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_L_BASEADDR { PARAM_VALUE.C_AXI_L_BASEADDR } {
	# Procedure called to validate C_AXI_L_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_AXI_L_HIGHADDR { PARAM_VALUE.C_AXI_L_HIGHADDR } {
	# Procedure called to update C_AXI_L_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_L_HIGHADDR { PARAM_VALUE.C_AXI_L_HIGHADDR } {
	# Procedure called to validate C_AXI_L_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_STREAM_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_STREAM_DATA_WIDTH PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_STREAM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_L_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_L_DATA_WIDTH PARAM_VALUE.C_AXI_L_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_L_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_L_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_L_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_L_ADDR_WIDTH PARAM_VALUE.C_AXI_L_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_L_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_L_ADDR_WIDTH}
}

