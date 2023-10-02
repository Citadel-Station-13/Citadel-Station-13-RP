#define HasBelow(Z) (((Z) > world.maxz || (Z) < 2 || ((Z)-1) > z_levels.len) ? 0 : z_levels[(Z)-1])
#define HasAbove(Z) (((Z) >= world.maxz || (Z) < 1 || (Z) > z_levels.len) ? 0 : z_levels[(Z)])
