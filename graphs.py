#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt

times = []
iterations = []
values = []

file = open("Results/ga_fill_3_1_5", "r")

for lines in file.readlines()[2:]:
    l = lines.split(" ")
    times.append(int(l[1]))
    iterations.append(int(l[0]))
    values.append(int(l[2]))

plt.plot(iterations, values, lw=2)
plt.xlabel("Iterações")
plt.ylabel("Best Fitness")
#plt.axis([0, len(times), 0, len(values)])
plt.show()
