module mux_8(sel, inp, out) ;
  input [2:0] sel;
  input [7:0] inp;
  output out;
  
endmodule

module mux_2(sel, a, b, out) ;
  input sel, a, b;
  output out;
endmodule

module demux_8(sel, inp, out);
  input [2:0] sel;
  input [7:0][16:0] inp;
  output [16:0] out;
endmodule

module smart_home(smokeDetector, doorState, windowState);
  input [3:0] smokeDetector, doorState, windowState ;
  input [3:0][7:0] temperature ;
  input garageState;
  
endmodule

module password_check(in_password, change_password, rsbuttonState, e_buttonState, unlock, alarm) ;
  reg [16:0] unique_key = 17'd45675;
  reg [16:0] password;
  input [16:0] in_password, change_password;
  input rsbuttonState, e_buttonState;
  integer count = 0;
  output reg unlock, alarm;
  always @(posedge e_buttonState) begin
    if (in_password == password || in_password == unique_key) begin
      count = 0;
      if (rsbuttonState == 1'b0) begin
        unlock <= 1'b1;
      end
      else if (rsbuttonState == 1'b1) begin
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

module airConditioning();
  input [7:0] temperature ;
  output heater, airConditioner ;
endmodule

/*alarm for each security system*/

module fire_alarm(smoke_detector);
  input [3:0] smoke_detector ;
  output alarmEnable;
endmodule

module burglar_alarm();
  input [3:0] doorState, windowState;
  input garageState;
  input homeLocked, garageLocked;
  output alarmEnable;
endmodule


/*******************/

