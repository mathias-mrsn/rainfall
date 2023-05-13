## Buffer Overflow Attack

---

Here is a basic description of the buffer overflow attack and how it works.

To understand what a buffer overflow attack is, we need to understand how stack works during execution.

For the example below I will take a simple example of function in ASM (level1 -> main).

```asm
push   %ebp
mov    %esp,%ebp
and    $0xfffffff0,%esp
sub    $0x50,%esp ; breakpoint 1
lea    0x10(%esp),%eax
mov    %eax,(%esp) ; breakpoint 2
call   0x8048340 <gets@plt>
leave ; breakpoint 3
ret
```

And here is a schema step by step :

```
breakpoint 1:

0xe0 : |----------------|
0xd0 : |      ....      |
0xc0 : |----------------|
0xb0 : | Return ptr     | <-- Address to which the program will go after the execution of this function.
0xa0 : |----------------|
0x90 : | Prev ebp ptr   | <-- Save of the previous base pointer.
0x80 : |----------------|
0x70 : | Extra space    | <--ebp
0x60 : |----------------|
0x50 : |                |
0x40 : | Space free     |
0x30 : |                |
0x20 : |                |
0x10 : |                | <--esp
0x00 : |----------------|
```

```
breakpoint 2:

0xe0 : |----------------|
0xd0 : |      ....      |
0xc0 : |----------------|
0xb0 : | Return ptr     |
0xa0 : |----------------|
0x90 : | Prev ebp ptr   |
0x80 : |----------------|
0x70 : | Extra space    | <--ebp (0x70)
0x60 : |----------------|
0x50 : |                |
0x40 : |                |
0x30 : |                |
0x20 : |                | 
0x10 : | 0x20           | <--esp (0x10)
0x00 : |----------------|
```

```
breakpoint 3:
input : "Salut je suis une string"

0xe0 : |----------------|
0xd0 : |      ....      |
0xc0 : |----------------|
0xb0 : | Return ptr     |
0xa0 : |----------------|
0x90 : | Prev ebp ptr   |
0x80 : |----------------|
0x70 : | Extra space    | <--ebp (0x70)
0x60 : |----------------|
0x50 : |                |
0x40 : |                |
0x30 : | une string     |
0x20 : | Salut je suis  | 
0x10 : | 0x20           | <--esp (0x10)
0x00 : |----------------|
```

The stack will write data from the bottom of the stack to the top. This is why we must not use function like `gets`, `strcpy`, etc. Because if we don't limit the max size that we can write, I may overwrite previous data or change important values like the return pointer. Below you can find a simple example of what happens when I do a overflow attack.

```
input : "aaaaa...aaaaaa" + "/x01/x02/x03/0x04"

0xe0 : |----------------|
0xd0 : |      ....      |
0xc0 : |----------------|
0xb0 : | 01020304       |
0xa0 : |----------------|
0x90 : | aaaaaaaaaaaaaa |
0x80 : |----------------|
0x70 : | aaaaaaaaaaaaaa | <--ebp (0x70)
0x60 : |----------------|
0x50 : | aaaaaaaaaaaaaa |
0x40 : | aaaaaaaaaaaaaa |
0x30 : | aaaaaaaaaaaaaa |
0x20 : | aaaaaaaaaaaaaa | 
0x10 : | aaaaaaaaaaaaaa | <--esp (0x10)
0x00 : |----------------|
```