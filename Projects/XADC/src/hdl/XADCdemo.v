`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Samuel Lowe
// 
// Create Date: 4/14/2016
// Design Name: Cmod A7 Xadc reference project 
// Module Name: XADC
// Target Devices: Digilent Cmod A7 15t rev. B
// Tool Versions: Vivado 2015.4
// Description: Demo that will take input from a button to decide which xadc channel to drive a pwm'd led
// Dependencies: 
// 
// Revision:  
// Revision 0.01 - File Created
// Additional Comments: 
//               
// 
//////////////////////////////////////////////////////////////////////////////////
 

module XADCdemo(
    input clk,
    input [3:0] sw,
    output [7:0] data_out,
    output [3:0] led,
//    output pio,
    input [3:0] xa_n,
    input [3:0] xa_p
 );
   
    //XADC signals
    wire enable;                     //enable into the xadc to continuosly get data out
    reg [6:0] Address_in = 7'h14;    //Adress of register in XADC drp corresponding to data
    wire ready;                      //XADC port that declares when data is ready to be taken
    wire [15:0] data;                //XADC data   
    reg [15:0] data0, data1, data2, data3;
//    wire [11:0] shifted_data;
    wire [11:0] shifted_data0, shifted_data1, shifted_data2, shifted_data3;
    
//    reg [32:0] decimal;              //Shifted data to convert to digits
    wire [4:0] channel_out;
    reg [1:0] sel;
    
    //xadc block needs a 100 MHz clk
//    wire clk;

//    clk_wiz_0 CLKWIZ (
//        clk_in1  (sysclk),
//        clk_out1 (clk)
//    );
    
    
    
    ///////////////////////////////////////////////////////////////////
    //XADC Instantiation
    //////////////////////////////////////////////////////////////////
    
    xadc_wiz_0  XLXI_7 (
        .daddr_in    (Address_in), 
        .dclk_in     (clk), 
        .den_in      (enable & |sw), 
        .di_in       (),
        .dwe_in      (),
        .busy_out    (),
        .vauxp15     (xa_p[2]),
        .vauxn15     (xa_n[2]),
        .vauxp14     (xa_p[0]),
        .vauxn14     (xa_n[0]),               
        .vauxp7      (xa_p[1]),
        .vauxn7      (xa_n[1]),
        .vauxp6      (xa_p[3]),
        .vauxn6      (xa_n[3]),               
        .do_out      (data),
        
        .eoc_out     (enable),
        .channel_out (channel_out),
        .drdy_out    (ready)
    );
                     

                                  
    ///////////////////////////////////////////////////////////////////
    //Address Handling Controlled by button
    //////////////////////////////////////////////////////////////////      
    
    always @(sel)      
        case(sel)
        0: Address_in <= 8'h1e;
        1: Address_in <= 8'h17;  
        2: Address_in <= 8'h1f;  
        3: Address_in <= 8'h16;
        default: Address_in <= 8'h14;
        endcase
    always@(negedge ready)
        case (sel)//next select is always next enabled channel, example: sel=0, sw=1001 -> sel=3
        0: sel <= (sw[1] ? 1 : (sw[2] ? 2 : (sw[3] ? 3 : 0)));
        1: sel <= (sw[2] ? 2 : (sw[3] ? 3 : (sw[0] ? 0 : 1)));
        2: sel <= (sw[3] ? 3 : (sw[0] ? 0 : (sw[1] ? 1 : 2)));
        3: sel <= (sw[0] ? 0 : (sw[1] ? 1 : (sw[2] ? 2 : 3)));
        default: sel <= 0;
        endcase
    assign data_out = {ready, 2'b0, channel_out[4:0]};
    always@(posedge ready) begin
        case (sel)
        0: data0 <= (channel_out == 8'h1E) ? data : data0;
        1: data1 <= (channel_out == 8'h17) ? data : data1;
        2: data2 <= (channel_out == 8'h1F) ? data : data2;
        3: data3 <= (channel_out == 8'h16) ? data : data3;
        endcase
    
//        if (sw[0] == 1'b1 && channel_out == 8'h1e)
//            data0 <= data;
//        else if (sw[0] == 1'b0)
//            data0 <= 'b0;
            
//        if (sw[1] == 1'b1 && channel_out == 8'h17)
//            data1 <= data;
//        else if (sw[1] == 1'b0)
//            data1 <= 'b0;
            
//        if (sw[2] == 1'b1 && channel_out == 8'h1f)
//            data2 <= data;
//        else if (sw[2] == 1'b0)
//            data2 <= 'b0;
            
//        if (sw[3] == 1'b1 && channel_out == 8'h16)
//            data3 <= data;
//        else if (sw[3] == 1'b0)
//            data3 <= 'b0;
    end
    ///////////////////////////////////////////////////////////////////
    //LED PWM
    //////////////////////////////////////////////////////////////////  
    
    integer pwm_end = 4070;
    //filter out tiny noisy part of signal to achieve zero at ground
    assign shifted_data0 = (data0 >> 4) & 12'hff0;
    assign shifted_data1 = (data1 >> 4) & 12'hff0;
    assign shifted_data2 = (data2 >> 4) & 12'hff0;
    assign shifted_data3 = (data3 >> 4) & 12'hff0;

    integer pwm_count = 0;
//    reg pwm_out = 0;
   

    //Pwm the data to show the voltage level
    always @(posedge(clk))begin
        if(pwm_count < pwm_end)begin
            pwm_count = pwm_count+1;
        end           
        else begin
            pwm_count=0;
        end
    end
    //leds are active high
    assign led[0] = (sw[0] == 1'b0) ? 1'b0 : (pwm_count < shifted_data0 ? 1'b1 : 1'b0);
    assign led[1] = (sw[1] == 1'b0) ? 1'b0 : (pwm_count < shifted_data1 ? 1'b1 : 1'b0);
    assign led[2] = (sw[2] == 1'b0) ? 1'b0 : (pwm_count < shifted_data2 ? 1'b1 : 1'b0);
    assign led[3] = (sw[3] == 1'b0) ? 1'b0 : (pwm_count < shifted_data3 ? 1'b1 : 1'b0);
       
endmodule
