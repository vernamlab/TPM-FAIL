noisy_local_key = 12982511241385771099689470326654774263894697667703711753598098427526832214082
remoteUDP_key = 106058005610142779690166437300572023785265939629722543453418132696315520505889
swan_key = 96658790794323050580830851915209505475804593577325048087712236537605880362920

modulo = Integer(115792089210356248762697446949407573529996955224135760342422259061068512044369L)

key = Integer(swan_key)

def load_samples(l=4):
    with open("sigpairs%d.txt" % l, "r") as f:
    #with open("sigpairs.txt", "r") as f:
        for line in f:
            a = line.split()
            t = tuple([int(x,16) for x in a])
            digest,r,s = t
            nonce = mod((digest+key*Integer(r))*inverse_mod(s,modulo), modulo)
            twelve = (lift(nonce)-lift(mod(nonce,2^(256-12))))/2^(256-12)
            eight = (lift(nonce)-lift(mod(nonce,2^(256-8))))/2^(256-8)
            four  = (lift(nonce)-lift(mod(nonce,2^(256-4))))/2^(256-4)
            print four, eight, twelve, "0x"+hex(r), " 0x"+hex(s), nonce

load_samples(8)
