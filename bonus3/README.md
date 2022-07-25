## BONUS 3

Ressources:
- [Disassembled code](disassembled_code.md)
- [Source code](srcs/bonus3.c)

This solution of this exercise can be found without even disassembling the code. We all know a much a empty line can destroy a project. So let's try this.

```shell
bonus3@RainFall:~$ ./bonus3 ""
$ cat /home/user/end/.pass
3321b6f81659f9a71c76616f606e4b50189cecfea611393d5d649f75e157353c
```

Congratulations, you have successfully completed this exercise.

Now let's understand why this solution works.

Firstly the program opens the `.pass` file who contains the flag, put it in the buffer then compare it with `av[1]`. So we can think that it's impossible, we cannot compare the flag that we're searching with it. But we can see on the line *19*, that we can change a character of the buffer by zero using the av[1]. So if we use an empty string. `atoi(av[1])` will return 0 and we will set the first character at zero. Then when we will compare these two strings, it will compare two empty strings that's means that `strcmp()` will return 0. Bingo !