;**************************************************************************
;
; A boot ROM image suitable for sanity-testing RAM and CPU cards in a
; S100-Z80-1982 system.  See: https://github.com/johnwinans/S100-Z80-1982
;
; Copyright (C) 2026 John Winans
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
;**************************************************************************

; On reset, the ROM at 0000h is enabled and the RAM at the same address is disabled.
; This remains until the first time that the RAM at address 0800h is read (or written),
; at which point the ROM is disabled and the RAM at address 0000h is enabled.
; Observation: It is not possible to copy the boot ROM into the RAM at address 0.


U1RX:   equ     80h             ; UART 1 RX data
U1ST:   equ     81h             ; UART 1 status port
U1TX:   equ     82h             ; UART 1 TX data

U2RX:   equ     83h             ; UART 2
U2ST:   equ     84h
U2TX:   equ     85h

STKTOP: equ     8000h           ; end of first RAM card


        ; Until the ROM is copied, code must be position independent!!

        ORG     0000h           ; execute from RAM1 after copied from ROM

start:
        di
        ld      sp,STKTOP       ; config a useful stack

loop:
        ld      hl,msg          ; HL = @ of message to print
        call    pstr            ; print it

        ld      hl,0            ; pause a moment
delay:
        dec     hl
        ld      a,h
        or      l
        jp      nz,delay

        jp      loop            ; go back & print again


; Print the 0-terminated string starting at address in HL
pstr:
        ld      a,(HL)          ; get the byte we want to print
        or      a               ; is the char to print zero?
        ret     z               ; if yes then done
pswait:
        in      a,(U1ST)        ; get the UART status
        and     01h             ; is the TX ready bit set?
        jp      z,pswait        ; no? wait

        ld      a,(hl)          ; re-get the byte to print
        out     (U1TX),a        ; print it
        inc     hl              ; point to next byte in the message
        jp      pstr            ; go back & print more


msg:    ; a message we want to print
        db      0dh,0ah,"Miracles can happen!",0

        ds      0800h-$,0ffh          ; padd to 2KB with FF
