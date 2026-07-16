
Read an AT28C16:
```
	minipro -p "AT28C16@DIP24" -r image.bin
```

Write an AT28C16:
```
	minipro -p "AT28C16@DIP24" -uP -w firmware.bin
```

Verify an AT28C16:
```
	minipro -p "AT28C16@DIP24" -m firmware.bin 
```

Erase an AT28C16:
```
	minipro -p "AT28C16@DIP24" -u -P -E
```

Blank check:
```
	minipro -p "AT28C16@DIP24" -b
```

