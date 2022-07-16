#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

void
m (void) {
	puts("Nope");
	return;
}

void
n (void) {
	system("/bin/sh /home/user/level7/.pass");
	return;
}

void
main (int ac, char **av) {
	char *str;
	void (*f)(void);

	str = (char*)malloc(64);
	f = (void*)malloc(4);
	f = m;
	strcpy(str, av[1]);
	(*f)();
	return;
}