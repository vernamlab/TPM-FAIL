sudo tpm2_flushcontext --transient-object
sudo tpm2_signserver -Q -c key.ctx -G sha256 -D data.in.digest -f plain -s data.out.signed >> /dev/null
