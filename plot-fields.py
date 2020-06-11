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

# Read in parameters.
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
    
xpix = sx * res
ypix = sy * res

numFcen = len(fcen_list)

# Set up figure.
fig, axs = plt.subplots(numFcen,3,figsize=(9,6))
fig.subplots_adjust(wspace = 0.4)

if(numFcen>1):
    for ax_row in axs:
        for ax in ax_row:
            ax.axis('square')
        
            ax.set_xlim([0,xpix])
            ax.set_ylim([0,ypix])
            ax.axes.xaxis.set_visible(False)
            ax.axes.yaxis.set_visible(False)
else:
    for ax in axs:
        ax.axis('square')
    
        ax.set_xlim([0,xpix])
        ax.set_ylim([0,ypix])
        ax.axes.xaxis.set_visible(False)
        ax.axes.yaxis.set_visible(False)

# If numerical artifacts appear at surface of rod (common for low res runs), 
# crank up mag_scale and diff_scale to make the target features in the scattered fields visible.
norm_scale = 1
mag_scale = 3
diff_scale = 3
    
row = 0 # incremended within for loop to specify row of subplot
for fcen in fcen_list:
    noRodFile = fcen + "/no-rod/no-rod-fields.txt"
    magPlasmaRodFile = fcen + "/mag-plasma-rod/mag-plasma-rod-fields.txt"
    label = "Frequency = " + fcen
    Z = np.zeros((xpix,ypix))
    
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
                    Z[x][y] = float(z)
                    x = x + 1
            y = y + 1
                   
    X, Y = np.meshgrid(X, Y)
    
    Z = np.array(Z)

    z_min = -np.max(np.abs(Z)) # symmetric range about 0
    z_max = np.max(np.abs(Z))
    
    if numFcen > 1:
        ax = axs[row][0]
    else:
        ax = axs[0]

    ax.set_title("Incident Field")
    ax.axes.yaxis.set_visible(True)
    ax.axes.yaxis.set_ticks([])
    ax.set_ylabel(label)
    c= ax.pcolor(X,Y,Z, cmap='RdBu', vmin=z_min, vmax=z_max)
    #fig.colorbar(c, ax=ax)
    fig.colorbar(c, ax=ax,fraction=0.046, pad=0.04)
    
    # --------------------------

    Z_mag = np.zeros((xpix,ypix))
    
    with open(magPlasmaRodFile,'r') as file:
        readfile = csv.reader(file, delimiter='\n')        
        y = 0
        for line in readfile:
            x = 0
            readline = csv.reader(line, delimiter=",")
            for field_vals in readline:
                for z in field_vals:
                    Z_mag[x][y] = float(z)
                    x = x + 1
            y = y + 1
                   
    Z_mag = np.array(Z_mag)
    z_min_mag = -np.max(np.abs(Z_mag)) / mag_scale
    
    z_max_mag = np.max(np.abs(Z_mag)) / mag_scale
    
    if numFcen > 1:
        ax = axs[row][1]
    else:
        ax = axs[1]

    ax.set_title("Total Field")
    
    c = ax.pcolor(X,Y,Z_mag, cmap='RdBu', vmin=z_min_mag, vmax=z_max_mag)
    fig.colorbar(c, ax=ax,fraction=0.046, pad=0.04)
    
    # -------------------------------------------------

    Z_diff = np.subtract(Z_mag, (norm_scale *Z))
    
    z_min_diff = -np.max(np.abs(Z_diff))/diff_scale
    
    z_max_diff = np.max(np.abs(Z_diff))/diff_scale
    if numFcen > 1:
        ax = axs[row][2]
    else:
        ax = axs[2]
    ax.set_title("Scattered Field")
    
    c = ax.pcolor(X,Y,Z_diff, cmap='RdBu', vmin=z_min_diff, vmax=z_max_diff)
    fig.colorbar(c, ax=ax,fraction=0.046, pad=0.04)
    
    row+= 1

#plt.show()
fig.savefig("fields-study.png")