
assemble:
	nasm -f bin dinoboot_main.asm

run:
	qemu-system-x86_64 -drive format=raw,file=dinoboot_main