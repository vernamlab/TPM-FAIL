#!/usr/bin/env python
import sys


import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

dataN = np.genfromtxt('rawdata.csv', delimiter=",")
data = np.genfromtxt('rawdata.csv', dtype=None , delimiter=",")
data_sorted = data[dataN[0:int(sys.argv[1]),2].argsort()]

for i in xrange(1000):
  print "0x"+(data_sorted[i][0]) , "0x"+(data_sorted[i][1])
