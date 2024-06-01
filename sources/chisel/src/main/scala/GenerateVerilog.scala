import chisel3._
import _root_.circt.stage.ChiselStage

object GenerateVerilog extends App {
    ChiselStage.emitSystemVerilogFile(
        new TopLevel,
        Array("--target-dir", "build/"),
        firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
    )
}
