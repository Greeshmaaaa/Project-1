import xarray as xr
import datetime 
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import metpy
import metpy.calc as mpcalc
from metpy.cbook import get_test_data
from metpy.units import units



temp = xr.open_dataset('/g/data/up6/gs5098/cdo/sfc_temp/temp-sfc-combined-newww.nc')
# relh = xr.open_dataset('/g/data/up6/gs5098/cdo/rel_hum/rel-hum-combine.nc')
# sdew = xr.open_dataset('/g/data/up6/gs5098/cdo/dewpt_scrn/dew-sfc-odukkathe.nc')
# spre = xr.open_dataset('/g/data/up6/gs5098/cdo/sfc_pres/sfc_prs-combine_final.nc')



riaaim = temp.sel(longitude=150.73, latitude= -33.90, method='nearest')



riaaim.to_netcdf('/g/data/up6/gs5098/cdo/sfc_temp/sfc_temp-badgery.nc')