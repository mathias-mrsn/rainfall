#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

void
p (void) {
	void	*ret_addr;
	char	buffer[76];

	fflush(stdout);
	gets(buffer);

	ret_addr = __builtin_ret_addr(0);
	if (((unsigned int)ret_addr & 0xb0000000) == 0xb0000000) {
		printf("(%p)\n", ret_addr);
		exit(1);
	}
	puts(buffer);
	strdup(buffer);
	return ;
}

int
main (void) {
	p();
	return (0);
}