//! constants
/**
 * the minimum radiation we care about
 * any less is harmless and rad waves get dropped below this threshold
 */
#define RAD_BACKGROUND_RADIATION 9

//! half life multipliers
/**
 * the **default** half life of a radioactive atom, in ds
 */
#define RAD_HALF_LIFE_DEFAULT (9 SECONDS)

//! falloff multipliers - higher is faster, lower is slower.
/**
 * the **default** falloff multiplier of a radioactive wave/atom
 */
#define RAD_FALLOFF_DEFAULT 1
/**
 * the default falloff multiplier of a contamination-infected atom.
 * this is usually higher to nerf contamination.
 */
#define RAD_FALLOFF_CONTAMINATION_DEFAULT 2

//! contamination - uh oh
// WARNING: The deines below could have disastrous consequences if tweaked incorrectly. See: The great SM purge of Oct.6.2017
// contamination_chance = 		(strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_CHANCE_COEFFICIENT * min(1/(steps*RAD_DISTANCE_COEFFICIENT), 1))
// contamination_strength = 	(strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_STR_COEFFICIENT
#define RAD_MINIMUM_CONTAMINATION 300				// How strong does a radiation wave have to be to contaminate objects
#define RAD_CONTAMINATION_CHANCE_COEFFICIENT 0.005	// Higher means higher strength scaling contamination chance
#define RAD_CONTAMINATION_STR_COEFFICIENT 0.99		// Higher means higher strength scaling contamination strength
