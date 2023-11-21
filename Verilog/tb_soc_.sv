`timescale 1ns / 1ps

module tb_soc_();

    ////////////////////////
    // Local declarations //
    ////////////////////////

    parameter              PERIOD     = 83.333; 

    logic                  clkin;                        
    logic  [4:0]           code_gold;                        

    /////////////////
    // Connections //
    /////////////////

    top tp(
        .sysclk(clkin),
        .ja(code_gold)
    );

    ////////////////
    // Test bench //
    ///////////////

//clk simulation
    initial forever begin
          #(PERIOD/2) clkin = 1'b1;
          #(PERIOD/2) clkin = 1'b0;
    end
    

endmodule
