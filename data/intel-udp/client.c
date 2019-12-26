// Client side implementation of UDP client-server model 
#include <stdio.h> 
#include <stdlib.h> 
#include <stdint.h>
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 
  

static __inline__ unsigned long long rdtsc(void)
{
    unsigned hi, lo;
    __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
    return ( (unsigned long long)lo)|( ((unsigned long long)hi)<<32 );
}

#define PORT     3000 
  

#define TPM2_MAX_ECC_KEY_BYTES 128

typedef struct {
    uint16_t size;
    uint8_t buffer[TPM2_MAX_ECC_KEY_BYTES];
} TPM2B_ECC_PARAMETER;



static void print_sig_hex(char * data){
    int i;
    TPM2B_ECC_PARAMETER * R = (TPM2B_ECC_PARAMETER *)data;
    TPM2B_ECC_PARAMETER * S = (TPM2B_ECC_PARAMETER *)(data + sizeof(TPM2B_ECC_PARAMETER));


    for(i = 0; i < R->size; i++){
        printf("%02x", (unsigned char)R->buffer[i]);
    }
    printf("\n");

    for(i = 0; i < S->size; i++){
        printf("%02x", (unsigned char)S->buffer[i]);
    }
    printf("\n"); 
}

char buffer[1024];
#define SRV_IP "130.215.23.18"

// Driver code 
int main() { 
    int sockfd;  
    char *msg = "0"; 
    struct sockaddr_in     servaddr; 
  
    // Creating socket file descriptor 
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) { 
        perror("socket creation failed"); 
        exit(EXIT_FAILURE); 
    } 
  
    memset(&servaddr, 0, sizeof(servaddr)); 
      
    // Filling server information 
    servaddr.sin_family = AF_INET; 
    servaddr.sin_port = htons(3000); 
    // servaddr.sin_addr.s_addr = INADDR_ANY; 

    if (inet_aton(SRV_IP, &servaddr.sin_addr)==0) {
        fprintf(stderr, "inet_aton() failed\n");
        exit(1);
    }
      
    int n, len; 
      
    
    unsigned long long t = rdtsc();
    sendto(sockfd, (const char *)msg, strlen(msg), 
        MSG_CONFIRM, (const struct sockaddr *) &servaddr,  
            sizeof(servaddr)); 
            
    n = recvfrom(sockfd, (char *)buffer, 1024,  
                MSG_WAITALL, (struct sockaddr *) &servaddr, 
                &len);

    print_sig_hex(buffer);

    buffer[n] = '\0'; 
    printf("%llu\n", rdtsc()-t);
    close(sockfd); 
    return 0; 
} 