import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):

    CONSTANT_CURRENT = 50  # For example, injecting some current
    OFF_CURRENT = 0

    dut._log.info("start simulation")

    # Initialize clock
    clock = Clock(dut.clk, 1, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the circuit.
    dut.rst_n.value = 0  # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1  # take out of reset

    # Initialize input values
    dut.ena.value = 1  # enable design

    for i in range(100):  # run for 100 clock cycles
        if 50 <= i <= 80:
            dut.ui_in.value = OFF_CURRENT
        else:
            dut.ui_in.value = CONSTANT_CURRENT

        await RisingEdge(dut.clk)

    dut._log.info("Finished test!")
