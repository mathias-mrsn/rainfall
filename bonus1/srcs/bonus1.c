#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int
main (int ac, char **av) {
	int ret;
	char str[40];
	int val;

	val = atoi(av[1]);
	if (val < 10) {
		memcpy(str, av[2], val * 4);
		if (val == 0x574f4c46) {
			execl("/bin/sh", "sh", 0);
		}
		ret = 0;
	} else {
		ret = 1;
	}
	return (ret);
}