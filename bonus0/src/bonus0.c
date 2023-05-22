#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

char *
p (char *s1, char *s2) {
	char	buffer[4096];
	char	*s3;
	char	*ret;

	puts(s2);
	read(0, buffer, 4096);
	s3 = strchr(buffer, '\n');
	*s3 = 0;
	ret = strncpy(s1, buffer, 20);
    return (ret);
}

char *
pp (char *str) {
	char			b[20];
	char			a[20];
	char			*ret;
	unsigned int	len;

	p(a, " - ");
	p(b, " - ");
	strcpy(str, a);
	len = strlen(str);
	str[len] = ' ';
    str[len + 1] = 0;
	ret = strcat(str, b);
    return (ret);
}

int
main(void) {
	char	buffer[42];

	pp(buffer);
	puts(buffer);
	return (0);
}

