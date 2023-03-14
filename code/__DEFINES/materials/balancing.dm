//? master file for balancing / efficiency tuning

//* efficiency

/// scale a lathe's efficiency to upgrade level
#define MATERIAL_EFFICIENCY_LATHE_SCALE(tier) (1.1 - tier * 0.1)
