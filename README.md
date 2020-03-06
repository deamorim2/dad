# Drainage Area Delineation(DAD)

Methodology to automatically delineate drainage areas using Digital Elevation Model(DEM) and hydrography derived from cartography.

## STATUS

## Branches

The master branch has the latest minor release. (1.0)

The develop branch has the next minor release. (1.1-dev)

## INTRODUCTION

This methodology uses tools from pydro project(https://github.com/deamorim2/pydro), TerraHidro software(http://www.dpi.inpe.br/terrahidro/doku.php) and GDAL/OGR library.

## REQUIREMENTS

Pydro 1.2+ (https://github.com/deamorim2/pydro)

GDAL/OGR 2.1.2+

QGIS 2.x ()

Windows O.S.

## INSTALLATION (v.1.0)

- Install Terra Hidro Console 5.0.1 and QGIS 2.x

- Download and copy the content of this release to the workspace directory.

## SETUP

## SYSTEM ENVIRONMENTAL SETUP (WINDOWS)

PATH=C:\Program Files\QGIS 2.18\bin (put this first in the list)
PATH=C:\Program Files\terrahidro5.1.0\bin
GDAL_DATA=C:\Program Files\QGIS 2.18\share\gdal
GDAL_DRIVER_PATH=C:\Program Files\QGIS 2.18\bin\gdalplugins
PYTHONPATH=C:\Program Files\QGIS 2.18\apps\Python27\Lib
PYTHONHOME=C:\Program Files\QGIS 2.18\apps\Python27

## GRASS SETUP

Open C:\Program Files\QGIS 2.x\bin\grass7x.bat file and set OSGEO4W_ROOT to "C:\Program Files\QGIS 2.x" instead of C:\OSGeo4W64

## SCRIPT SETUP (WINDOWS)

Edit the _Drainage_Area_Delineation--1.2_tutorial.bat_ and replace the _C:\Program Files\QGIS 2.x_ with the actual QGIS version in your computer as well as the workspace directory.

If needed, do the same thing to the _generalize_polygon.bat_ and _generalize_line.bat_ files

## USAGE

**Drainage_Area_Delineation--1.2_tutorial.bat**

>Open and type in the terminal each one of the commands in the _Drainage_Area_Delineation--1.2_tutorial.bat_ file or execute it at once.

## LINKS

https://www.qgis.org/en/site/

https://www.postgresql.org/

https://postgis.net/

https://grass.osgeo.org/

https://gdal.org/

https://www.python.org/

https://www.hydrosheds.org/

http://metadados.ana.gov.br/geonetwork/srv/pt/main.home

https://github.com/pghydro

https://plugins.qgis.org/plugins/PghydroTools/

https://github.com/deamorim2/pydro

http://www.dpi.inpe.br/terrahidro/doku.php

## Authors

Alexandre de Amorim Teixeira

## Licence

This methodology is Open Source, available under the GPLv2 license and is supported by a growing community of individuals, companies and organizations with an interest in management and decision making in water resources.
