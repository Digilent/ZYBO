set_false_path -through [get_pins -filter {NAME =~ */Inst_I2sCtl/Inst_SyncBit_*/sreg_reg[0]/D} -hier]
set_false_path -through [get_pins -filter {NAME =~ */Inst_I2sCtl/Inst_Rst_Sync*/FDRE_inst_*/PRE} -hier]

set_property ASYNC_REG true [get_cells -filter {NAME =~ */Inst_I2sCtl/Inst_Rst_Sync*} -hier]


