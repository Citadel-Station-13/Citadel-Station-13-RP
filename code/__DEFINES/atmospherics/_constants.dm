//* Math Constants *//

/// kPa*L/(K*mol).
#define R_IDEAL_GAS_EQUATION 8.31
/**
 * * Constant used for calculating blackbody radiation emittance.
 * * Unit is W / (m^2 * K^4)
 */
#define STEFAN_BOLTZMANN_CONSTANT 5.6704e-8

//* Simulation Constants *//

/// Volume, in liters, of a single tile. Y'KNOW WHY THIS IS A CONSTANT? WELL FOR ONE, initial_gas_mix IS MOLES, NOT PERCENTAGES OR PRESSURES. IF YOU TOUCH THIS, YOU BREAK *EVERYTHING*. DON'T TOUCH THIS.
/// Exceptions can be made if you're a big boy who knows how this clusterfuck of a ZAS/LINDA hybrid works and have good reason to touch this.
#define CELL_VOLUME 2500
/// Moles in a 2.5 m^3 cell at 101.325 kPa and 20 C.
#define CELL_MOLES (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))

//* Pressures *//

/// 1atm of earth-standard pressure, in kPa
#define ONE_ATMOSPHERE             101.325

//* Temperatures *//

// todo: T_0C?

/**
 * Constant used as absolute zero.
 *
 * * Why the hell is this conflicting with COSMIC_RADIATION_TEMPERATURE?
 * * This is basically the absolute zero of simulation. Gas cannot / should not get colder than this, ever.
 * * This is -270.3C.
 * * Please get this a better name.
 */
#define TCMB 2.7
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

/**
 * Temperature of cosmic microwave background radiation used for radiative space cooling.
 *
 * * This is above TCMB. Why?
 */
#define COSMIC_RADIATION_TEMPERATURE 3.15
