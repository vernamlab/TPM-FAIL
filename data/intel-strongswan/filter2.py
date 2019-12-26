#!/usr/bin/env python


zero16bit =  4.65e8
zero12bit =  4.70e8
zero8bit  =  4.75e8
zero4bit  =  4.80e8
fullbit   =  4.80e8



THRESHOLD  = zero4bit

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

dataN = np.genfromtxt('rawdata.csv', delimiter=",")
data = np.genfromtxt('rawdata.csv', dtype=None , delimiter=",")
tt = dataN[:, 3]
w8ld0BitIdx = np.where(tt < THRESHOLD*3.4/4.825)

for v in data[w8ld0BitIdx]:
  print "0x"+(v[0]) , "0x"+(v[1])
