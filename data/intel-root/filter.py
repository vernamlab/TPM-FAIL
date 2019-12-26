#!/usr/bin/env python

THRESHOLD = 4.06e8

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

dataN = np.genfromtxt('rawdata.csv', delimiter=",")
data = np.genfromtxt('rawdata.csv', dtype=None , delimiter=",")
tt = dataN[:, 5]
w8ld0BitIdx = np.where(tt < THRESHOLD)

for v in data[w8ld0BitIdx]:
  print "0x"+(v[1]) , "0x"+(v[2])
