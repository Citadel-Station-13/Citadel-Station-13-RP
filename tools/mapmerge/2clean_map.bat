SET z_levels=6
cd 

FOR %%f IN (../../maps/southern_cross_citadel/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/southern_cross_citadel/%%f.backup ../../maps/southern_cross_citadel/%%f ../../maps/southern_cross_citadel/%%f
)

pause