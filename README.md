# TPM-FAIL

Timing tool, data sets, scripts for lattice reduction and the source code for the research paper [TPM-FAIL: TPM Meets Timing and Lattice Attacks](https://tpm.fail/tpmfail.pdf).
The paper will be presented at [Real Word Crypto 2020](https://rwc.iacr.org/2020/program.html) and [Usenix Security 2020](https://www.usenix.org/conference/usenixsecurity20/presentation/moghimi)


The repository includes:

- `article`: The source code for the research paper
- `data`: The collected data and scripts for analysis of the data and key recovery on various platforms and setups.
- `timing-tool`: The tool to perform high-resolution timing measurement from the CPU and example scripts to program and analyze ECDSA on TPM.
- `website`: The source code for [TPM-fail website](https://tpm.fail/).

## Citation
```
@inproceedings {moghimiTPMFAil2020,
    title = {TPM-FAIL: {TPM} meets Timing and Lattice Attacks},
    author = {Daniel Moghimi, Berk Sunar, Thomas Eisenbarth, Nadia Heninger},
    booktitle = {29th {USENIX} Security Symposium ({USENIX} Security 20)},
    year = {2020},
    address = {Boston, MA},
    url = {https://www.usenix.org/conference/usenixsecurity20/presentation/moghimi},
    publisher = {{USENIX} Association},
    month = aug,
}
