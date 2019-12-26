# Recovers ECDSA key using LLL assuming samples with biased nonces
# Based on David Wong's code at
# https://github.com/mimoo/timing_attack_ecdsa_tls/blob/master/PoC/attack_clean.sage
# Note: 
#       We are sharing attack.sage since it's easier to use
#       Lattice formulation in attack2.sage (bsaed on Nadia Heninger's code) is more 
#       powerful and was able to recover the key while attack.sage did not



# Change configuration parameters 
known_bits = 8
MAX_SIG = 40


trick = 2^256 / 2^(known_bits+1)

digests = []
signatures = []



i = 0

with open("sigpairs.txt", "r") as f:
    for line in f:
        a = line.split()
        t = tuple([int(x,16) for x in a])
        signatures.append(t)
        i = i+1
        if i==MAX_SIG:
            break

print('Trying with %d signatures..' % len(signatures))
# Parse it

digest = 0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729
for i in range(len(signatures)):
    digests.append(digest)

# and public key modulo
# taken from NIST or FIPS (http://csrc.nist.gov/publications/fips/fips186-3/fips_186-3.pdf)
modulo = 115792089210356248762697446949407573529996955224135760342422259061068512044369L
# Building Equations
nn = len(digests)

# getting rid of the first equation
r0_inv = inverse_mod(signatures[0][0], modulo)
s0 = signatures[0][1]
m0 = digests[0]

AA = [-1]
BB = [0]

for ii in range(1, nn):
    mm = digests[ii]
    rr = signatures[ii][0]
    ss = signatures[ii][1]
    ss_inv = inverse_mod(ss, modulo)

    AA_i = Mod(-1 * s0 * r0_inv * rr * ss_inv, modulo)
    BB_i = Mod(-1 * mm * ss_inv + m0 * r0_inv * rr * ss_inv, modulo)
    AA.append(AA_i.lift())
    BB.append(BB_i.lift())

# Embedding Technique (CVP->SVP)
lattice = Matrix(ZZ, nn + 1)

# Fill lattice
for ii in range(nn):
    lattice[ii, ii] = modulo
    lattice[0, ii] = AA[ii]

BB.append(trick)
lattice[nn] = vector(BB)

# LLL
lattice = lattice.BKZ(blocksize=30) # should get better results with BKZ instead of LLL

# If a solution is found, format it
if lattice[0,-1] % modulo == trick:
    # get rid of (..., 1)
    vec = list(lattice[0])
    vec.pop()
    vec = vector(vec)
    solution = -1 * vec

    # get d
    rr = signatures[0][0]
    ss = signatures[0][1]
    mm = digests[0]
    nonce = solution[0]

    key = Mod((ss * nonce - mm) * inverse_mod(rr, modulo), modulo)

    print "found a key"
    print key
