# TPM-FAIL


## Data Sets and Scripts for Intel fTPM remote attack on Strongswan

ECDSA signing operations are not implemented to execute in constant time on the Intel fTPM. The timing variation is still visible over the network when response times are collected from Strongswan VPN software (which uses the Intel fTPM for ECDSA signing operations). 
The file `rawdata.csv` is filtered to create signature pair files which are then displayed or analyzed further.


Scripts:

- `filter3.py`: Filters samples with execution time in desired range; pipe output to signature pair text file
- `plothist_local.py`: Plots histogram for ECDSA timing samples collected on Strongswan server
- `plothist_remote.py`: Plots histogram for ECDSA timing samples collected by a remote client
- `nonce.sage`: Recovers nonce values from timing samples, computes most significant 4, 8, 12 bits
- `probs3.sage`: Experimentally computes probabilities of key recovery success for chosen lattice dimensions on subsets of measurements

Additional files:
- `data.in.raw`: The raw message to be signed
- `data.in.digest`: The sha256 digest of the message
- `rawdata.csv`: The raw attack data, each row consists of the gneratured signature pairs and timings, index 5 is the only time measurment that matters
- `ecdsa.pub.pem`: The public p2561 ecdsa key in PEM format
- `sigpairs8.txt` :  The filtered list of signature pairs (8 lzb). each line consists a signature pairs 
- `global.txt` : The hexdump of the global variables private key, public key and message digest
