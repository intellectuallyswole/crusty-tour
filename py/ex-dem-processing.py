"""
http://geologyandpython.com/dem-processing.html
"""

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import geopandas as gpd
#%matplotlib inline

bounds = gpd.read_file('./data/processed/area_of_study_bounds.gpkg').bounds
print(bounds)

west, south, east, north = bounds = bounds.loc[0]
west, south, east, north = bounds  = west - .05, south - .05, east + .05, north + .05
print(bounds)

import elevation
import os
dem_path = '/data/external/Iron_River_DEM.tif'
output = os.getcwd() + dem_path

# SRTM3 for coarser accuracy (90m instead of 30m)
elevation.clip(bounds=bounds, output=output, product='SRTM1')

from rasterio.transform import from_bounds, from_origin
from rasterio.warp import reproject, Resampling
import rasterio
dem_raster = rasterio.open('.' + dem_path)

src_crs = dem_raster.crs
src_shape = src_height, src_width = dem_raster.shape
src_transform = from_bounds(west, south, east, north, src_width, src_height)
source = dem_raster.read(1)

dst_crs = {'init': 'EPSG:32616'}
dst_transform = from_origin(268000.0, 5207000.0, 250, 250)
dem_array = np.zeros((451, 623))
dem_array[:] = np.nan

reproject(source,
          dem_array,
          src_transform=src_transform,
          src_crs=src_crs,
          dst_transform=dst_transform,
          dst_crs=dst_crs,
          resampling=Resampling.bilinear)

try:
    import pycpt
    topocmap = pycpt.load.cmap_from_cptcity_url('wkp/schwarzwald/wiki-schwarzwald-cont.cpt')
except:
    topocmap = 'Spectral_r'

vmin = 180
vmax = 575

ax = sns.distplot(dem_array.ravel(), axlabel='Elevation (m)')
ax = plt.gca()
_ = [patch.set_color(topocmap(plt.Normalize(vmin=vmin, vmax=vmax)(patch.xy[0]))) for patch in ax.patches]
_ = [patch.set_alpha(1) for patch in ax.patches]
ax.get_figure().savefig('images/8/1.png')

extent = xmin, xmax, ymin, ymax = 268000.0, 423500.0, 5094500.0, 5207000.0

def hillshade(array, azimuth, angle_altitude):
    # Source: http://geoexamples.blogspot.com.br/2014/03/shaded-relief-images-using-gdal-python.html

    x, y = np.gradient(array)
    slope = np.pi/2. - np.arctan(np.sqrt(x*x + y*y))
    aspect = np.arctan2(-x, y)
    azimuthrad = azimuth*np.pi / 180.
    altituderad = angle_altitude*np.pi / 180.


    shaded = np.sin(altituderad) * np.sin(slope) \
     + np.cos(altituderad) * np.cos(slope) \
     * np.cos(azimuthrad - aspect)
    return 255*(shaded + 1)/2

fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111)
ax.matshow(hillshade(dem_array, 330, 30), extent=extent, cmap='Greys', alpha=.1, zorder=10)
cax = ax.contourf(dem_array, np.arange(vmin, vmax, 10),extent=extent,
                  cmap='cubehelix', vmin=vmin, vmax=vmax, origin='image', zorder=0)
fig.colorbar(cax, ax=ax)
fig.savefig('images/8/3.png')

np.save('./data/processed/arrays/dem_array', dem_array)
np.save('./data/processed/arrays/dem_array_hs', hillshade(dem_array, 280, 25))
