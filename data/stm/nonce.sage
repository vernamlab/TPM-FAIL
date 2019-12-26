modulo = Integer(115792089210356248762697446949407573529996955224135760342422259061068512044369L)
digest = Integer(0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729)
st_key = 93232986087410402376210324188729155116374346565075163786508481029160405959648


key = Integer(st_key)
def load_samples(l=4):
    with open("sigpairs.txt", "r") as f:
        for line in f:
            a = line.split()
            t = tuple([int(x,16) for x in a])
            r,s= t
            nonce = mod((digest+key*Integer(r))*inverse_mod(s,modulo), modulo)
            print bin(nonce)[0:40]

load_samples()
