# from signature samples recovers nonces and
# computes most signaticant 4, 8, 12 bits



modulo = Integer(115792089210356248762697446949407573529996955224135760342422259061068512044369L)
digest = Integer(0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729)

inf_real_key = 85034076815184974961739170239653072089442086308599627559489680731885713194115

key = Integer(inf_real_key)


def load_samples():
    ocounter = 0
    lines=0

    with open("sigpairs.txt", "r") as f:
        for line in f:
            a = line.split()
            t = tuple([int(x,16) for x in a])
            r,s = t
            nonce = lift(mod((digest+key*Integer(r))*inverse_mod(s,modulo), modulo))
            four = nonce//2^(256-4)
            eight = nonce//2^(256-8)
            twelve = nonce//2^(256-12)
            ocounter += nonce//2^(256-1)
            print four, eight, twelve, "0x"+hex(r), " 0x"+hex(s)
            print bin(nonce + 2^257)[4:50]
            lines = lines + 1
            print ocounter, lines,float(ocounter)/float(lines)


load_samples()
