#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int	language;

void
greetuser (char *user) {
	char	buffer[64];

	if (language == 1)
		strcpy(buffer, "Hyvää päivää ");
	else if (language == 2)
		strcpy(buffer, "Goedemiddag! ");
	else if (language == 0)
		strcpy(buffer, "Hello ");
	strcat(buffer, user);
	puts(buffer);
}

int
main (int argc, char **argv) {
	char	buffer[72];
	char	*env;

	env = NULL;
	if (argc != 3) {
		return (1);
	}
	memset(buffer, 0, 72);
	strncpy(buffer, argv[1], 40);
	strncpy(&buffer[40], argv[2], 32);
	env = getenv("LANG");
	if (env) {
		if (memcmp(env, "fi", 2) == 0) {
			language = 1;
		} else if (memcmp(env, "nl", 2) == 0) {
			language = 2;
		}
	}
    // memcpy(buffer-72, buffer, 72);
	greetuser(buffer);
	return (0);
}