@ECHO OFF
:: This batch file extract drainage area delimitation using DEM/DTM.

TITLE Drainage Area Extraction

ECHO 
ECHO  Copyright (c) 2020 Alexandre de Amorim Teixeira, pghydro.project@gmail.com
ECHO 
ECHO  This program is free software; you can redistribute it and/or modify
ECHO  it under the terms of the GNU General pghydro License as published by
ECHO  the Free Software Foundation; either version 2 of the License, or
ECHO  (at your option) any later version.
ECHO 
ECHO  This program is distributed in the hope that it will be useful,
ECHO  but WITHOUT ANY WARRANTY; without even the implied warranty of
ECHO  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
ECHO  GNU General pghydro License for more details.
ECHO 
ECHO  You should have received a copy of the GNU General pghydro License
ECHO  along with this program; if not, write to the Free Software
ECHO  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
ECHO

ECHO ---------------------------------------------------------------------------------
ECHO Drainage Area Delineation Tutorial version 1.4 of 09/05/2020
ECHO ---------------------------------------------------------------------------------

REM ============================
REM REQUIREMENTS
REM ============================

:: Terra Hidro 5 - Console Applications (http://www.dpi.inpe.br/terrahidro/doku.php)
:: QGIS 2.18 (https://qgis.org/)
:: Python 2.7
:: GDAL 2.4.0
:: pydro_agreedem_gdal.py 1.4 (https://github.com/deamorim2/pydro)
:: pydro_flow_path.py 1.0 (https://github.com/deamorim2/pydro)

REM ============================
REM INSTALLATION
REM ============================

::  Install Terra Hidro Console 5.0.1 and QGIS 2.18, create a workspace directory with pydro_agreedem_gdal.py and pydro_flow_path.py

REM =======================================
REM SETUP Environment Variables for Windows
REM =======================================

:: PATH=C:\Program Files\QGIS 2.18\bin --put this first in the list
:: PATH=C:\Program Files\terrahidro5.1.0\bin
:: GDAL_DATA=C:\Program Files\QGIS 2.18\share\gdal
:: GDAL_DRIVER_PATH=C:\Program Files\QGIS 2.18\bin\gdalplugins
:: PYTHONPATH=C:\Program Files\QGIS 2.18\apps\Python27\Lib
:: PYTHONHOME=C:\Program Files\QGIS 2.18\apps\Python27

REM =======================================
REM SETUP Environment Variables for Grass
REM =======================================

:: Open C:\Program Files\QGIS 2.18\bin\grass76.bat file and set OSGEO4W_ROOT to "C:\Program Files\QGIS 2.18" instead of C:\OSGeo4W64

REM =======================================
REM Data Dictionary
REM =======================================

:: INPUT DATA:
::------------

:: *.tif -> DEM files (EPSG:4326)
:: buffer_wgs84.shp -> basin buffer (EPSG:4326)
:: tdr.shp -> drainage line (EPSG:3857)
:: source.shp - watercourse start point (EPSG:3857)

:: OUTPUT DATA:
::-------------

:: img01.tif - Mosaic (EPSG:4326)
:: img02.tif - clip/mask/reprojection (EPSG:3857)
:: agreedem.tif - Agree DEM (EPSG:3857)
:: imgfel.tif - pit removed (EPSG:3857)
:: flowdirection.tif - D8 flow direction (EPSG:3857)
:: imgad8.tif - flow acumulation (EPSG:3857)
:: flowpath.tif - File name for stream raster grid since source.shp (EPSG:3857)
:: outputDrainage.shp - vector drainage segments(EPSG:3857)
:: outputSegments.tif - drainage segments (EPSG:3857)
:: outputMinibasins.tif - raster watershed (EPSG:3857)
:: outputMinibasins3.tif - raster watershed filtered (3 pixels) (EPSG:3857)
:: dra.shp - vector watershed(EPSG:3857)
:: smooth.shp - smoothed drainage area vector(EPSG:3857)

REM ============================
REM LINKS
REM ============================

:: https://www.qgis.org/en/site/

:: https://www.postgresql.org/

:: https://postgis.net/

:: https://grass.osgeo.org/

:: https://gdal.org/

:: https://www.python.org/

:: https://www.hydrosheds.org/

:: http://metadados.ana.gov.br/geonetwork/srv/pt/main.home

:: https://github.com/pghydro

:: https://plugins.qgis.org/plugins/PghydroTools/

:: https://www.youtube.com/channel/UCgkCUQ-i72bBY41a1bhVWyw

:: https://github.com/deamorim2/pydro

:: http://www.dpi.inpe.br/terrahidro/doku.php

:: Section 1: Mosaic/Projection/Clip
ECHO ============================
ECHO Mosaic/Projection/Clip
ECHO ============================

gdalbuildvrt img01.vrt *.tif
gdal_translate -of GTiff img01.vrt img01.tif
gdalwarp -overwrite -s_srs EPSG:4326 -cutline buffer_wgs84.shp -t_srs EPSG:3857 -crop_to_cutline -of GTiff img01.tif img02.tif

:: Section 2: Agreedem
ECHO ============================
ECHO Agreedem
ECHO ============================

python pydro_agreedem_gdal.py -w e:/dad/ -hy e:/dad/tdr.shp -i e:/dad/img02.tif -o e:/dad/agreedem.tif -bf 2 -sm 5 -sh 100 -gd "C:/Program Files/QGIS 2.18/bin" -od "C:/Program Files/QGIS 2.18/bin"

:: Section 3: Remove Pits
ECHO ============================
ECHO Remove Pits
ECHO ============================

th removepits agreedem.tif imgfel.tif

:: Section 4: Flow Direction
ECHO ============================
ECHO Flow Direction
ECHO ============================

th d8 imgfel.tif flowdirection.tif

:: Section 5: Contributing Area
ECHO ============================
ECHO Contributing Area
ECHO ============================

th d8ca flowdirection.tif imgad8.tif

:: Section 6: Flow Path Since Source
ECHO ============================
ECHO Flow Path Since Source
ECHO ============================

python pydro_flowpath.py -w e:/dad/ -s source.shp -i flowdirection.tif -o flowpath.tif -f a

:: Section 7: Stream Network
ECHO ============================
ECHO Stream Network
ECHO ============================

th segments flowdirection.tif flowpath.tif outputSegments.tif

:: Section 8: Stream Network Vector
ECHO ============================
ECHO Stream Network Vector
ECHO ============================

th d8drainagev flowpath.tif flowdirection.tif outputDrainage.shp

:: Section 9: Mini Basins
ECHO ============================
ECHO Mini Basins
ECHO ============================

th minibasins flowdirection.tif outputSegments.tif outputMinibasins.tif

:: Section 10: Sieve(Filter)
ECHO ============================
ECHO Sieve(Filter)
ECHO ============================

python "C:\Program Files\QGIS 2.18\bin\gdal_sieve.py" -st 3 e:\dad\outputMinibasins.tif e:\dad\outputMinibasins3.tif

:: Section 11: Polygonize
ECHO ============================
ECHO Polygonize
ECHO ============================

python "C:\Program Files\QGIS 2.18\bin\gdal_polygonize.py" e:\dad\outputMinibasins3.tif -f GPKG e:/dad/dra.gpkg

PAUSE

:: Section 12: Polygon Smoothing
ECHO ============================
ECHO Polygon Smoothing
ECHO ============================

"C:\Program Files\QGIS 2.18\bin\grass76.bat" --tmp-location "e:\dad\dra.gpkg" --exec "e:\dad\generalize_polygon.bat"

PAUSE
