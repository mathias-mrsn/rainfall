#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

char buffer[76];

void
run (void) {
	fwrite("Good... Wait what?\n", 1, 19, stdout);
	system("/bin/sh");
	return;
}

int
main (int ac, char **av) {
	gets(buffer);
	return (0);
}