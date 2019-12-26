#define _GNU_SOURCE

#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <sched.h>
#include <sys/types.h>
#include <unistd.h>
#include "../kernel/tpmttl.h"


int main(int argc, char * argv[])
{

  if (argc < 2){
    printf("[X] No arguments provided!\n");
    return -1;
  }

  
  int fd;
  struct tpmttl_generic_param param;
  

  fd = open("/dev/tpmttl", O_RDWR);\
  if (fd == -1) {
    printf("Couldn't open /dev/tpmttl\n");
    return -1;
}
   
  
  int sw = atoi(argv[1]);

  switch(sw)
  {
    case 1:        
      if(ioctl(fd, TPMTTL_IOCTL_UNINSTALL_TIMER, &param)){
        printf("IOCTL failed %d\n", errno);
        return -1;
      }
      break;
    case 2:      
      if(ioctl(fd, TPMTTL_IOCTL_INSTALL_TIMER, &param)){
        printf("IOCTL failed %d\n", errno);
        return -1;
      }
      break;
    case 3:
      if(ioctl(fd, TPMTTL_IOCTL_READ, &param)){
        printf("IOCTL failed %d\n", errno);
        return -1;
      }
      for(int i = 0; i < param.cnt; i++){
          printf("%lu,", param.ttls[i]);
      }
      printf("\n");      
      break;   
    default:
      printf("Invalid switch.\n");
      return -1;
      break;
  }    
}
