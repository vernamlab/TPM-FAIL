'''
New ECDSA leakage expoitation code
Based on hamecdsa.sage code obtained from Nadia Heninger
'''
import matplotlib.pyplot as plt
from collections import Counter
import time
import random

p = 0
q = 0
g = 0
x = 0
y = 0

pubx = 0xc4c88d9d220a562bf95421c84d7c94160aa57eb538e1fce8204d1bf19eaecb46
offset=0
remoteUDP_key = 106058005610142779690166437300572023785265939629722543453418132696315520505889

# and public key modulo
# taken from NIST or FIPS (http://csrc.nist.gov/publications/fips/fips186-3/fips_186-3.pdf)
modulo = 115792089210356248762697446949407573529996955224135760342422259061068512044369L
digest = 0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729

key = remoteUDP_key

all_signatures = []

def load_samples(l=4):
    with open("sigpairs%d.txt" % l, "r") as f:
        for line in f:
            a = line.split()
            t = tuple([int(x,16) for x in a])
            all_signatures.append(t)




class ecdsa_solver:
    def __init__(self, m=80, known_bits=4):
        #self.n = Integer(ecdsa.SECP256k1.generator.order())
        self.n = Integer(modulo)
        self.x = Integer(key) #ZZ.random_element(self.n)
        self.s_list = []
        self.r_list = []
        self.fake_init(m, max_k=2^(256-known_bits))
        self.R = PolynomialRing(QQ,self.m,'x',order='lex')

    def fake_init(self,m,max_k):
        for i in range(m):
            r,s = all_signatures[i+offset]
            self.s_list.append(s)
            self.r_list.append(r)
        self.h_list = [digest]*m  # repeat fixed digest m times
        self.k_list = []
        self.m = m
        self.max_k = max_k

    def gen_cvp_lattice(self):
        X = ceil(self.max_k/2)
        k_weights = [X]*self.m

        h_list = [lift(mod(h,self.n)*inverse_mod(s,self.n))-w for h,s,w in zip(self.h_list,self.s_list,k_weights)]
        r_list = [lift(mod(r,self.n)*inverse_mod(s,self.n)) for r,s in zip(self.r_list,self.s_list)]

        X = ceil(self.n/(ceil(self.max_k/2))) #2^(self.n.nbits()-self.klen+1)
        weights = [X]*self.m

        dim = self.m+2
        A = MatrixSpace(IntegerRing(),dim,dim)(0)

        for i in range(dim-2):
            A[i,i] = weights[i]*self.n
        for i in range(dim-2):
            A[dim-2,i] = weights[i]*r_list[i]
        A[dim-2,dim-2] = 1

        for i in range(dim-2):
            A[dim-1,i] = weights[i]*h_list[i]
        A[dim-1,dim-1] = self.n
        return A

    def solve_cvp(self,LLL=False,block_size=30):
        A = self.gen_cvp_lattice()
        if LLL:
            B = A.LLL()
        else:
            B = A.BKZ(block_size=block_size)
        candidate_exponents = [B[i,-2] for i in range(B.nrows()) if B[i,-2] not in (self.n, -self.n)]
        candidate_exponents += [-d for d in candidate_exponents]
        for d in candidate_exponents:
            if lift(mod(d,self.n)) == self.x:
                return True, lift(mod(d,self.n))
        return False, 0

#known_bits = 8
#samples = 40


known_bits = 4
samples = 80



load_samples(l=known_bits)
e = ecdsa_solver(m=samples, known_bits=known_bits)
print e.solve_cvp()
