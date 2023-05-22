## Disassembled code

main:
   0x080485a4 <+0>:	push   %ebp ; Save the old base pointer
   0x080485a5 <+1>:	mov    %esp,%ebp ; Set the new base pointer to the current stack pointer
   0x080485a7 <+3>:	and    $0xfffffff0,%esp ; Align the stack pointer to 16 bytes
   0x080485aa <+6>:	sub    $0x40,%esp ; Allocate 64 bytes on the stack
   0x080485ad <+9>:	lea    0x16(%esp),%eax ; Load the address of our buffer into eax
   {
        char buffer[32];
   }
   0x080485b1 <+13>:	mov    %eax,(%esp) ; Push the address of our buffer onto the stack
   0x080485b4 <+16>:	call   0x804851e <pp> ; Call the function pp
   {
        pp(buffer);
   }
   0x080485b9 <+21>:	lea    0x16(%esp),%eax ; Load the address of our buffer into eax
   0x080485bd <+25>:	mov    %eax,(%esp) ; Push the address of our buffer onto the stack
   0x080485c0 <+28>:	call   0x80483b0 <puts@plt> ; Call puts
   {
        puts(buffer);
   }
   0x080485c5 <+33>:	mov    $0x0,%eax ; Set eax to 0
   0x080485ca <+38>:	leave ; Set the stack pointer to the base pointer and pop the base pointer
   0x080485cb <+39>:	ret ; Return 0
   {
        return (0);
   }

pp:
   0x0804851e <+0>:	push   %ebp
   0x0804851f <+1>:	mov    %esp,%ebp
   0x08048521 <+3>:	push   %edi
   0x08048522 <+4>:	push   %ebx
   0x08048523 <+5>:	sub    $0x50,%esp ; Allocate 80 bytes on the stack
   0x08048526 <+8>:	movl   $0x80486a0,0x4(%esp) ; Load the string " - " into the stack
   0x0804852e <+16>:	lea    -0x30(%ebp),%eax ; Create buffer of 48 bytes and put it on the $eax
   0x08048531 <+19>:	mov    %eax,(%esp) ; Push the address of the buffer onto the stack
   0x08048534 <+22>:	call   0x80484b4 <p> ; Call the function p
   {
        p(" - ", buffer1);
   }
   0x08048539 <+27>:	movl   $0x80486a0,0x4(%esp) ; Load the string " - " into the stack
   0x08048541 <+35>:	lea    -0x1c(%ebp),%eax ; Create buffer of 28 bytes and put it on  the $eax
   0x08048544 <+38>:	mov    %eax,(%esp) ; Push the address of the buffer onto the stack
   0x08048547 <+41>:	call   0x80484b4 <p> ; Call the function p
   {
        p(" - ", buffer2);
   }
   0x0804854c <+46>:	lea    -0x30(%ebp),%eax ; Load the address of buffer1 into eax
   0x0804854f <+49>:	mov    %eax,0x4(%esp) ; Push the address of buffer1 onto the stack
   0x08048553 <+53>:	mov    0x8(%ebp),%eax ; Load the argument into eax
   0x08048556 <+56>:	mov    %eax,(%esp) ; Push the argument onto the stack
   0x08048559 <+59>:	call   0x80483a0 <strcpy@plt> ; Call strcpy
   {
        strcpy(_func_arg, buffer1);
   }
   0x0804855e <+64>:	mov    $0x80486a4,%ebx ; Load the string " " into ebx
   0x08048563 <+69>:	mov    0x8(%ebp),%eax ; Load the argument into eax
   0x08048566 <+72>:	movl   $0xffffffff,-0x3c(%ebp) ; Set a variable in the stack to -1
   0x0804856d <+79>:	mov    %eax,%edx ; Move the argument into edx
   0x0804856f <+81>:	mov    $0x0,%eax ; Set eax to 0
   0x08048574 <+86>:	mov    -0x3c(%ebp),%ecx ; Move the variable into ecx
   0x08048577 <+89>:	mov    %edx,%edi ; Move the argument into edi
   0x08048579 <+91>:	repnz scas %es:(%edi),%al ; Compare each byte of the argument with 0 and return the result in %al (8 bytes of eax)
   0x0804857b <+93>:	mov    %ecx,%eax ; Move the variable into eax
   0x0804857d <+95>:	not    %eax ; Negate eax
   0x0804857f <+97>:	sub    $0x1,%eax ; Subtract 1 from eax
   0x08048582 <+100>:	add    0x8(%ebp),%eax ; Add the argument to eax
   0x08048585 <+103>:	movzwl (%ebx),%edx ; Move the first 2 bytes of ebx into edx
   {
        _func_arg[strlen(__func_arg)] = ' ';
   }
   0x08048588 <+106>:	mov    %dx,(%eax) ; Move the first 2 bytes of ebx into eax
   0x0804858b <+109>:	lea    -0x1c(%ebp),%eax ; Load the address of buffer2 into eax
   0x0804858e <+112>:	mov    %eax,0x4(%esp) ; Push the address of buffer2 onto the stack
   0x08048592 <+116>:	mov    0x8(%ebp),%eax ; Load the argument into eax
   0x08048595 <+119>:	mov    %eax,(%esp) ; Push the argument onto the stack
   0x08048598 <+122>:	call   0x8048390 <strcat@plt>
   {
        strcat(_func_arg, buffer2);
   }
   0x0804859d <+127>:	add    $0x50,%esp
   0x080485a0 <+130>:	pop    %ebx
   0x080485a1 <+131>:	pop    %edi
   0x080485a2 <+132>:	pop    %ebp
   0x080485a3 <+133>:	ret


