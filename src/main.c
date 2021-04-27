#include <stdio.h>

int
main(void)
{
	fprintf(stdout, "Hello world\n");
	fprintf(stderr, "Hello error\n");
	return 1;
}