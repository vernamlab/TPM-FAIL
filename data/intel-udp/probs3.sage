'''
New ECDSA leakage expoitation code
Based on hamecdsa.sage code obtained from Nadia Heninger
Obtains probabilities of success over fixed size subsets of the samples
'''
import matplotlib.pyplot as plt
from collections import Counter
import time
import random
from random import sample



pubx = 0xc4c88d9d220a562bf95421c84d7c94160aa57eb538e1fce8204d1bf19eaecb46
remoteUDP_key = 106058005610142779690166437300572023785265939629722543453418132696315520505889


# and public key modulo
# taken from NIST or FIPS (http://csrc.nist.gov/publications/fips/fips186-3/fips_186-3.pdf)
modulo = 115792089210356248762697446949407573529996955224135760342422259061068512044369L
digest = 0xb39eaeb437e33087132f01c2abc60c6a16904ee3771cd7b0d622d01061b40729
block_size = 30
all_signatures = []


folder = ""

key = remoteUDP_key

def load_samples(l=4):
    with open(folder+"sigpairs%d.txt" % l, "r") as f:
    #with open(folder + "sigpairs8.txt", "r") as f:
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
        self.m = m
        #self.fake_init(m, max_k=2^(256-known_bits))
        self.R = PolynomialRing(QQ,self.m,'x',order='lex')

    def fake_init(self,max_k):
        self.s_list = []
        self.r_list = []
        l = sample(range(len(all_signatures)), self.m)
        for i in l:
            r,s = all_signatures[i]
            self.s_list.append(s)
            self.r_list.append(r)
        self.h_list = [digest]*self.m  # repeat fixed digest m times
        self.k_list = []
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

    def solve_cvp(self,LLL=False,block_size=block_size):
        A = self.gen_cvp_lattice()
        if LLL:
            B = A.LLL()
        else:
            B = A.BKZ(block_size=block_size)
        candidate_exponents = [B[i,-2] for i in range(B.nrows()) if B[i,-2] not in (self.n, -self.n)]
        candidate_exponents += [-d for d in candidate_exponents]
        for d in candidate_exponents:
            if lift(mod(d,self.n)) == self.x:
                return True#, lift(mod(d,self.n))
        return False




############################## CODE BEGINGS HERE
known_bits=8

# randomize of TIMES subsets of samples
TIMES = 100


print('Assuming %d bit bias, sampling %d times' % (known_bits, TIMES))

max_k = 2^(256-known_bits)
load_samples(l=known_bits)
sols=[]


lattice_dims = range(39,41)


for m in lattice_dims:
    sol = 0
    e = ecdsa_solver(m=m, known_bits=known_bits)
    for i in range(TIMES):
        e.fake_init(max_k=max_k)
        if e.solve_cvp():
            sol +=1
        print('i=%d sol=%d' % (i,sol))
    sols.append(sol*100.0/TIMES)

print "Lattice Dims:  ", lattice_dims
print "Success Prob:  ", sols
