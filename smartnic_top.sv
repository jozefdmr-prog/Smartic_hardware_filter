module smartnic_top (
    input logic clk,
    input logic reset,
    input logic [7:0] rx_data,
    input logic rx_valid,
    input logic pcie_ready,   
    output logic [7:0] tx_data,
    output logic tx_valid,    
    output logic alarm_preplnenia
);
    logic [7:0] filter_to_fifo_data;
    logic filter_to_fifo_valid;
    logic fifo_prazdne;

    smartnic_vstupny_filter filter_inst (
        .clk(clk),
        .reset(reset),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_data(filter_to_fifo_data),
        .tx_valid(filter_to_fifo_valid)
    );

    smartnic_fifo_buffer fifo_inst (
        .clk(clk),
        .reset(reset),
        .data_in(filter_to_fifo_data),
        .wr_en(filter_to_fifo_valid),
        .rd_en(pcie_ready), 
        .data_out(tx_data),
        .plne(alarm_preplnenia),
        .prazdne(fifo_prazdne)
    );

    assign tx_valid = !fifo_prazdne;
endmodule
