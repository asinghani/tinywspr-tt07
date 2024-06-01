import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import chisel3.experimental.VecLiterals._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.must.Matchers
import chiseltest.ChiselScalatestTester

trait StringEncoderBehavior {
    this: AnyFlatSpec with ChiselScalatestTester =>

    def enqueue(dut: DecoupledIO[UInt], clock: Clock, value: Int) = {
        var done = false
        while (!done) {
            dut.bits.poke(value.U)
            dut.valid.poke(true.B)
            if (dut.ready.peekValue().asBigInt != 0) {
                clock.step()
                dut.valid.poke(false.B)
                done = true;
            }
            clock.step()
        }
    }

    def test_string_encode(cs: String, loc: String, pwr: Int, exp: BigInt): Unit = {
        it should s"encode correctly callsign=${cs} loc=${loc} pwr=${pwr}" in {
            simulate(new StringEncoder) { dut => 
                println(s"Config: callsign=${cs} loc=${loc} pwr=${pwr}")
                dut.reset.poke(true.B)
                dut.clock.step()
                dut.reset.poke(false.B)
                dut.clock.step()

                dut.io.start.poke(true.B)
                dut.clock.step()
                dut.io.start.poke(false.B)
                dut.clock.step()

                dut.io.config_in.valid.poke(false.B)

                enqueue(dut.io.config_in, dut.clock, cs(0).toInt)
                enqueue(dut.io.config_in, dut.clock, cs(1).toInt)
                enqueue(dut.io.config_in, dut.clock, cs(2).toInt)
                enqueue(dut.io.config_in, dut.clock, cs(3).toInt)
                enqueue(dut.io.config_in, dut.clock, cs(4).toInt)
                enqueue(dut.io.config_in, dut.clock, cs(5).toInt)

                // Note: reordering here is intentional
                enqueue(dut.io.config_in, dut.clock, loc(0).toInt)
                enqueue(dut.io.config_in, dut.clock, loc(2).toInt)
                enqueue(dut.io.config_in, dut.clock, loc(1).toInt)
                enqueue(dut.io.config_in, dut.clock, loc(3).toInt)

                enqueue(dut.io.config_in, dut.clock, pwr)

                var cycles: Int = 0
                var bitstring = BigInt(0)
                while (dut.io.done.peekValue().asBigInt == 0) {
                    if (dut.io.bit_out.valid.peekValue().asBigInt == 1) {
                        val bit = dut.io.bit_out.bits.peekValue().asBigInt.toInt
                        bitstring <<= 1
                        bitstring |= BigInt(bit)
                    }

                    dut.clock.step()
                    cycles += 1
                }

                println(s"Cycles: ${cycles}")
                println(s"BS: ${bitstring}")
                assert (bitstring == exp)
            }
        }
    }
}


class StringEncoderSpec extends AnyFlatSpec 
    with StringEncoderBehavior
    with ChiselScalatestTester
    with Matchers {

    (it should behave).like(
        test_string_encode("VU3CZQ", "AB36", 50, BigInt("5178638023828960625008303675638454395817527943676")))
    (it should behave).like(
        test_string_encode(" K3RTL", "FN00", 13, BigInt("5470489249118428733615144273840563155431526871183")))
}
