import chisel3._
import chisel3.util._
import chisel3.experimental.dataview._
import chisel3.experimental.VecLiterals._
import chisel3.experimental.BundleLiterals._
import _root_.circt.stage.ChiselStage

class BitGenerator extends Module {
    val io = IO(new Bundle {
        val config_in      = Flipped(Decoupled(UInt(8.W)))
        val start          = Input(Bool())
        val bit_out        = Decoupled(UInt(2.W)) 
    })

    val se = Module(new StringEncoder)
    se.io.config_in <> io.config_in
    se.io.start <> io.start

    val regs = List.tabulate(162)(n => Reg(UInt(1.W)))

    val ready = RegInit(false.B)

    // Bit interleaving order
    val map = List(0, 81, 41, 122, 21, 102, 61, 142, 11, 92, 51, 132, 31, 112, 71, 152, 6, 87, 46, 127, 26, 107, 66, 147, 16, 97, 56, 137, 36, 117, 76, 157, 3, 84, 44, 125, 24, 105, 64, 145, 14, 95, 54, 135, 34, 115, 74, 155, 9, 90, 49, 130, 29, 110, 69, 150, 19, 100, 59, 140, 39, 120, 79, 160, 2, 83, 43, 124, 23, 104, 63, 144, 13, 94, 53, 134, 33, 114, 73, 154, 8, 89, 48, 129, 28, 109, 68, 149, 18, 99, 58, 139, 38, 119, 78, 159, 5, 86, 45, 126, 25, 106, 65, 146, 15, 96, 55, 136, 35, 116, 75, 156, 10, 91, 50, 131, 30, 111, 70, 151, 20, 101, 60, 141, 40, 121, 80, 161, 1, 82, 42, 123, 22, 103, 62, 143, 12, 93, 52, 133, 32, 113, 72, 153, 7, 88, 47, 128, 27, 108, 67, 148, 17, 98, 57, 138, 37, 118, 77, 158, 4, 85)

    val sync = RegInit(VecInit(1.U, 1.U, 0.U, 0.U, 0.U, 0.U, 0.U, 0.U, 1.U, 0.U, 0.U, 0.U, 1.U, 1.U, 1.U, 0.U, 0.U, 0.U, 1.U, 0.U, 0.U, 1.U, 0.U, 1.U, 1.U, 1.U, 1.U, 0.U, 0.U, 0.U, 0.U, 0.U, 0.U, 0.U, 1.U, 0.U, 0.U, 1.U, 0.U, 1.U, 0.U, 0.U, 0.U, 0.U, 0.U, 0.U, 1.U, 0.U, 1.U, 1.U, 0.U, 0.U, 1.U, 1.U, 0.U, 1.U, 0.U, 0.U, 0.U, 1.U, 1.U, 0.U, 1.U, 0.U, 0.U, 0.U, 0.U, 1.U, 1.U, 0.U, 1.U, 0.U, 1.U, 0.U, 1.U, 0.U, 1.U, 0.U, 0.U, 1.U, 0.U, 0.U, 1.U, 0.U, 1.U, 1.U, 0.U, 0.U, 0.U, 1.U, 1.U, 0.U, 1.U, 0.U, 1.U, 0.U, 0.U, 0.U, 1.U, 0.U, 0.U, 0.U, 0.U, 0.U, 1.U, 0.U, 0.U, 1.U, 0.U, 0.U, 1.U, 1.U, 1.U, 0.U, 1.U, 1.U, 0.U, 0.U, 1.U, 1.U, 0.U, 1.U, 0.U, 0.U, 0.U, 1.U, 1.U, 1.U, 0.U, 0.U, 0.U, 0.U, 0.U, 1.U, 0.U, 1.U, 0.U, 0.U, 1.U, 1.U, 0.U, 0.U, 0.U, 0.U, 0.U, 0.U, 0.U, 1.U, 1.U, 0.U, 1.U, 0.U, 1.U, 1.U, 0.U, 0.U, 0.U, 1.U, 1.U, 0.U, 0.U, 0.U))

    val ctr = Reg(UInt(8.W))

    when (se.io.bit_out.valid) {
        for (i <- 0 until 161) {
            regs(i) := regs(i+1)
        }
        regs(161) := se.io.bit_out.bits(0)
    }

    when (io.start) {
        ready := false.B
    }

    when (se.io.done) {
        ctr := 0.U
        ready := true.B
    }

    io.bit_out.valid := ready
    io.bit_out.bits := Cat(regs(0), sync(ctr))
    when (io.bit_out.ready === true.B) {
        for (i <- 0 until 161) {
            regs(map(i)) := regs(map(i+1))
        }
        regs(map(161)) := regs(map(0))
        ctr := ctr + 1.U
    }

}
