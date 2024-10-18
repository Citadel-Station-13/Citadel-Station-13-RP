//* Simulation Constants *//

/// Volume, in liters, of a single tile. Y'KNOW WHY THIS IS A CONSTANT? WELL FOR ONE, initial_gas_mix IS MOLES, NOT PERCENTAGES OR PRESSURES. IF YOU TOUCH THIS, YOU BREAK *EVERYTHING*. DON'T TOUCH THIS.
/// Exceptions can be made if you're a big boy who knows how this clusterfuck of a ZAS/LINDA hybrid works and have good reason to touch this.
#define CELL_VOLUME 2500
/// Moles in a 2.5 m^3 cell at 101.325 kPa and 20 C.
#define CELL_MOLES (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))

//* Gas Constants *//

/// kPa*L/(K*mol).
#define R_IDEAL_GAS_EQUATION 8.31

//* Math Helpers - Pressures *//

/// 1atm of earth-standard pressure, in kPa
#define ONE_ATMOSPHERE             101.325

//* Math Helpers - Temperatures *//

// todo: T_0C?

/**
 * -60C in Kelvin
 *
 * * Please get this a better name. T_NEG_60C?
 */
#define TN60C 213.15
/// 0 deg C, in Kelvin
#define T0C 273.15
/// 20 deg C, in Kelvin
#define T20C 293.15
/// 100 deg C, in Kelvin
#define T100C 373.15
