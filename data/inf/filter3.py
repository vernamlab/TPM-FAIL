#!/usr/bin/env python

# filters samples with execution time in desired range
# pipe output to sigpair.txt file


import numpy as np
import sys

data = np.genfromtxt(sys.argv[1], delimiter=',')

tl = data[:, 5]


# uncomment desired filter range here

#flt  = (tl > 1.200e8) & (tl < 1.430e8)
flt  = (tl > 1.4300e8) & (tl < 1.45e8)
#flt  = (tl > 1.4350e8) & (tl < 1.440e8)
#flt  = (tl > 1.460e8) & (tl < 1.5e8)

data = np.genfromtxt(sys.argv[1], dtype=None , delimiter=",")


data_filtered = data[flt]

for v in data_filtered:
  print "0x"+(v[1]), "0x"+(v[2])
