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

Initialize_Ppu:
    LDA #(NMI_ENABLED |
          SPRITE_8x16 |
          BG_TILES_0000 |
          VRAM_HORZ_WRITE |
          NAMETABLE_2000)
    STA Ppu_Ctrl

    LDA #(SPRITES_DISABLED |
          BG_DISABLED |
          UNCLIP_LEFT_EDGE |
          COLOR_MODE)
    STA Ppu_Mask
    RTS

Initialize_Palette:
    LDA #$0F
    LDX #$1F

Initialize_Palette_Loop:
    STA Current_Palette, X
    DEX
    BNE Initialize_Palette_Loop
    RTS

Clear_Screen:

    RTS

Update_Palette:
    RTS

Clear_Mem_Addr_Lo       = Param8_0
Clear_Mem_Addr_Hi       = Param8_1
Clear_Mem_Length        = Param8_2

Clear_Mem:
    LDA #$FF
    LDY #$00

Clear_Mem_Loop:
    STA [Clear_Mem_Addr_Lo], Y
    
    INC Clear_Mem_Addr_Lo
    BCC Clear_Mem_NoCarry

    INC Clear_Mem_Addr_Hi

Clear_Mem_NoCarry:
    DEC Clear_Mem_Length
    BCC Clear_Mem_Loop
    RTS

NMI_Triggered:
    RTI

Reset_Triggered:
    LDA #$00
    STA Clear_Mem_Addr_Lo

    LDA #$02
    STA Clear_Mem_Addr_Hi

    JSR Clear_Mem
    
    JSR Initialize_Ppu
    JSR Initialize_Palette
    RTI

IRQ_Triggered:
    RTI

	.org $FFFA

Vector_Table:
	.word IntNMI   	
	.word IntReset	
	.word IntIRQ