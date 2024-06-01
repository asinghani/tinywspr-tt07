`timescale 1ns / 1ns

module tb;

    logic clock, reset;
    logic [7:0] config_bits_in;
    logic config_valid_in;
    logic config_start;
    logic rf_start;
    logic rf_out;
    logic [1:0] bit_out;

    TopLevel dut (
        .clock, .reset,
        .io_config_bits_in(config_bits_in),
        .io_config_valid_in(config_valid_in),
        .io_config_start(config_start),
        .io_rf_start(rf_start),
        .io_rf_out(rf_out),
        .io_bit_out(bit_out)
    );

    always #25 clock <= ~clock;

    task enq (input [7:0] val);
        begin
            config_bits_in = val;
            config_valid_in = 1;
            @(negedge clock);
            config_valid_in = 0;
            @(negedge clock);
        end
    endtask

    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
        config_bits_in = 0;
        config_valid_in = 0;
        config_start = 0;
        rf_start = 0;

        clock = 0;
        reset = 1;
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        reset = 0;
        repeat(10) @(negedge clock);

        config_start = 1;
        repeat(10) @(negedge clock);
        config_start = 0;

        repeat(2000) @(negedge clock);
        enq(" ");
        repeat(2000) @(negedge clock);
        enq("K");
        repeat(2000) @(negedge clock);
        enq("3");
        repeat(2000) @(negedge clock);
        enq("R");
        repeat(2000) @(negedge clock);
        enq("T");
        repeat(2000) @(negedge clock);
        enq("L");

        repeat(2000) @(negedge clock);
        enq("F");
        repeat(2000) @(negedge clock);
        enq("0");
        repeat(2000) @(negedge clock);
        enq("N");
        repeat(2000) @(negedge clock);
        enq("0");

        repeat(2000) @(negedge clock);
        enq(13);

        repeat(2000) @(negedge clock);
        enq(8'h00);
        repeat(2000) @(negedge clock);
        enq(8'h01);
        repeat(2000) @(negedge clock);
        enq(8'h86);
        repeat(2000) @(negedge clock);
        enq(8'hA0);

        repeat(2000) @(negedge clock);
        enq(8'h64);
        repeat(2000) @(negedge clock);
        enq(8'h01);
        repeat(2000) @(negedge clock);
        enq(8'hA3);
        repeat(2000) @(negedge clock);
        enq(8'h6E);

        repeat(2000) @(negedge clock);
        enq(8'h53);
        repeat(2000) @(negedge clock);
        enq(8'hE3);

        repeat(2000) @(negedge clock);

        rf_start = 1;
        repeat(2000) @(negedge clock);
        rf_start = 0;

        repeat(1000000) @(negedge clock);

        $finish;
    end

    

endmodule
