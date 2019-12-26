#!/usr/bin/env python

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import sys

data = np.genfromtxt(sys.argv[1], delimiter=',')

tr = data[:, 3]
#flt = (tr > 3.28e8) & (tr < 4e8)
flt = (tr > 0.28e8) & (tr < 5e8)
tl = data[flt, 4]
tr = data[flt, 3]

zero16bit = tr[(tl < 4.65e8)]
zero12bit = tr[(tl > 4.65e8) & (tl < 4.70e8)]
zero8bit  = tr[(tl > 4.70e8) & (tl < 4.75e8)]
zero4bit  = tr[(tl > 4.75e8) & (tl < 4.80e8)]
fullbit   = tr[(tl > 4.80e8)]


print len(fullbit)
print len(zero4bit)
print len(zero8bit)
print len(zero12bit)
print len(zero16bit)


plt.plot([0]*len(fullbit), fullbit, 'yo')
plt.plot([4]*len(zero4bit), zero4bit, 'go')
plt.plot([8]*len(zero8bit), zero8bit, 'ro')
plt.plot([12]*len(zero12bit), zero12bit, 'bo')
plt.plot([16]*len(zero16bit), zero16bit, 'co')

print len(tr[(tr < 3.335e8)])

plt.xlim(-1, 17)
#plt.ylim(3.28e8, 4e8)

#plt.hist(tt, 5000)
plt.show()
