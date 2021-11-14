`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 01.05.2021 18:52:22
// Design Name: 
// Module Name: Temperature_sensor_top
// Project Name:  
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Temperature_sensor_top(
         output AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0, 
         output CA, CB, CC, CD, CE, CF, CG, DP,
         output TMP_INT_out, TMP_CT_out,
         output Tcritical, Thigh, Tlow,
         output SCL, 
         inout  SDA, 
         input  [3:0] Register_select,
         input  TMP_INT, TMP_CT,       
 	    input  Clock_100MHz, Clear_n);
    
 wire [15:0] sensor_out; 
 
 assign TMP_INT_out = TMP_INT;
 assign TMP_CT_out  = TMP_CT;
 
Temperature_sensor temp_sensor_DUT (
   .Sensor_out(sensor_out), 
   .Tcritical(Tcritical), .Thigh(Thigh), .Tlow(Tlow),
   .SCL(SCL), .SDA(SDA),
   .Register_select(Register_select),
   .Clock_100MHz(Clock_100MHz), .Clear_n(Clear_n));   
 

BCD_to_7_segment_LED_Decoder bcd_to_7_seg_LED_DUT (
   .DP(DP),
   .Cathodes({CA,CB,CC,CD,CE,CF,CG}), 
   .Anodes({AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0}),                                                       
   .Clock_100MHz(Clock_100MHz), .Clear_n(Clear_n),
   .Enable(1'b1), .In(sensor_out));   
    
endmodule
