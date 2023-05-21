main:
    0x080485f4 <+0>:	push   %ebp ; Save the old base pointer
    0x080485f5 <+1>:	mov    %esp,%ebp ; Set $ebp to the current stack pointer
    0x080485f7 <+3>:	push   %ebx ; Save the old $ebx
    0x080485f8 <+4>:	and    $0xfffffff0,%esp ; Align the stack pointer
    0x080485fb <+7>:	sub    $0x20,%esp ; Allocate 32 bytes on the stack
    0x080485fe <+10>:	cmpl   $0x1,0x8(%ebp) ; Compare the number of argument with 1
    0x08048602 <+14>:	jg     0x8048610 <main+28> ; If there is greater than 1 argument, jump to main+28
    {
        if (argc > 1)
            goto main+28;
    }
    0x08048604 <+16>:	movl   $0x1,(%esp) ; Load 1 into the stack
    0x0804860b <+23>:	call   0x80484f0 <_exit@plt> ; Exit the program
    {
        exit(1);
    }
    0x08048610 <+28>:	movl   $0x6c,(%esp) ; Load 0x6c into the heap
    0x08048617 <+35>:	call   0x8048530 <_Znwj@plt> Call function related to dynamic memory allocation. I suspect this function to allocate 0x6c bytes on the heap and return the address of the allocated memory.
    0x0804861c <+40>:	mov    %eax,%ebx ; Save the return value of the function in $ebx
    0x0804861e <+42>:	movl   $0x5,0x4(%esp) ; Load 5 into the stack
    0x08048626 <+50>:	mov    %ebx,(%esp) ; Load the return value of the function into the stack
    0x08048629 <+53>:	call   0x80486f6 <_ZN1NC2Ei> ; Call the constructor of the class N
    0x0804862e <+58>:	mov    %ebx,0x1c(%esp) ; Load the return address allocated into the stack
    {
        N *n = new N(5);
    }
    0x08048632 <+62>:	movl   $0x6c,(%esp)
    0x08048639 <+69>:	call   0x8048530 <_Znwj@plt> 
    0x0804863e <+74>:	mov    %eax,%ebx
    0x08048640 <+76>:	movl   $0x6,0x4(%esp)
    0x08048648 <+84>:	mov    %ebx,(%esp)
    0x0804864b <+87>:	call   0x80486f6 <_ZN1NC2Ei>
    0x08048650 <+92>:	mov    %ebx,0x18(%esp) ; Load the return address allocated into the stack
    {
        N *n2 = new N(6);
    }
    0x08048654 <+96>:	mov    0x1c(%esp),%eax ; Load the first allocation in $eax
    0x08048658 <+100>:	mov    %eax,0x14(%esp) ; Load the first allocation into the stack
    {
        void *ptr1 = n;
    }
    0x0804865c <+104>:	mov    0x18(%esp),%eax ; Load the second allocation in $eax
    0x08048660 <+108>:	mov    %eax,0x10(%esp) ; Load the second allocation into the stack
    {
        void *ptr2 = n2;
    }
    0x08048664 <+112>:	mov    0xc(%ebp),%eax ; Load the arguments into $eax
    0x08048667 <+115>:	add    $0x4,%eax ; Add 4 to the first argument
    0x0804866a <+118>:	mov    (%eax),%eax ; dereferences the first argument
    0x0804866c <+120>:	mov    %eax,0x4(%esp) ; Load the first argument into the stack
    0x08048670 <+124>:	mov    0x14(%esp),%eax ; Load the ptr1 into $eax
    0x08048674 <+128>:	mov    %eax,(%esp) ; Load the ptr1 into the stack
    0x08048677 <+131>:	call   0x804870e <_ZN1N13setAnnotationEPc> ; Call the setAnnotation function
    {
        ptr1->setAnnotation(argv[1]);
    }
    0x0804867c <+136>:	mov    0x10(%esp),%eax ; Load the ptr2 into $eax
    0x08048680 <+140>:	mov    (%eax),%eax ; dereferences the ptr2 in $eax
    0x08048682 <+142>:	mov    (%eax),%edx ; dereferences the ptr2 again and load the function pointer into $edx
    0x08048684 <+144>:	mov    0x14(%esp),%eax ; Load the ptr1 into $eax
    0x08048688 <+148>:	mov    %eax,0x4(%esp) ; Load the ptr1 into the stack
    0x0804868c <+152>:	mov    0x10(%esp),%eax ; Load the ptr2 into $eax
    0x08048690 <+156>:	mov    %eax,(%esp) ; Load the ptr2 into the stack
    0x08048693 <+159>:	call   *%edx ; Call the function pointed by $edx
    {
        (*ptr2)->operator+(*ptr1);
    }
    0x08048695 <+161>:	mov    -0x4(%ebp),%ebx
    0x08048698 <+164>:	leave
    0x08048699 <+165>:	ret

_ZN1NC2Ei:
    0x080486f6 <+0>:	push   %ebp
    0x080486f7 <+1>:	mov    %esp,%ebp
    0x080486f9 <+3>:	mov    0x8(%ebp),%eax ; Load the first argument into $eax
    0x080486fc <+6>:	movl   $0x8048848,(%eax) ; Load 0x8048848 into the address pointed by $eax
    0x08048702 <+12>:	mov    0x8(%ebp),%eax ; Load the first argument into $eax
    0x08048705 <+15>:	mov    0xc(%ebp),%edx ; Load the second argument into $edx
    0x08048708 <+18>:	mov    %edx,0x68(%eax) ; Load the second argument into the address pointed by $eax+0x68
    0x0804870b <+21>:	pop    %ebp
    0x0804870c <+22>:	ret

_ZN1N13setAnnotationEPc:
    0x0804870e <+0>:	push   %ebp
    0x0804870f <+1>:	mov    %esp,%ebp
    0x08048711 <+3>:	sub    $0x18,%esp ; Allocate 24 bytes in the stack
    0x08048714 <+6>:	mov    0xc(%ebp),%eax ; Load the first argument into $eax
    0x08048717 <+9>:	mov    %eax,(%esp) ; Load the argument into the stack
    0x0804871a <+12>:	call   0x8048520 <strlen@plt> ; Call the strlen function
    {
        strlen(n);
    }
    0x0804871f <+17>:	mov    0x8(%ebp),%edx ; Load the this into $edx
    0x08048722 <+20>:	add    $0x4,%edx ; Add 4 to the this
    0x08048725 <+23>:	mov    %eax,0x8(%esp) ; Load the return value of strlen into the stack
    0x08048729 <+27>:	mov    0xc(%ebp),%eax ; Load the argument
    0x0804872c <+30>:	mov    %eax,0x4(%esp) ; Load the argument into the stack
    0x08048730 <+34>:	mov    %edx,(%esp) ; Load the this->var into the stack
    0x08048733 <+37>:	call   0x8048510 <memcpy@plt> ; Call the memcpy function
    {
        memcpy(this->var, n, strlen(n));
    }
    0x08048738 <+42>:	leave
    0x08048739 <+43>:	ret