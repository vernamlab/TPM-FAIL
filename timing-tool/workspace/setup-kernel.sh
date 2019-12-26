sudo rmmod tpmttl
sudo insmod ../kernel/tpmttl.ko
sudo ../client/tpmttl 2
sudo ../client/tpmttl 3 >> /dev/null

