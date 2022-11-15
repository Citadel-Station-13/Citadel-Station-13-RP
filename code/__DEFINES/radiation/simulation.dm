//! constants
/**
 * the minimum radiation we care about
 * any less is harmless and rad waves get dropped below this threshold
 */
#define RAD_BACKGROUND_RADIATION 9

//! Pulse - Falloff
//* When updating, write what it's for and how it's used so future coders don't have a Bad Time

//? Only defaults are defined for the above reasons.
#define RAD_FALLOFF_NORMAL 1
#define RAD_FALLOFF_CONTAMINATION_NORMAL 2

//! Pulse - Strength
//* When updating, write what it's for and how it's used so future coders don't have a Bad Time

//? items
/// standalone shockpaddles - use
#define RAD_INTENSITY_STANDALONE_DEFIB 100
/// standalone shockpaddles - fail tick
#define RAD_INTENSITY_STANDALONE_DEFIB_FAIL 150

//? mecha
/// mecha nuclear generator rad per tick
#define RAD_INTENSITY_MECH_REACTOR_TICK 50

//? machines
/**
 * particle smasher lost energy to radiation conversion
 * at time of writing, energy loss is usually 5-30 per tick.
 */
#define RAD_INTENSITY_PARTICLE_SMASHER_ENERGY_LOSS(e) (e * 50)
/// rtg - on tick when open
#define RAD_INTENSITY_RADIOISOTOPE_GEN 250
/// supermatter - broken plinth
#define RAD_INTENSITY_SM_BROKEN 500
/// superpacman - every so often
#define RAD_INTENSITY_SUPERPACMAN 50
/**
 * superpacman - on explosion
 * at time of writing this is radiation per sheet of uranium.
 */
#define RAD_INTENSITY_SUPERPACMAN_BOOM_FACTOR 100

//? projectiles
/// arc projectiles default
#define RAD_INTENSITY_PROJ_ARC 450

//? chems
/// irradiated nanites - area
#define RAD_INTENSITY_CHEM_IRRADIATED_NANITES 50
/// irradiated nanites - self
#define RAD_INTENSITY_CHEM_IRRADIATED_NANITES_SELF 25

//! Pulse - Other
//* When updating, write what it's for and how it's used so future coders don't have a Bad Time

/// minimum radiation for collectors to make power; radiation amount is also subtracted by this
#define RAD_MISC_COLLECTOR_FLAT_LOSS 80
/// **kilojoules** per 1 radiation intensity
#define RAD_MISC_COLLECTOR_MULTIPLIER 1.25

//! half life multipliers
/**
 * the **default** half life of a radioactive atom, in ds
 */
#define RAD_HALF_LIFE_DEFAULT (9 SECONDS)

//! contamination - uh oh
// WARNING: The deines below could have disastrous consequences if tweaked incorrectly. See: The great SM purge of Oct.6.2017
// contamination_chance = 		(strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_CHANCE_COEFFICIENT * min(1/(steps*RAD_DISTANCE_COEFFICIENT), 1))
// contamination_strength = 	(strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_STR_COEFFICIENT
#define RAD_MINIMUM_CONTAMINATION 300				// How strong does a radiation wave have to be to contaminate objects
#define RAD_CONTAMINATION_CHANCE_COEFFICIENT 0.005	// Higher means higher strength scaling contamination chance
#define RAD_CONTAMINATION_STR_COEFFICIENT 0.99		// Higher means higher strength scaling contamination strength
#define RAD_CONTAMINATION_MAXIMUM_OBJECT_RATIO 0.1	// max amount of starting intensity that can be imparted to one object at a time
/// can things contaminate by default?
#define RAD_CONTAMINATION_DEFAULT TRUE
