`timescale 1ns/1ns

//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 26.09.2021 15:00:05
// Design Name: 
// Module Name: BCD_to_7_segment_LED_Decoder
// Project Name: 
// Target Devices: Device Independent 
// Tool Versions: 
// Description: 
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BCD_to_7_segment_LED_Decoder(
         output reg DP,  // Decimal point selection for 7_seg_LED Display
         output reg [6:0] Cathodes, // Cathode selection for 7_seg_LED Display
         output reg [7:0] Anodes,   //Anode selection for 7_seg_LED Display
         input [26:0] In,
         input Enable, Clock_100MHz, Clear_n);
 
         reg clock_8KHz;  
         reg [31:0] BCD;   
                
            
//Convert Decimal number(In) to BCD number(BCD)
 always@(posedge clock_8KHz, negedge Clear_n)
   if(!Clear_n)
      BCD <= 0;
   else   
      BCD <= ((In/10**7)*(16**6)*6) + ((In/10**6)*(16**5)*6) +
             ((In/10**5)*(16**4)*6) + ((In/10**4)*(16**3)*6) +
             ((In/10**3)*(16**2)*6) + ((In/10**2)*(16**1)*6) +
             ((In/10**1)*(16**0)*6) +   In;  
                    
    
 // This program uses 1ms refresh scheme for 7-segment_LED display,
  // i.e all eight digits are driven once every 1ms
  // There are 8 digits, so create a clock of 1ms/8 = 125 탎(8 KHz)
  // 125 탎 clock = 62.5 탎 on + 62.5 탎 off
  // 10 ns = 1; 62.5 탎 = x; x = 6250; 
  // 6249 = 1_1000_0110_1001b
  
    reg [12:0] count_6250; 
  
    always@(posedge Clock_100MHz, negedge Clear_n)
       if(!Clear_n)
          begin
            count_6250 <= 0;
            clock_8KHz <= 0;
          end          
       else if(count_6250 == 6249)
          begin
            count_6250 <= 0;
            clock_8KHz <= ~clock_8KHz;                                
          end
        else if(Enable)
            count_6250 <= count_6250 + 1;             
          
          
 // Generate Anode assert for 7-segment LED
  // 7 for Digit 7, ------  0 for Digit 0   
     reg [2:0] Digit;
     
     always@(posedge clock_8KHz, negedge Clear_n)
        if(!Clear_n)
           Digit <= 0;          
        else if(Digit == 7) 
           Digit <= 0;                    
        else if(Enable)
           Digit <= Digit + 1;  
           
          
  // Make assignments to Anodes and Cathodes based on In
  always@(negedge clock_8KHz, negedge Clear_n)
    if(!Clear_n)
      begin 
        DP <= 1;
        Anodes   <= 8'b11111110;
        Decoder(4'd0);  // 0
      end   
    else if(In <= 9)   
       case(Digit)  //Assert AN0
               0 : Digit_0;
         default : Digit_disable;          
       endcase         
    else if((In >= 10) && (In <= 99)) 
       case(Digit)  //Assert AN0,AN1
               0 : Digit_0;
               1 : Digit_1;
         default : Digit_disable;  
       endcase         
    else if((In >= 100) && (In <= 999))     
       case(Digit)  //Assert AN0,AN1,AN2 
               0 : Digit_0;
               1 : Digit_1;
               2 : Digit_2;
         default : Digit_disable; 
       endcase       
    else if((In >= 1000) && (In <= 9999)) 
        case(Digit)  //Assert AN0,AN1,AN2,AN3
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
          default : Digit_disable;       
        endcase        
    else if((In >= 10000) && (In <= 99999)) 
        case(Digit)  //Assert AN0,AN1,AN2,AN3,AN4
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
          default : Digit_disable;      
        endcase         
    else if((In >= 100000) && (In <= 999999)) 
        case(Digit)  //Assert AN0,AN1,AN2,AN3,AN4,AN5
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
                5 : Digit_5;
          default : Digit_disable;      
        endcase 
   else if((In >= 1000000) && (In <= 9999999)) 
        case(Digit)  //Assert AN0,AN1,AN2,AN3,AN4,AN5,AN6
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
                5 : Digit_5;
                6 : Digit_6;
          default : Digit_disable;      
        endcase   
   else if((In >= 10000000) && (In <= 99999999))  
        case(Digit)  //Assert AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7 
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
                5 : Digit_5;
                6 : Digit_6;
                7 : Digit_7;
        endcase 
   else // Display OVER FLOW if In is greaterthan 99999999
     case(Digit)
          7 : begin
                DP <= 1;
                Anodes <= 8'b01111111;
                Cathodes <= 7'b0000001; // O
              end
          6 : begin 
                DP <= 1;
                Anodes <= 8'b10111111;
                Cathodes <= 7'b1000001; // U = V
              end                       
          5 : begin
                DP <= 1;
                Anodes <= 8'b11011111;
                Cathodes <= 7'b0110000; // E
              end                        
          4 : begin
                DP <= 1;
                Anodes <= 8'b11101111;
                Cathodes <= 7'b0001000; // R
              end  
          3 : begin
                DP <= 1;
                Anodes <= 8'b11110111;
                Cathodes <= 7'b0111000; // F
              end
           2 : begin
                 DP <= 1;
                 Anodes <= 8'b11111011;
                 Cathodes <= 7'b1110001; // L
               end                        
          1 : begin
                DP <= 1;
                Anodes <= 8'b11111101;
                Cathodes <= 7'b0000001; // O
              end                       
          0 : begin
                DP <= 1;
                Anodes <= 8'b11111110;
                Cathodes <= 7'b1000001; // U = W
              end
        endcase               
    
  task Digit_disable;
    begin  
      DP <= 1;
      Anodes <= 8'b11111111;
      Decoder(4'b1111);
     end  
  endtask        
               
  task Digit_0;
    begin
      DP <= 1;
      Anodes <= 8'b11111110;
      Decoder(BCD[3:0]);
    end  
  endtask  
    
  task Digit_1;
    begin
      DP <= 1;
      Anodes <= 8'b11111101;
      Decoder(BCD[7:4]);
    end  
  endtask     
    
  task Digit_2;
    begin
      DP <= 1;
      Anodes <= 8'b11111011;
      Decoder(BCD[11:8]);
    end  
  endtask 
    
  task Digit_3;
    begin
      DP <= 1;
      Anodes <= 8'b11110111;
      Decoder(BCD[15:12]);
    end  
  endtask  
    
  task Digit_4;
    begin
      DP <= 1;
      Anodes <= 8'b11101111;
      Decoder(BCD[19:16]);
    end  
  endtask 
    
  task Digit_5;
    begin
      DP <= 1;
      Anodes <= 8'b11011111;
      Decoder(BCD[23:20]);
    end  
  endtask 

  task Digit_6;
    begin
      DP <= 1;
      Anodes <= 8'b10111111;
      Decoder(BCD[27:24]);
    end  
  endtask 
    
  task Digit_7;
    begin
      DP <= 1;
      Anodes <= 8'b01111111;
      Decoder(BCD[31:28]);
    end  
  endtask  
   
    
  // Enable Cathodes of a digit       
   task Decoder;
     input [3:0] BCD_Number;
      case(BCD_Number)  //Assign values to 7 segment LED's A as MSB, G as LSB
             0:  Cathodes <= 7'b0000001; // 0
             1:  Cathodes <= 7'b1001111; // 1
             2:  Cathodes <= 7'b0010010; // 2
             3:  Cathodes <= 7'b0000110; // 3
             4:  Cathodes <= 7'b1001100; // 4
             5:  Cathodes <= 7'b0100100; // 5
             6:  Cathodes <= 7'b0100000; // 6
             7:  Cathodes <= 7'b0001111; // 7
             8:  Cathodes <= 7'b0000000; // 8
             9:  Cathodes <= 7'b0000100; // 9
        default: Cathodes <= 7'b1111111; // Disble all cathodes          
       endcase                 
    endtask    
   
 endmodule
