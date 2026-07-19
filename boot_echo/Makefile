
all: echo.bin

%.bin : %.asm
	z80asm $< -o - --list=$(subst .asm,.lst,$<) > $(subst .asm,.bin,$<)


#PROFILE=AT28C16@DIP24		# might not work with crap chips from Ebay
#PROFILE=CAT28C16A@DIP24
#PROFILE=28C16A@DIP24
#PROFILE=AT28C16E@DIP24
PROFILE=AM28C16A@DIP24		# drop its data transfer speeds and use a wider write-pulse window ?

burn: echo.bin
	minipro -p $(PROFILE) -uP -w $<

clean:
	rm -f *.bin *.lst

world: clean all

