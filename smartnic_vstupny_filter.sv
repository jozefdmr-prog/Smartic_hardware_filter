module smartnic_vstupny_filter (
    input logic clk,
    input logic reset,
    input logic [7:0] rx_data,     
    input logic rx_valid,    
    output logic [7:0] tx_data,    
    output logic tx_valid    
);
    logic [7:0] pipe_data1, pipe_data2;
    logic pipe_valid1, pipe_valid2;

    always_ff @(posedge clk) begin
        if (reset) begin
            pipe_valid1 <= 1'b0;
            pipe_valid2 <= 1'b0;
            tx_valid <= 1'b0;
        end else begin
            if (rx_valid && rx_data != 8'h00) begin
                pipe_data1 <= rx_data;
                pipe_valid1 <= 1'b1; 
            end else begin
                pipe_valid1 <= 1'b0;  
            end

            pipe_data2 <= pipe_data1 ^ 8'hFF; 
            pipe_valid2 <= pipe_valid1;        

            tx_data <= pipe_data2;
            tx_valid <= pipe_valid2;
        end
    end
endmodule
