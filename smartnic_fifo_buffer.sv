module smartnic_fifo_buffer (
    input logic clk,
    input logic reset,
    input logic [7:0] data_in,
    input logic wr_en,      
    input logic rd_en,      
    output logic [7:0] data_out,
    output logic plne,            
    output logic prazdne          
);
    logic [3:0][7:0] pamat;
    logic [1:0] wr_ptr; 
    logic [1:0] rd_ptr; 
    logic [2:0] pocet_poloziek; 

    assign prazdne = (pocet_poloziek == 0);
    assign plne = (pocet_poloziek == 4);

    always_ff @(posedge clk) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            pocet_poloziek <= 0;
        end else begin
            if (wr_en && !plne) begin
                pamat[wr_ptr] <= data_in; 
                wr_ptr <= wr_ptr + 1; 
            end
            if (rd_en && !prazdne) begin
                rd_ptr <= rd_ptr + 1; 
            end
            if ((wr_en && !plne) && !(rd_en && !prazdne)) begin
                pocet_poloziek <= pocet_poloziek + 1; 
            end else if (!(wr_en && !plne) && (rd_en && !prazdne)) begin
                pocet_poloziek <= pocet_poloziek - 1; 
            end
        end
    end
    assign data_out = pamat[rd_ptr];
endmodule
