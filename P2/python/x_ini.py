# Functions

def dist(a, b):
	return (sum([(a[i] - b[i])**2 for i in range(0, len(a))]))**(1 / 2)

# Read

exec(open('./cities.py').read())

# Nearest neighbour algorithm

## Initialization

remain = list(range(1, len(cities)))

x = [0]

## Computations

while remain:
	min_i = 0
	min_dist = dist(cities[x[-1]], cities[remain[min_i]])

	for i in range(0, len(remain)):
		temp_dist = dist(cities[x[-1]], cities[remain[i]])

		if temp_dist < min_dist:
			min_i, min_dist = i, temp_dist

	x.append(remain.pop(min_i))

# Write

with open('resources/txt/x_ini.txt', 'w') as f:
	while len(x) > 0:
		f.write(str(x.pop(0)) + '\n')
