
module Generator#(    
    //Lenght of the code
    parameter N          = 63,
    //Polynom lenght
    parameter LENGTH     = $clog2(N), 
    //Number of Gold codes    
    parameter QUA        =  3,
    //Number of cycles
    parameter NUM_CYCLES = 100001 //1ms
    )(
    
    input logic               clkin,
    input logic               rstn,
    
    axistream_if.master  m_axis
    
    );
    ////////////////////////
    // Local declarations //
    ////////////////////////   

   logic [17:0]       transaction_cnt;

   logic [LENGTH-1:0] cnt_shift;             

   logic [LENGTH-1:0] table_shift[0:10] = '{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};    
   
   enum 
   logic [1:0]        { transaction = 2'b00,
                        waiting     = 2'b01} state;

    //////////////////
    // Main program //
    //////////////////
    
    always_ff @(posedge clkin) begin
      if(!rstn) begin
         cnt_shift <= 1'b0;
         transaction_cnt <= NUM_CYCLES; 
         m_axis.tvalid <= 0;
         
         state <= transaction; 
      end else begin
         
         case(state)
            transaction: begin
                         m_axis.tvalid <= 1;                        
                            if(m_axis.tready && m_axis.tvalid) begin
                                cnt_shift <= cnt_shift + 1'b1;
                                if(cnt_shift == QUA) begin
                                    m_axis.tvalid <= 0;
                                    cnt_shift <= 1'b0;
                                    state <= waiting;                                                   
                                end
                            end
                         end
                         
           waiting:     begin
                            if(transaction_cnt == 0) begin
                                transaction_cnt <= NUM_CYCLES;
                                state <= transaction;
                            end
                         end
         endcase

         transaction_cnt <= transaction_cnt - 1'b1;
         if(transaction_cnt == 0) begin
         transaction_cnt <= NUM_CYCLES;
         end
     end            
    end
    
    assign m_axis.tdata = table_shift[cnt_shift];
    assign m_axis.tuser = 1'b0; 
       
endmodule
