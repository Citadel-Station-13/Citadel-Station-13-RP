//! constants
/**
 * the minimum radiation we care about
 * any less is harmless and rad waves get dropped below this threshold
 */
#define RAD_BACKGROUND_RADIATION 9

//! Pulse - Falloff
//* When updating, write what it's for and how it's used so future coders don't have a Bad Time

//? Only defaults are defined for the above reasons.
/// default falloff
#define RAD_FALLOFF_NORMAL 0.75
/// default falloff for contaminated objects
#define RAD_FALLOFF_CONTAMINATION_NORMAL 1.25
/// default falloff for anomalies
#define RAD_FALLOFF_ANOMALY 0.5
/// default falloff for smashed anomalies
#define RAD_FALLOFF_ANOMALY_SHARDS 0.33
/// fission engine
#define RAD_FALLOFF_ENGINE_FISSION 0.75
/// fusion engine
#define RAD_FALLOFF_ENGINE_FUSION 0.75
/// supermatter
#define RAD_FALLOFF_ENGINE_SUPERMATTER 0.75
/// singulo
#define RAD_FALLOFF_ENGINE_SINGULARITY 0.75

//! Pulse - Z Falloff
//* Keep in mind that these are low because things are usually really far away and the point of Z rad is to hit most things.
#define RAD_FALLOFF_ZLEVEL_DEFAULT 0.05
#define RAD_FALLOFF_ZLEVEL_SUPERMATTER_DELAMINATION 0.05
#define RAD_FALLOFF_ZLEVEL_FISSION_MELTDOWN 0.05

//! Pulse - Strength
//* When updating, write what it's for and how it's used so future coders don't have a Bad Time

//? chems
/// irradiated nanites - area
#define RAD_INTENSITY_CHEM_IRRADIATED_NANITES 50
/// irradiated nanites - self
#define RAD_INTENSITY_CHEM_IRRADIATED_NANITES_SELF 25

//? items
/// standalone shockpaddles - use
#define RAD_INTENSITY_STANDALONE_DEFIB 100
/// standalone shockpaddles - fail tick
#define RAD_INTENSITY_STANDALONE_DEFIB_FAIL 150

//? machines
/// gravity generator grav per tick while charging/discharging
#define RAD_INTENSITY_GRAVGEN_OPERATING_TICK 300
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

//? materials - radioactivity
#define RAD_INTENSITY_MAT_URANIUM 60
#define RAD_INTENSITY_MAT_SUPERMATTER 240

//? materials - snowflake
/// supermatter material radiation on pickup per sheet
#define RAD_INTENSITY_MAT_SUPERMATTER_PICKUP_PER_SHEET(s) (s * 50)
/// supermatter material radiation on explode per sheet
#define RAD_INTENSITY_MAT_SUPERMATTER_EXPLODE_PER_SHEET(s) (s * 200)
/**
 * uranium airlock
 * at time of writing this is about every 4 seconds
 */
#define RAD_INTENSITY_MAT_SPECIAL_URANIUM_AIRLOCK 150
/// simple door divisor for material radioactivity
#define RAD_INTENSITY_DIVISOR_SIMPLE_DOOR 3

//? mecha
/// mecha nuclear generator rad per tick
#define RAD_INTENSITY_MECH_REACTOR_TICK 50
/// phasing being cancelled by damage
#define RAD_INTENSITY_MECH_JANUS_FORCED_UNPHASE 350

//? misc
/// manhole cover for POI
#define RAD_INTENSITY_POI_MANHOLE_COVER 100
/// reactor rack for POI
#define RAD_INTENSITY_POI_REACTOR_RACK 500
/// radioactive meteors
#define RAD_INTENSITY_RADIOACTIVE_METEOR 1500

//? mobs
/// radioactive blob power
#define RAD_INTENSITY_BLOB_RADIOACTIVE_OOZE 250
/// xenobio green slime per tick
#define RAD_INTENSITY_GREEN_SLIME_TICK 500

