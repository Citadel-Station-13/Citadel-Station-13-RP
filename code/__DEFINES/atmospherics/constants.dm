// Gas moles
/// Moles in a tile after which gases are visible.
#define MOLES_GAS_VISIBLE					0.25
/// moles_visible * FACTOR_GAS_VISIBLE_MAX = Moles after which gas is at maximum visibility.
#define FACTOR_GAS_VISIBLE_MAX				20
/// Mole step for alpha updates. This means alpha can update at 0.25, 0.5, 0.75, and so on.
#define MOLES_GAS_VISIBLE_STEP				0.25

/// Volume, in liters, of a single tile. Y'KNOW WHY THIS IS A CONSTANT? WELL FOR ONE, initial_gas_mix IS MOLES, NOT PERCENTAGES OR PRESSURES. IF YOU TOUCH THIS, YOU BREAK *EVERYTHING*. DON'T TOUCH THIS.
/// Exceptions can be made if you're a big boy who knows how this clusterfuck of a ZAS/LINDA hybrid works and have good reason to touch this.
#define CELL_VOLUME							2500
