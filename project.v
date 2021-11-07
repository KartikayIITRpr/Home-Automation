module mux_8(sel, inp, out) ; 
  input [2:0] sel;
  input [7:0] inp;
  output out;
  assign out = inp[sel];
endmodule

module mux_2(sel, a, b, out) ;
  input sel, a, b;
  output out;
  assign out = (sel) ? a:b;
endmodule

module demux_8(sel, inp, out);
  input [2:0] sel;
  input [7:0][16:0] inp;
  output [16:0] out;
endmodule

module smart_home(smokeDetector, doorState, windowState, humanDetector, 
                  doorEnable, in_password, change_password, rs_buttonState,
                  e_buttonState, temperature, humanDetector, day_time, 
                  motionSensor, stove_state);
  input [3:0] smokeDetector, doorState, windowState, humanDetector, motionSensor ;
  input [3:0] doorEnable, rs_buttonState, e_buttonState;
  input [3:0][16:0] in_password, change_password;
  input [4:0] day_time;
  input [3:0][7:0] temperature ;
  input garageState ,stove_state;
  
endmodule

module password_check(in_password, change_password, rs_buttonState, e_buttonState, lock, alarm) ;
  reg [16:0] unique_key = 17'd45675;
  reg [16:0] password;
  input [16:0] in_password, change_password;
  input rs_buttonState, e_buttonState;
  integer count = 0;
  output reg lock, alarm;
  always @(posedge e_buttonState) begin
    if (in_password == password || in_password == unique_key) begin
      count = 0;
      if (rs_buttonState == 1'b0) begin
        lock <= 1'b0;
      end
      else if (rs_buttonState == 1'b1) begin
        password = change_password;
      end
    end
    else begin
      count = count + 1;
    end
    if (count > 3) begin
      alarm <= 1'b1;
    end
  end
endmodule

module airConditioning(temperature, heater, airConditioner, humanDetector, fan_speed);
  input [7:0] temperature ;
  input humanDetector;
  output heater, airConditioner ;
  output [1:0] fan_speed;
  
endmodule

module lighting (day_time, motionSensor, light);
  input [4:0] day_time;
  input motion_sensor ;
  output light ;
endmodule

module kitchen(stove_state, chimney) ;
  input stove_state ;
  output chimney ;
endmodule

/*alarm for each security system*/
module fire_alarm(smoke_detector, alarmEnable);
  input [3:0] smoke_detector ;
  output alarmEnable;
endmodule

module burglar_alarm(doorState, windowState, garageState, homeLocked, garageLocked, alarmEnable);
  input [3:0] doorState, windowState;
  input garageState;
  input homeLocked, garageLocked;
  output [3:0] alarmEnable;
endmodule
