# Building

Build the active MiSTer project from the repo root with Quartus:

```bash
quartus_sh --flow compile Tamagotchi.qpf
```

The generated microcode hex and UI font hex are already checked in as build inputs. Regenerate them only when changing the source assembly or font data.

## Building Microcode

```bash
cd support
npm run build
```

## Verilator

For Verilator, you probably want to generate hex versions of the [background and sprite assets](tools.md#modelsim-hex-generator-modelsimjs).

### Also see [Tools](tools.md)
