import sys
digest = []
r = []
s = []
t = []
i = 0
with open(sys.argv[1], "r") as f:
    for line in f:
        a = line.split(',')
        digest.append(int(a[0], 16))
        r.append(int(a[1], 16))
        s.append(int(a[2], 16))
        t.append(int(a[4]))
        
d_A = 96658790794323050580830851915209505475804593577325048087712236537605880362920

sorted_t = sorted((e,i) for i,e in enumerate(t))

modulo = 115792089210356248762697446949407573529996955224135760342422259061068512044369L

def count_lzb(binstr):
    c = 0
    for v in binstr:
        if v == '1':
            break
        c += 1
    return c
   

for i in xrange(len(r)):
    nonce = Mod(inverse_mod(s[i], modulo) * (r[i] * d_A + digest[i]), modulo)
    binstr = format(int(nonce), '0256b')    
    #print binstr
    print "%d,%d"%(count_lzb(binstr), t[i])
