//* Physics Constants *//

/// in Kelvin, temperature of cosmic microwave background radiation (used for radiative space cooling)
#define COSMIC_RADIATION_TEMPERATURE 3.15
/// kPa*L/(K*mol).
#define R_IDEAL_GAS_EQUATION 8.31
/// W/(m^2*K^4).
#define STEFAN_BOLTZMANN_CONSTANT 5.6704e-8


/// Volume, in liters, of a single tile. Y'KNOW WHY THIS IS A CONSTANT? WELL FOR ONE, initial_gas_mix IS MOLES, NOT PERCENTAGES OR PRESSURES. IF YOU TOUCH THIS, YOU BREAK *EVERYTHING*. DON'T TOUCH THIS.
/// Exceptions can be made if you're a big boy who knows how this clusterfuck of a ZAS/LINDA hybrid works and have good reason to touch this.
#define CELL_VOLUME 2500
/// Moles in a 2.5 m^3 cell at 101.325 kPa and 20 C.
#define CELL_MOLES (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))
