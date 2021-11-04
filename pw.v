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

module tb ();
    reg [16:0] in_password, change_password;
    reg rsbuttonState, e_buttonState;
  
    wire reg unlock, alarm;

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
        e_buttonState = 1'b1;
        #5;
    end

    initial begin
        $dumpfile("pw.vcd");
        $dumpvars;
    end
endmodule