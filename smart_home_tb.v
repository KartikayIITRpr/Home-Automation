`include "project.v"
module smart_home_tb() ;
    reg [7:0] smokeDetector, doorState, windowState, humanDetector, motionSensor, lock_button;
    reg [2:0] doorEnable, rs_buttonState, e_buttonState ;
    reg [2:0][16:0] in_password, change_password ;
    reg [16:0] garage_change_password, garage_in_password ;
    reg [2:0][2:0] luminosity;
    reg [2:0][6:0] temperature ;
    reg garageState, stove_state, garage_e_button, garage_lock_button, garage_rs_button ;
    wire unlock, fire_alarm, chimney, garage_alarm, garageLocked; 
    wire [7:0] burglar_alarm_enable, light, heater, airConditioner;
    wire [7:0][1:0] fan_speed ;

    smart_home s(smokeDetector, doorState, windowState, humanDetector, 
                  doorEnable, in_password, change_password, rs_buttonState,
                  e_buttonState, temperature, luminosity, 
                  motionSensor, stove_state, burglar_alarm_enable, unlock, fire_alarm, chimney, garage_alarm,
                  light, heater, airConditioner, fan_speed, lock_button, garageLocked, garageState,
                  garage_in_password, garage_change_password, garage_rs_button, garage_e_button, garage_lock_button) ;
    integer i ;
    initial begin
        rs_buttonState = 3'd0;
        in_password = 136'd0;
        change_password = 136'd0;
        e_buttonState = 3'd0;
        doorState = 8'd0;
        windowState = 8'd0;
        humanDetector = 8'd0;
        motionSensor = 8'd0 ;
        lock_button = 8'd0 ;
        doorEnable = 3'd0 ;
        luminosity = 9'd0;
        temperature = 21'd0;
        garageState = 1'b0;
        stove_state = 1'b0;
        smokeDetector = 8'd0;
        garage_in_password = 17'd0 ;
        garage_change_password = 17'd0 ;
        garage_e_button = 1'd0 ;
        garage_rs_button = 1'd0 ;
        garage_lock_button = 1'd0 ;
    end
    initial begin
        humanDetector = 8'd255;    
        for (i = 0; i<128; i=i+1) begin
            temperature[0] = i;
            #1;
        end
        for (i = 127; i>=0; i=i-1) begin
            temperature[0] = i;
            #1;
        end
        humanDetector = 1'b0;
        for (i = 0; i<128; i=i+1) begin
            temperature[0] = i;
            #1;
        end
        for (i = 127; i>=0; i=i-1) begin
            temperature[0] = i;
            #1;
        end
    end

    integer j;
    initial begin
        motionSensor = 8'd255 ;
        for (j = 0; j<8; j=j+1) begin
            luminosity[0] = j;
            #1;
        end
        for (j = 7; j>=0; j=j-1) begin
            luminosity[0] = j;
            #1;
        end
        motionSensor = 1'b0 ;
        for (j = 0; j<8; j=j+1) begin
            luminosity[0] = j;
            #1;
        end
        for (j = 7; j>=0; j=j-1) begin
            luminosity[0] = j;
            #1;
        end
    end
  
    initial begin
        #1
        doorEnable = 1'd1;
        rs_buttonState[1] = 1'b1;
        in_password[1] = 17'd45675;
        change_password [1]= 17'd78954;
        lock_button = 8'b0 ;
        e_buttonState [1]= 1'b0;
        #5
        e_buttonState [1]= 1'b1;
        #5
        rs_buttonState[1] = 1'b0;
        e_buttonState[1] = 1'b0;
        #5
        in_password[1] = 17'd78954;
        e_buttonState[1] = 1'b1;
        #5
        in_password[1] = 17'd45;
        e_buttonState[1] = 1'b0;
        #5
        lock_button = 8'b00100000;
        e_buttonState[1] = 1'b1;
        #5
        lock_button = 8'd0;
        e_buttonState[1] = 1'b0;
        #5
        e_buttonState[1] = 1'b1;
        #5
        e_buttonState[1] = 1'b0;
        #5
        e_buttonState[1] = 1'b1;
        #5
        e_buttonState[1] = 1'b0;
        #5
        e_buttonState[1] = 1'b1;
        #5
        lock_button = 8'b1 ;        
        #5;
    end
    integer k;
    initial begin
        #5
        smokeDetector[0] = 1'b1;
        #5
        smokeDetector[0] = 1'b0;
        #5
        smokeDetector[5] = 1'b1;
        #5
        smokeDetector[5] = 1'b0;
        #5;
    end
    initial begin
        #5
        stove_state = 1'b0;
        #60
        stove_state = 1'b1;
        #20
        stove_state = 1'b0;
        #90;
    end

    initial begin
        #1
        garage_rs_button = 1'b1;
        garage_in_password = 17'd45675;
        garage_change_password= 17'd78954;
        garage_lock_button = 1'b0 ;
        garage_e_button= 1'b0;
        #5
        garage_e_button= 1'b1;
        #5
        garage_rs_button = 1'b0;
        garage_e_button = 1'b0;
        #5
        garage_in_password = 17'd78954;
        garage_e_button = 1'd0;
        #5
        garage_in_password = 17'd45;
        garage_e_button = 1'b0;
        #5
        garage_lock_button = 1'b1;
        garage_e_button = 1'b1;
        #5
        garage_lock_button = 1'd0;
        garage_e_button = 1'b0;
        #5
        garage_e_button = 1'b1;
        #5
        garage_e_button = 1'b0;
        #5
        garage_e_button = 1'b1;
        #5
        garage_e_button = 1'b0;
        #5
        garage_e_button = 1'b1;
        #5
        garage_lock_button = 1'b1 ;        
        #5;
    end
    initial begin
        #5
        smokeDetector[0] = 1'b1;
        #5
        smokeDetector[0] = 1'b0;
        #5
        smokeDetector[5] = 1'b1;
        #5
        smokeDetector[5] = 1'b0;
        #5;
    end

    initial begin
        #200
        //garageState = 1'b1;
        doorState[5] = 1'b1;
    end


    initial begin
        $dumpfile("smart_home_tb.vcd");
        $dumpvars ;
    end
endmodule