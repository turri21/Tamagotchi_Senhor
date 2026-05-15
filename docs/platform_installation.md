# MiSTer Installation

## ROMs

The Tamagotchi ROM can be commonly found in the MAME zip `tama.zip`, and will be named `tama.b` inside that zip. Rename `tama.b` to `rom.bin`.

MD5: `3fce172403c27274e59723bbb9f6d8e9`

## Game Folder

All files are in `/games/Tamagotchi/` on the MiSTer SD card:

* `rom.bin` - The Tamagotchi ROM
* `boot1.rom` - The rendered background
* `boot2.rom` - The spritesheet/status icons

The background and spritesheet can be replaced by the user. See the [image generation tools](tools.md#image-preparation-prepare_imagejs) for more information.

## Manual Core Install

Build or download the MiSTer RBF, place it under `_Other/cores/`, and launch it with an MGL that points at the RBF and loads `/games/Tamagotchi/rom.bin`.
