@ECHO ON
g.region -p
v.in.ogr input=e:/dad/outputDrainage.shp type=line output=gdrn
v.generalize input=gdrn output=smooth_line method=chaiken threshold=30 iterations=10
v.out.ogr input=smooth_line type=line format=GPKG output=e:/dad/smooth_line.gpkg
rem Parameters
rem GRASS:> v.generalize
rem Feature Type: boundary
rem Method: chaiken
rem Maximal Tolerance Value: 30 (SRTM 30m)
rem Iterations: 10
PAUSE