#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

int
main (int ac, char **av) {
	char	*path;
	uid_t	uid;
	gid_t 	gid;
	
	int val = atoi(av[1]);
	if (val == 423) {
		path = strdup("/bin/sh");
		uid = getuid();
		gid = getgid();
		execv("/bin/sh", &path);
	} else {
		fwrite("No !\n", 1, 5, stderr);
	}
	return (0);
}