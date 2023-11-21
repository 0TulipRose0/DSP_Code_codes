module top (
    input logic sysclk,
    
    output logic [4:0] ja
    );
    
        
    
    ////////////////////////
    // Local declarations //
    ////////////////////////
    
    logic               aclk, clk_100MHz, rstn;         
    axistream_if        axis(aclk);
    
    /////////////////
    // Connections //
    /////////////////
    
    Gold_gen gold_gen(
        .clkin(clk_100MHz),
        .rstn(rstn), 
        .code_gold(ja[0]),
        .strobe_sig_o(ja[4]),
        .s_axis(axis)
    );
    
    Generator shift_gen(
        .clkin(clk_100MHz),
        .rstn(rstn),
        .m_axis(axis),
        .debug(ja[2])
    );
    
    pll pll(
        .clkin(sysclk),
        .clk_100MHz(clk_100MHz),
        .aclk(aclk),
        .rstn_lock(rstn)
    );

endmodule
