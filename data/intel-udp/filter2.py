#!/usr/bin/env python

THRESHOLD  = 4.975e8  # for 4 bit 0 window
#THRESHOLD = 4.93e8   # for 8 bit 0 window
#THRESHOLD = 4.103e8  # for 12 bit 0 window

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

dataN = np.genfromtxt('rawdata.csv', delimiter=",")
data = np.genfromtxt('rawdata.csv', dtype=None , delimiter=",")
tt = dataN[:, 2]
w8ld0BitIdx = np.where(tt < THRESHOLD)

for v in data[w8ld0BitIdx]:
  print "0x"+(v[0]) , "0x"+(v[1])
