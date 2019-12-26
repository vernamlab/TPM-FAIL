struct tpmttl_generic_param {
  unsigned long long ttls[1000];
  unsigned long long cnt;
};


#define TPMTTL_IOCTL_UNINSTALL_TIMER _IOWR('p', 0x01, struct tpmttl_generic_param)
#define TPMTTL_IOCTL_INSTALL_TIMER   _IOWR('p', 0x02, struct tpmttl_generic_param)
#define TPMTTL_IOCTL_READ            _IOWR('p', 0x03, struct tpmttl_generic_param)
