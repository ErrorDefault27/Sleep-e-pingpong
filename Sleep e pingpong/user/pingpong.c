#include "user.h"

#include "types.h"

#include "stat.h"

#include "fcntl.h"

#include "syscall.h"
 
int main() {

    int pipe1[2], pipe2[2]; 

    char byte = 'A'; 

    if (pipe(pipe1) < 0 || pipe(pipe2) < 0) {

        printf(2, "pingpong: pipe failed\n");

        exit(1);

    }
 
    int pid = fork();

    if (pid < 0) {

        printf(2, "pingpong: fork failed\n");

        exit(1);

    }
 
    if (pid == 0) { 

        close(pipe1[1]);  

        close(pipe2[0]);
 
        

        read(pipe1[0], &byte, 1);

        printf(1, "%d: received ping\n", getpid());
 
        

        write(pipe2[1], &byte, 1);
 
        close(pipe1[0]);

        close(pipe2[1]);

        exit(0);

    } else { 

        close(pipe1[0]);  

        close(pipe2[1]);  
 
        

        write(pipe1[1], &byte, 1);
 
        

        read(pipe2[0], &byte, 1);

        printf(1, "%d: received pong\n", getpid());
 
        close(pipe1[1]);

        close(pipe2[0]);

        wait();  

        exit(0);

    }

}
