# TPM-FAIL

## High-Resolution TPM Time Sampling

In Threat Model I, a System-Level Adversary may install a kernel module to facilitate collection of high resolution timing measurements. Higher resolution (lower noise) samples allows us to recover the signing key much faster with fewer samples. We share our Linux kernel module here.

Note: The driver has been tested on Ubuntu kernel version 4.15.0-72-generic

To install our kernel module proceed with the following steps:
* `./tpm2-setup.sh` to install the proper version of tpm2-tss and tpm2-tools if they are not installed on the system.
* Recover the address of kernel functions `crb_send` and and `tpm_tcg_write_bytes`. e.g. `sudo cat /proc/kallsyms | grep ptpm_tcg_write_bytes`
* Update `pcrb_send` and `ptpm_tcg_write_bytes` in the `kernel/tpmttl.c` with recoverred addresses and compile the kernel module and the client `cd kernel && make && cd ../client && make`
* Install the kernel driver and setup the hook stubs: `cd ../workspace && setup-kernel.sh`
* Go to the ECDSATPMKey workspace directory and generate a new ECDSA private key inside the TPM: `cd ECDSATPMKey/ && ./gen_tpm.sh`. If you prefer to program the TPM with a known key, use `./gen_openssl`.
* Run `./run.sh` in a loop: `seq 1000000 | xargs -I -- ./run.sh` to collect signature and timing samples. Check the collected measurments: `cat result.csv`



Note: Analysis of the data for potential vulnerabilities and conducting lattice attack depends on the implementation and if the device is vulnerable to timing attacks. We have provided data set and scripts for such attacks in the [`TPM-FAIL/data`](https://github.com/danielmgmi/TPM-FAIL/tree/master/data) directory. Feel free to contact us if you need help with analyzing your TPM timing samples.
