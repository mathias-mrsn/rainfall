m:
    0x080484f4 <+0>:	push   %ebp ; Push the base pointer onto the stack
    0x080484f5 <+1>:	mov    %esp,%ebp ; Move the stack pointer into the base pointer
    0x080484f7 <+3>:	sub    $0x18,%esp ; Allocate 24 bytes on the stack
    0x080484fa <+6>:	movl   $0x0,(%esp) ; Move 0 into the first 4 bytes of the stack
    0x08048501 <+13>:	call   0x80483d0 <time@plt> ; Call time() with 0 as the argument
    0x08048506 <+18>:	mov    $0x80486e0,%edx ; Move the string "%s - %d\n" in $edx
    0x0804850b <+23>:	mov    %eax,0x8(%esp) ; Move the return value of time() into the 8th byte of the stack
    0x0804850f <+27>:	movl   $0x8049960,0x4(%esp) ; Move the global string inside the 4th byte of the stack
    0x08048517 <+35>:	mov    %edx,(%esp) ; Move the string "%s - %d\n" into the first byte of the stack
    0x0804851a <+38>:	call   0x80483b0 <printf@plt> ; Call printf() with "%s - %d\n", the global string, and the return value of time()
    0x0804851f <+43>:	leave ; Pop the base pointer off the stack
    0x08048520 <+44>:	ret ; Return to the calling function

