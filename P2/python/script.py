# Imports

import numpy as np
import csv

import matplotlib.pyplot as plt
import time
import sys

# Settings

np.set_printoptions(threshold = sys.maxsize)

# Functions

def fun(x, beta):
	return np.exp(-beta * x)

def dist(a, b):
	return (sum([(a[i] - b[i])**2 for i in range(0, len(a))]))**(1 / 2)

def length(cities, path):
	l = float(0)

	for i in range(0, len(path)):
		l += dist(cities[path[i - 1]], cities[path[i]])

	return l

def var_length(cities, path, i):
	j = np.mod(i + 1, len(path))
	var = 0
	var -= dist(cities[path[i - 2]], cities[path[i - 1]])
	var -= dist(cities[path[i]], cities[path[j]])
	var += dist(cities[path[i - 2]], cities[path[i]])
	var += dist(cities[path[i - 1]], cities[path[j]])
	return var

def Q(cities, path, interv, beta):
	return [fun(var_length(cities, path, i), beta) for i in interv]

def pick(q):
	r = np.random.rand() * sum(q)

	for i in range(0, len(q)):
		r -= q[i]
		if r <= 0:
			return i

	return len(q)


# Computations

## Initialization

cities = list()

with open('resources/csv/belgium-cities.csv', 'r') as f:
	belgium = csv.reader(f)
	for city in belgium:
		cities.append((float(city[1]), float(city[2])))

## Hastings

n = len(cities)
m = 1000000

beta = 0.02;
beta_max = 0.05;

d_beta = (beta_max - beta) / m;

start = time.time()

x = list(range(0, n))
lx = length(cities, x)
qx = Q(cities, x, range(0, n), beta)
sx = sum(qx)

x_min = x
l_min = lx
l = [lx]

while len(l) < m:
	i = pick(qx)

	delta_l = var_length(cities, x, i)

	ly = lx + delta_l

	interv = list(np.mod(range(i - 2, i + 3), n))

	x[i], x[i - 1] = x[i - 1], x[i] # x -> y

	_qx = [qx[j] for j in interv]
	_qy = Q(cities, x, interv, beta) # _qy = [qy[j] for j in interv]
	sy = sx - sum(_qx) + sum(_qy)
	
	alpha = fun(-delta_l, beta) * sx / sy

	if (alpha >= 1) or (np.random.rand() < alpha):
		lx = ly
		for j in interv:
			qx[j] = _qy[np.mod(j - i + 2, n)]
		sx = sy
	else:
		x[i], x[i - 1] = x[i - 1], x[i] # y -> x

	if lx < l_min:
		x_min = x
		l_min = lx

	beta += d_beta
	l.append(lx)

end = time.time()

print(end - start)

plt.plot(l)
plt.show()