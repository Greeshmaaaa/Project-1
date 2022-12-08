#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 16 07:43:38 2022

@author: moutassem
"""

import matplotlib
import numpy as np
matplotlib.rcParams['figure.figsize'] = [12.5, 9.0]
matplotlib.rcParams['figure.dpi'] = 300
matplotlib.rcParams['font.size'] = 20
matplotlib.rcParams['text.usetex'] = True
matplotlib.rcParams['font.family'] = 'Helvetica'
import pyart


radar = pyart.io.read('54_20160114_041804_ppi.nc')

radar.info('compact')


display = pyart.graph.RadarMapDisplayBasemap(radar)

# display.plot('corrected_velocity', sweep=1, vmin=-40, vmax=40)
#    min_lon=151, max_lon=151.5, min_lat=-34.1, max_lat=-33.8, Syd Airport

# display.plot_ppi_map(
#     'corrected_velocity',sweep=1, vmin=-40, vmax=40, cmap='pyart_NWSVel',
#     resolution='h', embelish=False)

#    min_lon=150, max_lon=153, min_lat=-36, max_lat=-32, Syd Airport
# display.plot_ppi_map(
#     'corrected_reflectivity',sweep=0, vmin=-25, vmax=60, cmap='pyart_NWSRef',
#     resolution='h', embelish=False,colorbar_label='Corrected reflectivity dBZ',min_lon=150, max_lon=153, min_lat=-36, max_lat=-32)

display.plot_ppi_map(
    'corrected_reflectivity',sweep=0, vmin=-25, vmax=60, cmap='pyart_NWSRef',
    resolution='h', embelish=False,colorbar_label='Corrected reflectivity dBZ',min_lon=150.5, max_lon=152, min_lat=-34.5, max_lat=-33.5)

# display.plot_ppi_map(
#     'azshear',sweep=1, vmin=-7, vmax=7, cmap='pyart_NWSRef',
#     resolution='h', embelish=False)


display.plot_point(151.18, -33.95,symbol = 'ko',markersize=8,) #Syd Airport

display.basemap.drawstates(color='black')
display.basemap.drawcoastlines(color='black')

# draw parallels
# display.basemap.drawparallels(np.arange(-90,90,1),labels=[1,0,0,0])
# # draw meridians
# display.basemap.drawmeridians(np.arange(150,153,1),labels=[0,1,0,1])
