`timescale 1ns / 1ps
module tb();

////////////////////////
// Local declarations //
////////////////////////

parameter PERIOD = 10.0;
logic clkin;
logic rstn;

/////////////////
// Connections //
/////////////////

Generator gen(
.clkin(clkin),
.rstn(rstn),
.out()
);


////////////////
// Test bench //
///////////////

//clk simulation
initial forever begin
      #(PERIOD/2) clkin = 1'b1;
      #(PERIOD/2) clkin = 1'b0;
end

//rst signal test
initial
begin 
rstn = 0;
#100;
rstn = 1;
#100;
end
endmodule
