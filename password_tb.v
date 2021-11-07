`include "project.v"
module password_tb ();
    reg [16:0] in_password, change_password;
    reg rsbuttonState, e_buttonState;
  
    wire reg lock, alarm;

    password_check x (in_password, change_password, rsbuttonState, e_buttonState, unlock, alarm);

    initial begin
        rsbuttonState = 1'b1;
        in_password = 17'd45675;
        change_password = 17'd78954;
        e_buttonState = 1'b0;
        #5
        e_buttonState = 1'b1;
        #5
        rsbuttonState = 1'b0;
        e_buttonState = 1'b0;
        #5
        in_password = 17'd78954;
        e_buttonState = 1'b1;
        #5
        in_password = 17'd45;
        e_buttonState = 1'b0;
        #5
        e_buttonState = 1'b1;
        #5
        e_buttonState = 1'b0;
        #5
        e_buttonState = 1'b1;
        #5
        e_buttonState = 1'b0;
        #5
        e_buttonState = 1'b1;
        #5
        e_buttonState = 1'b0;
        #5
        //lock = 0;
        e_buttonState = 1'b1;
        #5;
    end

    initial begin
        $dumpfile("password_tb.vcd");
        $dumpvars;
    end
endmodule