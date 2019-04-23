# Imports

import numpy as np
import copy

# Functions

def fun(x, beta):
	if x < 0:
		return 1

	return np.exp(-beta * x)

def dist(a, b):
	return (sum([(a[i] - b[i])**2 for i in range(0, len(a))]))**(1 / 2)

def length(cities, path):
	l = float(0)

	for i in range(0, len(path)):
		l += dist(cities[path[i - 1]], cities[path[i]])

	return l

def var_length(cities, path, n, i, j):
	var = 0

	if (j == n - 1) and (i == 0):
		i, j = j, i

	var -= dist(cities[path[i - 1]], cities[path[i]])
	var -= dist(cities[path[j]], cities[path[(j + 1) % n]])

	var += dist(cities[path[i - 1]], cities[path[j]])
	var += dist(cities[path[i]], cities[path[(j + 1) % n]])

	if j != (i + 1) % n:
		var -= dist(cities[path[i]], cities[path[i + 1]])
		var -= dist(cities[path[j - 1]], cities[path[j]])

		var += dist(cities[path[j]], cities[path[i + 1]])
		var += dist(cities[path[j - 1]], cities[path[i]])

	return var

# Read

exec(open('./cities.py').read())

x = list()
with open('resources/txt/x_best.txt', 'r') as f:
	for y in f:
		x.append(int(y))

# Metropolis-Hastings

## Parameters

m = 1e6

beta = 10
d_beta = 50 / m

## Initialization

n = len(cities)
l = length(cities, x)

x_min = copy.copy(x)
l_min = l
l_best = l

## Computations

print("Current best : %.6f km" %l_best)

while m > 0:
	m -= 1
	beta += d_beta

	i = np.random.randint(n - 1)
	j = np.random.randint(i + 1, n)

	delta_l = var_length(cities, x, n, i, j)

	alpha = fun(delta_l, beta)

	if (alpha >= 1) or (np.random.rand() < alpha):
		x[i], x[j] = x[j], x[i]
		l += delta_l

		if l < l_min:
			x_min = copy.copy(x)
			l_min = l

# Write

if l_min < l_best:
	print("New best : %.6f km" %l_min)
	with open('resources/txt/x_temp.txt', 'w') as f:
		while len(x_min) > 0:
			f.write(str(x_min.pop(0)) + '\n')