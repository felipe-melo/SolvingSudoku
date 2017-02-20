#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
from collections import Counter
import matplotlib.pyplot as plt

ps1 = {}
ps2 = {}

for i in range(0,10):

    iterations = []
    values = []

    p = round(i/10.0,1)

    file = open("Results/_ga_fill_"+ str(p)+ "_10_1", "r")

    for lines in file.readlines():
        l = lines.split(" ")
        iterations.append(int(l[1]))
        values.append(int(l[2]))

    c = Counter(values)
    ps1[p] = np.mean(iterations)

    if 0 not in c:
        ps2[p] = 0
    else:
        ps2[p] = (c[0] / len(values)) * 100

ax1 = plt.plot()
plt.bar(ps1.keys(), ps1.values(), 0.01, color="blue")
plt.xlabel('p% de valores fixos',color='b')
plt.ylabel('Iterações',color='b')

ax2 = plt.gca().twinx()
ax2.plot(list(ps2.keys()), list(ps2.values()), 'ro')
plt.ylim([0, 110])
plt.ylabel('% de problemas resolvidos',color='r')
plt.show()
