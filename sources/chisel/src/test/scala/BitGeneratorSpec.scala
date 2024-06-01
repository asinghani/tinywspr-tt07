import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import chisel3.experimental.VecLiterals._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.must.Matchers
import chiseltest.ChiselScalatestTester

trait BitGeneratorBehavior {
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
            simulate(new BitGenerator) { dut => 
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

                var ctr: Int = 0
                var bitstring = BigInt(0)
                dut.io.bit_out.ready.poke(true.B)
                while (ctr < 162) {
                    if (dut.io.bit_out.valid.peekValue().asBigInt == 1) {
                        val bit = dut.io.bit_out.bits.peekValue().asBigInt.toInt
                        bitstring <<= 2
                        bitstring |= BigInt(bit)
                        ctr += 1
                    }

                    dut.clock.step()
                }

                println(s"BS: ${bitstring}")
                assert (bitstring == exp)
            }
        }
    }
}


class BitGeneratorSpec extends AnyFlatSpec 
    with BitGeneratorBehavior
    with ChiselScalatestTester
    with Matchers {

    (it should behave).like(
        test_string_encode("VU3CZQ", "AB36", 50,
            BigInt("33395857051595779595594712565422928868805109926684639601100021250411892661059934935740615716307810")))

    (it should behave).like(
        test_string_encode(" K3RTL", "FN00", 13, 
            BigInt("32374798051854018372420542344105833043171721983851965114240917287855676595133659422528308838760938")))
}
