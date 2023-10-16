
module Generator#(    
    //Lenght of the code
    parameter N          = 63,
    //Polynom lenght
    parameter LENGTH     = $clog2(N), 
    //Number of Gold codes    
    parameter QUA        =  10,
    //Number of cycles of holding code at the out
    parameter HOLD       = 4,
    //Number of cycles
    parameter NUM_SYCLES = 100000 //1ms
    )(
    
    input logic               clkin,
    input logic               rstn,
    input logic               ready_i,
    
    output logic [LENGTH-1:0] code2_o,
    output logic              gating_sig,
    output logic              tvalid_o
    
    );
    ////////////////////////
    // Local declarations //
    ////////////////////////
    
    enum 
    logic [1:0] {waiting = 2'b00,
                 changing = 2'b01,
                 end_transaction = 2'b10                 
                                } states;

   logic [LENGTH-1:0] gold_shift2;

   logic [17:0]       transaction_cnt;
   
   logic [HOLD:0]     hold_last_bit;
   logic [HOLD:0]     hold_first_bit;      
   
   logic              ready_reg;  

   logic [LENGTH-1:0] cnt_shift;             

   logic [LENGTH-1:0] table_shift[0:10];
   
   logic              shift_done;

    //////////////////
    // Main program //
    //////////////////
    
    always_ff @(posedge clkin) begin
      if(~rstn) begin
         table_shift <= '{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
         cnt_shift <= 0;
         transaction_cnt <= NUM_SYCLES - 1;         
         gold_shift2 <= 0;
      end else begin
         
     if(ready_i && (cnt_shift < (QUA+1))) begin       
        tvalid_o = 1;          
        gold_shift2 = table_shift[cnt_shift];
        code2_o = gold_shift2;                    
        shift_done = 1;
     end
     
     if(shift_done && ~ready_i) begin
        cnt_shift <= cnt_shift + 1'b1;
        shift_done <= 0;
        code2_o = gold_shift2;
     end
     
     if(cnt_shift == (QUA+1)) begin
            tvalid_o = 0;
            gold_shift2 = table_shift[0];                                                            
     end

     if(transaction_cnt == 0) begin
        transaction_cnt = NUM_SYCLES;
        tvalid_o <= 1; 
        cnt_shift <= 0;
        code2_o <= table_shift[0];
     end  

        transaction_cnt <= transaction_cnt - 1;

    end 
  

    end

endmodule
