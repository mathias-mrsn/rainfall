# LEVEL 0

To this level, we will simply call gdb and see how the program works.

```shell
level0@RainFall:~$ gdb -q level0
Reading symbols from /home/user/level0/level0...(no debugging symbols found)...done.
(gdb) disas main
Dump of assembler code for function main:
   0x08048ec0 <+0>:	push   %ebp
   0x08048ec1 <+1>:	mov    %esp,%ebp
   [...]
   0x08048ed4 <+20>:	call   0x8049710 <atoi>
   0x08048ed9 <+25>:	cmp    $0x1a7,%eax
   0x08048ede <+30>:	jne    0x8048f58 <main+152>
   [...]
  ```

We can see above that the program call ```atoi()``` then compare the result with ```0x1a7``` this value is 423 in decimal.

Let's try to use this value as parameter and see what happens !

```shell
level0@RainFall:~$ ./level0 423
$ whoami
level1
```

Perfect, we can now use this shell with level1 owner to open the ```.pass``` file.

```shell
$ cat /home/user/level1/.pass
1fe8a524fa4bec01ca4ea2a869af2a02260d4a7d5fe7e7c24d8617e6dca12d3a
```