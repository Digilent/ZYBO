// (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: digilentinc.com:IP:PWM:1.0
// IP Revision: 5

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
PmodAMP2_PWM_0_0 your_instance_name (
  .pwm(pwm),                          // output wire pwm
  .interrupt(interrupt),              // output wire interrupt
  .pwm_axi_awaddr(pwm_axi_awaddr),    // input wire [3 : 0] pwm_axi_awaddr
  .pwm_axi_awprot(pwm_axi_awprot),    // input wire [2 : 0] pwm_axi_awprot
  .pwm_axi_awvalid(pwm_axi_awvalid),  // input wire pwm_axi_awvalid
  .pwm_axi_awready(pwm_axi_awready),  // output wire pwm_axi_awready
  .pwm_axi_wdata(pwm_axi_wdata),      // input wire [31 : 0] pwm_axi_wdata
  .pwm_axi_wstrb(pwm_axi_wstrb),      // input wire [3 : 0] pwm_axi_wstrb
  .pwm_axi_wvalid(pwm_axi_wvalid),    // input wire pwm_axi_wvalid
  .pwm_axi_wready(pwm_axi_wready),    // output wire pwm_axi_wready
  .pwm_axi_bresp(pwm_axi_bresp),      // output wire [1 : 0] pwm_axi_bresp
  .pwm_axi_bvalid(pwm_axi_bvalid),    // output wire pwm_axi_bvalid
  .pwm_axi_bready(pwm_axi_bready),    // input wire pwm_axi_bready
  .pwm_axi_araddr(pwm_axi_araddr),    // input wire [3 : 0] pwm_axi_araddr
  .pwm_axi_arprot(pwm_axi_arprot),    // input wire [2 : 0] pwm_axi_arprot
  .pwm_axi_arvalid(pwm_axi_arvalid),  // input wire pwm_axi_arvalid
  .pwm_axi_arready(pwm_axi_arready),  // output wire pwm_axi_arready
  .pwm_axi_rdata(pwm_axi_rdata),      // output wire [31 : 0] pwm_axi_rdata
  .pwm_axi_rresp(pwm_axi_rresp),      // output wire [1 : 0] pwm_axi_rresp
  .pwm_axi_rvalid(pwm_axi_rvalid),    // output wire pwm_axi_rvalid
  .pwm_axi_rready(pwm_axi_rready),    // input wire pwm_axi_rready
  .pwm_axi_aclk(pwm_axi_aclk),        // input wire pwm_axi_aclk
  .pwm_axi_aresetn(pwm_axi_aresetn)  // input wire pwm_axi_aresetn
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

