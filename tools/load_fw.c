#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>

#define BAUDRATE B115200
#define FW_SIZE 768

#define _POSIX_SOURCE 1 /* POSIX compliant source */


int main(int argc, char *argv[])
{
	int fd,c, res;
	struct termios oldtio,newtio;
	char buf[1024];
	int vbias = -1, vref = -1;

	if (argc < 3) {
		printf("\n\nFirmware loader\n\nusage: %s <serial port> <.bin>\n", argv[0]);
		return 1;
	}
	

	fd = open(argv[1], O_RDWR | O_NOCTTY | O_NONBLOCK); 
	if (fd < 0) {
		perror(argv[0]);
		return 1;
	}

	tcgetattr(fd,&oldtio); /* save current port settings */

	bzero(&newtio, sizeof(newtio));
	newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
	newtio.c_iflag = IGNPAR;
	newtio.c_oflag = 0;

	/* set input mode (non-canonical, no echo,...) */
	newtio.c_lflag = 0;

	newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
	newtio.c_cc[VMIN]     = 0;   /* blocking read until 5 chars received */
	

	tcflush(fd, TCIFLUSH);
	tcsetattr(fd,TCSANOW,&newtio);

	FILE *h;
	uint8_t fw[FW_SIZE];
	int ret;
	int i;

	h = fopen(argv[2], "r");
	if (h == NULL) {
		printf("file error\n");
		return 1;
	}
	ret = fread(fw, 1, FW_SIZE, h);
	fclose(h);
	if (ret <= 0) {
		printf("file error\n");
		return 1;
	}

	ret = write(fd, fw, FW_SIZE);
	tcsetattr(fd,TCSANOW,&oldtio);
	close(fd);
	printf("sent %d bytes\n", ret);
	return 0;

}

