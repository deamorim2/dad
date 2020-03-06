@ECHO ON
g.region -p
v.in.ogr input=c:/workspace/dra.shp type=boundary output=gdra
v.generalize input=gdra output=smooth_polygon method=chaiken threshold=30 iterations=10
v.out.ogr input=smooth_polygon type=area format=ESRI_Shapefile output=c:/workspace/smooth_polygon.shp
rem Parameters
rem GRASS:> v.generalize
rem Feature Type: boundary
rem Method: chaiken
rem Maximal Tolerance Value: 30 (SRTM 30m)
rem Iterations: 10
PAUSE

:: Section 12: Line Smoothing
ECHO ============================
ECHO Line Smoothing
ECHO ============================

"C:\Program Files\QGIS 2.18\bin\grass76.bat" --tmp-location "c:\workspace\outputDrainage.shp" --exec "c:\workspace\generalize_line.bat"

PAUSE