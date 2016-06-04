//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
//Date        : Wed Apr 06 16:08:54 2016
//Host        : WK116 running 64-bit major release  (build 9200)
//Command     : generate_target PmodAMP2.bd
//Design      : PmodAMP2
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "PmodAMP2,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=PmodAMP2,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=2,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "PmodAMP2.hwdef" *) 
module PmodAMP2
   (GPIO_AXI_araddr,
    GPIO_AXI_arready,
    GPIO_AXI_arvalid,
    GPIO_AXI_awaddr,
    GPIO_AXI_awready,
    GPIO_AXI_awvalid,
    GPIO_AXI_bready,
    GPIO_AXI_bresp,
    GPIO_AXI_bvalid,
    GPIO_AXI_rdata,
    GPIO_AXI_rready,
    GPIO_AXI_rresp,
    GPIO_AXI_rvalid,
    GPIO_AXI_wdata,
    GPIO_AXI_wready,
    GPIO_AXI_wstrb,
    GPIO_AXI_wvalid,
    PWM_AXI_araddr,
    PWM_AXI_arprot,
    PWM_AXI_arready,
    PWM_AXI_arvalid,
    PWM_AXI_awaddr,
    PWM_AXI_awprot,
    PWM_AXI_awready,
    PWM_AXI_awvalid,
    PWM_AXI_bready,
    PWM_AXI_bresp,
    PWM_AXI_bvalid,
    PWM_AXI_rdata,
    PWM_AXI_rready,
    PWM_AXI_rresp,
    PWM_AXI_rvalid,
    PWM_AXI_wdata,
    PWM_AXI_wready,
    PWM_AXI_wstrb,
    PWM_AXI_wvalid,
    Pmod_out_pin10_i,
    Pmod_out_pin10_o,
    Pmod_out_pin10_t,
    Pmod_out_pin1_i,
    Pmod_out_pin1_o,
    Pmod_out_pin1_t,
    Pmod_out_pin2_i,
    Pmod_out_pin2_o,
    Pmod_out_pin2_t,
    Pmod_out_pin3_i,
    Pmod_out_pin3_o,
    Pmod_out_pin3_t,
    Pmod_out_pin4_i,
    Pmod_out_pin4_o,
    Pmod_out_pin4_t,
    Pmod_out_pin7_i,
    Pmod_out_pin7_o,
    Pmod_out_pin7_t,
    Pmod_out_pin8_i,
    Pmod_out_pin8_o,
    Pmod_out_pin8_t,
    Pmod_out_pin9_i,
    Pmod_out_pin9_o,
    Pmod_out_pin9_t,
    PWM_interrupt,
    s_axi_aclk,
    s_axi_aresetn);
  input [8:0]GPIO_AXI_araddr;
  output GPIO_AXI_arready;
  input GPIO_AXI_arvalid;
  input [8:0]GPIO_AXI_awaddr;
  output GPIO_AXI_awready;
  input GPIO_AXI_awvalid;
  input GPIO_AXI_bready;
  output [1:0]GPIO_AXI_bresp;
  output GPIO_AXI_bvalid;
  output [31:0]GPIO_AXI_rdata;
  input GPIO_AXI_rready;
  output [1:0]GPIO_AXI_rresp;
  output GPIO_AXI_rvalid;
  input [31:0]GPIO_AXI_wdata;
  output GPIO_AXI_wready;
  input [3:0]GPIO_AXI_wstrb;
  input GPIO_AXI_wvalid;
  input [3:0]PWM_AXI_araddr;
  input [2:0]PWM_AXI_arprot;
  output PWM_AXI_arready;
  input PWM_AXI_arvalid;
  input [3:0]PWM_AXI_awaddr;
  input [2:0]PWM_AXI_awprot;
  output PWM_AXI_awready;
  input PWM_AXI_awvalid;
  input PWM_AXI_bready;
  output [1:0]PWM_AXI_bresp;
  output PWM_AXI_bvalid;
  output [31:0]PWM_AXI_rdata;
  input PWM_AXI_rready;
  output [1:0]PWM_AXI_rresp;
  output PWM_AXI_rvalid;
  input [31:0]PWM_AXI_wdata;
  output PWM_AXI_wready;
  input [3:0]PWM_AXI_wstrb;
  input PWM_AXI_wvalid;
  input Pmod_out_pin10_i;
  output Pmod_out_pin10_o;
  output Pmod_out_pin10_t;
  input Pmod_out_pin1_i;
  output Pmod_out_pin1_o;
  output Pmod_out_pin1_t;
  input Pmod_out_pin2_i;
  output Pmod_out_pin2_o;
  output Pmod_out_pin2_t;
  input Pmod_out_pin3_i;
  output Pmod_out_pin3_o;
  output Pmod_out_pin3_t;
  input Pmod_out_pin4_i;
  output Pmod_out_pin4_o;
  output Pmod_out_pin4_t;
  input Pmod_out_pin7_i;
  output Pmod_out_pin7_o;
  output Pmod_out_pin7_t;
  input Pmod_out_pin8_i;
  output Pmod_out_pin8_o;
  output Pmod_out_pin8_t;
  input Pmod_out_pin9_i;
  output Pmod_out_pin9_o;
  output Pmod_out_pin9_t;
  output wire PWM_interrupt;
  input s_axi_aclk;
  input s_axi_aresetn;

  wire PWM_0_pwm;
  wire [3:0]PWM_AXI_1_ARADDR;
  wire [2:0]PWM_AXI_1_ARPROT;
  wire PWM_AXI_1_ARREADY;
  wire PWM_AXI_1_ARVALID;
  wire [3:0]PWM_AXI_1_AWADDR;
  wire [2:0]PWM_AXI_1_AWPROT;
  wire PWM_AXI_1_AWREADY;
  wire PWM_AXI_1_AWVALID;
  wire PWM_AXI_1_BREADY;
  wire [1:0]PWM_AXI_1_BRESP;
  wire PWM_AXI_1_BVALID;
  wire [31:0]PWM_AXI_1_RDATA;
  wire PWM_AXI_1_RREADY;
  wire [1:0]PWM_AXI_1_RRESP;
  wire PWM_AXI_1_RVALID;
  wire [31:0]PWM_AXI_1_WDATA;
  wire PWM_AXI_1_WREADY;
  wire [3:0]PWM_AXI_1_WSTRB;
  wire PWM_AXI_1_WVALID;
  wire [8:0]S_AXI_1_ARADDR;
  wire S_AXI_1_ARREADY;
  wire S_AXI_1_ARVALID;
  wire [8:0]S_AXI_1_AWADDR;
  wire S_AXI_1_AWREADY;
  wire S_AXI_1_AWVALID;
  wire S_AXI_1_BREADY;
  wire [1:0]S_AXI_1_BRESP;
  wire S_AXI_1_BVALID;
  wire [31:0]S_AXI_1_RDATA;
  wire S_AXI_1_RREADY;
  wire [1:0]S_AXI_1_RRESP;
  wire S_AXI_1_RVALID;
  wire [31:0]S_AXI_1_WDATA;
  wire S_AXI_1_WREADY;
  wire [3:0]S_AXI_1_WSTRB;
  wire S_AXI_1_WVALID;
  wire [2:0]axi_gpio_0_gpio_io_o;
  wire pmod_bridge_0_Pmod_out_PIN10_I;
  wire pmod_bridge_0_Pmod_out_PIN10_O;
  wire pmod_bridge_0_Pmod_out_PIN10_T;
  wire pmod_bridge_0_Pmod_out_PIN1_I;
  wire pmod_bridge_0_Pmod_out_PIN1_O;
  wire pmod_bridge_0_Pmod_out_PIN1_T;
  wire pmod_bridge_0_Pmod_out_PIN2_I;
  wire pmod_bridge_0_Pmod_out_PIN2_O;
  wire pmod_bridge_0_Pmod_out_PIN2_T;
  wire pmod_bridge_0_Pmod_out_PIN3_I;
  wire pmod_bridge_0_Pmod_out_PIN3_O;
  wire pmod_bridge_0_Pmod_out_PIN3_T;
  wire pmod_bridge_0_Pmod_out_PIN4_I;
  wire pmod_bridge_0_Pmod_out_PIN4_O;
  wire pmod_bridge_0_Pmod_out_PIN4_T;
  wire pmod_bridge_0_Pmod_out_PIN7_I;
  wire pmod_bridge_0_Pmod_out_PIN7_O;
  wire pmod_bridge_0_Pmod_out_PIN7_T;
  wire pmod_bridge_0_Pmod_out_PIN8_I;
  wire pmod_bridge_0_Pmod_out_PIN8_O;
  wire pmod_bridge_0_Pmod_out_PIN8_T;
  wire pmod_bridge_0_Pmod_out_PIN9_I;
  wire pmod_bridge_0_Pmod_out_PIN9_O;
  wire pmod_bridge_0_Pmod_out_PIN9_T;
  wire s_axi_aclk_1;
  wire s_axi_aresetn_1;
  wire [0:0]xlslice_0_Dout;
  wire [0:0]xlslice_1_Dout;
  wire [0:0]xlslice_2_Dout;

  assign GPIO_AXI_arready = S_AXI_1_ARREADY;
  assign GPIO_AXI_awready = S_AXI_1_AWREADY;
  assign GPIO_AXI_bresp[1:0] = S_AXI_1_BRESP;
  assign GPIO_AXI_bvalid = S_AXI_1_BVALID;
  assign GPIO_AXI_rdata[31:0] = S_AXI_1_RDATA;
  assign GPIO_AXI_rresp[1:0] = S_AXI_1_RRESP;
  assign GPIO_AXI_rvalid = S_AXI_1_RVALID;
  assign GPIO_AXI_wready = S_AXI_1_WREADY;
  assign PWM_AXI_1_ARADDR = PWM_AXI_araddr[3:0];
  assign PWM_AXI_1_ARPROT = PWM_AXI_arprot[2:0];
  assign PWM_AXI_1_ARVALID = PWM_AXI_arvalid;
  assign PWM_AXI_1_AWADDR = PWM_AXI_awaddr[3:0];
  assign PWM_AXI_1_AWPROT = PWM_AXI_awprot[2:0];
  assign PWM_AXI_1_AWVALID = PWM_AXI_awvalid;
  assign PWM_AXI_1_BREADY = PWM_AXI_bready;
  assign PWM_AXI_1_RREADY = PWM_AXI_rready;
  assign PWM_AXI_1_WDATA = PWM_AXI_wdata[31:0];
  assign PWM_AXI_1_WSTRB = PWM_AXI_wstrb[3:0];
  assign PWM_AXI_1_WVALID = PWM_AXI_wvalid;
  assign PWM_AXI_arready = PWM_AXI_1_ARREADY;
  assign PWM_AXI_awready = PWM_AXI_1_AWREADY;
  assign PWM_AXI_bresp[1:0] = PWM_AXI_1_BRESP;
  assign PWM_AXI_bvalid = PWM_AXI_1_BVALID;
  assign PWM_AXI_rdata[31:0] = PWM_AXI_1_RDATA;
  assign PWM_AXI_rresp[1:0] = PWM_AXI_1_RRESP;
  assign PWM_AXI_rvalid = PWM_AXI_1_RVALID;
  assign PWM_AXI_wready = PWM_AXI_1_WREADY;
  assign Pmod_out_pin10_o = pmod_bridge_0_Pmod_out_PIN10_O;
  assign Pmod_out_pin10_t = pmod_bridge_0_Pmod_out_PIN10_T;
  assign Pmod_out_pin1_o = pmod_bridge_0_Pmod_out_PIN1_O;
  assign Pmod_out_pin1_t = pmod_bridge_0_Pmod_out_PIN1_T;
  assign Pmod_out_pin2_o = pmod_bridge_0_Pmod_out_PIN2_O;
  assign Pmod_out_pin2_t = pmod_bridge_0_Pmod_out_PIN2_T;
  assign Pmod_out_pin3_o = pmod_bridge_0_Pmod_out_PIN3_O;
  assign Pmod_out_pin3_t = pmod_bridge_0_Pmod_out_PIN3_T;
  assign Pmod_out_pin4_o = pmod_bridge_0_Pmod_out_PIN4_O;
  assign Pmod_out_pin4_t = pmod_bridge_0_Pmod_out_PIN4_T;
  assign Pmod_out_pin7_o = pmod_bridge_0_Pmod_out_PIN7_O;
  assign Pmod_out_pin7_t = pmod_bridge_0_Pmod_out_PIN7_T;
  assign Pmod_out_pin8_o = pmod_bridge_0_Pmod_out_PIN8_O;
  assign Pmod_out_pin8_t = pmod_bridge_0_Pmod_out_PIN8_T;
  assign Pmod_out_pin9_o = pmod_bridge_0_Pmod_out_PIN9_O;
  assign Pmod_out_pin9_t = pmod_bridge_0_Pmod_out_PIN9_T;
  assign S_AXI_1_ARADDR = GPIO_AXI_araddr[8:0];
  assign S_AXI_1_ARVALID = GPIO_AXI_arvalid;
  assign S_AXI_1_AWADDR = GPIO_AXI_awaddr[8:0];
  assign S_AXI_1_AWVALID = GPIO_AXI_awvalid;
  assign S_AXI_1_BREADY = GPIO_AXI_bready;
  assign S_AXI_1_RREADY = GPIO_AXI_rready;
  assign S_AXI_1_WDATA = GPIO_AXI_wdata[31:0];
  assign S_AXI_1_WSTRB = GPIO_AXI_wstrb[3:0];
  assign S_AXI_1_WVALID = GPIO_AXI_wvalid;
  assign pmod_bridge_0_Pmod_out_PIN10_I = Pmod_out_pin10_i;
  assign pmod_bridge_0_Pmod_out_PIN1_I = Pmod_out_pin1_i;
  assign pmod_bridge_0_Pmod_out_PIN2_I = Pmod_out_pin2_i;
  assign pmod_bridge_0_Pmod_out_PIN3_I = Pmod_out_pin3_i;
  assign pmod_bridge_0_Pmod_out_PIN4_I = Pmod_out_pin4_i;
  assign pmod_bridge_0_Pmod_out_PIN7_I = Pmod_out_pin7_i;
  assign pmod_bridge_0_Pmod_out_PIN8_I = Pmod_out_pin8_i;
  assign pmod_bridge_0_Pmod_out_PIN9_I = Pmod_out_pin9_i;
  assign s_axi_aclk_1 = s_axi_aclk;
  assign s_axi_aresetn_1 = s_axi_aresetn;
  PmodAMP2_PWM_0_0 PWM_0
       (.pwm(PWM_0_pwm),
        .interrupt(PWM_interrupt),
        .pwm_axi_aclk(s_axi_aclk_1),
        .pwm_axi_araddr(PWM_AXI_1_ARADDR),
        .pwm_axi_aresetn(s_axi_aresetn_1),
        .pwm_axi_arprot(PWM_AXI_1_ARPROT),
        .pwm_axi_arready(PWM_AXI_1_ARREADY),
        .pwm_axi_arvalid(PWM_AXI_1_ARVALID),
        .pwm_axi_awaddr(PWM_AXI_1_AWADDR),
        .pwm_axi_awprot(PWM_AXI_1_AWPROT),
        .pwm_axi_awready(PWM_AXI_1_AWREADY),
        .pwm_axi_awvalid(PWM_AXI_1_AWVALID),
        .pwm_axi_bready(PWM_AXI_1_BREADY),
        .pwm_axi_bresp(PWM_AXI_1_BRESP),
        .pwm_axi_bvalid(PWM_AXI_1_BVALID),
        .pwm_axi_rdata(PWM_AXI_1_RDATA),
        .pwm_axi_rready(PWM_AXI_1_RREADY),
        .pwm_axi_rresp(PWM_AXI_1_RRESP),
        .pwm_axi_rvalid(PWM_AXI_1_RVALID),
        .pwm_axi_wdata(PWM_AXI_1_WDATA),
        .pwm_axi_wready(PWM_AXI_1_WREADY),
        .pwm_axi_wstrb(PWM_AXI_1_WSTRB),
        .pwm_axi_wvalid(PWM_AXI_1_WVALID));
  PmodAMP2_axi_gpio_0_0 axi_gpio_0
       (.gpio_io_o(axi_gpio_0_gpio_io_o),
        .s_axi_aclk(s_axi_aclk_1),
        .s_axi_araddr(S_AXI_1_ARADDR),
        .s_axi_aresetn(s_axi_aresetn_1),
        .s_axi_arready(S_AXI_1_ARREADY),
        .s_axi_arvalid(S_AXI_1_ARVALID),
        .s_axi_awaddr(S_AXI_1_AWADDR),
        .s_axi_awready(S_AXI_1_AWREADY),
        .s_axi_awvalid(S_AXI_1_AWVALID),
        .s_axi_bready(S_AXI_1_BREADY),
        .s_axi_bresp(S_AXI_1_BRESP),
        .s_axi_bvalid(S_AXI_1_BVALID),
        .s_axi_rdata(S_AXI_1_RDATA),
        .s_axi_rready(S_AXI_1_RREADY),
        .s_axi_rresp(S_AXI_1_RRESP),
        .s_axi_rvalid(S_AXI_1_RVALID),
        .s_axi_wdata(S_AXI_1_WDATA),
        .s_axi_wready(S_AXI_1_WREADY),
        .s_axi_wstrb(S_AXI_1_WSTRB),
        .s_axi_wvalid(S_AXI_1_WVALID));
  PmodAMP2_pmod_bridge_0_0 pmod_bridge_0
       (.in0_O(PWM_0_pwm),
        .in0_T(0),
        .in1_O(xlslice_0_Dout),
        .in1_T(0),
        .in2_O(xlslice_1_Dout),
        .in2_T(0),
        .in3_O(xlslice_2_Dout),
        .in3_T(0),
        .out0_I(pmod_bridge_0_Pmod_out_PIN1_I),
        .out0_O(pmod_bridge_0_Pmod_out_PIN1_O),
        .out0_T(pmod_bridge_0_Pmod_out_PIN1_T),
        .out1_I(pmod_bridge_0_Pmod_out_PIN2_I),
        .out1_O(pmod_bridge_0_Pmod_out_PIN2_O),
        .out1_T(pmod_bridge_0_Pmod_out_PIN2_T),
        .out2_I(pmod_bridge_0_Pmod_out_PIN3_I),
        .out2_O(pmod_bridge_0_Pmod_out_PIN3_O),
        .out2_T(pmod_bridge_0_Pmod_out_PIN3_T),
        .out3_I(pmod_bridge_0_Pmod_out_PIN4_I),
        .out3_O(pmod_bridge_0_Pmod_out_PIN4_O),
        .out3_T(pmod_bridge_0_Pmod_out_PIN4_T),
        .out4_I(pmod_bridge_0_Pmod_out_PIN7_I),
        .out4_O(pmod_bridge_0_Pmod_out_PIN7_O),
        .out4_T(pmod_bridge_0_Pmod_out_PIN7_T),
        .out5_I(pmod_bridge_0_Pmod_out_PIN8_I),
        .out5_O(pmod_bridge_0_Pmod_out_PIN8_O),
        .out5_T(pmod_bridge_0_Pmod_out_PIN8_T),
        .out6_I(pmod_bridge_0_Pmod_out_PIN9_I),
        .out6_O(pmod_bridge_0_Pmod_out_PIN9_O),
        .out6_T(pmod_bridge_0_Pmod_out_PIN9_T),
        .out7_I(pmod_bridge_0_Pmod_out_PIN10_I),
        .out7_O(pmod_bridge_0_Pmod_out_PIN10_O),
        .out7_T(pmod_bridge_0_Pmod_out_PIN10_T));
  PmodAMP2_xlslice_0_0 xlslice_0
       (.Din(axi_gpio_0_gpio_io_o),
        .Dout(xlslice_0_Dout));
  PmodAMP2_xlslice_0_1 xlslice_1
       (.Din(axi_gpio_0_gpio_io_o),
        .Dout(xlslice_1_Dout));
  PmodAMP2_xlslice_0_2 xlslice_2
       (.Din(axi_gpio_0_gpio_io_o),
        .Dout(xlslice_2_Dout));
endmodule
