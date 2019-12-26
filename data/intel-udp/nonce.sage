noisy_local_key = 12982511241385771099689470326654774263894697667703711753598098427526832214082
modulo = Integer(115792089210356248762697446949407573529996955224135760342422259061068512044369L)
digest = Integer(0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729)
inf_real_key = 85034076815184974961739170239653072089442086308599627559489680731885713194115
remoteUDP_key = 106058005610142779690166437300572023785265939629722543453418132696315520505889


key = Integer(remoteUDP_key)


def load_samples(l=4):
    ocounter = 0
    lines=0

    with open("sigpairs%d.txt" % l, "r") as f:
        for line in f:
            a = line.split()
            t = tuple([int(x,16) for x in a])
            r,s = t
            nonce = lift(mod((digest+key*Integer(r))*inverse_mod(s,modulo), modulo))
            #twelve = (lift(nonce)-lift(mod(nonce,2^(256-12))))//2^(256-12)
            #eight = (lift(nonce)-lift(mod(nonce,2^(256-8))))//2^(256-8)
            #four  = (lift(nonce)-lift(mod(nonce,2^(256-4))))//2^(256-4)
            four = nonce//2^(256-4)
            eight = nonce//2^(256-8)
            twelve = nonce//2^(256-12)
            ocounter += nonce//2^(256-1)
            print four, eight, twelve, "0x"+hex(r), " 0x"+hex(s)
            print bin(nonce + 2^257)[4:50]
            lines = lines + 1
            print ocounter, lines,float(ocounter)/float(lines)


load_samples(12)
