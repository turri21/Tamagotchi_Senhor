import { execSync } from "child_process";

const commands = [
  {
    command:
      "node micro_asm.js ../rtl/core/microcode.asm ../rtl/core/microcode.rom",
    error: "Failed to build microcode",
  },
  {
    command:
      "node modelsim.js ../rtl/core/microcode.rom ../rtl/core/microcode.hex 4",
    error: "Failed to create ModelSim microcode binary",
  },
];

for (const { command, error } of commands) {
  const stdout = execSync(command);

  if (stdout.length > 0) {
    console.log(stdout.toString());
    console.log(error);

    break;
  }
}
