//! constants
/**
 * the minimum radiation we care about
 * any less is harmless and rad waves get dropped below this threshold
 */
#define RAD_BACKGROUND_RADIATION 9

//! Pulse strengths

//? machines
/// rtg - on tick when open
#define RAD_INTENSITY_RADIOISOTOPE_GEN 250
/// supermatter - broken plinth
#define RAD_INTENSITY_SM_BROKEN 500
/// superpacman - every so often
#define RAD_INTENSITY_SUPERPACMAN 50
/// superpacman - on explosion
#define RAD_INTENSITY_SUPERPACMAN_BOOM_FACTOR 100

//? projectiles
/// arc projectiles default
#define RAD_INTENSITY_PROJ_ARC 450

//? chems
/// irradiated nanites - area
#define RAD_INTENSITY_CHEM_IRRADIATED_NANITES 50
/// irradiated nanites - self
#define RAD_INTENSITY_CHEM_IRRADIATED_NANITES_SELF 25

//! Pulse falloffs

//? Only defaults are defined for the above reasons.
#define RAD_FALLOFF_NORMAL 1
#define RAD_FALLOFF_CONTAMINATION_NORMAL 2

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
