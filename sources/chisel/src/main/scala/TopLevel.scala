import chisel3._
import chisel3.util._
import chisel3.experimental.dataview._
import chisel3.experimental.VecLiterals._
import chisel3.experimental.BundleLiterals._
import _root_.circt.stage.ChiselStage

class TopLevel extends Module {
    val io = IO(new Bundle {
        val config_bits_in  = Input(UInt(8.W))
        val config_valid_in = Input(Bool()) // TODO: needs rising edge
        val config_start    = Input(Bool()) // TODO: needs debounce

        val rf_start        = Input(Bool())

        val rf_out          = Output(UInt(1.W))
        val bit_out         = Output(UInt(2.W))
    })

    val se = Module(new BitGenerator)
    se.io.config_in.valid := io.config_valid_in
    se.io.config_in.bits := io.config_bits_in
    se.io.start := io.config_start

    val config_regs = List.tabulate(10)(n => Reg(UInt(8.W)))

    val symbol_time = Cat(config_regs(0), config_regs(1), config_regs(2), config_regs(3))
    val divider = Cat(config_regs(4), config_regs(5), config_regs(6), config_regs(7))
    val deviation = Cat(config_regs(8), config_regs(9))

    when (io.config_valid_in) {
        for (i <- 0 until 9) {
            config_regs(i) := config_regs(i+1)
        }
        config_regs(9) := io.config_bits_in
    }

    val symbol_time_ctr = Reg(UInt(32.W))
    val osc_time_ctr = Reg(UInt(32.W))
    val symbol_ctr = Reg(UInt(8.W))

    when (io.rf_start) {
        symbol_ctr := 162.U
        symbol_time_ctr := symbol_time
        osc_time_ctr := 0.U
    }

    when (symbol_ctr =/= 0.U) {
        symbol_time_ctr := symbol_time_ctr - 1.U
        osc_time_ctr := osc_time_ctr + divider + (se.io.bit_out.bits * deviation)
    }

    se.io.bit_out.ready := false.B

    when (symbol_time_ctr === 0.U) {
        symbol_time_ctr := symbol_time
        symbol_ctr := symbol_ctr - 1.U
        se.io.bit_out.ready := true.B
    }

    io.bit_out := se.io.bit_out.bits
    io.rf_out := osc_time_ctr(31)
}
