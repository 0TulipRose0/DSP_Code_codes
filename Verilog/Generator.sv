//TulipRose/Dmitriy V.

module Generator#(
    //Polynomials are specified without the first "1"
    parameter POLYNOME1 = 5'b00101,  //Polynomial 1 M-sequence
    parameter POLYNOME2 = 5'b01101,  //Polynomial 2 M-sequence
    //Phase should not be only zeros!
    parameter PHASE1    = 5'b01010,  //Phase 1 M-sequence
    parameter PHASE2    = 5'b01110,   //Phase 2 M-sequence

    parameter SHIFT     = 5'd3       //Shift for 2-nd M-sequence
    )(
    input  logic     clkin,
    input  logic     rstn,
    
    output logic     out     
    
    );
    ////////////////////////
    // Local declarations //
    ////////////////////////
    logic [4:0]     step_var1, step_var2;
    logic           xor1, xor2;
    
    logic [4:0]     poly1, poly2, phase1, phase2;
    logic [30:0]    m_seq1, m_seq2, m_sum;
    
    logic [5:0]     cnt;
    logic           fix;

    enum 
    logic [1:0]     {prepering = 2'b00,
                     shift_sum = 2'b01,
                     ready     = 2'b10} states;
    //1-st state generate main m-seq
    //2-nd state continues to generate a sequence and sends a bit to the output

    //////////////////
    // Main program //
    //////////////////
    always_ff @(posedge clkin) begin
        if(~rstn) begin
        poly1 <= POLYNOME1; 
        poly2 <= POLYNOME2; 
        phase1 <= PHASE1; 
        phase2 <= PHASE2;
        cnt <= 0;
        fix <= 1;
        states <= prepering;
        end else begin
        case (states)
            prepering : begin        

                        xor1 = ^(poly1 & phase1);   
                        m_seq1 <= {m_seq1[29:0], xor1};
                        phase1 <= {xor1, phase1[4:1]};      //m-sequence first

                        xor2 = ^(poly2 & phase2);
                        m_seq2 <= {m_seq2[29:0], xor2};
                        phase2 <= {xor2, phase2[4:1]};      //m-sequence second
                        cnt <= cnt + 1;                      //Sequence ready counter

                        if(cnt == 5'd30) begin
                            states <= shift_sum;

 //                           if(SHIFT != 1'b0)               //shift operation
//                            m_seq2 = {m_seq2[SHIFT-1:0], m_seq2[30:SHIFT]};
//
//                            m_sum = m_seq1 ^ m_seq2;        //"Gold" code out
                        end  
                        end


            shift_sum : begin
                        if(SHIFT != 1'b0)               //shift operation
                        m_seq2 = {m_seq2[SHIFT-1:0], m_seq2[30:SHIFT]};

                        m_sum = m_seq1 ^ m_seq2;        //"Gold" code out
                        
                        states <= ready;
                        end 
            
            
            ready : begin
                    
                    if(fix == 0)
                    out <= m_sum[30];                       
                    if(fix == 1)
                    fix <= fix -1;
                    
                    xor1 = ^(poly1 ^ phase1);
                    m_seq1 <= {m_seq1[29:0], xor1};
                    phase1 <= {xor1, phase1[4:1]};

                    xor2 = ^(poly2 ^ phase2);
                    m_seq2 <= {m_seq2[29:0], xor2};
                    phase2 <= {xor2, phase2[4:1]};

                    m_sum <= m_seq1 ^ m_seq2;
                    end
        endcase

        end
    end
endmodule
