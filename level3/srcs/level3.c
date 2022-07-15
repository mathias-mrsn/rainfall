#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int		m;

void
v(void) {
	char	buffer[520];

	fgets(buffer, 0x200, stdin);
	printf(buffer);
	if (m == 64) {
		fwrite("Wait what?!\n", 1, 12, stdout);
		system("/bin/sh");
	}
	return ;
}

int
main(void) {
	v();
	return;
}