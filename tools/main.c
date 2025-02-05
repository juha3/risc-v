#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
	uint8_t b[4];
	int ret;
	char s[256];

	if (argc > 1) {
		while(1) {
			if (fgets(s, 255, stdin) == NULL) break;
			sscanf(s, "%x", &ret);
			fwrite(&ret, 1, 4, stdout);
		}
		return 0;
	}
	
	while(1) {
		ret = fread(b, 1, 4, stdin);
		if (ret <= 0) break;
		printf("%02x%02x%02x%02x\n", b[3], b[2], b[1], b[0]);
	}
	return 0;
}

