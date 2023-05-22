## BONUS 3

Ressources:
- [Disassembled code](disassembled_code.md)
- [Source code](srcs/bonus3.c)

This solution of this exercise can be found without even disassembling the code. We all know how much a empty line can destroy a project. So let's try this.

```shell
bonus3@RainFall:~$ ./bonus3 ""
$ cat /home/user/end/.pass
3321b6f81659f9a71c76616f606e4b50189cecfea611393d5d649f75e157353c
```

Congratulations on successfully completing this exercise!

Now let's delve into why this solution works.

Firstly, the program opens the `.pass` file that contains the flag, places it in the buffer, and then compares it with `av[1]`. Initially, it may seem impossible to compare the flag we are searching for with `av[1]`. However, on line 19, we notice that we can modify a character of the buffer to zero using `av[1]`. So, if we provide an empty string as `av[1]`, `atoi(av[1])` will return 0, effectively setting the first character of the buffer to zero. Consequently, when we compare these two strings, we are comparing two empty strings, resulting in `strcmp()` returning 0. Bingo!