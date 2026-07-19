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

; This will echo characters received from the UART 1.

U1RX:   equ     80h             ; UART 1 RX data
U1ST:   equ     81h             ; UART 1 status port
U1TX:   equ     82h             ; UART 1 TX data

U2RX:   equ     83h             ; UART 2
U2ST:   equ     84h
U2TX:   equ     85h

STKTOP: equ     8000h           ; end of first RAM card

        ORG     0000h

start:
        di
        ld      sp,STKTOP       ; config a useful stack

loop:

        ; wait for RX ready
rxwait:
        in      a,(U1ST)        ; get the UART status
        and     80h             ; is the RX ready bit set?
        jp      z,rxwait        ; no? wait

        in      a,(U1RX)
        ld      c,a

        ; wait for TX ready
txwait:
        in      a,(U1ST)        ; get the UART status
        and     01h             ; is the TX ready bit set?
        jp      z,txwait        ; no? wait

        ld      a,c
        out     (U1TX),a        ; print it

        jp      loop

        ds      0800h-$,0ffh    ; padd to 2KB with FF
