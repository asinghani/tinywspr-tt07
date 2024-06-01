/*
 * Copyright (c) 2024 Anish Singhani
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_asinghani_tinywspr (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    assign uio_out = 0;
    assign uio_oe  = 0;

    TopLevel tl (
        .clock(clk),
        .reset(!rst_n),
        .io_config_bits_in(uio_in),
        .io_config_valid_in(io_in[0]),
        .io_config_start(io_in[1]),
        .io_rf_start(io_in[2]),
        .io_rf_out(uo_out[0]),
        .io_bit_out(uo_out[7:6])
    )

    assign uo_out[1] = uo_out[0];
    assign uo_out[5:2] = 0;

endmodule
