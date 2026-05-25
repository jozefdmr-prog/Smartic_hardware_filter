`timescale 1ns/1ps

module smartnic_top_tb;
    logic clk;
    logic reset;
    logic [7:0] rx_data;
    logic rx_valid;
    logic pcie_ready;
    logic [7:0] tx_data;
    logic tx_valid;
    logic alarm_preplnenia;

    smartnic_top dut (
        .clk(clk),
        .reset(reset),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .pcie_ready(pcie_ready),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .alarm_preplnenia(alarm_preplnenia)
    );

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        reset = 1; rx_data = 8'h00; rx_valid = 0; pcie_ready = 1;
        #20; reset = 0; #10;

        // Posielame dáta
        @(posedge clk); rx_data = 8'h0A; rx_valid = 1;
        @(posedge clk); rx_data = 8'h05; rx_valid = 1;
        @(posedge clk); rx_valid = 0; // Pauza
        
        #100;
        $display("Simulacia ukoncena.");
        $finish;
    end
endmodule
