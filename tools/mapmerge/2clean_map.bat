SET z_levels=6
cd 

FOR %%f IN (../../maps/northern_star/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/northern_star/%%f.backup ../../maps/northern_star/%%f ../../maps/northern_star/%%f
)

FOR %%f IN (../../maps/southern_cross/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/southern_cross/%%f.backup ../../maps/southern_cross/%%f ../../maps/southern_cross/%%f
)

FOR %%f IN (../../maps/southern_cross_citadel/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/southern_cross_citadel/%%f.backup ../../maps/southern_cross_citadel/%%f ../../maps/southern_cross_citadel/%%f
)

pause