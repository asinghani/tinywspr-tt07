import chisel3._
import chisel3.util._
import chisel3.experimental.dataview._
import chisel3.experimental.VecLiterals._
import chisel3.experimental.BundleLiterals._
import _root_.circt.stage.ChiselStage

// Encodes callsign, location, power level into bit strings
class StringEncoder extends Module {
    val io = IO(new Bundle {
        val config_in      = Flipped(Decoupled(UInt(8.W)))

        val start          = Input(Bool())
        val done           = Output(Bool())
        //val bitstring_out  = Output(UInt(81.W))

        val bit_out = ValidIO(UInt(1.W))
    })


    object State extends ChiselEnum {
        val IDLE, FETCH, EXEC, STORE_PWR, DONE1 = Value
        val SHIFT_N, SHIFT_M, SHIFT_SP, SHIFT_PWR, SHIFT_DONE, DONE2, DONE = Value
    }

    object InstrOp extends ChiselEnum {
        val ZERO            = Value
        val DECODE_CS       = Value
        val MULTIPLY        = Value
        val SUBTRACT        = Value
        val SUBTRACT_FROM   = Value
        val DECODE_LOC_CHAR = Value
        val DECODE_LOC_DIG  = Value
        val SAVE_REG_N      = Value
        val DONE            = Value
    }

    class InstrOpWithData extends Bundle {
        val op = InstrOp()
        val value = UInt(8.W)

    }

    object InstrOpWithData {
        def apply(op: InstrOp.Type, value: UInt) = {
            (new InstrOpWithData).Lit(_.op -> op, _.value -> value)
        }
    }

    val program = RegInit(VecInit(
        InstrOpWithData(InstrOp.ZERO,            0.U),
        InstrOpWithData(InstrOp.DECODE_CS,       0.U),
        InstrOpWithData(InstrOp.MULTIPLY,        36.U),
        InstrOpWithData(InstrOp.DECODE_CS,       1.U),
        InstrOpWithData(InstrOp.MULTIPLY,        10.U),
        InstrOpWithData(InstrOp.DECODE_CS,       2.U),
        InstrOpWithData(InstrOp.MULTIPLY,        27.U),
        InstrOpWithData(InstrOp.DECODE_CS,       3.U),
        InstrOpWithData(InstrOp.SUBTRACT,        10.U),
        InstrOpWithData(InstrOp.MULTIPLY,        27.U),
        InstrOpWithData(InstrOp.DECODE_CS,       4.U),
        InstrOpWithData(InstrOp.SUBTRACT,        10.U),
        InstrOpWithData(InstrOp.MULTIPLY,        27.U),
        InstrOpWithData(InstrOp.DECODE_CS,       5.U),
        InstrOpWithData(InstrOp.SUBTRACT,        10.U),
        InstrOpWithData(InstrOp.SAVE_REG_N,      0.U),

        InstrOpWithData(InstrOp.ZERO,            0.U),
        InstrOpWithData(InstrOp.DECODE_LOC_CHAR, 0.U),
        InstrOpWithData(InstrOp.MULTIPLY,        10.U),
        InstrOpWithData(InstrOp.DECODE_LOC_DIG,  2.U),
        InstrOpWithData(InstrOp.SUBTRACT_FROM,   179.U),
        InstrOpWithData(InstrOp.MULTIPLY,        18.U),
        InstrOpWithData(InstrOp.DECODE_LOC_CHAR, 1.U),
        InstrOpWithData(InstrOp.MULTIPLY,        10.U),
        InstrOpWithData(InstrOp.DECODE_LOC_DIG,  3.U),

        InstrOpWithData(InstrOp.DONE,            0.U)
    ))

    val state = RegInit(State.IDLE)
    val pc = Reg(UInt(log2Ceil(program.length).W))
    val instr = Reg(new InstrOpWithData)

    val accum = Reg(UInt(28.W))
    val mul_reg = Reg(UInt(28.W))
    val reg_n = Reg(UInt(28.W))

    val power_dbm = Reg(UInt(6.W))

    val decoded = Wire(UInt(7.W))
    decoded := 0.U

    val sub_res = Mux(instr.op === InstrOp.SUBTRACT_FROM, instr.value, accum) -
                    Mux(instr.op === InstrOp.SUBTRACT_FROM, accum, instr.value)
    val dec_res = accum + decoded

    val bit_tmp = Wire(ValidIO(UInt(1.W)))
    val bit_out_tmp = Wire(ValidIO(UInt(1.W)))
    val conv_reg = Reg(UInt(32.W))

    io.config_in.ready := false.B

    bit_tmp.bits := 0.U
    bit_tmp.valid := false.B

