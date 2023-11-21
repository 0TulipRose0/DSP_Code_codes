module Gold_gen#(
    
    //Lenght of the code
    parameter N        = 63,
    //Polynom lenght
    parameter LENGTH   = $clog2(N)
    
    )(
    //reset and clocking signals
    input logic              clkin,
    input logic              rstn,
    
    //strobe sig and code "Gold"    
    output logic             strobe_sig_o,
    output logic             code_gold,
    
    axistream_if.slave  s_axis 
    );  
    

    ////////////////////////
    // Local declarations //
    ////////////////////////

    logic                   ready1, ready2;
    logic                   out1, out2;
    logic                   valid1, valid2;
    logic [LENGTH-1:0]      code1_i;
    logic                   strobe_o;        
    
    /////////////////
    // Connections //
    /////////////////


    //1 param - polynome, 2 - length of code, 3 - polynome length, 4 - Hold value
    M_Sequence_gen1 #(6'b000011, 6'd63, 4'd6, 7'd3)
    m1(
    .clkin(clkin),
    .rstn(rstn),
    .out(out1),
    .valid(valid1),
    .code_i(s_axis.tuser),
    .ready_o(ready1),
    .strobe_o()
    );
    
    M_Sequence_gen2 #(6'b100111, 6'd63, 4'd6, 7'd3) 
    m2
    ( 
    .clkin(clkin),
    .rstn(rstn),
    .out(out2),
    .valid(valid2),
    .code_i(s_axis.tdata),
    .ready_o(ready2),
    .strobe_o(strobe_o)
    );
    
    ////////////////
    // Top Module //
    ////////////////
    
    assign s_axis.tready = ready2;
    assign code1_i = 1'b0;
    assign strobe_sig_o = strobe_o;
    assign code_gold = out1 ^ out2;
    
    always_ff @(posedge clkin) begin
        if(s_axis.tvalid) begin           
            valid1 <= 1;
            valid2 <= 1;                        
        end else begin                          
            valid1 <= 0;
            valid2 <= 0;           
        end
        
    end
          
endmodule
