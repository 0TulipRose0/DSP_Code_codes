module top #(    
    //Lenght of the code
    parameter N          = 63,
    //Polynom lenght
    parameter LENGTH     = $clog2(N)
    )(
    input logic clkin,
    
    output logic code_gold
    );
    
        
    
    ////////////////////////
    // Local declarations //
    ////////////////////////
    
    logic [LENGTH-1:0]  code1, code2;
    logic               ready;
    logic               tvalid;
    logic               rstn;    
    
    logic               gating_sig;
    logic               clk_100MHz;
    
    

    /////////////////
    // Connections //
    /////////////////
    
    Gold_gen gold_gen(
        .clkin(clk_100MHz),
        .rstn(rstn), 
        .code2_i(code2),
        .ready_o(ready),
        .tvalid_i(tvalid),   
        .code_gold(code_gold)
    );
    
    Generator shift_gen(
        .clkin(clk_100MHz),
        .rstn(rstn),
        .ready_i(ready),
        .tvalid_o(tvalid),        
        .code2_o(code2),
        .gating_sig(gating_sig) 
    );
    
    pll pll(
        .clkin(clkin),
        .clk_100MHz(clk_100MHz),
        .rstn_lock(rstn)
    );
         
    

endmodule
