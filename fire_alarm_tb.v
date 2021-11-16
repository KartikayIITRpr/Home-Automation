`include "project.v"
module fireAlarm_tb() ;
    reg [2:0] smoke_detector ;
    wire alarmEnable ;

    fire_alarm f (smoke_detector, alarmEnable) ;

    integer i = 0 ;
    initial begin
        for (i = 0; i<4; i=i+1) begin
            smoke_detector = i;
            #1;
        end
        for (i = 3; i>=0; i=i-1) begin
            smoke_detector = i;
            #1;
        end            
    end

    initial begin
        $dumpfile("fire_alarm_tb.vcd");
        $dumpvars;        
    end
endmodule