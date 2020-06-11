#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 21 18:07:48 2020

@author: root
"""

from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np
import csv

fcen_list = []
with open('fcen.txt','r') as file:
    readfile = csv.reader(file, delimiter='\n')        
    for x in readfile:
        fcen_list.append(x[0])

with open('sx.txt','r') as file:
    sx = int(file.readline())
    
with open('sy.txt','r') as file:
    sy = int(file.readline())
    
with open('res.txt','r') as file:
    res = int(file.readline())
    
with open('runtime.txt','r') as file:
    runtime = int(file.readline())

xpix = sx * res
ypix = sy * res

numFcen = len(fcen_list)

diff_scale = 2 # scales down colorbar scale for subtracted image to pull interesting features out of the smaller amplitude signals if high-value numerical artifacts are present

for fcen in fcen_list:
    # Loop through each timestep, assuming we used (at-every 1) in .ctl.
    for time in range(1,runtime+1):
        plt.figure(figsize=(16,16))
        #ax.axis('square')
        plt.xlim([0,xpix])
        plt.ylim([0,ypix])
        plt.gca().xaxis.set_visible(False)
        plt.gca().yaxis.set_visible(False)

        formattedTime = "%06d" % time 
        noRodFile = fcen + "/no-rod/hz-" + formattedTime + ".00.txt"
        magPlasmaRodFile = fcen + "/mag-plasma-rod/hz-" + formattedTime + ".00.txt"
        label = "Frequency = " + fcen
        Z_diff = np.zeros((xpix,ypix))
        
        X = np.arange(0,xpix,1)
        Y = np.arange(0,ypix,1)
        
        with open(noRodFile,'r') as file:
            readfile = csv.reader(file, delimiter='\n')        
            y = 0
            for line in readfile:
                x = 0
                readline = csv.reader(line, delimiter=",")
                for field_vals in readline:
                    for z in field_vals:
                        Z_diff[x][y] = -float(z)
                        x = x + 1
                y = y + 1
                               
        with open(magPlasmaRodFile,'r') as file:
            readfile = csv.reader(file, delimiter='\n')        
            y = 0
            for line in readfile:
                x = 0
                readline = csv.reader(line, delimiter=",")
                for field_vals in readline:
                    for z in field_vals:
                        Z_diff[x][y] += float(z)
                        x = x + 1
                y = y + 1
                               
        z_min_diff = -np.max(np.abs(Z_diff))/diff_scale
        
        z_max_diff = np.max(np.abs(Z_diff))/diff_scale
        
        c = plt.pcolor(X,Y,Z_diff, cmap='RdBu', vmin=z_min_diff, vmax=z_max_diff)
        #plt.colorbar(c, ax=ax,fraction=0.046, pad=0.04)
        subTitle = fcen + "/subtracted/hz-" + formattedTime + ".00.png"
        plt.savefig(subTitle)
        plt.close()