rm -rf *.ctx
sudo tpm2_flushcontext --transient-object
sudo tpm2_createprimary -a n -G ecc -o prim.ctx
sudo tpm2_create -G ecc256 -u ecdsa.pub -r ecdsa.priv -C prim.ctx
sudo tpm2_flushcontext --transient-object
sudo tpm2_load -C prim.ctx -u ecdsa.pub -r ecdsa.priv -o key.ctx
echo "data to sign" > data.in.raw
sha256sum data.in.raw | awk '{ print "000000 " $1 }' | xxd -r -c 32 > data.in.digest
sudo tpm2_flushcontext --transient-object
sudo tpm2_sign -Q -c key.ctx -G sha256 -D data.in.digest -f plain -s data.out.signed
sudo tpm2_readpublic -c key.ctx -f pem -o ecdsa.pub.pem
openssl dgst -verify ecdsa.pub.pem -keyform pem -sha256 -signature data.out.signed data.in.raw

