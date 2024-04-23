CC = gcc
AS = nasm
ASFLAGS = -f elf64 -w+all -w+error
CFLAGS = -Wall -Wextra -std=c17 -g
LDFLAGS = -z noexecstack

.PHONY: clean all test

all: fake_mdiv_example mdiv_example test

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

show_asembly:
	objdump -d -M intel fake_mdiv.o

clean:
	rm -rf *.o mdiv_example fake_mdiv_example
