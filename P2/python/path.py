# Imports

import numpy as np
import matplotlib.pyplot as plt

# Read

exec(open('./cities.py').read())

x_best = list()

with open('resources/txt/x_best.txt', 'r') as f:
	for y in f:
		x_best.append(int(y))

# Plot

x = list()
y = list()

for n in x_best:
	x.append(cities[n][0])
	y.append(-cities[n][1])

plt.plot(x, y)
plt.show()