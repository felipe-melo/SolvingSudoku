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
#plt.axis([0, len(times), 0, len(values)])
plt.show()
