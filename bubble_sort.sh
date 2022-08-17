nasm -f elf -g -F dwarf -o bubble_sort.o bubble_sort.asm
ld -m elf_i386 -o bubble_sort bubble_sort.o
./bubble_sort
