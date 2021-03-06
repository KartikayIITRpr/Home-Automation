// 16 : 1 multiplexer (17 bit)
module mux_8_16b(sel, inp, out) ; 
  input [2:0] sel ;
  input [2:0][16:0] inp ;
  output [16:0] out ;
  assign out = inp[sel] ;
endmodule

// 16 : 1 multiplexer
module mux_8(sel, inp, out) ; 
  input [2:0] sel ;
  input [2:0] inp ;
  output out ;
  assign out = inp[sel] ;
endmodule

// This is the main module to control all the automations in the smart home.
// All inputs will be passed from here.
module smart_home(smokeDetector, doorState, windowState, humanDetector, 
                  doorEnable, in_password, change_password, rs_buttonState,
                  e_buttonState, temperature, luminosity, 
                  motionSensor, stove_state, burglar_alarm_enable, unlock, fire_alarm, chimney, garage_alarm,
                  light, heater, airConditioner, fan_speed, lock_button, garageLocked, garageState,
                  garage_in_password, garage_change_password, garage_rs_button, garage_e_button, garage_lock_button) ;
  input [7:0] smokeDetector, doorState, windowState, humanDetector, motionSensor, lock_button;
  input [2:0] doorEnable, rs_buttonState, e_buttonState;
  input [7:0][16:0] in_password, change_password ;
  input [7:0][2:0] luminosity;
  input [7:0][6:0] temperature ;
  input [16:0] garage_in_password, garage_change_password;
  input garageState, stove_state, garage_rs_button, garage_e_button, garage_lock_button ;
  output fire_alarm, chimney ; 
  output reg unlock, garageLocked, garage_alarm;
  output [7:0] light, heater, airConditioner;
  output reg [7:0] burglar_alarm_enable;
  output [7:0][1:0] fan_speed ;
  wire [7:0] burglar_alarm_s;
  wire garage_alarm_sb;
  burglar_alarm b (doorState, windowState, garageState, !unlock, garageLocked, burglar_alarm_s, garage_alarm_sb) ;

  always @(burglar_alarm_s) begin
    for (integer i = 0; i<8; i=i+1) begin
      if (burglar_alarm_s[i])
        burglar_alarm_enable[i] = 1'b1;
    end
  end

  always @(posedge garage_alarm_sb) begin
    garage_alarm = 1'b1;
  end

  kitchen k (stove_state, chimney) ; 

  genvar i;
  generate
    for (i = 0; i<8; i=i+1) begin
      airConditioning ac1 ({temperature[i][6], temperature[i][5], temperature[i][4], temperature[i][3], 
        temperature[i][2], temperature[i][1], temperature[i][0]}, 
        heater[i], airConditioner[i], humanDetector[i], {fan_speed[i][1], fan_speed[i][0]}) ;
      lighting l ({luminosity[i][2], luminosity[i][1], luminosity[i][0]}, motionSensor[i], light[i]) ;
    end
  endgenerate
  wire [16:0] password_in, password_change;
  wire buttonState_e, buttonState_rs;
  mux_8_16b m1 (doorEnable, in_password, password_in);
  mux_8_16b m2 (doorEnable, change_password, password_change);
  mux_8 m3 (doorEnable, rs_buttonState, buttonState_rs);
  mux_8 m4 (doorEnable, e_buttonState, buttonState_e);

  wire unlock_s, alarm_s;
  password_check p (password_in, password_change, buttonState_rs, buttonState_e, unlock_s, alarm_s);
  initial begin
    burglar_alarm_enable <= 8'd0;
    unlock <= 1'b0;
    garageLocked <= 1'b0;
    garage_alarm <= 1'b0;
  end
  always @(posedge unlock_s, alarm_s) begin
    if (unlock_s) begin
      unlock <= 1'b1;
    end
    if (alarm_s) begin
      burglar_alarm_enable[doorEnable] <= 1'b1;
    end
  end
  always @(lock_button) begin
    if(lock_button > 0)
      unlock = 1'b0;
  end

  fire_alarm f (smokeDetector, fire_alarm);
  
  wire garage_unlock_s;
  password_check pg (garage_in_password, garage_change_password, garage_rs_button, garage_e_button, garage_unlock_s, garage_alarm_s);
  always @(posedge garage_unlock_s,posedge garage_alarm_s) begin
    if (garage_unlock_s == 1'b1) begin
      garageLocked <= 1'b0;
    end
    if (garage_alarm_s == 1'b1) begin
      garage_alarm <= 1'b1;
    end
  end
  always @(posedge garage_lock_button) begin
    garageLocked = 1'b1;
  end
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
  initial begin
    fan_speed = 2'b0;
    heater = 1'b0 ;
    airConditioner = 1'b0 ;
  end
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
        fan_speed = 2'd2 ;
      end   
      else if (temperature > 7'd87 & temperature < 7'd90) begin 
        // temperature is greater than 23 but less than 26
        fan_speed = 2'd3 ;
        airConditioner = 1'b0 ;
      end    
      else if (temperature > 7'd90 ) begin
        // temperature is greater than 26
        fan_speed = 2'd1 ;  
        airConditioner = 1'b1;    
      end
    end
    else begin
      fan_speed = 2'd0;
      airConditioner = 1'b0;
      heater = 1'b0 ;
    end
  end
endmodule

// It takes input, time and motion of humans, like in night time, when humans are not moving
// It might be the case that he/she is sleeping or no one is in the room, hence lights are turned off.
// In day time we do not need lights.
module lighting (luminosity, motionSensor, light) ;
  input [2:0] luminosity ;
  input motionSensor ;
  output reg light ;
  always @(*) begin
    if(luminosity< 3'd4 & motionSensor)
      light = 1'b1;
    else
      light = 1'b0;
  end
endmodule

// Chimney will turn on when stove is in an active state and turn off after some delay.
module kitchen(stove_state, chimney) ;
  input stove_state ;
  output reg chimney ;
  initial begin
    chimney = 1'b0;
  end
  always @ (stove_state)
    if(stove_state)
      chimney = 1'b1 ;
    else 
      chimney <= #60 1'b0 ;
endmodule

// Smoke luminosity is of multiple bits as there will be smoke detectors in every room.
module fire_alarm(smoke_detector, alarmEnable) ;
  input [7:0] smoke_detector ;
  output reg alarmEnable ;
  initial begin
    alarmEnable = 1'b0;
  end
  always @(smoke_detector) begin
    if(smoke_detector>0)
      alarmEnable = 1'b1;
    else 
      alarmEnable = 1'b0;
   end
  endmodule

// This module will trigger burglar alarm in the respective room whenever the burglar breaks the door or window.
// Burglar can enter from doors, windows or garage, so we have taken all of them in consideration.
module burglar_alarm(doorState, windowState, garageState, homeLocked, garageLocked, alarmEnable, garageAlarm) ;
  input [7:0] doorState, windowState ;
  input garageState ;
  input homeLocked, garageLocked ;
  output reg [7:0] alarmEnable ;  //for each room we are having an alarm
  output reg garageAlarm;  
  initial begin
    alarmEnable <= 8'd0;
    garageAlarm <= 1'b0;
  end
  always @(garageLocked, garageState) begin
    garageAlarm = garageLocked & garageState;
    garageAlarm = #1 1'b0;
  end
  always @(doorState, windowState, homeLocked) begin
    alarmEnable[0] = (doorState[0] | windowState[0]) & homeLocked;
    alarmEnable[1] = (doorState[1] | windowState[1]) & homeLocked;
    alarmEnable[2] = (doorState[2] | windowState[2]) & homeLocked;
    alarmEnable[3] = (doorState[3] | windowState[3]) & homeLocked;
    alarmEnable[4] = (doorState[4] | windowState[4]) & homeLocked;
    alarmEnable[5] = (doorState[5] | windowState[5]) & homeLocked;
    alarmEnable[6] = (doorState[6] | windowState[6]) & homeLocked;
    alarmEnable[7] = (doorState[7] | windowState[7]) & homeLocked;
    #1
    alarmEnable = 8'd0;
  end
endmodule