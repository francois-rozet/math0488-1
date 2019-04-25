# Imports

import csv
import numpy as np
import matplotlib.pyplot as plt

# Read

x = list()
y = list()

with open('resources/csv/x_best.csv', 'r') as f:
	r = csv.reader(f)
	for point in r:
		x.append(float(point[0]))
		y.append(-float(point[1]))

# Plot

plt.plot(x, y)
plt.show()