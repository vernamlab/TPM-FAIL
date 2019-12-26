#!/usr/bin/env python

import numpy as np
import sys

data = np.genfromtxt(sys.argv[1], delimiter=',')
#data_sorted = data[data[:, 3].argsort()]

tl = data[:, 3]


u = 340762127.535/481936715.019

flt12 = (tl > 4.65e8*u) & (tl < 4.70e8*u)
flt8  = (tl > 4.70e8*u) & (tl < 4.74e8*u)
#flt4  = (tl > 4.75e8*u) & (tl < 4.77e8*u)
flt4  = (tl > 4.75e8*u) & (tl < 4.755e8*u)

data = np.genfromtxt(sys.argv[1], dtype=None , delimiter=",")


# set filter here
flt = flt12

data_filtered = data[flt]

for v in data_filtered:
  print "0x"+(v[0]) , "0x"+(v[1]), "0x"+(v[2])
