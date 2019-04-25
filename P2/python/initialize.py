# Imports

import csv

# Read

y = list()

with open('resources/csv/belgium-cities.csv', 'r') as f:
	cities = csv.reader(f)
	for city in cities:
		y.append((float(city[1]), float(city[2])))

# Nearest neighbour algorithm

## Functions

def dist(a, b):
	return (sum([(a[i] - b[i])**2 for i in range(0, len(a))]))**(1 / 2)

## Initialization

x = [y.pop(0)]

## Computations

while y:
	min_i = 0
	min_dist = dist(x[-1], y[min_i])

	for i in range(0, len(y)):
		temp_dist = dist(x[-1], y[i])

		if temp_dist < min_dist:
			min_i, min_dist = i, temp_dist

	x.append(y.pop(min_i))

# Write

with open('resources/csv/x_ini.csv', 'w', newline='\n') as f:
	w = csv.writer(f)
	for point in x:
		w.writerow([point[0], point[1]])