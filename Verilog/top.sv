module top #(    
    //Lenght of the code
    parameter N          = 63,
    //Polynom lenght
    parameter LENGTH     = $clog2(N)
    )(
    input logic sysclk,
    input logic btn[0],
    
    output logic ja[0],
    output logic code_gold
    );
    
        
    
    ////////////////////////
    // Local declarations //
    ////////////////////////
    
    logic               aclk, strobe_sig, clk_100MHz;         
    axistream_if        axis(aclk);
    
    /////////////////
    // Connections //
    /////////////////
    
    Gold_gen gold_gen(
        .clkin(clk_100MHz),
        .rstn(btn[0]), 
        .code_gold(ja[0]),
        .strobe_sig_o(strobe_sig),
        .s_axis(axis)
    );
    
    Generator shift_gen(
        .clkin(clk_100MHz),
        .rstn(btn[0]),
        .m_axis(axis)
    );
    
    pll pll(
        .clkin(sysclk),
        .clk_100MHz(clk_100MHz),
        .aclk(aclk),
        .rstn_lock(btn[0])
    );
         
    

endmodule
