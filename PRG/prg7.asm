NMI_DISABLED        = %00000000
NMI_ENABLED         = %10000000
SPRITE_8x8          = %00000000
SPRITE_8x16         = %00100000
BG_TILES_0000       = %00000000
BG_TILES_1000       = %00001000
VRAM_HORZ_WRITE     = %00000000
VRAM_VERT_WRITE     = %00000100
NAMETABLE_2000      = %00000000
NAMETABLE_2400      = %00000001
NAMETABLE_2800      = %00000010
NAMETABLE_2C00      = %00000011

BLUE_EMPHASIS       = %10000000
GREEN_EMPHASIS      = %01000000
RED_EMPHASIS        = %00100000
SPRITES_DISABLED    = %00000000
SPRITES_ENABLED     = %00010000
BG_DISABLED         = %00000000
BG_ENABLED          = %00001000
CLIP_LEFT_EDGE      = %00000000
UNCLIP_LEFT_EDGE    = %00000110
COLOR_MODE          = %00000000
GRAYSCALE_MODE      = %00000001

Rtn_InitPpu:
    LDA #(NMI_ENABLED | SPRITE_8x16 | BG_TILES_0000 | VRAM_HORZ_WRITE | NAMETABLE_2000)
    STA Ppu_Ctrl

    LDA #(SPRITES_DISABLED | BG_DISABLED | UNCLIP_LEFT_EDGE | COLOR_MODE)
    STA Ppu_Mask

    JMP Rtn_UpdatePpuRegisters    

Rtn_InitPalette:
    LDA #$0F
    LDX #$1F

_InitPalette_Loop:
    STA Current_Palette, X
    DEX
    BNE _InitPalette_Loop
    RTS

Rtn_InitChrRam:
    

PPU_CTRL        = $2000
PPU_MASK        = $2001
PPU_STATUS      = $2002
PPU_VRAMADDR    = $2006
PPU_VRAMDATA    = $2007

Rtn_UpdatePpuRegisters:
    LDA Ppu_Ctrl
    STA PPU_CTRL

    LDA Ppu_Mask
    STA PPU_MASK
    RTS

Rtn_UpatePpuPalette:
    LDA PPU_STATUS

    LDA #$3F
    STA PPU_VRAMADDR

    LDA #$00
    STA PPU_VRAMADDR

    LDX #$1F

_UpdatePpuPalette_Loop:    
    LDA Current_Palette, X
    STA PPU_VRAMDATA
    DEX

    BPL _UpdatePpuPalette_Loop
    RTS 

Rtn_ClearScreen:
    RTS

Rtn_UpdatePalette:
    RTS

MMC3_CMD8000            = %00000110
MMC3_CMDA000            = %00000111
MMC3_BANKCMD            = $8000
MMC3_BANKSWAP           = $8001

Rtn_Swap8000:
    LDA #MMC3_CMD8000
    STA MMC3_BANKCMD

    LDA Mmc3_Bank8000
    STA MMC3_BANKSWAP
    RTS

Rtn_SwapA000:
    LDA #MMC3_CMDA000
    STA MMC3_BANKCMD

    LDA Mmc3_BankA000
    STA MMC3_BANKSWAP
    RTS

ClearMem_AddrLo         = Param_0
ClearMem_AddrHi         = Param_1
ClearMem_Length         = Param_2

Rtn_ClearMem:
    LDA #$00
    LDY #$00

_ClearMem_Loop:
    STA [ClearMem_AddrLo], Y
    
    INC ClearMem_AddrLo
    BCC _ClearMem_NoCarry

    INC ClearMem_AddrHi

_ClearMem_NoCarry:
    DEC ClearMem_Length
    BNE _ClearMem_Loop
    RTS

Rtn_NmiTriggered:
    RTI

ResetMemoryMap:
    .byte $02, $03, $04, $05, $06, $07    

Rtn_ResetTriggered:
    STA DEBUG_SNAP

    LDX #$05


_ResetTriggered_ClearMemLoop:
    JSR Rtn_InitPalette
    JSR Rtn_InitPpu

    LDA #$00
    STA ClearMem_AddrLo

    LDA ResetMemoryMap, X
    STA ClearMem_AddrHi

    LDA #$FF
    STA ClearMem_Length

    JSR Rtn_ClearMem

    DEX
    BPL _ResetTriggered_ClearMemLoop

    RTI

Rtn_IrqTriggered:
    RTI

	.org $FFFA

	.word Rtn_NmiTriggered
	.word Rtn_ResetTriggered
	.word Rtn_IrqTriggered