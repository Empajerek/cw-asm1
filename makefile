CC = gcc
AS = nasm
ASFLAGS = -f elf64 -w+all -w+error
CFLAGS = -Wall -Wextra -std=c17 -O3
LDFLAGS = -z noexecstack

.PHONY: clean all test test_fake show_assembly

all: clean fake_mdiv_example mdiv_example

fake_mdiv_example: fake_mdiv.o mdiv_example.o
	$(CC) $(LDFLAGS) -o $@ $^

mdiv_example: mdiv.o mdiv_example.o
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

test:
	./mdiv_example

test_fake:
	./fake_mdiv_example

show_assembly:
	gcc -S -O3 -masm=intel fake_mdiv.c -o fake_mdiv.asm
	sed -i 's/QWORD PTR/qword/g' fake_mdiv.asm

clean:
	rm -rf *.o mdiv_example fake_mdiv fake_mdiv_example fake_mdiv.asm
