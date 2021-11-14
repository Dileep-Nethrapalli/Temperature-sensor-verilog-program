`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli 
// 
// Create Date: 01.05.2021 11:29:17
// Design Name: 
// Module Name: Temperature_sensor
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


module Temperature_sensor( 
         output reg [15:0] Sensor_out, 
         output reg Tcritical, Thigh, Tlow,
         output reg SCL, 
         inout  SDA,
         input  [3:0] Register_select,
         input  Clock_100MHz, Clear_n);         
         
         reg den, sda_reg;         
         reg [7:0] apr;
         reg [6:0] sba = 7'h4B;
         

  // Generate a 400KHz clock
   // 400KHz = 2.5us = 2.6us
   // 2.6us clock = 1.3us ON + 1.3us OFF
   // 100MHz = 10ns = 1;  1.3us = x; x = 130;
   // 129 = 1000_0001b   
  
   reg clock_400KHz;
   reg [7:0] count_130;   
   
   always@(posedge Clock_100MHz, negedge Clear_n)
     if(!Clear_n)
       begin
         count_130 <= 0;
         clock_400KHz <= 0;
       end
     else if(count_130 == 129)
       begin
         count_130 <= 0;
         clock_400KHz <= ~clock_400KHz;
       end
     else
        count_130 <= count_130 + 1;  
                
         
 // FSM for Temperature_sensor
   // SERIAL BUS ADDRESS = SBA
   // ADDRESS POINTER REGISTER = APR
   
  parameter [5:0] 
    RESET = 6'd0, START = 6'd1,
    WR_SBA_6 = 6'd2, WR_SBA_5 = 6'd3, 
    WR_SBA_4 = 6'd4, WR_SBA_3 = 6'd5, 
    WR_SBA_2 = 6'd6, WR_SBA_1 = 6'd7, 
    WR_SBA_0 = 6'd8, WRITE = 6'd9, 
    WR_SBA_ACK = 6'd10, 
                  
    APR_7 = 6'd11, APR_6 = 6'd12, 
    APR_5 = 6'd13, APR_4 = 6'd14,
    APR_3 = 6'd15, APR_2 = 6'd16, 
    APR_1 = 6'd17, APR_0 = 6'd18, 
    APR_ACK = 6'd19, 
    
    RE_START = 6'd20, 
    RD_SBA_6 = 6'd21, RD_SBA_5 = 6'd22, 
    RD_SBA_4 = 6'd23, RD_SBA_3 = 6'd24, 
    RD_SBA_2 = 6'd25, RD_SBA_1 = 6'd26, 
    RD_SBA_0 = 6'd27, READ = 6'd28, 
    RD_SBA_ACK = 6'd29,
                  
    DATA_15 = 6'd30, DATA_14 = 6'd31, 
    DATA_13 = 6'd32, DATA_12 = 6'd33, 
    DATA_11 = 6'd34, DATA_10 = 6'd35, 
    DATA_9  = 6'd36, DATA_8  = 6'd37,
    DATA_ACK = 6'd38,    
    DATA_7 = 6'd39, DATA_6 = 6'd40, 
    DATA_5 = 6'd41, DATA_4 = 6'd42, 
    DATA_3 = 6'd43, DATA_2 = 6'd44, 
    DATA_1 = 6'd45, DATA_0 = 6'd46,  
    NO_ACK = 6'd47, 
    
    STOP = 6'd48, FINISH = 6'd49;    
         
  reg [5:0] present_state, next_state;  
 
// FSM Sequential block
   always@(negedge clock_400KHz, negedge Clear_n)
     if(!Clear_n)  
        present_state <= RESET; 
     else
        present_state <= next_state;          
        
// FSM Combinational block
always@(present_state, clock_400KHz, count_130, SDA, sba, apr)  
 case(present_state)
  RESET: begin SCL = 1; den = 1; sda_reg = 1; 
               next_state = START; 
         end  
  START: begin SCL = 1; den = 1; sda_reg = 0; 
               next_state = WR_SBA_6; 
         end 
  
  WR_SBA_6: begin SCL = clock_400KHz; den = 1; 
                  Data(0, sba[6]); next_state = WR_SBA_5; 
            end  
  WR_SBA_5: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[6], sba[5]); next_state = WR_SBA_4;
            end       
  WR_SBA_4: begin SCL = clock_400KHz; den = 1;
                  Data(sba[5], sba[4]); next_state = WR_SBA_3;
            end  
  WR_SBA_3: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[4], sba[3]); next_state = WR_SBA_2;
            end  
  WR_SBA_2: begin SCL = clock_400KHz; den = 1;
                  Data(sba[3], sba[2]); next_state = WR_SBA_1;
            end  
  WR_SBA_1: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[2], sba[1]); next_state = WR_SBA_0;
            end  
  WR_SBA_0: begin SCL = clock_400KHz; den = 1;
                  Data(sba[1], sba[0]); next_state = WRITE;
            end 
  WRITE: begin SCL = clock_400KHz; den = 1; 
               Data(sba[0], 0); next_state = WR_SBA_ACK; 
         end 
  WR_SBA_ACK: begin 
                SCL = clock_400KHz; Enable(1, 0); Data(0, 1);
                if(!SDA) next_state = APR_7; 
                else     next_state = present_state;
              end 
  
  APR_7: begin SCL = clock_400KHz; Enable(0, 1); 
               Data(1, apr[7]); next_state = APR_6; 
         end 
  APR_6: begin SCL = clock_400KHz; den = 1; 
               Data(apr[7], apr[6]); next_state = APR_5; 
         end  
  APR_5: begin SCL = clock_400KHz; den = 1; 
               Data(apr[6], apr[5]); next_state = APR_4;
         end  
  APR_4: begin SCL = clock_400KHz; den = 1; 
               Data(apr[5], apr[4]); next_state = APR_3; 
         end  
  APR_3: begin SCL = clock_400KHz; den = 1; 
               Data(apr[4], apr[3]); next_state = APR_2;
         end  
  APR_2: begin SCL = clock_400KHz; den = 1; 
               Data(apr[3], apr[2]); next_state = APR_1; 
         end  
  APR_1: begin SCL = clock_400KHz; den = 1; 
               Data(apr[2], apr[1]); next_state = APR_0; 
         end  
  APR_0: begin SCL = clock_400KHz; den = 1; 
               Data(apr[1], apr[0]); next_state = APR_ACK; 
         end   
  APR_ACK: begin SCL = clock_400KHz; Enable(1, 0);
                 Data(apr[0], 1);  
                 if(!SDA) next_state = RE_START;
                 else     next_state = present_state; 
           end 
  
  RE_START: begin 
              SCL = clock_400KHz; next_state = RD_SBA_6;
              if(!clock_400KHz)
                 begin den = 0; sda_reg = 1; end
              else if((clock_400KHz) && (count_130 < 60)) 
                 begin den = 1; sda_reg = 1; end                   
              else 
                 begin den = 1; sda_reg = 0; end 
            end               
 
  RD_SBA_6: begin SCL = clock_400KHz; den = 1; 
                  Data(0, sba[6]); next_state = RD_SBA_5; 
            end  
  RD_SBA_5: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[6], sba[5]); next_state = RD_SBA_4;
            end  
  RD_SBA_4: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[5], sba[4]); next_state = RD_SBA_3; 
            end  
  RD_SBA_3: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[4], sba[3]); next_state = RD_SBA_2;
            end  
  RD_SBA_2: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[3], sba[2]); next_state = RD_SBA_1;
            end  
  RD_SBA_1: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[2], sba[1]); next_state = RD_SBA_0;
            end  
  RD_SBA_0: begin SCL = clock_400KHz; den = 1; 
                  Data(sba[1], sba[0]); next_state = READ; 
            end 
  READ: begin SCL = clock_400KHz; den = 1; Data(sba[0], 1);
              next_state = RD_SBA_ACK; 
        end 
  RD_SBA_ACK: begin 
                SCL = clock_400KHz; Enable(1, 0); Data(1, 1);   
                if(!SDA) 
                   if((apr == 8'h00) || (apr == 8'h04) || 
                      (apr == 8'h06) || (apr == 8'h08))
                       next_state = DATA_15;
                   else
                       next_state = DATA_7;  
                else  
                  next_state = present_state; 
              end 
 
  DATA_15: begin 
             SCL = clock_400KHz; den = 0; sda_reg = 1;
             next_state = DATA_14; 
           end 
  DATA_14: begin 
             SCL = clock_400KHz; den = 0; sda_reg = 1;
             next_state = DATA_13; 
           end  
  DATA_13: begin 
             SCL = clock_400KHz; den = 0; sda_reg = 1;
             next_state = DATA_12;
           end  
  DATA_12: begin 
              SCL = clock_400KHz; den = 0; sda_reg = 1;
              next_state = DATA_11; 
           end  
  DATA_11: begin 
             SCL = clock_400KHz; den = 0; sda_reg = 1;
             next_state = DATA_10; 
           end  
  DATA_10: begin
             SCL = clock_400KHz; den = 0; sda_reg = 1;
             next_state = DATA_9; 
           end  
  DATA_9: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_8;  
          end  
  DATA_8: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_ACK; 
          end   
  DATA_ACK: begin 
              SCL = clock_400KHz; Enable(0, 1); Data(1, 0);
              next_state = DATA_7; 
            end                  
  DATA_7: begin 
            SCL = clock_400KHz; Enable(1, 0); Data(0, 1);
            next_state = DATA_6; 
         end 
  DATA_6: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_5; 
          end  
  DATA_5: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_4; 
          end  
  DATA_4: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_3; 
          end  
  DATA_3: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_2; 
          end  
  DATA_2: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_1; 
          end  
  DATA_1: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = DATA_0; 
          end  
  DATA_0: begin 
            SCL = clock_400KHz; den = 0; sda_reg = 1;
            next_state = NO_ACK; 
          end   
  NO_ACK: begin
            SCL = clock_400KHz; Enable(0, 1); Data(1, 1); 
            next_state = STOP; 
          end                  
                   
  STOP: begin 
          SCL = clock_400KHz; next_state = FINISH;
          if((!clock_400KHz) && (count_130 < 60))
             begin den = 1; sda_reg = 1; end
          else if(((!clock_400KHz) && (count_130 >= 60)) || 
                  ((clock_400KHz)  && (count_130 < 60))) 
             begin den = 1; sda_reg = 0; end                   
          else 
             begin den = 1; sda_reg = 1; end 
        end 
             
  FINISH: begin 
            SCL = 1; den = 1; sda_reg = 1; next_state = START;
          end
  default: begin 
             SCL = 1; den = 1; sda_reg = 1; 
             next_state = RESET; 
           end                                                           
 endcase  
 
 
 task Data(input data_hold, data_setup);
        if((!SCL) && (count_130 < 60))
           sda_reg = data_hold;
        else
           sda_reg = data_setup; 
 endtask  
 
 task Enable(input den_hold,  den_setup);
        if((!SCL) && (count_130 < 60))           
            den = den_hold;             
        else
            den = den_setup;
 endtask   
 
 assign SDA = den ? sda_reg : 1'bz;  
 
 
// Capture Data generated by Temperature sensor
   reg [15:0] data;
   
   always@(posedge clock_400KHz, negedge Clear_n)
     if(!Clear_n)  
        data <= {16{1'b0}}; 
     else 
       case(present_state) 
         DATA_15: data[15] <= SDA;
         DATA_14: data[14] <= SDA;
         DATA_13: data[13] <= SDA;
         DATA_12: data[12] <= SDA;
         DATA_11: data[11] <= SDA;
         DATA_10: data[10] <= SDA;         
         DATA_9:  data[9]  <= SDA;
         DATA_8:  data[8]  <= SDA;
         DATA_7:  data[7]  <= SDA;
         DATA_6:  data[6]  <= SDA;
         DATA_5:  data[5]  <= SDA;
         DATA_4:  data[4]  <= SDA;
         DATA_3:  data[3]  <= SDA;
         DATA_2:  data[2]  <= SDA;
         DATA_1:  data[1]  <= SDA;
         DATA_0:  data[0]  <= SDA;
       endcase 
       
  
// Generate Register_select
  always@(posedge clock_400KHz, negedge Clear_n)
   if(!Clear_n)  
      apr <= 8'h00; 
   else if(present_state == START) 
     case(Register_select)      
          0:  apr <= 8'h00;
          1:  apr <= 8'h01;
          2:  apr <= 8'h02;
          3:  apr <= 8'h03;
          4:  apr <= 8'h04;
          5:  apr <= 8'h05;
          6:  apr <= 8'h06;
          7:  apr <= 8'h07;
          8:  apr <= 8'h08;
          9:  apr <= 8'h09;
          10: apr <= 8'h0A;
          11: apr <= 8'h0B;
          default: apr <= 8'hFF;
      endcase  
     
  
// Generate sensor output 
 always@(posedge clock_400KHz, negedge Clear_n)
   if(!Clear_n)       
      {Tcritical, Thigh, Tlow, Sensor_out} <= {19{1'b0}};             
   else if(present_state == FINISH)   
        // 16-bit Temperature
     if((apr == 8'h00))      
        begin
          if(data[15]) // Negative Number 
             Sensor_out <= (data[14:3] - 4096)/16;             
          else  // Positive Number
             Sensor_out <= data[14:3]/16;     
      {Tcritical, Thigh, Tlow} <= {data[2], data[1], data[0]};
        end         
     else if(apr == 8'h01)  // 8-bit Temperature
        begin
          Sensor_out <= data[7:3]/16;
      {Tcritical, Thigh, Tlow} <= {data[2], data[1], data[0]};
        end   
            // Thigh, Tlow, Tcrit MSB and LSB
     else if((apr == 8'h04) || (apr == 8'h06) || 
             (apr == 8'h08))
       begin
         if(data[15]) // Negative Number 
            Sensor_out <= (data[14:3] - 4096)/16;             
         else  // Positive Number
            Sensor_out <= data[14:3]/16; 
         {Tcritical, Thigh, Tlow} <= {3{1'b0}};         
       end 
     else if(apr == 8'hFF) // Not supported commands
        begin  
          Sensor_out <= {16{1'b0}};  
          {Tcritical, Thigh, Tlow} <= {3{1'b0}};
        end               
       // Status, Configuration, Thigh LSB, Tlow LSB, Tcrit LSB, Thyst, ID   
     else 
       begin  
         Sensor_out <= data[7:0];  
         {Tcritical, Thigh, Tlow} <= {3{1'b0}};
       end  
          
endmodule