sudo rm -rf /usr/local/bin/tpm2_*
sudo rm -rf /usr/local/sbin/tpm2_*
rm -rf tpmtools
mkdir tpmtools
cd tpmtools

sudo apt -y install \
  autoconf-archive \
  libcmocka0 \
  libcmocka-dev \
  procps \
  iproute2 \
  build-essential \
  git \
  pkg-config \
  gcc \
  libtool \
  automake \
  libssl-dev \
  uthash-dev \
  autoconf \
  gnulib \
  doxygen

sudo apt-get install autoconf automake libtool pkg-config gcc libssl-dev \
    libcurl4-gnutls-dev
    

git clone https://github.com/tpm2-software/tpm2-tools
git clone https://github.com/tpm2-software/tpm2-tss
wget http://mirrors.ocf.berkeley.edu/gnu/autoconf-archive/autoconf-archive-2019.01.06.tar.xz
tar -xvf autoconf-archive-*.xz 
mv autoconf-archive-2019.01.06 autoconf-archive
    
cp autoconf-archive/m4/ax_* tpm2-tss/m4/
cd tpm2-tss
git checkout 443455b
sudo ./bootstrap -I /usr/share/gnulib/m4
./configure
sed -e s/@CODE_COVERAGE_RULES@/#/ Makefile  > Makefile.new
cp Makefile.new Makefile
make -j`nproc`
sudo make install
sudo ldconfig
cd ../tpm2-tools
git checkout c66e4f0
./bootstrap
./configure
make -j`nproc`
sudo make install
sudo tpm2_getcap -c properties-variable
sudo tpm2_getcap -c properties-fixed | grep -A 11 TPM2_PT_VENDOR_STRING_1

