CC = /usr/local/i386elfgcc/bin/i386-elf-gcc
LD = /usr/local/i386elfgcc/bin/i386-elf-ld
GDB = /usr/local/i386elfgcc/bin/i386-elf-gdb

CFLAGS = -gcc
QEMU = qemu-system-i386

IMG = ArenaOS.img
BOOT_BIN = boot/boot_sector.bin boot/setup.bin boot/head.bin boot/fake_kernel.bin

# default make target
.defautl: all

all: $(IMG) 

boot:
	cd boot && make 

elf:
	cd boot && make debug

$(IMG): $(BOOT_BIN)
	cat $(BOOT_BIN) > $@

# Magic, don't delete '@' 
$(BOOT_BIN): boot
	@


# main targets
run: $(IMG)
	$(QEMU) -m size=16 -mem-prealloc -drive format=raw,file=$(IMG)

debug: $(IMG) elf
	$(QEMU) -m size=16 -mem-prealloc -s -S -drive format=raw,file=$(IMG) & 
	$(GDB) --silent --command=debug/gdb_commands
	
clean:
	rm -rf $(IMG) $(IMG_ELF)
	rm -rf boot/*.bin boot/*.o boot/*.elf

.PHONY: clean debug boot