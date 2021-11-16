// 16 : 1 multiplexer
module mux_8(sel, inp, out) ; 
  input [2:0] sel ;
  input [7:0] inp ;
  output out ;
  assign out = inp[sel] ;
endmodule

// 2 : 1 multiplexer
module mux_2(sel, a, b, out) ;
  input sel, a, b ;
  output out ;
  assign out = (sel) ? a:b ;
endmodule

// 1 : 16 demultiplexer
module demux_8(sel, inp, out) ;
  input [2:0] sel ;
  input [16:0] inp ;
  output [7:0][16:0] out ;
endmodule

// This is the main module to control all the automations in the smart home.
// All inputs will be passed from here.
module smart_home(smokeDetector, doorState, windowState, humanDetector, 
                  doorEnable, in_password, change_password, rs_buttonState,
                  e_buttonState, temperature, humanDetector, luminosity, 
                  motionSensor, stove_state) ;
  input [2:0] smokeDetector, doorState, windowState, humanDetector, motionSensor ;
  input [2:0] doorEnable, rs_buttonState, e_buttonState ;
  input [2:0][16:0] in_password, change_password ;
  input [2:0][2:0] luminosity ;
  input [2:0][7:0] temperature ;
  input garageState, stove_state ;
endmodule

// This module checks the password. It also has an option of reset, to reset the password if user forgets it.
// We have registered a unique key, in case user forgets the password .
module password_check(in_password, change_password, rs_buttonState, e_buttonState, unlock, alarm) ;
  reg [16:0] unique_key = 17'd45675 ;
  reg [16:0] password ;
  input [16:0] in_password, change_password ;
  input rs_buttonState, e_buttonState ;
  integer count = 0 ;
  output reg unlock, alarm ;
  initial begin
    unlock = 1'b0 ;
    alarm = 1'b0 ;
    password = unique_key ;
  end
  always @(posedge e_buttonState) begin
    if (in_password == password || in_password == unique_key) begin
      count = 0 ;
      if (rs_buttonState == 1'b0) begin
        unlock <= 1'b1 ;
        unlock <= #1 1'b0 ;
      end
      else if (rs_buttonState == 1'b1) begin
        password = change_password ;
      end
    end
    else begin
      count = count + 1 ;
    end
    if (count > 3) begin
      alarm <= 1'b1 ;
      alarm <= #1 1'b0 ;
    end
  end
endmodule

// This automated cooling and heating works with temperature and presence of humans as input.
// It will turn A.C., heater on/off and control fan speed.  
module airConditioning(temperature, heater, airConditioner, humanDetector, fan_speed) ;
  input [6:0] temperature ;
  input humanDetector ;
  output reg heater, airConditioner ;
  output reg [1:0] fan_speed ; 
  always @(*) begin
    if (humanDetector) begin 
      if(temperature < 7'd74)begin
        // temperature is less than 10
        heater = 1'b1 ;
      end
      else if (temperature > 7'd74 & temperature < 7'd84) begin 
        // temperature is less than 20 but greater than 10 
        heater = 1'b0;
        fan_speed = 1'b0 ;
      end
      else if (temperature > 7'd84 & temperature < 7'd87) begin 
        // temperature is less than 23 but greater than 20 degree
        heater = 1'b0 ;
        fan_speed = 2'd1 ;
        airConditioner = 1'b0 ;
      end   
      else if (temperature > 7'd87 & temperature < 7'd90) begin 
        // temperature is greater than 23 but less than 26
        heater = 1'b0 ;
        fan_speed = 2'd3 ;
        airConditioner = 1'b0 ;
      end    
      else if (temperature > 7'd90 ) begin
        // temperature is greater than 26
        heater = 1'b0 ;
        fan_speed = 2'd2 ;  
        airConditioner = 1'b1;    
      end
    end
    else 
      fan_speed = 2'd0;
      airConditioner = 1'b0;
      heater = 1'b0 ;
  end
endmodule

// It takes input, time and motion of humans, like in night time, when humans are not moving
// It might be the case that he/she is sleeping or no one is in the room, hence lights are turned off.
// In day time we do not need lights.
module lighting (luminosity, motionSensor, light) ;
  input [2:0] luminosity ;
  input motionSensor ;
  output light ;
endmodule

// Chimney will turn on when stove is in an active state and turn off after some delay.
module kitchen(stove_state, chimney) ;
  input stove_state ;
  output reg chimney ;
  always @ (stove_state)
    if(stove_state)
      chimney = 1'b1 ;
    else 
      chimney <= #60 1'b0 ;  
endmodule

// Smoke luminosity is of multiple bits as there will be smoke detectors in every room.
module fire_alarm(smoke_detector, alarmEnable) ;
  input [2:0] smoke_detector ;
  output alarmEnable ;
endmodule

// This module will trigger burglar alarm in the respective room whenever the burglar breaks the door or window.
// Burglar can enter from doors, windows or garage, so we have taken all of them in consideration.
module burglar_alarm(doorState, windowState, garageState, homeLocked, garageLocked, alarmEnable) ;
  input [2:0] doorState, windowState ;
  input garageState ;
  input homeLocked, garageLocked ;
  output [2:0] alarmEnable ;
endmodule
