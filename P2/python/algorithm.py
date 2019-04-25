# Imports

import csv
import numpy as np
import copy

# Functions

def fun(x, beta):
	if x < 0:
		return 1

	return np.exp(-beta * x)

def dist(a, b):
	return (sum([(a[i] - b[i])**2 for i in range(0, len(a))]))**(1 / 2)

def length(path):
	l = float(0)

	for i in range(0, len(path)):
		l += dist(path[i - 1], path[i])

	return l

def var_length(path, n, i, j):
	var = 0

	if (j == n - 1) and (i == 0):
		i, j = j, i

	var -= dist(path[i - 1], path[i])
	var -= dist(path[j], path[(j + 1) % n])

	var += dist(path[i - 1], path[j])
	var += dist(path[i], path[(j + 1) % n])

	if j != (i + 1) % n:
		var -= dist(path[i], path[i + 1])
		var -= dist(path[j - 1], path[j])

		var += dist(path[j], path[i + 1])
		var += dist(path[j - 1], path[i])

	return var

# Read

x = list()

with open('resources/csv/x_best.csv', 'r') as f:
	r = csv.reader(f)
	for point in r:
		x.append((float(point[0]), float(point[1])))

# Metropolis-Hastings

## Parameters

m = 1e6

beta = 10
d_beta = 50 / m

## Initialization

n = len(x)
l = length(x)

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

	delta_l = var_length(x, n, i, j)

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
	with open('resources/csv/x_best.csv', 'w', newline='\n') as f:
		w = csv.writer(f)
		for point in x:
			w.writerow([point[0], point[1]])