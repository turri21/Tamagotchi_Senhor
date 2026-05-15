# MiSTer Migration Log

Date: 2026-05-15

## Goal

Reshape the Tamagotchi MiSTer split around the current local `Template_MiSTer` layout:

* `sys/` is the MiSTer framework and must remain byte-for-byte identical to `Template_MiSTer/sys`.
* `rtl/` contains the Tamagotchi core RTL plus MiSTer-local PLL, generated RAM IP, and savestate/turbo support logic.
* Root project files (`Tamagotchi.qpf`, `Tamagotchi.qsf`, `Tamagotchi.srf`, `Tamagotchi.sv`, `files.qip`) follow the MiSTer template convention.
* `releases/` is present for MiSTer release RBFs.

## Upstream Sources

* Local MiSTer template: `Template_MiSTer`
* Template commit used for local copy: `f35083f3b40d24853abea4cd3f77caccbd71d5de`
* Game & Watch migration notes referenced as the migration pattern: `GameAndWatch_MiSTer`

## Changes Made

* Copied current `Template_MiSTer/sys/` into this repo as `sys/`.
* Added root MiSTer project files:
  * `Tamagotchi.qpf`
  * `Tamagotchi.qsf`
  * `Tamagotchi.srf`
  * `Tamagotchi.sv`
  * `files.qip`
  * `clean.bat`
* Converted the old MiMiC wrapper from `target/mimic/core_top.sv` into the MiSTer template `emu` module in `Tamagotchi.sv`.
* Switched the build date include from old generated `build_id.vh` to template-generated `build_id.v`.
* Added current template HDMI framework outputs `HDMI_BLACKOUT` and `HDMI_BOB_DEINT`.
* Moved MiSTer-only collateral under `rtl/`:
  * `target/mimic/pll/` -> `rtl/pll.qip`, `rtl/pll.v`, and `rtl/pll/`
  * generated RAM IP from `projects/` -> `rtl/ip/`
  * old MiSTer savestate and turbo helpers from `target/mimic/` and `target/shared/` -> `rtl/mister/`
* Moved the generated microcode hex and UI font hex next to the RTL that reads them so the active `$readmemh` calls use filenames only.
* Removed the legacy multi-target/OpenGateware layout:
  * `.github/`
  * old asset folder
  * old assembler folder
  * `gateware.json`
  * `pkg/`
  * `platform/`
  * `projects/`
  * `target/`
  * unused `rtl/tamagotchi_p1.qip`
* Updated README/build/install documentation to describe the MiSTer split and root `Tamagotchi.qpf` build.

## Active Build Entry

```sh
quartus_sh --flow compile Tamagotchi.qpf
```

The resulting release artifact should follow MiSTer naming convention:

```text
Tamagotchi_YYYYMMDD.rbf
```

## Verification Log

Completed:

* `sys/` compared byte-for-byte against the current local `Template_MiSTer/sys/` with `diff -qr`.
* `find sys -type f | wc -l` returned `57`, matching the current local template copy.
* `files.qip` direct source path check found no missing files.
* Nested QIP path check for `rtl/pll.qip`, `rtl/ip/main_ram.qip`, `rtl/ip/intel_video_ram.qip`, and `sys/sys.qip` found no missing source/QIP files, excluding optional generated `MISC_FILE` collateral such as `pll.cmp`.
* Active root/build files were checked for stale references to the old `NSX_*`, `core_top`, `build_id.vh`, `platform/mimic`, `target/mimic`, `target/shared`, `projects/`, and old project file paths; none were found outside this migration log.
* `git diff --check` passed.

Pending in this workspace:

* Quartus compile or analysis pass. `quartus_sh` is not available on PATH in this workspace.
* Verilator/Icarus syntax pass. `verilator` and `iverilog` are not available on PATH in this workspace.
