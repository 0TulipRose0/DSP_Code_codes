//TulipRose/Dmitriy V.
module M_Sequence_gen2#(
    //Polynomials are specified without the first "1"
    parameter POLYNOME = 6'b100111,  //Polynomial M-sequence
    //Lenght of the code
    parameter N        = 63,
    //Polynom lenght
    parameter LENGTH   = $clog2(N),
    //Number of cycles of holding code at the out
    parameter HOLD     = 3
    )(
    input  logic              clkin,
    input  logic              rstn,
    
    input  logic              valid,
    output logic              out,
    
    //Shift value and ready signal
    input  logic [LENGTH-1:0] code_i,
    output logic              strobe_o,
    output logic              ready_o
    );
    
    ////////////////////////
    // Local declarations //
    ////////////////////////
    
    logic                  xor_op;

    logic [LENGTH-1:0]     phase;

    logic [LENGTH-1:0]     cnt;
    
    logic [HOLD-1:0]       hold_cnt;
    
    logic [LENGTH-1:0]     code;
    
    /////////////////
    // Main module //
    /////////////////
    
    always_comb begin
        xor_op = ^(POLYNOME & phase);
        code = code_i; 
    end
    
    always_ff @(posedge clkin) begin
        if(!rstn) begin
            ready_o  <= 1'b1;
            cnt <= N;
            hold_cnt <= HOLD - 1;
            out <= 0;            
            strobe_o <= 0;
                       
        end else if((code_i != 0 || code_i == 0) && (valid || hold_cnt != 0)) begin         
            ready_o  <= 1'b0; 
            hold_cnt <= HOLD - 1;           
            
                if(cnt == N) begin
                    
                    //Phase should not be only zeros!
                    //generated from python script
                        case(code)
                        6'd0: phase <= 6'b101010;
                        6'd1: phase <= 6'b010101;
                        6'd2: phase <= 6'b001010;
                        6'd3: phase <= 6'b100101;
                        6'd4: phase <= 6'b110010;
                        6'd5: phase <= 6'b011001;
                        6'd6: phase <= 6'b101100;
                        6'd7: phase <= 6'b010110;
                        6'd8: phase <= 6'b001011;
                        6'd9: phase <= 6'b000101;
                        6'd10: phase <= 6'b000010;
                        6'd11: phase <= 6'b100001;
                        6'd12: phase <= 6'b010000;
                        6'd13: phase <= 6'b001000;
                        6'd14: phase <= 6'b000100;
                        6'd15: phase <= 6'b100010;
                        6'd16: phase <= 6'b010001;
                        6'd17: phase <= 6'b101000;
                        6'd18: phase <= 6'b110100;
                        6'd19: phase <= 6'b011010;
                        6'd20: phase <= 6'b101101;
                        6'd21: phase <= 6'b110110;
                        6'd22: phase <= 6'b111011;
                        6'd23: phase <= 6'b111101;
                        6'd24: phase <= 6'b111110;
                        6'd25: phase <= 6'b111111;
                        6'd26: phase <= 6'b011111;
                        6'd27: phase <= 6'b101111;
                        6'd28: phase <= 6'b010111;
                        6'd29: phase <= 6'b101011;
                        6'd30: phase <= 6'b110101;
                        6'd31: phase <= 6'b111010;
                        6'd32: phase <= 6'b011101;
                        6'd33: phase <= 6'b001110;
                        6'd34: phase <= 6'b000111;
                        6'd35: phase <= 6'b100011;
                        6'd36: phase <= 6'b110001;
                        6'd37: phase <= 6'b011000;
                        6'd38: phase <= 6'b001100;
                        6'd39: phase <= 6'b100110;
                        6'd40: phase <= 6'b110011;
                        6'd41: phase <= 6'b111001;
                        6'd42: phase <= 6'b011100;
                        6'd43: phase <= 6'b101110;
                        6'd44: phase <= 6'b110111;
                        6'd45: phase <= 6'b011011;
                        6'd46: phase <= 6'b001101;
                        6'd47: phase <= 6'b000110;
                        6'd48: phase <= 6'b000011;
                        6'd49: phase <= 6'b000001;
                        6'd50: phase <= 6'b100000;
                        6'd51: phase <= 6'b110000;
                        6'd52: phase <= 6'b111000;
                        6'd53: phase <= 6'b111100;
                        6'd54: phase <= 6'b011110;
                        6'd55: phase <= 6'b001111;
                        6'd56: phase <= 6'b100111;
                        6'd57: phase <= 6'b010011;
                        6'd58: phase <= 6'b001001;
                        6'd59: phase <= 6'b100100;
                        6'd60: phase <= 6'b010010;
                        6'd61: phase <= 6'b101001;
                        6'd62: phase <= 6'b010100;
                        6'd63: phase <= 6'b101010;
                        endcase   
                        if(hold_cnt != 0) begin
                        hold_cnt <= hold_cnt - 1;
                        end else begin                     
                        cnt <= cnt - 1'b1;
                        hold_cnt <= HOLD-1;
                        strobe_o <= 1;
                        
                        out <= phase[0];                                                                      
                        phase <= {xor_op, phase[LENGTH-1:1]};
                    end
                end
                
                if(cnt != 1 && cnt != N) begin
                
                   if(hold_cnt != 0) begin
                       hold_cnt <= hold_cnt - 1;
                   end else begin 
                       out <= phase[0];                                          
                       phase <= {xor_op, phase[LENGTH-1:1]};
                       
                       hold_cnt <= HOLD - 1;                                                 
                       cnt <= cnt - 1;                       
                   end
                                      
                   end else if (cnt == 1) begin 
                       if(hold_cnt != 0) begin
                           hold_cnt <= hold_cnt - 1;
                       end else begin
                           ready_o <= 1'b1;
                           cnt <= N;
                           hold_cnt <= HOLD - 1;
                         
                           out <= phase[0];                                                
                           phase <= {xor_op, phase[LENGTH-1:1]};
                       end
                 end 
                 
         end else begin
            out <= 0;
            ready_o <= 1'b1;
            cnt <= N;                            
            if(cnt == 63 && ~valid) strobe_o <= 0;            
         end
    end

endmodule