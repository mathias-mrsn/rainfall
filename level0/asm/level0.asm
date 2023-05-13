main:
    0x08048ec0 <+0>:	push   %ebp                        ; Save the value of the base pointer on the stack
    0x08048ec1 <+1>:	mov    %esp,%ebp                   ; Copy the value of the stack pointer to the base pointer
    0x08048ec3 <+3>:	and    $0xfffffff0,%esp            ; Align the stack pointer to a 16-byte boundary
    0x08048ec6 <+6>:	sub    $0x20,%esp                  ; Allocate space on the stack for local variables
    0x08048ec9 <+9>:	mov    0xc(%ebp),%eax              ; Retrieve the value of the function argument into the %eax register
    0x08048ecc <+12>:	add    $0x4,%eax                   ; Add 4 to the argument value
    0x08048ecf <+15>:	mov    (%eax),%eax                 ; Move the value pointed to by %eax into %eax
    0x08048ed1 <+17>:	mov    %eax,(%esp)                 ; Place the value of %eax on the stack
    0x08048ed4 <+20>:	call   0x8049710 <atoi>            ; Call the atoi function with the argument from the stack
    0x08048ed9 <+25>:	cmp    $0x1a7,%eax                 ; Compare the value of %eax with 0x1a7
    0x08048ede <+30>:	jne    0x8048f58 <main+152>        ; Jump to the label if the comparison is not equal
    0x08048ee0 <+32>:	movl   $0x80c5348,(%esp)           ; Place a value on the stack
    0x08048ee7 <+39>:	call   0x8050bf0 <strdup>          ; Call the strdup function with the argument from the stack
    0x08048eec <+44>:	mov    %eax,0x10(%esp)             ; Store the returned value in a stack location
    0x08048ef0 <+48>:	movl   $0x0,0x14(%esp)             ; Place a value on the stack
    0x08048ef8 <+56>:	call   0x8054680 <getegid>         ; Call the getegid function
    0x08048efd <+61>:	mov    %eax,0x1c(%esp)             ; Store the return value in a stack location
    0x08048f01 <+65>:	call   0x8054670 <geteuid>         ; Call the geteuid function
    0x08048f06 <+70>:	mov    %eax,0x18(%esp)             ; Store the return value in a stack location
    0x08048f0a <+74>:	mov    0x1c(%esp),%eax             ; Move the value from a stack location to %eax
    0x08048f0e <+78>:	mov    %eax,0x8(%esp)              ; Store the value in a stack location
    0x08048f12 <+82>:	mov    0x1c(%esp),%eax             ; Move the value from a stack location to %eax
    0x08048f16 <+86>:	mov    %eax,0x4(%esp)              ; Store the value in a stack location
    0x08048f1a <+90>:	mov    0x1c(%esp),%eax             ; Move the value from a stack location to %eax
    0x08048f1e <+94>:	mov    %eax,(%esp)                 ; Place the value of %eax on the stack
    0x08048f21 <+97>:	call   0x8054700 <setresgid>       ; Call the setresgid function with the arguments from the stack
    0x08048f26 <+102>:	mov    0x18(%esp),%eax             ; Move the value from a stack location to %eax
    0x08048f2a <+106>:	mov    %eax,0x8(%esp)              ; Store the value in a stack location
    0x08048f2e <+110>:	mov    0x18(%esp),%eax             ; Move the value from a stack location to %eax
    0x08048f32 <+114>:	mov    %eax,0x4(%esp)              ; Store the value in a stack location
    0x08048f36 <+118>:	mov    0x18(%esp),%eax             ; Move the value from a stack location to %eax
    0x08048f3a <+122>:	mov    %eax,(%esp)                 ; Place the value of %eax on the stack
    0x08048f3d <+125>:	call   0x8054690 <setresuid>       ; Call the setresuid function with the arguments from the stack
    0x08048f42 <+130>:	lea    0x10(%esp),%eax             ; Compute the effective address of a stack location into %eax
    0x08048f46 <+134>:	mov    %eax,0x4(%esp)              ; Store the value in a stack location
    0x08048f4a <+138>:	movl   $0x80c5348,(%esp)           ; Place a value on the stack
    0x08048f51 <+145>:	call   0x8054640 <execv>           ; Call the execv function with the arguments from the stack
    0x08048f56 <+150>:	jmp    0x8048f80 <main+192>        ; Unconditional jump to the specified label
    0x08048f58 <+152>:	mov    0x80ee170,%eax              ; Move the value from a memory location into %eax
    0x08048f5d <+157>:	mov    %eax,%edx                   ; Move the value of %eax to %edx
    0x08048f5f <+159>:	mov    $0x80c5350,%eax             ; Move a constant value to %eax
    0x08048f64 <+164>:	mov    %edx,0xc(%esp)              ; Store the value of %edx in a stack location
    0x08048f68 <+168>:	movl   $0x5,0x8(%esp)              ; Store a constant value in a stack location
    0x08048f70 <+176>:	movl   $0x5,0x8(%esp)              ; Store a constant value in a stack location
    0x08048f78 <+184>:	mov    %eax,(%esp)                 ; Place the value of %eax on the stack
    0x08048f7b <+187>:	call   0x804a230 <fwrite>          ; Call the fwrite function with the arguments from the stack
    0x08048f80 <+192>:	mov    $0x0,%eax                   ; Move the value 0 to %eax
    0x08048f85 <+197>:	leave                              ; Restore the previous stack frame
    0x08048f86 <+198>:	ret    