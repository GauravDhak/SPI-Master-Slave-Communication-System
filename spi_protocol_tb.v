`include "spi_protocol.v"
module tb_spi_master();
    reg clk;
    reg rst;
    reg [7:0] data_in;
    reg start;
    reg [3:0] cs; // Adjust size according to the number of slaves
    wire spi_clk;
    wire mosi;
    reg miso;
    wire [7:0] data_out;
    wire done;

    spi_master #(4) uut ( // Adjust parameter N if needed
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .start(start),
        .cs(cs),
        .spi_clk(spi_clk),
        .mosi(mosi),
        .miso(miso),
        .data_out(data_out),
        .done(done)
    );

    initial begin
        $dumpfile("tb_spi_master.vcd");
        $dumpvars(0,tb_spi_master);
        // Initialize signals
        clk = 0;
        rst = 0;
        data_in = 8'hA5;
        start = 0;
        cs = 4'b0010; // Select slave 0
        miso = 0;

        // Reset the UUT
        rst = 1;
        #10;
        rst = 0;

        // Start SPI transaction
        start = 1;
        #10;
        start = 0;

        // Simulate incoming data on MISO line
        repeat (16) begin
            #5 clk = ~clk; // Toggle clock
            if (clk) begin
                miso = ~miso;
            end
        end

        #20;
        $finish;
    end

    always #5 clk = ~clk; // Generate clock
endmodule
