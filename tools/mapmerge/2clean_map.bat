SET z_levels=10
cd 

FOR %%f IN (../../maps/tether/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/tether/%%f.backup ../../maps/tether/%%f ../../maps/tether/%%f
)

SET z_levels=6
cd 

FOR %%f IN (../../maps/northern_star/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/northern_star/%%f.backup ../../maps/northern_star/%%f ../../maps/northern_star/%%f
)

FOR %%f IN (../../maps/southern_cross/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/southern_cross/%%f.backup ../../maps/southern_cross/%%f ../../maps/southern_cross/%%f
)

pause