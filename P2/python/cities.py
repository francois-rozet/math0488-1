# Imports

import csv

# Read

cities = list()

with open('resources/csv/belgium-cities.csv', 'r') as f:
	belgium = csv.reader(f)
	for city in belgium:
		cities.append((float(city[1]), float(city[2])))