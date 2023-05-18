main:
    0x08048564 <+0>:	push   %ebp ; Save the old base pointer
    0x08048565 <+1>:	mov    %esp,%ebp ; Set $ebp to the current stack pointer
    0x08048567 <+3>:	push   %edi ; Save the old value of $edi
    0x08048568 <+4>:	push   %esi ; Save the old value of $esi
    0x08048569 <+5>:	and    $0xfffffff0,%esp ; Align the stack pointer
    0x0804856c <+8>:	sub    $0xa0,%esp ; Allocate 160 bytes on the stack
    0x08048572 <+14>:	jmp    0x8048575 <main+17> ; Jump to the next instruction
    0x08048574 <+16>:	nop
    0x08048575 <+17>:	mov    0x8049ab0,%ecx ; Move the global variable service into $ecx
    0x0804857b <+23>:	mov    0x8049aac,%edx ; Move the global variable auth into $edx
    0x08048581 <+29>:	mov    $0x8048810,%eax ; Move the string "%p, %p \n" into $eax
    0x08048586 <+34>:	mov    %ecx,0x8(%esp) ; Move the value of $ecx into the 8th byte of the stack
    0x0804858a <+38>:	mov    %edx,0x4(%esp) ; Move the value of $edx into the 4th byte of the stack
    0x0804858e <+42>:	mov    %eax,(%esp) ; Move the value of $eax into the 0th byte of the stack
    0x08048591 <+45>:	call   0x8048410 <printf@plt> ; Call printf
    {
        printf("%p, %p \n", auth, service);
    }
    0x08048596 <+50>:	mov    0x8049a80,%eax ; Move the global variable stdin into $eax
    0x0804859b <+55>:	mov    %eax,0x8(%esp) ; Move stdin into the 8th byte of the stack
    0x0804859f <+59>:	movl   $0x80,0x4(%esp) ; Move 128 into the 4th byte of the stack
    0x080485a7 <+67>:	lea    0x20(%esp),%eax ; Move the address of the 32nd byte of the stack into $eax
    0x080485ab <+71>:	mov    %eax,(%esp) ; Move the value of $eax into the 0th byte of the stack
    0x080485ae <+74>:	call   0x8048440 <fgets@plt> ; Call fgets
    {
        fgets(buffer, 128, stdin);
    }
    0x080485b3 <+79>:	test   %eax,%eax ; Test if fgets returned 0
    0x080485b5 <+81>:	je     0x804872c <main+456> ; If fgets returned 0, jump to the end of main
    {
        if (fgets(...) == 0)
            break;
    }
    0x080485bb <+87>:	lea    0x20(%esp),%eax ; Move the address of the 32nd byte of the stack into $eax
    0x080485bf <+91>:	mov    %eax,%edx ; Move the value of $eax into $edx
    0x080485c1 <+93>:	mov    $0x8048819,%eax ; Move the string "auth " into $eax
    0x080485c6 <+98>:	mov    $0x5,%ecx ; Move 5 into $ecx
    0x080485cb <+103>:	mov    %edx,%esi ; Move the value of $edx into $esi
    0x080485cd <+105>:	mov    %eax,%edi ; Move the value of $eax into $edi
    0x080485cf <+107>:	repz cmpsb %es:(%edi),%ds:(%esi) ; Compare the string in $edi with the string in $esi
    0x080485d1 <+109>:	seta   %dl ; Set $dl to 1 if the strings in $edi is greater than the string in $esi
    0x080485d4 <+112>:	setb   %al ; Set $al to 1 if the strings in $edi is less than the string in $esi
    0x080485d7 <+115>:	mov    %edx,%ecx ; Move the value of $dl into $ecx
    0x080485d9 <+117>:	sub    %al,%cl ; Subtract $al from $cl (low byes register of $ecx)
    0x080485db <+119>:	mov    %ecx,%eax ; Move the value of $ecx into $eax
    0x080485dd <+121>:	movsbl %al,%eax ; Move the sign extended value of $al into $eax
    0x080485e0 <+124>:	test   %eax,%eax ; Test if $eax is 0
    0x080485e2 <+126>:	jne    0x8048642 <main+222> ; If $eax is not 0, jump to the end of main
    {
        if (strncmp(buffer, "auth ", 5) == 0)
            auth = malloc(4);
    }
    0x080485e4 <+128>:	movl   $0x4,(%esp) ; Move 4 into the 0th byte of the stack
    0x080485eb <+135>:	call   0x8048470 <malloc@plt> ; Call malloc
    0x080485f0 <+140>:	mov    %eax,0x8049aac ; Move the return value of malloc into the global variable auth
    {
        auth = malloc(4);
    }
    0x080485f5 <+145>:	mov    0x8049aac,%eax ; Move the global variable auth into $eax
    0x080485fa <+150>:	movl   $0x0,(%eax) ; Move 0 into the 0th byte of the address in $eax
    {
        auth[0] = 0;
    }
    0x08048600 <+156>:	lea    0x20(%esp),%eax ; Move the buffer address in $eax
    0x08048604 <+160>:	add    $0x5,%eax ; Add 5 to the address in $eax
    0x08048607 <+163>:	movl   $0xffffffff,0x1c(%esp) ; Move -1 into the 28th byte of the stack
    0x0804860f <+171>:	mov    %eax,%edx ; Move the value of $eax into $edx
    0x08048611 <+173>:	mov    $0x0,%eax ; Move 0 into $eax (buffer + 5)
    0x08048616 <+178>:	mov    0x1c(%esp),%ecx ; Move -1 to $ecx
    0x0804861a <+182>:	mov    %edx,%edi ; Move the value of $edx into $edi
    0x0804861c <+184>:	repnz scas %es:(%edi),%al ; Scan the buffer from buffer + 5 until null byte is found
    0x0804861e <+186>:	mov    %ecx,%eax ; Move the value of $ecx into $eax ($ecx is the length of $edi)
    0x08048620 <+188>:	not    %eax ; Negate $eax
    0x08048622 <+190>:	sub    $0x1,%eax ; Subtract 1 from $eax
    0x08048625 <+193>:	cmp    $0x1e,%eax ; Compare $eax with 30
    0x08048628 <+196>:	ja     0x8048642 <main+222> ; If $eax is greater than 30, jump to the end of main
    {
        if (strlen(buffer + 5) > 30)
            return 1;
    }
    0x0804862a <+198>:	lea    0x20(%esp),%eax ; Move the buffer address in $eax
    0x0804862e <+202>:	lea    0x5(%eax),%edx ; Move the buffer address + 5 into $edx
    0x08048631 <+205>:	mov    0x8049aac,%eax ; Move the global variable auth into $eax
    0x08048636 <+210>:	mov    %edx,0x4(%esp) ; Move the buffer address + 5 into the 4th byte of the stack
    0x0804863a <+214>:	mov    %eax,(%esp) ; Move the global variable auth into the 0th byte of the stack
    0x0804863d <+217>:	call   0x8048460 <strcpy@plt> ; Call strcpy
    {
        strcpy(auth, buffer + 5);
    }
    0x08048642 <+222>:	lea    0x20(%esp),%eax
    0x08048646 <+226>:	mov    %eax,%edx
    0x08048648 <+228>:	mov    $0x804881f,%eax ; Move the string "reset" into $eax
    0x0804864d <+233>:	mov    $0x5,%ecx
    0x08048652 <+238>:	mov    %edx,%esi
    0x08048654 <+240>:	mov    %eax,%edi
    0x08048656 <+242>:	repz cmpsb %es:(%edi),%ds:(%esi)
    0x08048658 <+244>:	seta   %dl
    0x0804865b <+247>:	setb   %al
    0x0804865e <+250>:	mov    %edx,%ecx
    0x08048660 <+252>:	sub    %al,%cl
    0x08048662 <+254>:	mov    %ecx,%eax
    0x08048664 <+256>:	movsbl %al,%eax
    0x08048667 <+259>:	test   %eax,%eax
    0x08048669 <+261>:	jne    0x8048678 <main+276>
    {
        if (strncmp(buffer, "reset", 5) != 0)
    }
    0x0804866b <+263>:	mov    0x8049aac,%eax ; Move the global variable auth into $eax
    0x08048670 <+268>:	mov    %eax,(%esp) ; Move the global variable auth into the 0th byte of the stack
    0x08048673 <+271>:	call   0x8048420 <free@plt> ; Call free
    {
        free(auth);
    }
    0x08048678 <+276>:	lea    0x20(%esp),%eax
    0x0804867c <+280>:	mov    %eax,%edx
    0x0804867e <+282>:	mov    $0x8048825,%eax ; Move the string "service" into $eax
    0x08048683 <+287>:	mov    $0x6,%ecx
    0x08048688 <+292>:	mov    %edx,%esi
    0x0804868a <+294>:	mov    %eax,%edi
    0x0804868c <+296>:	repz cmpsb %es:(%edi),%ds:(%esi)
    0x0804868e <+298>:	seta   %dl
    0x08048691 <+301>:	setb   %al
    0x08048694 <+304>:	mov    %edx,%ecx
    0x08048696 <+306>:	sub    %al,%cl
    0x08048698 <+308>:	mov    %ecx,%eax
    0x0804869a <+310>:	movsbl %al,%eax
    0x0804869d <+313>:	test   %eax,%eax
    0x0804869f <+315>:	jne    0x80486b5 <main+337>
    {
        if (strncmp(buffer, "service", 6) != 0)
    }
    0x080486a1 <+317>:	lea    0x20(%esp),%eax ; Move the buffer address into $eax
    0x080486a5 <+321>:	add    $0x7,%eax ; Add 7 to $eax
    0x080486a8 <+324>:	mov    %eax,(%esp) ; Move the buffer address + 7 into the 0th byte of the stack
    0x080486ab <+327>:	call   0x8048430 <strdup@plt> ; Call strdup
    0x080486b0 <+332>:	mov    %eax,0x8049ab0 ; Move the return value of strdup into the global variable service
    {
        service = strdup(buffer + 7);
    }
    0x080486b5 <+337>:	lea    0x20(%esp),%eax
    0x080486b9 <+341>:	mov    %eax,%edx
    0x080486bb <+343>:	mov    $0x804882d,%eax
    0x080486c0 <+348>:	mov    $0x5,%ecx
    0x080486c5 <+353>:	mov    %edx,%esi
    0x080486c7 <+355>:	mov    %eax,%edi
    0x080486c9 <+357>:	repz cmpsb %es:(%edi),%ds:(%esi)
    0x080486cb <+359>:	seta   %dl
    0x080486ce <+362>:	setb   %al
    0x080486d1 <+365>:	mov    %edx,%ecx
    0x080486d3 <+367>:	sub    %al,%cl
    0x080486d5 <+369>:	mov    %ecx,%eax
    0x080486d7 <+371>:	movsbl %al,%eax
    0x080486da <+374>:	test   %eax,%eax
    0x080486dc <+376>:	jne    0x8048574 <main+16>
    {
        if (strncmp(buffer, "login", 5) != 0)
            goto _main+16;
    }
    0x080486e2 <+382>:	mov    0x8049aac,%eax ; Move the global variable auth into $eax
    0x080486e7 <+387>:	mov    0x20(%eax),%eax ; Move the 32nd byte of the global variable auth into $eax
    0x080486ea <+390>:	test   %eax,%eax ; Test if $eax is 0
    0x080486ec <+392>:	je     0x80486ff <main+411>
    {
        if (auth[32] == 0)
            goto _main+411;
    }
    0x080486ee <+394>:	movl   $0x8048833,(%esp) ; Move the string "/bin/sh" into the 0th byte of the stack
    0x080486f5 <+401>:	call   0x8048480 <system@plt> ; Call system
    0x080486fa <+406>:	jmp    0x8048574 <main+16>
    {
        system("/bin/sh");
        goto _main+16;
    }
    0x080486ff <+411>:	mov    0x8049aa0,%eax ; Move stdout in $eax
    0x08048704 <+416>:	mov    %eax,%edx ; Move stdout in $edx
    0x08048706 <+418>:	mov    $0x804883b,%eax ; Move the string "Password:\n" in $eax
    0x0804870b <+423>:	mov    %edx,0xc(%esp) ; Move stdout in the 12th byte of the stack
    0x0804870f <+427>:	movl   $0xa,0x8(%esp) ; Move 10 in the 8th byte of the stack
    0x08048717 <+435>:	movl   $0x1,0x4(%esp) ; Move 1 in the 4th byte of the stack
    0x0804871f <+443>:	mov    %eax,(%esp) ; Move stdout in the 0th byte of the stack
    0x08048722 <+446>:	call   0x8048450 <fwrite@plt> ; Call fwrite
    0x08048727 <+451>:	jmp    0x8048574 <main+16>
    {
        fwrite("Password:\n", 1, 10, stdout);
        goto _main+16;
    }
    0x0804872c <+456>:	nop ; No operation
    0x0804872d <+457>:	mov    $0x0,%eax ; Move 0 in $eax
    0x08048732 <+462>:	lea    -0x8(%ebp),%esp ; Move the stack pointer to the base pointer - 8
    0x08048735 <+465>:	pop    %esi ; Pop the stack into $esi
    0x08048736 <+466>:	pop    %edi ; Pop the stack into $edi
    0x08048737 <+467>:	pop    %ebp ; Pop the stack into $ebp
    0x08048738 <+468>:	ret
