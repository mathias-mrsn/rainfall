n:
    0x08048454 <+0>:	push   %ebp ; Save the old $ebp address
    0x08048455 <+1>:	mov    %esp,%ebp ; Put $ebp at the same place than $esp
    0x08048457 <+3>:	sub    $0x18,%esp ; Allocate 24 bytes.
    0x0804845a <+6>:	movl   $0x80485b0,(%esp) ; Put the string "/bin/cat /home/user/level7/.pass" inside $esp
    0x08048461 <+13>:	call   0x8048370 <system@plt> ; Call system with "/bin/cat /home/user/level7/.pass" as argument
    0x08048466 <+18>:	leave  ; Set $esp to $ebp, set $ebp to (old ebp) and pop (old ebp)
    0x08048467 <+19>:	ret ; Go to return address

m:
    0x08048468 <+0>:	push   %ebp
    0x08048469 <+1>:	mov    %esp,%ebp
    0x0804846b <+3>:	sub    $0x18,%esp
    0x0804846e <+6>:	movl   $0x80485d1,(%esp) ; Put the string "Nope" inside $esp
    0x08048475 <+13>:	call   0x8048360 <puts@plt> ; Call puts with "Nope" as asgument.
    0x0804847a <+18>:	leave
    0x0804847b <+19>:	ret

main:
    0x0804847c <+0>:	push   %ebp
    0x0804847d <+1>:	mov    %esp,%ebp
    0x0804847f <+3>:	and    $0xfffffff0,%esp ; Align the memory;
    0x08048482 <+6>:	sub    $0x20,%esp ; Allocate 32 bytes
    0x08048485 <+9>:	movl   $0x40,(%esp) ; Set the number 64 in $esp
    0x0804848c <+16>:	call   0x8048350 <malloc@plt> ; Allocate 64 in heap 
    0x08048491 <+21>:	mov    %eax,0x1c(%esp) ; Store the address allocated in $esp+28
    0x08048495 <+25>:	movl   $0x4,(%esp) ; Set the number 4 in $esp
    0x0804849c <+32>:	call   0x8048350 <malloc@plt> ; Allocate 4 bytes in heap;
    0x080484a1 <+37>:	mov    %eax,0x18(%esp) ; Store the address allocated in $esp+24
    0x080484a5 <+41>:	mov    $0x8048468,%edx ; Set m function address in $edx
    0x080484aa <+46>:	mov    0x18(%esp),%eax ; Move the second allocated address in $eax
    0x080484ae <+50>:	mov    %edx,(%eax) ; The second allocated address point to m
    0x080484b0 <+52>:	mov    0xc(%ebp),%eax ; Move the main argv to $eax
    0x080484b3 <+55>:	add    $0x4,%eax ; Increment of 1 bytes argv to get argv[1] 
    0x080484b6 <+58>:	mov    (%eax),%eax ; Dereference $eax
    0x080484b8 <+60>:	mov    %eax,%edx ; Move argv[1] to $edx;
    0x080484ba <+62>:	mov    0x1c(%esp),%eax ; Move the first allocated address to $eax
    0x080484be <+66>:	mov    %edx,0x4(%esp) ; Put in $esp+4 argv[1] 
    0x080484c2 <+70>:	mov    %eax,(%esp) ; Put in $esp the first allocated address
    0x080484c5 <+73>:	call   0x8048340 <strcpy@plt> ; Call strcpy with buffer as first arg and argv[1] as second
    0x080484ca <+78>:	mov    0x18(%esp),%eax ; Move the second address allocated in $eax (this address point to m)
    0x080484ce <+82>:	mov    (%eax),%eax ; Dereference $eax
    0x080484d0 <+84>:	call   *%eax ; Call the function of $eax
    0x080484d2 <+86>:	leave
    0x080484d3 <+87>:	ret