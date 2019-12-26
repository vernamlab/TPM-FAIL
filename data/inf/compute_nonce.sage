import sys
r = []
s = []
t = []
i = 0
with open(sys.argv[1], "r") as f:
    for line in f:
        a = line.split(',')
        if a[0] == "Verified OK":
            r.append(int(a[1], 16))
            s.append(int(a[2], 16))
            t.append(int(a[5]))
        
d_A = 0xbbff94f768bb477bf34e9c8f772c0e6a97a68d8434fad9ac4af5a21c239b7c83
digest = 0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729


sorted_t = sorted((e,i) for i,e in enumerate(t))


modulo = 115792089210356248762697446949407573529996955224135760342422259061068512044369L


for i in xrange(len(r)):
    nonce = Mod(inverse_mod(s[i], modulo) * (r[i] * d_A + digest), modulo)
    print "%x,%x,%x,%d"%(r[i], s[i], int(nonce), t[i])
