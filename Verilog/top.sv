module top(
    //reset and clocking signals
    input logic       clkin,
    input logic       rstn,
    
    //shift signals for both m-modules
    input logic [5:0] code1, code2,
    
    //ready out and code "Gold"
    output logic      ready,
    output logic      code_gold
    );
    

    ////////////////////////
    // Local declarations //
    ////////////////////////

    logic       ready1, ready2;
    logic       out1, out2;
    
    /////////////////
    // Connections //
    /////////////////


    //1 param - polynome, 2 - phase, 3 - lenght of code, 4 - polynome lenght
    M_Sequence_gen1 #(6'b000011, 6'b101010, 6'd63, 4'd6)
    m1(
    .clkin(clkin),
    .rstn(rstn),
    .out(out1),
    .code(code1),
    .ready(ready1)
    );
    
    M_Sequence_gen2 #(6'b100111, 6'b101010, 6'd63, 4'd6) 
    m2
    ( 
    .clkin(clkin),
    .rstn(rstn),
    .out(out2),
    .code(code2),
    .ready(ready2)
   
    );
    
    ////////////////
    // Top Module //
    ////////////////

    always_ff @(posedge clkin) begin
    
    if(ready2 && ready1)
       ready <= 1'b1;
    else ready <= 1'b0;
   
    code_gold <= out1 ^ out2;
    
    end
    
endmodule
