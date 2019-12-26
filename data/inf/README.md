# TPM-FAIL


## Data Sets and Scripts for Infineon TPM

ECDSA signing operations are not implemented to execute in constant time on the Infineon TPM. 
The file `rawdata.csv` is filtered to create signature pair files which are then displayed or analyzed further.


Scripts:

- `filter3.py`: Filters samples with execution time in desired range; pipe output to signature pair text file
- `plothist_inf.py`: Plots histogram for collected Infineon TPM ECDSA timing samples 
- `nonce.sage`: Recovers nonce values from timing samples, computes most significant 4, 8, 12 bits
