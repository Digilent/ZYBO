# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "kRedDepth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "kRedPad" -parent ${Page_0}
  ipgui::add_param $IPINST -name "kBlueDepth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "kBluePad" -parent ${Page_0}
  ipgui::add_param $IPINST -name "kGreenDepth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "kGreenPad" -parent ${Page_0}


}

proc update_PARAM_VALUE.kBluePad { PARAM_VALUE.kBluePad } {
	# Procedure called to update kBluePad when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kBluePad { PARAM_VALUE.kBluePad } {
	# Procedure called to validate kBluePad
	return true
}

proc update_PARAM_VALUE.kGreenPad { PARAM_VALUE.kGreenPad } {
	# Procedure called to update kGreenPad when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kGreenPad { PARAM_VALUE.kGreenPad } {
	# Procedure called to validate kGreenPad
	return true
}

proc update_PARAM_VALUE.kRedPad { PARAM_VALUE.kRedPad } {
	# Procedure called to update kRedPad when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kRedPad { PARAM_VALUE.kRedPad } {
	# Procedure called to validate kRedPad
	return true
}

proc update_PARAM_VALUE.kBlueDepth { PARAM_VALUE.kBlueDepth } {
	# Procedure called to update kBlueDepth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kBlueDepth { PARAM_VALUE.kBlueDepth } {
	# Procedure called to validate kBlueDepth
	return true
}

proc update_PARAM_VALUE.kGreenDepth { PARAM_VALUE.kGreenDepth } {
	# Procedure called to update kGreenDepth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kGreenDepth { PARAM_VALUE.kGreenDepth } {
	# Procedure called to validate kGreenDepth
	return true
}

proc update_PARAM_VALUE.kRedDepth { PARAM_VALUE.kRedDepth } {
	# Procedure called to update kRedDepth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kRedDepth { PARAM_VALUE.kRedDepth } {
	# Procedure called to validate kRedDepth
	return true
}


proc update_MODELPARAM_VALUE.kRedDepth { MODELPARAM_VALUE.kRedDepth PARAM_VALUE.kRedDepth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kRedDepth}] ${MODELPARAM_VALUE.kRedDepth}
}

proc update_MODELPARAM_VALUE.kGreenDepth { MODELPARAM_VALUE.kGreenDepth PARAM_VALUE.kGreenDepth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kGreenDepth}] ${MODELPARAM_VALUE.kGreenDepth}
}

proc update_MODELPARAM_VALUE.kBlueDepth { MODELPARAM_VALUE.kBlueDepth PARAM_VALUE.kBlueDepth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kBlueDepth}] ${MODELPARAM_VALUE.kBlueDepth}
}

proc update_MODELPARAM_VALUE.kRedPad { MODELPARAM_VALUE.kRedPad PARAM_VALUE.kRedPad } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kRedPad}] ${MODELPARAM_VALUE.kRedPad}
}

proc update_MODELPARAM_VALUE.kGreenPad { MODELPARAM_VALUE.kGreenPad PARAM_VALUE.kGreenPad } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kGreenPad}] ${MODELPARAM_VALUE.kGreenPad}
}

proc update_MODELPARAM_VALUE.kBluePad { MODELPARAM_VALUE.kBluePad PARAM_VALUE.kBluePad } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kBluePad}] ${MODELPARAM_VALUE.kBluePad}
}

