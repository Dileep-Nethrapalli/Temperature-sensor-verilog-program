`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 02.05.2021 17:56:43
// Design Name: 
// Module Name: Temperature_sensor_tb
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


module Temperature_sensor_tb( );

 wire SCL, SDA;
 wire [5:0]  present_state;
 wire [7:0]  count_130;
 wire [15:0] sensor_out;
 
 reg SDA_reg, Clock_100MHz, Clear_n;
 reg [3:0]  Register_select;

  Temperature_sensor temp_sensor_DUT(
    .Sensor_out(sensor_out), 
    .Tcritical(), .Thigh(), .Tlow(),
    .SCL(SCL), .SDA(SDA),  
    .Register_select(Register_select),      
    .Clock_100MHz(Clock_100MHz), 
    .Clear_n(Clear_n));
                     
  assign count_130 =  temp_sensor_DUT.count_130;
  assign present_state = temp_sensor_DUT.present_state;
                     
  initial   Clock_100MHz = 0;
  always #5 Clock_100MHz = ~Clock_100MHz;   
 
  always@(present_state)
     case(present_state)
       10, 19, 29, 38: SDA_reg = 0;
       30, 31, 32, 33, 34, 35, 36, 37,
       39, 40, 41, 42, 43, 44, 45, 46: SDA_reg = $random;
       default: SDA_reg = 1'bz;   
     endcase 
     
  assign SDA = SDA_reg;   
 
  initial
   begin
          Clear_n = 0;
          Register_select = 4'hB;  // ID
     #100 Clear_n = 1;
     #110000 $finish;   
   end            

endmodule
