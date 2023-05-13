#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

char c[68];

void
m (void) {
	time_t tVar1;

	tVar1 = time((time_t *)0);
	printf("%s - %d\n", c, tVar1);
	return;
}

int
main (int ac, char **av) {
	int		*s1;
	int		*s2;

	s1 = (int)malloc(8);
	s1[0] = 1;
	s1[1] = malloc(8);
	s2 = (int)malloc(8);
	s2[0] = 2;
	s2[1] = malloc(8);

	strcpy((char *)s1[1], av[1]);
	strcpy((char *)s2[1], av[2]);
	fgets(c, 68, fopen("/home/user/level8/.pass", "r"));
	puts("~~");
	return (0);
}