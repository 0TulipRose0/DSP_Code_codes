`timescale 1ns / 1ps
module tb();

////////////////////////
// Local declarations //
////////////////////////

parameter PERIOD = 10.0;
logic       clkin;
logic       rstn;

logic       ready;
logic       out;
logic [5:0] code1, code2;

/////////////////
// Connections //
/////////////////

//M_Sequence_gen1 m1(
//.clkin(clkin),
//.rstn(rstn),
//.out(),
//.code(code1),
//.ready(ready)
//);

top tp(
.clkin(clkin),
.rstn(rstn), 
.code1(code1),
.code2(code2),
.ready(ready),   
.code_gold()
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

if(ready) begin
code1 <= 6'b000000;
code2 <= 6'b000011;
end

end

endmodule
