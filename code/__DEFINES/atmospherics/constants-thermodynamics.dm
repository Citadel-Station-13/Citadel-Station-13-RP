//* Thermodynamics - Constants *//

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
 * * Constant used for calculating blackbody radiation emittance.
 * * Unit is W / (m^2 * K^4)
 */
#define STEFAN_BOLTZMANN_CONSTANT 5.6704e-8
/**
 * Temperature of cosmic microwave background radiation used for radiative space cooling.
 *
 * * This is above TCMB. Why?
 */
#define COSMIC_RADIATION_TEMPERATURE 3.15

//* Thermodynamics - Radiation *//

// todo: all of these below are semi-confusing. is there a better way?

/**
 * * kPa at 20C
 * * This should realistically be higher as gases aren't great conductors until they are dense.
 * * Uses the critical pressure for air.
 */
#define THERMODYNAMICS_OPTIMAL_RADIATOR_PRESSURE 3771
/**
 * The critical point temperature for air.
 *
 * * This is where standard airmix's liquid / gas / supercritical phases meet.
 */
#define THERMODYANMICS_CRITICAL_TEMPERATURE_OF_AIR     132.65

/**
 * Ratio of surface area exposed to theroetical star for radiative heating while in space.
 *
 * todo: wouldn't it be funny if this was based on overmap entity :drooling:
 */
#define THERMODYNAMICS_THEORETICAL_STAR_EXPOSURE_RATIO (1 / 4)
/**
 * W / m^2 energy hitting external surfaces from a theoretical star.
 *
 * todo: wouldn't it be funny if this was based on overmap entity :drooling:
 */
#define THERMODYNAMICS_THEORETICAL_STAR_EXPOSED_POWER_DENSITY 200

/// m^2, surface area of 1.7m (H) x 0.46m (D) cylinder
#define THERMODYNAMICS_HUMAN_EXPOSED_SURFACE_AREA          5.2
