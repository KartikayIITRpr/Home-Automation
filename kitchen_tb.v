`include "project.v"
module kitchen_tb();
    reg stove_state ;
    wire chimney ;
    kitchen k (stove_state, chimney);
    initial begin
        stove_state = 1'b0;
        #61
        stove_state = 1'b1;
        #20
        stove_state = 1'b0;
        #90;
    end
    initial begin
        $dumpfile("kitchen_tb.vcd");
        $dumpvars;
    end
endmodule