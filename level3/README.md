## LEVEL 3
---

As usual, I disasemble the binary, you can find the asm file [here](./asm/level3.asm).

Here is the most important parts.

```shell
v:
    0x080484a7 <+3>:	sub    $0x218,%esp; Allocate 536 bytes on the stack
    [...]
    0x080484be <+26>:	lea    -0x208(%ebp),%eax ; Load the address of the buffer in eax
    0x080484c4 <+32>:	mov    %eax,(%esp) ; Put the address of the buffer in the stack
    0x080484c7 <+35>:	call   0x80483a0 <fgets@plt> ; Call fgets, and store the result in the buffer
    [...]
    0x080484cc <+40>:	lea    -0x208(%ebp),%eax ; Load the address of the buffer in eax
    0x080484d2 <+46>:	mov    %eax,(%esp) ; Put the address of the buffer in the stack
    0x080484d5 <+49>:	call   0x8048390 <printf@plt> ; Call printf with the buffer as argument
    [...]
    0x080484da <+54>:	mov    0x804988c,%eax ; Load the address of a global value in eax
    0x080484df <+59>:	cmp    $0x40,%eax ; Compare the value with 64.
    0x080484e2 <+62>:	jne    0x8048518 <v+116> ; If not equal, jump to the end of the function
    [...]
    0x08048513 <+111>:	call   0x80483c0 <system@plt> ; Call system with "/bin/sh" as argument
    0x08048518 <+116>:	leave
    0x08048519 <+117>:	ret 
```

The program uses `fgets` to forbid buffer overflow attack on return address. But it does have another vulnerability on `printf` function. It calls `printf` like this `printf(buffer)`, this format is vulnerable to format string attack.

To understand what is a format string attack, you can read [this](../x86_docs/format_string_attack.md).

---

*Source :*

*https://www.exploit-db.com/docs/english/28476-linux-format-string-exploitation.pdf*