#include "user.h"

#include "types.h"

#include "stat.h"

#include "fcntl.h"

#include "syscall.h"
 
int main(int argc, char *argv[]) {

    if (argc < 2) {

        printf(2, "sleep: missing operand\n");

        exit(1);

    }
 
    int ticks = atoi(argv[1]);

    if (ticks <= 0) {

        printf(2, "sleep: invalid number of ticks\n");

        exit(1);

    }
 
    sleep(ticks);  // Chamada de sistema sleep

    exit(0);  // Finaliza o programa com status 0

}