main:
    0x08048521 <+0>:	push   %ebp
    0x08048522 <+1>:	mov    %esp,%ebp
    0x08048524 <+3>:	and    $0xfffffff0,%esp ; Align the stack pointer to a 16 byte boundary
    0x08048527 <+6>:	sub    $0x20,%esp ; Allocate 32 bytes on the stack
    0x0804852a <+9>:	movl   $0x8,(%esp) ; Move 8 into the first 4 bytes of the stack
    0x08048531 <+16>:	call   0x80483f0 <malloc@plt> ; Call malloc() with 8 as the argument
    0x08048536 <+21>:	mov    %eax,0x1c(%esp) ; Move the return value of malloc() into the 28th byte of the stack
    {
        ptr1 = malloc(8);
    }
    0x0804853a <+25>:	mov    0x1c(%esp),%eax ; Move the 28th byte of the stack into $eax
    0x0804853e <+29>:	movl   $0x1,(%eax) ; Set the pointer allocated to 1,
    {
        *(ptr1) = 1;
    }
    0x08048544 <+35>:	movl   $0x8,(%esp) ; Move 8 into the first 4 bytes of the stack
    0x0804854b <+42>:	call   0x80483f0 <malloc@plt> ; Call malloc() with 8 as the argument
    0x08048550 <+47>:	mov    %eax,%edx ; Move the return value of malloc() into $edx
    0x08048552 <+49>:	mov    0x1c(%esp),%eax ; Move address at 28th byte of the stack into $eax
    0x08048556 <+53>:	mov    %edx,0x4(%eax) ; Move the return value of malloc() into the 32nd byte of the stack
    {
        *(ptr1 + 4) = malloc(8);
    }
    0x08048559 <+56>:	movl   $0x8,(%esp) ; Move 8 into the first 4 bytes of the stack
    0x08048560 <+63>:	call   0x80483f0 <malloc@plt> ; Call malloc() with 8 as the argument
    0x08048565 <+68>:	mov    %eax,0x18(%esp) ; Move the return value of malloc() into the 24th byte of the stack
    {
        ptr2 = malloc(8);
    }
    0x08048569 <+72>:	mov    0x18(%esp),%eax ; Move the address at the 24th byte of the stack into $eax
    0x0804856d <+76>:	movl   $0x2,(%eax) ; Set the pointer allocated to 2
    {
        *(ptr2) = 2;
    }
    0x08048573 <+82>:	movl   $0x8,(%esp) ; Move 8 into the first 4 bytes of the stack
    0x0804857a <+89>:	call   0x80483f0 <malloc@plt> ; Call malloc() with 8 as the argument
    0x0804857f <+94>:	mov    %eax,%edx ; Move the return value of malloc() into $edx
    0x08048581 <+96>:	mov    0x18(%esp),%eax ; Move the address at the 24th byte of the stack into $eax
    0x08048585 <+100>:	mov    %edx,0x4(%eax) ; Move the return value of malloc() into the 28th byte of the stack
    {
        *(ptr2 + 4) = malloc(8);
    }
    0x08048588 <+103>:	mov    0xc(%ebp),%eax ; Move the arguments of main() into $eax
    {
        $eax = argv;
    }
    0x0804858b <+106>:	add    $0x4,%eax ; Add 4 to $eax to reach the second argument
    0x0804858e <+109>:	mov    (%eax),%eax ; Dereference the $eax value to get the second argument
    {
        $eax = *(argv + 1);
    }
    0x08048590 <+111>:	mov    %eax,%edx ; Move the second argument into $edx
    0x08048592 <+113>:	mov    0x1c(%esp),%eax ; Move the address at the 28th byte of the stack into $eax
    0x08048596 <+117>:	mov    0x4(%eax),%eax ; Move the value at the 32nd byte of the stack into $eax
    {
        $eax = (ptr1 + 4);
    }
    0x08048599 <+120>:	mov    %edx,0x4(%esp) ; Move the second argument into the 4th byte of the stack
    0x0804859d <+124>:	mov    %eax,(%esp) ; Move the value at the 32nd byte of the stack into the first byte of the stack
    0x080485a0 <+127>:	call   0x80483e0 <strcpy@plt> ; Call strcpy() with argv[1] and the pointer allocated to 1
    {
        strcpy((ptr1 + 4), argv[1]);
    }
    0x080485a5 <+132>:	mov    0xc(%ebp),%eax ; Move the arguments of main() into $eax
    0x080485a8 <+135>:	add    $0x8,%eax ; Add 8 to $eax to reach the third argument
    0x080485ab <+138>:	mov    (%eax),%eax ; Dereference the $eax value to get the third argument
    {
        $eax = *(argv + 2);
    }
    0x080485ad <+140>:	mov    %eax,%edx ; Move the third argument into $edx
    0x080485af <+142>:	mov    0x18(%esp),%eax ; Move the address at the 24th byte of the stack into $eax
    0x080485b3 <+146>:	mov    0x4(%eax),%eax ; Move the value at the 28th byte of the stack into $eax
    {
        $eax = (ptr2 + 4);
    }
    0x080485b6 <+149>:	mov    %edx,0x4(%esp) ; Load the third argument into the 4th byte of the stack
    0x080485ba <+153>:	mov    %eax,(%esp) ; Load the value at the 28th byte of the stack into the first byte of the stack
    0x080485bd <+156>:	call   0x80483e0 <strcpy@plt> ; Call strcpy() with argv[2] and the pointer allocated to 2
    {
        strcpy((ptr2 + 4), argv[2]);
    }
    0x080485c2 <+161>:	mov    $0x80486e9,%edx ; Load the address of "r" into $edx
    0x080485c7 <+166>:	mov    $0x80486eb,%eax ; Load the address of "/home/user/level8/.pass" into $eax
    0x080485cc <+171>:	mov    %edx,0x4(%esp) ; Load the address of "r" into the 4th byte of the stack
    0x080485d0 <+175>:	mov    %eax,(%esp) ; Load the address of "/home/user/level8/.pass" into the first byte of the stack
    0x080485d3 <+178>:	call   0x8048430 <fopen@plt> ; Call fopen() with the address of "/home/user/level8/.pass" and "r"
    {
        res = fopen("/home/user/level8/.pass", "r");
    }
    0x080485d8 <+183>:	mov    %eax,0x8(%esp) ; Move the return value of fopen() into the 8th byte of the stack
    0x080485dc <+187>:	movl   $0x44,0x4(%esp) ; Move 68 into the 4th byte of the stack
    0x080485e4 <+195>:	movl   $0x8049960,(%esp) ; Move the global variable into the first byte of the stack
    0x080485eb <+202>:	call   0x80483c0 <fgets@plt> ; Call fgets() with the global variable, 68, and the return value of fopen()
    {
        fgets(global, 44, res);
    }
    0x080485f0 <+207>:	movl   $0x8048703,(%esp) ; Move the address of "~~" into the first byte of the stack
    0x080485f7 <+214>:	call   0x8048400 <puts@plt> ; Call puts() with the address of "~~"
    {
        puts("~~");
    }
    0x080485fc <+219>:	mov    $0x0,%eax ; Move 0 into $eax
    0x08048601 <+224>:	leave 
    0x08048602 <+225>:	ret