import matplotlib.pyplot as plt
import csv
import numpy as np

fcen_list = []
with open('fcen.txt','r') as file:
    readfile = csv.reader(file, delimiter='\n')        
    for x in readfile:
        fcen_list.append(x[0])

# For each frequency, inspect the incident and transmitted fluxes.
for fcen in fcen_list:
	noRodFile = fcen + "/flux0.dat"
	magPlasmaRodFile = fcen + "/flux.dat"
	
	freq = []
	flux = []
	trans_flux = []

	with open(noRodFile) as csvfile:
	    readCSV = csv.reader(csvfile, delimiter=',')
	    
	    for row in readCSV:
	        freq.append(float(row[1]))
	        flux.append(float(row[2]))

	with open(magPlasmaRodFile) as csvfile:
	    readCSV = csv.reader(csvfile, delimiter=',')
	    
	    for row in readCSV:
	        trans_flux.append(float(row[2]))

	plt.figure()

	# Calculate bandwidth.
	maxIndex = flux.index(max(flux))
	maxFlux = flux[maxIndex]
	true_fcen = freq[maxIndex]
	isValid = False
	bandwidth = 0
	for i in range(len(flux)):
		if flux[i] > np.exp(-1) * maxFlux:
			isValid = True

		if isValid and flux[i] < np.exp(-1) * maxFlux:
			bandwidth = freq[i] - true_fcen
			plt.plot(freq[i],flux[i],"ro")
			break
	title = "Fcen = " + fcen + ", Bandwidth = " + str(np.round(bandwidth, 4))

	plt.plot(freq[maxIndex],maxFlux,"ro")
	plt.plot()
	plt.scatter(freq, flux, label='Incident Flux')
	plt.ylim((np.min(flux),np.max(flux)))
	plt.xlim((np.min(freq),np.max(freq)))
	plt.scatter(freq, trans_flux, label='Transmitted Flux')
	#plt.xlim(left=0)
	#plt.vlines(fcen,0,max(flux))
	#plt.vlines(freq[flux.index(max(flux))],0,max(flux))
	plt.xlabel('Frequency (Meep Units)')
	plt.ylabel("Relative Flux (arb. units)")
	plt.title(title)
	plt.legend()
	img_title = fcen + "/fluxes.png"
	plt.savefig(img_title)
	plt.close()