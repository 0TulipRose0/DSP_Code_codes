
module Generator#(    
    //Lenght of the code
    parameter N          = 63,
    //Polynom lenght
    parameter LENGTH     = $clog2(N), 
    //Number of Gold codes    
    parameter QUA        =  10,
    //Number of cycles
    parameter NUM_SYCLES = 100000 //1ms
    )(
    
    input logic               clkin,
    input logic               rstn,
    
    axistream_if.master  m_axis
    
    );
    ////////////////////////
    // Local declarations //
    ////////////////////////

   logic [LENGTH-1:0] gold_shift2;

   logic [17:0]       transaction_cnt;

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
         transaction_cnt <= NUM_SYCLES;         
         gold_shift2 <= 0;
      end else begin
         
         if(m_axis.tready && (cnt_shift < (QUA+1))) begin       
            m_axis.tvalid = 1;          
            gold_shift2 = table_shift[cnt_shift];
            m_axis.tdata = gold_shift2;                    
            shift_done = 1;
         end
     
         if(shift_done && ~m_axis.tready) begin
            cnt_shift = cnt_shift + 1;
            shift_done = 0;
            if(cnt_shift == (QUA+1)) begin
                m_axis.tvalid = 0;
                gold_shift2 = table_shift[0];                                                            
            end
         end

         if(transaction_cnt == 0) begin
            transaction_cnt = NUM_SYCLES;
            m_axis.tvalid <= 1; 
            cnt_shift <= 0;
            m_axis.tdata <= table_shift[0];
         end  
         
         transaction_cnt <= transaction_cnt - 1;
     end   
     
    end

endmodule
