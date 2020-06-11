# User-specified parameters
runtime = 20
res = 5
sx = 20
sy = 20
fcen = [0.14517, 0.12173] # SP +/- 1 frequencies, MEEP units

file = open('res.txt','w')
file.write(str(res))
file.close()

file = open('runtime.txt','w')
file.write(str(runtime))
file.close()

file = open('sx.txt','w')
file.write(str(sx))
file.close()

file = open('sy.txt','w')
file.write(str(sy))
file.close()

file = open('fcen.txt','w')
for i in range(len(fcen)):
	file.write(str(fcen[i]))
	if i != len(fcen) - 1:
		file.write("\n")
file.close()