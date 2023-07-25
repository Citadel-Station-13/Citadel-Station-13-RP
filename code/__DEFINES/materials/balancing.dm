//? master file for balancing / efficiency tuning

//* Attributes - Resistance

/// the level at which vulnerability is comedically high
#define MATERIAL_RESISTANCE_SUPER_VULNERABLE -200
/// the level at which vulnerability is high
#define MATERIAL_RESISTANCE_VERY_VULNERABLE -100
/// the level at which vulnerability is moderate
#define MATERIAL_RESISTANCE_VULNERABLE -50
/// the level at which vulnerability is minor
#define MATERIAL_RESISTANCE_SOMEWHAT_VULNERABLE -20
/// baseline MATERIAL_RESISTANCE for nothing
#define MATERIAL_RESISTANCE_NONE 0
/// the level at which resistance is workable
#define MATERIAL_RESISTANCE_LOW 50
/// the level at which resistance is good
#define MATERIAL_RESISTANCE_MODERATE 100
/// the level at which resistance is high
#define MATERIAL_RESISTANCE_HIGH 200
/// the level at which resistance is very high
#define MATERIAL_RESISTANCE_EXTREME 400
/// the level at which resistance is nearly impermeable
#define MATERIAL_RESISTANCE_IMPERMEABLE 800

//* Attributes - Significance

/// baseline significance of material calculations done on material-side / default computations
#define MATERIAL_SIGNIFICANCE_BASELINE 10
/// significance used for normal wall layer
#define MATERIAL_SIGNIFICANCE_WALL 20
/// significance used for reinforcing wall layer
#define MATERIAL_SIGNIFICANCE_WALL_REINF 10
/// significance used for girder wall layer
#define MATERIAL_SIGNIFICANCE_WALL_GIRDER 5

//* Efficiency

/// scale a lathe's efficiency to upgrade level
#define MATERIAL_EFFICIENCY_LATHE_SCALE(tier) max(0, 1.1 - tier * 0.1)
