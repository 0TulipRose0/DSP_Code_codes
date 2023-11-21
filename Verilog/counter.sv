module counter(
    input logic clkin_i,
    input logic rstn_i,
    
    output logic data_o
    );        
    
    logic [3:0] cnt;
    
    always_ff @(posedge clkin_i) begin
        if(~rstn_i) begin data_o <= 0; cnt <= 0; end
        else if(cnt == 5) begin 
            data_o <= ~data_o;
            cnt <= 0;
        end else cnt <= cnt + 1;            
    end
    
endmodule
