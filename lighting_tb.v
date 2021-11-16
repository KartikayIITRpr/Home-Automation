`include "project.v"

module lighting_tb();
    reg [2:0] luminosity ;
    reg motionSensor ;
    wire light ;

    lighting l (luminosity, motionSensor, light) ;
    integer i=0;
    initial begin
        motionSensor = 1'b1 ;
        for (i = 0; i<8; i=i+1) begin
            luminosity = i;
            #1;
        end
        for (i = 7; i>=0; i=i-1) begin
            luminosity = i;
            #1;
        end
        motionSensor = 1'b0 ;
        for (i = 0; i<8; i=i+1) begin
            luminosity = i;
            #1;
        end
        for (i = 7; i>=0; i=i-1) begin
            luminosity = i;
            #1;
        end
    end

    initial begin
        $dumpfile("lighting_tb.vcd");
        $dumpvars;        
    end
endmodule