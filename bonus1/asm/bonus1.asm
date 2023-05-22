main :
    0x08048424 <+0>:	push   %ebp ; Save the old base pointer
    0x08048425 <+1>:	mov    %esp,%ebp ; Set the new base pointer
    0x08048427 <+3>:	and    $0xfffffff0,%esp ; Align the stack
    0x0804842a <+6>:	sub    $0x40,%esp ; Allocate 64 bytes on the stack
    0x0804842d <+9>:	mov    0xc(%ebp),%eax ; Get the arguments
    0x08048430 <+12>:	add    $0x4,%eax ; Add 4 to the arguments
    0x08048433 <+15>:	mov    (%eax),%eax ; Dereference the argument
    0x08048435 <+17>:	mov    %eax,(%esp) ; Move the first argument to the stack
    0x08048438 <+20>:	call   0x8048360 <atoi@plt> ; Call atoi
    0x0804843d <+25>:	mov    %eax,0x3c(%esp) ; Move the result to the stack
    {
            int n = atoi(av[1]);
    }
    0x08048441 <+29>:	cmpl   $0x9,0x3c(%esp) ; Compare the result to 9 (lower or equal)
    0x08048446 <+34>:	jle    0x804844f <main+43> ; Move to the next instruction
    0x08048448 <+36>:	mov    $0x1,%eax ; Move 1 to eax
    0x0804844d <+41>:	jmp    0x80484a3 <main+127> ; Jump to the end
    {
            if (atoi(av[1]) > 9)
                return 1;
    }
    0x0804844f <+43>:	mov    0x3c(%esp),%eax ; Move the result (n) to eax
    0x08048453 <+47>:	lea    0x0(,%eax,4),%ecx ; Multiply n by 4 and store the result in ecx
    0x0804845a <+54>:	mov    0xc(%ebp),%eax ; Get the arguments
    0x0804845d <+57>:	add    $0x8,%eax ; Add 8 to the arguments
    0x08048460 <+60>:	mov    (%eax),%eax ; Dereference the argument two
    0x08048462 <+62>:	mov    %eax,%edx ; Move the argument to edx
    0x08048464 <+64>:	lea    0x14(%esp),%eax ; Move the address of the stack to eax
    0x08048468 <+68>:	mov    %ecx,0x8(%esp) ; Move the result of the multiplication to the stack
    0x0804846c <+72>:	mov    %edx,0x4(%esp) ; Move the argument two to the stack
    0x08048470 <+76>:	mov    %eax,(%esp) ; Move the address on the stack to the stack
    0x08048473 <+79>:	call   0x8048320 <memcpy@plt> ; Call memcpy
    {
            memcpy(buf, av[2], n * 4);
    }
    0x08048478 <+84>:	cmpl   $0x574f4c46,0x3c(%esp) ; Compare the result to 0x574f4c46
    0x08048480 <+92>:	jne    0x804849e <main+122> ; Jump to the end if not equal
    {
            if (n != 0x574f4c46)
                return 0;
    }
    0x08048482 <+94>:	movl   $0x0,0x8(%esp) ; Move 0 to the stack
    0x0804848a <+102>:	movl   $0x8048580,0x4(%esp) ; Move the string "sh" to the stack
    0x08048492 <+110>:	movl   $0x8048583,(%esp) ; Move the string "/bin/sh" to the stack
    0x08048499 <+117>:	call   0x8048350 <execl@plt> ; Call execl
    {
            execl("/bin/sh", "sh", 0);
    }
    0x0804849e <+122>:	mov    $0x0,%eax ; Move 0 to eax
    0x080484a3 <+127>:	leave ; Restore the old base pointer
    0x080484a4 <+128>:	ret ; Return
