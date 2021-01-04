CFLAGS := -Wall -Wstrict-prototypes -g -fomit-frame-pointer -ffreestanding

all : start.S led.S
	arm-linux-gnueabi-gcc $(CFLAGS) -c -o start.o start.S
	arm-linux-gnueabi-gcc $(CFLAGS) -c -o led.o led.S
	arm-linux-gnueabi-ld -T led.lds start.o led.o -o led.elf
	arm-linux-gnueabi-objcopy -O binary -S led.elf led.bin
	arm-linux-gnueabi-objdump -D -m arm led.elf > led.dis

clean:
	rm -f led.dis led.bin led.elf *.o
