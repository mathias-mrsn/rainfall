## LEVEL 
---

## What is a format string

A format string is a specific type of string used by functions like `printf`, `scanf`, etc. It enables users to print more complex strings in a simplified manner. For example, the following string is a format string : `Salut %s, je suis %s et j'ai %d ans.`.

## How to detect a format string vulnerability

The correct way to use a format string is `printf("Hello %s, I am %s and I am %d years old.", str1, str2, age)`, where `str1`, `str2`, and `age` are variables defined previously in the code.

Format string attacks occur when printf (or similar functions) mistakenly interprets a variable as a format string instead of a regular string defined in the code. For example:

```c
int main(int ac, char **av) {
    if (ac != 2) return 1;
    printf(av[1]);
    return (0);
}
```
In this case, a format string attack can allow us to read from and write to the stack easily. This is because `printf` is unaware of the number of variables present within `av[1]`, which can lead to unintended consequences.

## What happens during a format string attack

In x86-32 architecture, function arguments are typically set on the stack at `$esp`, and the function retrieves the variables from `$esp + (4 * {variable number})`. To better understand the stack behavior, let's create a fictitious function and examine the stack:

```c
void fake(int a, int b, int c) {
    // breakpoint 2
    return (a + b + c);
}

int main (int ac, char **av) {
    fake(1, 2, 3); // breakpoint 1
}
```

At breakpoint 1 main will set these variable inside the stack like this :
```asm
movl $0x3, 0x8(%esp)
movl $0x2, 0x4(%esp)
movl $0x1, (%esp)
```
Then at breakpoint 2 fake will retrieve these 3 values like this :
```
a = 0x8($ebp)
b = 0xc($ebp)
c = 0x10($ebp)
```

In the case of a vulnerable printf, it will traverse up the stack as many times as there are variables in the string. This can lead to memory leaks, and when combined with the `%n` specifier, it can result in more severe consequences such as shell code injection, security bypassing, and other exploits.

For more detailed explanations, I recommend you to watch this 10-minute video in the source below.

---
*Source :*

*https://www.youtube.com/watch?v=0WvrSfcdq1I*