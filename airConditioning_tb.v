`include "project.v"

module airConditioning_tb();
  reg [6:0] temperature ;
  reg humanDetector ;
  wire heater, airConditioner ;
  wire [1:0] fan_speed ; 
  
  airConditioning a (temperature, heater, airConditioner, humanDetector, fan_speed);
  integer i = 0;
  initial begin
    humanDetector = 1'b1;
    
    for (i = 0; i<128; i=i+1) begin
        temperature = i;
        #1;
    end
    for (i = 127; i>=0; i=i-1) begin
        temperature = i;
        #1;
    end
    humanDetector = 1'b0;
    for (i = 0; i<128; i=i+1) begin
        temperature = i;
        #1;
    end
    for (i = 127; i>=0; i=i-1) begin
        temperature = i;
        #1;
    end
  end
  initial begin
        $dumpfile("airConditioning_tb.vcd");
        $dumpvars;
  end
endmodule