`timescale 1ns / 1ps

module tb_soc_();

    ////////////////////////
    // Local declarations //
    ////////////////////////

    parameter              PERIOD     = 83.333;
    parameter              LENGTH     = 63;             //code lenght for checks   
    parameter              POLY_LEN   = $clog2(LENGTH); //polynom lenght 

    logic                  clkin;                       //clocking
    logic                  rstn;                        //reset
    logic                  code_gold;                   //1 bit of Gold code      

    /////////////////
    // Connections //
    /////////////////

    top tp(
        .clkin(clkin),
        .code_gold(code_gold)
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
