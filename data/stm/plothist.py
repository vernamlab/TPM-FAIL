#!/usr/bin/env python

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

data = np.genfromtxt('rawdata.csv', delimiter=',')

tt = data[:, 5]


plt.hist(tt, 5000)
plt.show()
