sudo tpm2_flushcontext --transient-object
sudo ../../client/tpmttl 3 >> /dev/null
sudo tpm2_sign -Q -c key.ctx -G sha256 -D data.in.digest -f plain -s data.out.signed >> /dev/null
openssl dgst -verify ecdsa.pub.pem -keyform pem -sha256 -signature data.out.signed data.in.raw | tr "\n" , >> result.csv
openssl asn1parse -dump -inform der -in data.out.signed  | tail -n 2 | awk -F ":" '{print $NF}' | tr '\n' , >> result.csv
sudo ../../client/tpmttl 3 >> result.csv
