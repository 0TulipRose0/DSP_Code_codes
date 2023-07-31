//TulipRose/Dmitriy V.

module Generator#(
    //Polynomials are specified without the first "1"
    parameter POLYNOME1 = 5'b00101,  //Polynomial 1 M-sequence
    parameter POLYNOME2 = 5'b01101,  //Polynomial 2 M-sequence
    //Phase should not be only zeros!
    parameter PHASE1    = 5'b01010,  //Phase 1 M-sequence
    parameter PHASE2    = 5'b01110,   //Phase 2 M-sequence

    parameter SHIFT     = 5'd0       //Shift for 2-nd M-sequence
    )(
    input  logic     clkin,
    input  logic     rstn,
    
    output logic     out     
    
    );
    /////////////////////////
    // Local declarations //
    ////////////////////////
    logic [4:0]     step_var1, step_var2;
    logic           xor1, xor2;
    
    logic [4:0]     poly1, poly2, phase1, phase2;
    logic [30:0]    m_seq1, m_seq2, m_sum;
    
    logic [5:0]     cnt;

    enum 
    logic {prepering = 1'b0,
           ready     = 1'b1} states;
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
        states <= prepering;
        end else begin
        case (states)
            prepering : begin        
                        step_var1 = poly1 & phase1;
                        xor1 = ^step_var1;   
                        m_seq1 <= {m_seq1[29:0], xor1};
                        phase1 <= {xor1, phase1[4:1]};      //m-sequence first

                        step_var2 = poly2 & phase2;
                        xor2 = ^step_var2;
                        m_seq2 <= {m_seq2[29:0], xor2};
                        phase2 <= {xor2, phase2[4:1]};      //m-sequence second
                        cnt = cnt + 1;                      //Sequence ready counter

                        if(cnt == 6'd32) begin
                            states <= ready;

                            if(SHIFT != 1'b0)               //shift operation
                            m_seq2 = {m_seq2[30:31-SHIFT], m_seq2[30-SHIFT: 0]};

                            m_sum = m_seq1 ^ m_seq2;        //"Gold" code out
                        end  
                        end

            ready : begin

                    out <= m_sum[30];                       

                    step_var1 <= poly1 ^ phase1;
                    xor1 = ^step_var1;
                    m_seq1 <= {m_seq1[29:0], xor1};
                    phase1 <= {xor1, phase1[4:1]};

                    step_var2 <= poly2 ^ phase2;
                    xor2 <= ^step_var2;
                    m_seq2 <= {m_seq2[29:0], xor2};
                    phase2 <= {xor2, phase2[4:1]};

                    m_sum <= m_seq1 ^ m_seq2;
                    end
        endcase

        end
    end
endmodule
