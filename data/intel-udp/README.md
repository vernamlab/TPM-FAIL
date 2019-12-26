# TPM-FAIL


## Data Sets and Scripts for Intel fTPM over UDP

ECDSA signing operations are not implemented to execute in constant time on the Intel fTPM. The timing discrepancy is still visitble over the network with additional noise.
The file `rawdata.csv` is filtered to create signature pair files which are then displayed or analyzed further.


Scripts:

- `filter3.py`: Filters samples with execution time in desired range; pipe output to signature pair text file
- `plothist_udp.m`: Plots histogram for collected ECDSA timing samples 
- `nonce.sage`: Recovers nonce values from timing samples, computes most significant 4, 8, 12 bits
- `attack.sage`: Performs lattice attack to recover the signing key for a chosen (biased) sample set, and lattice dimension
- `probs3.sage`: Experimentally computes probabilities of key recovery success for chosen lattice dimensions on subsets of measurements

Additional files:
- `data.in.raw`: The raw message to be signed
- `data.in.digest`: The sha256 digest of the message
- `rawdata.csv`: The raw attack data, each row consists of the gneratured signature pairs and timings, index 5 is the only time measurment that matters
- `ecdsa.pub.pem`: The public p2561 ecdsa key in PEM format
- `sigpairs8.txt` :  The filtered list of signature pairs (8 lzb). each line consists a signature pairs 
- `global.txt` : The hexdump of the global variables private key, public key and message digest
