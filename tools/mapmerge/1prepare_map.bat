cd ../../maps/southern_cross_citadel

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
