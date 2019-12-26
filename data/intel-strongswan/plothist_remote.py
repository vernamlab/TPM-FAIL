#!/usr/bin/env python

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import sys

#data = np.genfromtxt(sys.argv[1], delimiter=',')

#tt = data[:, int(sys.argv[2])]

data = np.genfromtxt('rawdata.csv', delimiter=',')

tt = data[:, 3]


plt.hist(tt, 1000)
plt.show()