p:
   0x080484b4 <+0>:	push   %ebp
   0x080484b5 <+1>:	mov    %esp,%ebp
   0x080484b7 <+3>:	sub    $0x1018,%esp ; Allocate 4120 bytes on the stack
   0x080484bd <+9>:	mov    0xc(%ebp),%eax ; Load the argument 2 into eax
   0x080484c0 <+12>:	mov    %eax,(%esp) ; Push the argument onto the stack
   0x080484c3 <+15>:	call   0x80483b0 <puts@plt> ; Call puts
   {
        puts(__func_arg_1);
   }
   0x080484c8 <+20>:	movl   $0x1000,0x8(%esp) ; Load 4096 into the stack
   0x080484d0 <+28>:	lea    -0x1008(%ebp),%eax ; Load the address of the buffer at $ebp-0x1008 into eax
   0x080484d6 <+34>:	mov    %eax,0x4(%esp) ; Push the address of the buffer onto the stack
   0x080484da <+38>:	movl   $0x0,(%esp) ; Push 0 onto the stack
   0x080484e1 <+45>:	call   0x8048380 <read@plt> ; Call read
   {
        read(0, buffer1, 4096);
   }
   0x080484e6 <+50>:	movl   $0xa,0x4(%esp) ; Push 10 onto the stack
   0x080484ee <+58>:	lea    -0x1008(%ebp),%eax ; Load the address of the buffer at $ebp-0x1008 into eax
   0x080484f4 <+64>:	mov    %eax,(%esp) ; Push the address of the buffer onto the stack
   0x080484f7 <+67>:	call   0x80483d0 <strchr@plt> ; Call strchr
   {
        strchr(buffer1, 10);
   }
   0x080484fc <+72>:	movb   $0x0,(%eax) ; Set the byte at the address returned by strchr to 0
   {
        strchr(buffer1, 11)[0] = 0;
   }
   0x080484ff <+75>:	lea    -0x1008(%ebp),%eax ; Load the address of the buffer at $ebp-0x1008 into eax
   0x08048505 <+81>:	movl   $0x14,0x8(%esp) ; Push 20 onto the stack
   0x0804850d <+89>:	mov    %eax,0x4(%esp) ; Push the address of the buffer onto the stack
   0x08048511 <+93>:	mov    0x8(%ebp),%eax ; Load the argument 2 into eax
   0x08048514 <+96>:	mov    %eax,(%esp) ; Push the argument onto the stack
   0x08048517 <+99>:	call   0x80483f0 <strncpy@plt> ; Call strncpy
   {
        strncpy(__func_arg_1, buffer2, 20);
   }
   0x0804851c <+104>:	leave
   0x0804851d <+105>:	ret
