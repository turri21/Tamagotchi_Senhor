`include "vunit_defines.svh"

module interrupt_tb;
  bench bench();

  `TEST_SUITE begin
    `TEST_CASE("Interrupt should be captured and jump to interrupt vector") begin
      bench.initialize(12'hEE0); // INC X
      bench.cpu_uut.core.regs.x = 12'h0;
      bench.cpu_uut.core.regs.pc = 13'h1234;
      bench.cpu_uut.core.regs.np = 5'h1F;
      bench.cpu_uut.core.regs.interrupt = 1;

      // Wait some time for instruction to start
      #2;
      // Set interrupt 0x1
      bench.cpu_uut.clock_mask = 4'h8;
      bench.cpu_uut.interrupt.clock_factor = 4'h8;

      bench.run_until_complete();
      #1;
      // Unassert interrupt
      bench.cpu_uut.interrupt.clock_factor = 4'h0;

      `CHECK_EQUAL(bench.cpu_uut.core.microcode.performing_interrupt, 1);

      @(posedge bench.clk iff bench.cpu_uut.core.microcode.stage == 3); // STEP2
      #1;
      bench.assert_interrupt(0);

      bench.run_until_complete();
      #1;
      bench.assert_cycle_length(12 + 5);
      bench.assert_pc(13'h1102);
      bench.assert_ram(bench.prev_sp - 1, 4'h2);
      bench.assert_ram(bench.prev_sp - 2, 4'h3);
      bench.assert_ram(bench.prev_sp - 3, 4'h5);

      bench.assert_x(12'h1);
    end

    `TEST_CASE("Interrupt should set vector based on requested line") begin
      bench.initialize(12'hEE0); // INC X
      bench.cpu_uut.core.regs.x = 12'h0;
      bench.cpu_uut.core.regs.pc = 13'h1234;
      bench.cpu_uut.core.regs.np = 5'h1F;
      bench.cpu_uut.core.regs.interrupt = 1;

      // Wait some time for instruction to start
      #4;
      bench.cpu_uut.prog_timer_mask = 1;
      bench.cpu_uut.timers.prog_timer.factor_flags = 1;

      bench.run_until_complete();
      #4;
      // Unassert interrupt
      bench.cpu_uut.timers.prog_timer.factor_flags = 1;

      bench.run_until_complete();
      #1;
      bench.assert_cycle_length(12 + 5);
      bench.assert_pc(13'h110C);
    end

    // TODO: I'm unsure whether this should be 12 or 13 cycles. The docs aren't very clear
    `TEST_CASE("Interrupt should take exactly 12 cycles when immediately asserted") begin
      reg [7:0] cycle_time;

      bench.initialize(12'hEE0); // INC X
      bench.cpu_uut.core.regs.x = 12'h0;
      bench.cpu_uut.core.regs.pc = 13'h1234;
      bench.cpu_uut.core.regs.np = 5'h1F;
      bench.cpu_uut.core.regs.interrupt = 1;

      // Wait some time for instruction to start
      bench.run_until_final_stage_fetch();
      bench.cpu_uut.prog_timer_mask = 1;
      bench.cpu_uut.timers.prog_timer.factor_flags = 1;
      #1;
      cycle_time = bench.cycle_count; // Save cycle count

      bench.run_until_complete();
      #1;
      // Unassert interrupt
      bench.cpu_uut.timers.prog_timer.factor_flags = 1;

      bench.run_until_complete();
      #1;
      // Should take 12 cycles from start of interrupt assertion to completion
      bench.assert_cycle_length(cycle_time + 12);
      bench.assert_pc(13'h110C);
    end

    `TEST_CASE("Interrupt should take exactly 13 cycles when asserted during halt") begin
      reg [7:0] cycle_time;

      bench.initialize(12'hFF8); // HALT
      bench.cpu_uut.core.regs.x = 12'h0;
      bench.cpu_uut.core.regs.pc = 13'h1234;
      bench.cpu_uut.core.regs.np = 5'h1F;
      bench.cpu_uut.core.regs.interrupt = 1;

      // Wait a long time for halt
      #30;

      bench.cpu_uut.stopwatch_mask = 2'h2;
      bench.cpu_uut.timers.stopwatch.factor_flags = 2'h2;
      #1;
      cycle_time = bench.cycle_count; // Save cycle count

      #6;
      // Unassert interrupt
      bench.cpu_uut.timers.stopwatch.factor_flags = 2'h0;

      // bench.run_until_complete();
      bench.run_until_complete();
      #1;
      // Should take 13 cycles from start of interrupt assertion to completion
      bench.assert_cycle_length(cycle_time + 13);
      bench.assert_pc(13'h1104);

      bench.assert_ram(bench.prev_sp - 1, 4'h2);
      bench.assert_ram(bench.prev_sp - 2, 4'h3);
      bench.assert_ram(bench.prev_sp - 3, 4'h5);
    end

    `TEST_CASE("Interrupt should handle req staying high after interrupt starts") begin
      bench.initialize(12'hEE0); // INC X
      bench.cpu_uut.core.regs.x = 12'h0;
      bench.cpu_uut.core.regs.pc = 13'h1234;
      bench.cpu_uut.core.regs.np = 5'h1F;
      bench.cpu_uut.core.regs.interrupt = 1;

      // Wait some time for instruction to start
      #2;
      bench.cpu_uut.input_lines.factor_flags = 2'h1;

      bench.run_until_complete();
      #1;

      `CHECK_EQUAL(bench.cpu_uut.core.microcode.performing_interrupt, 1);

      @(posedge bench.clk iff bench.cpu_uut.core.microcode.stage == 3); // STEP2
      #1;
      bench.assert_interrupt(0);

      bench.run_until_complete();
      #1;
      // Unassert interrupt
      bench.cpu_uut.input_lines.factor_flags = 2'h0;

      bench.assert_cycle_length(12 + 5);
      bench.assert_pc(13'h1106);
      bench.assert_ram(bench.prev_sp - 1, 4'h2);
      bench.assert_ram(bench.prev_sp - 2, 4'h3);
      bench.assert_ram(bench.prev_sp - 3, 4'h5);

      bench.run_until_complete();
      #1;

      bench.assert_x(12'h2);
    end
  end;

  // The watchdog macro is optional, but recommended. If present, it
  // must not be placed inside any initial or always-block.
  `WATCHDOG(1ns);
endmodule
