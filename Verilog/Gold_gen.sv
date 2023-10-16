module Gold_gen#(
    
    //Lenght of the code
    parameter N        = 63,
    //Polynom lenght
    parameter LENGTH   = $clog2(N)
    
    )(
    //reset and clocking signals
    input logic              clkin,
    input logic              rstn,
    
    //shift signals for both m-modules
    input logic [LENGTH-1:0] code2_i,
    
    input logic              tvalid_i,
    
    //ready out and code "Gold"
    output logic             ready_o,
    output logic             code_gold,
    output logic             strobe_sig   
    );  
    

    ////////////////////////
    // Local declarations //
    ////////////////////////

    logic                   ready1, ready2;
    logic                   out1, out2;
    logic                   valid1, valid2;
    logic [LENGTH-1:0]      code1_i;
    
    logic [6:0]             cnt;
    
    /////////////////
    // Connections //
    /////////////////


    //1 param - polynome, 2 - length of code, 3 - polynome length, 4 - Hold value
    M_Sequence_gen1 #(6'b000011, 6'd63, 4'd6, 7'd4)
    m1(
    .clkin(clkin),
    .rstn(rstn),
    .out(out1),
    .valid(valid1),
    .code_i(code1_i),
    .ready_o(ready1)
    );
    
    M_Sequence_gen2 #(6'b100111, 6'd63, 4'd6, 7'd4) 
    m2
    ( 
    .clkin(clkin),
    .rstn(rstn),
    .out(out2),
    .valid(valid2),
    .code_i(code2_i),
    .ready_o(ready2)
   
    );
    
    ////////////////
    // Top Module //
    ////////////////
    
    assign ready_o = ready2;
    assign code1_i = 1'b0;
    
    always_ff @(posedge clkin) begin
        if(tvalid_i) begin
            valid1 <= 1;
            valid2 <= 1;
            code_gold = out1 ^ out2;            
        end else begin            
            valid1 <= 0;
            valid2 <= 0;
            code_gold <= 0;
        end
        
    end
          
endmodule
