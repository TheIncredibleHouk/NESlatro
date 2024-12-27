	.inesprg 2  ; 16x 16KB PRG code (32 banks of 8KB)
	.ineschr 0  ; 16x  8KB CHR data (128 banks of 1KB)
	.inesmap 4   ; mapper 4 = MMC3, 8KB PRG, 1/2KB CHR bank swapping
	.inesmir 0   ; background mirroring

    .data
    .org $00
    Param_0:            .ds 1
    Param_1:            .ds 1
    Param_2:            .ds 1
    Param_3:            .ds 1
    Param_4:            .ds 1
    Param_5:            .ds 1
    Param_6:            .ds 1
    Param_7:            .ds 1
    Param_8:            .ds 1
    Param_9:            .ds 1
    Param_A:            .ds 1
    Param_B:            .ds 1
    Param_C:            .ds 1
    Param_D:            .ds 1
    Param_E:            .ds 1
    Param_F:            .ds 1

    .org $200

    Ppu_Ctrl:           .ds 1
    Ppu_Mask:           .ds 1
    Horizontal_Scroll:  .ds 1
    Vertical_Scroll:    .ds 1
    Current_Palette:    .ds 32
    Target_Palette:     .ds 32
    

    .bank 0
    .org $8000
    .include "PRG/prg0.asm"

    .bank 1
    .org $A000
    .include "PRG/prg1.asm"

    .bank 2
    .org $C000
    .include "PRG/prg2.asm"

    .bank 3
    .org $E000
    .include "PRG/prg3.asm"