    switch (state) {
        is (State.IDLE) {
            when (io.start) {
                state := State.FETCH
                pc := 0.U
                conv_reg := 0.U
            }
        }

        is (State.FETCH) {
            state := State.EXEC
            instr := program(pc)
            pc := pc + 1.U
            mul_reg := 0.U
        }

        is (State.EXEC) {
            state := State.FETCH
            switch (instr.op) {
                is (InstrOp.ZERO) {
                    accum := 0.U
                }

                is (InstrOp.DECODE_CS) {
                    io.config_in.ready := true.B
                    state := Mux(io.config_in.valid, State.FETCH, State.EXEC)
                    when (io.config_in.valid) {
                        // "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ ".index(ch)
                        when (io.config_in.bits === ' '.toInt.U) {
                            decoded := 36.U
                        } .elsewhen (io.config_in.bits <= '9'.toInt.U) {
                            decoded := io.config_in.bits - '0'.toInt.U
                        } .otherwise {
                            decoded := io.config_in.bits - 'A'.toInt.U + 10.U
                        }

                        accum := dec_res
                    }
                }

                is (InstrOp.MULTIPLY) {
                    mul_reg := mul_reg + accum
                    state := State.EXEC
                    when (instr.value === 0.U) {
                        accum := mul_reg
                        state := State.FETCH
                    }
                    instr.value := instr.value - 1.U
                    state := Mux(instr.value === 0.U, State.FETCH, State.EXEC)
                }

                is (InstrOp.SUBTRACT) {
                    accum := sub_res
                }

                is (InstrOp.SUBTRACT_FROM) {
                    accum := sub_res
                }

                is (InstrOp.DECODE_LOC_CHAR) {
                    io.config_in.ready := true.B
                    state := Mux(io.config_in.valid, State.FETCH, State.EXEC)
                    when (io.config_in.valid) {
                        decoded := io.config_in.bits - 'A'.toInt.U
                        accum := dec_res
                    }
                }

                is (InstrOp.DECODE_LOC_DIG) {
                    io.config_in.ready := true.B
                    state := Mux(io.config_in.valid, State.FETCH, State.EXEC)
                    when (io.config_in.valid) {
                        decoded := io.config_in.bits - '0'.toInt.U
                        accum := dec_res
                    }
                }

                is (InstrOp.SAVE_REG_N) {
                    reg_n := accum
                }

                is (InstrOp.DONE) {
                    state := State.STORE_PWR
                }
            }
        }

        is (State.STORE_PWR) {
            io.config_in.ready := true.B
            state := Mux(io.config_in.valid, State.DONE1, State.STORE_PWR)
            when (io.config_in.valid) {
                power_dbm := io.config_in.bits
            }
        }

        is (State.DONE1) {
            state := State.SHIFT_N
            instr.value := 55.U
        }

        is (State.SHIFT_N) {
            bit_tmp.bits := reg_n(27)
            when (instr.value(0) === 0.U) {
                reg_n := reg_n << 1.U
                bit_tmp.valid := true.B
            }
            instr.value := instr.value - 1.U
            when (instr.value === 0.U) {
                state := State.SHIFT_M
                instr.value := 29.U
            }
        }

        is (State.SHIFT_M) {
            bit_tmp.bits := accum(14)
            when (instr.value(0) === 0.U) {
                accum := accum << 1.U
                bit_tmp.valid := true.B
            }
            instr.value := instr.value - 1.U
            when (instr.value === 0.U) {
                state := State.SHIFT_SP
                instr.value := 1.U
            }
        }

        is (State.SHIFT_SP) {
            bit_tmp.bits := 1.U
            instr.value := instr.value - 1.U
            when (instr.value === 0.U) {
                state := State.SHIFT_PWR
                instr.value := 11.U
                bit_tmp.valid := true.B
            }
        }

        is (State.SHIFT_PWR) {
            bit_tmp.bits := power_dbm(5)
            when (instr.value(0) === 0.U) {
                power_dbm := power_dbm << 1.U
                bit_tmp.valid := true.B
            }
            instr.value := instr.value - 1.U
            when (instr.value === 0.U) {
                state := State.SHIFT_DONE
                instr.value := 61.U
            }
        }

        is (State.SHIFT_DONE) {
            bit_tmp.bits := 0.U
            when (instr.value(0) === 0.U) {
                bit_tmp.valid := true.B
            }
            instr.value := instr.value - 1.U
            when (instr.value === 0.U) {
                state := State.DONE2
                instr.value := 128.U
                bit_tmp.valid := true.B
            }
        }

        //val SHIFT_N, SHIFT_M, SHIFT_SP, SHIFT_PWR, SHIFT_DONE, DONE = Value

        is (State.DONE2) {
            instr.value := instr.value - 1.U
            when (instr.value === 0.U) {
                state := State.DONE
            }
        }

        is (State.DONE) {
            state := State.IDLE
        }
    }

    io.done := (state === State.DONE)

    io.bit_out := RegNext(bit_out_tmp)

    when (bit_tmp.valid) {
        conv_reg := Cat(conv_reg, bit_tmp.bits(0))
    }

    bit_out_tmp.valid := RegNext(bit_tmp.valid) || RegNext(RegNext(bit_tmp.valid))
    bit_out_tmp.bits := (conv_reg & "hF2D05351".U).xorR
    when (RegNext(RegNext(bit_tmp.valid))) {
        bit_out_tmp.bits := (conv_reg & "hE4613C47".U).xorR
    }


    /*io.bitstring_out := Cat(
        reg_n(27, 0),
        accum(14, 0),
        1.U(1.W),
        power_dbm(5, 0),
        0.U(31.W)
    )*/

}