//? projectiles
/// arc projectiles default
#define RAD_INTENSITY_PROJ_ARC 450
/// cyberhorror priest arc projectiles
#define RAD_INTENSITY_PROJ_ARC_HORROR_PRIEST 450

//? weather
/// fallout radiation amount - direct
#define RAD_INTENSITY_FALLOUT_DIRECT_LOW 5
/// fallout radiation amount - direct
#define RAD_INTENSITY_FALLOUT_DIRECT_HIGH 15
/// fallout radiation amount - direct
#define RAD_INTENSITY_FALLOUT_INDIRECT_LOW 150
/// fallout radiation amount - direct
#define RAD_INTENSITY_FALLOUT_INDIRECT_HIGH 750

//? xenoarcheology
/// anomaly radiation low
#define RAD_INTENSITY_ANOMALY_PULSE_LOW 250
/// anomaly radiation high
#define RAD_INTENSITY_ANOMALY_PULSE_HIGH 400
/// anomaly radiation low - broken
#define RAD_INTENSITY_ANOMALY_SMASH_LOW 200
/// anomaly radiation high - broken
#define RAD_INTENSITY_ANOMALY_SMASH_HIGH 500

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
#define RAD_HALF_LIFE_DEFAULT (20 SECONDS)
/// broken anomaly decay
#define RAD_HALF_LIFE_ANOMALY_SMASH (1 MINUTES)

//! contamination - uh oh
//? WARNING: The deines below could have disastrous consequences if tweaked incorrectly. See: The great SM purge of Oct.6.2017
//? Touching them without mathing it out and extensive testing is not a great idea.
// contamination_chance = 		(strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_CHANCE_COEFFICIENT * min(1/(steps*RAD_DISTANCE_COEFFICIENT), 1))
// contamination_strength = 	(strength-RAD_MINIMUM_CONTAMINATION) * RAD_CONTAMINATION_STR_COEFFICIENT
/// weakest wave strength to contaminate
#define RAD_MINIMUM_CONTAMINATION 200
/// lowest meaningful contamination strength
#define RAD_CONTAMINATION_MEANINGFUL 5
#define RAD_CONTAMINATION_CHANCE_COEFFICIENT 0.005	// Higher means higher strength scaling contamination chance
/// factor for max contamination strength from source strength
#define RAD_CONTAMINATION_STR_COEFFICIENT 0.8
/// adjust for max contamination strength from soruce strength - this is **sutracted**, so should never be < 0.
#define RAD_CONTAMINATION_STR_ADJUST 5
/// additional times radiation contamination lets out when decaying; BE CAREFUL
#define RAD_CONTAMINATION_CHEAT_FACTOR 2
#define RAD_CONTAMINATION_MAXIMUM_OBJECT_RATIO 0.1	// max amount of starting intensity that can be imparted to one object at a time
/// percentage of current intensity that can stack onto objects
//! disabled until radiation conserves energy to avoid cascades.
// #define RAD_CONTAMINATION_STACK_COEFFICIENT 0.5
/// can things contaminate by default?
#define RAD_CONTAMINATION_DEFAULT TRUE
/// can z-wide radiatoin contaminate by default?
#define RAD_ZLEVEL_CONTAMINATION_DEFAULT TRUE
/// amount of contamination washed out by a single tick of a shower, or 10 units of water
#define RAD_CONTAMINATION_CLEANSE_POWER 20
	#define RAD_CONTAMINATION_CLEANSE_POWER_WASHING_MACHINE 200
/// amount of contamination washed out as a multiplier
#define RAD_CONTAMINATION_CLEANSE_FACTOR 0.1
	#define RAD_CONTAMINATION_CLEANSE_FACTOR_WASHING_MACHINE 0.9

//! z_radiate_flags
/// respect rad shielded maint
#define Z_RADIATE_CHECK_AREA_SHIELD (1<<0)
