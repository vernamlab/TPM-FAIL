rm -rf *.ctx

openssl ecparam -name prime256v1 -genkey -noout -out ecdsa.priv.pem
openssl ec -in ecdsa.priv.pem -out ecdsa.pub.pem -pubout

sudo tpm2_flushcontext --transient-object
sudo tpm2_loadexternal -Q -G ecc -r  ecdsa.priv.pem -o key.ctx

echo "data to sign" > data.in.raw
sha256sum data.in.raw | awk '{ print "000000 " $1 }' | xxd -r -c 32 > data.in.digest
sudo tpm2_flushcontext --transient-object
sudo tpm2_sign -Q -c key.ctx -G sha256 -D data.in.digest -f plain -s data.out.signed
sudo tpm2_readpublic -c key.ctx -f pem -o ecdsa.pub.pem
openssl dgst -verify ecdsa.pub.pem -keyform pem -sha256 -signature data.out.signed data.in.raw
