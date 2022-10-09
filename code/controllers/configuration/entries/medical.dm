//! ### MEDICAL ### !//
//? Entries for the health systems used in game.


//! ## Breakage

/// Determines whether heads can be gibbed through excessive damage.
/datum/config_entry/flag/allow_headgibs
	default = TRUE

/// Determines whether bones can be broken through excessive damage to the organ.
/datum/config_entry/flag/bones_can_break
	default = TRUE

/// Determines whether limbs can be amputated through excessive damage to the organ.
/datum/config_entry/flag/limbs_can_break
	default = TRUE


//! ## Health
/// Determines how much health the brainmob has by default.
/datum/config_entry/number/default_brain_health
	default = 400
	min_val = 0

/// Level of health at which a mob goes into continual shock. (soft crit)
/datum/config_entry/number/health_threshold_softcrit
	default = 0

/// Level of health at which a mob becomes unconscious. (crit)
/datum/config_entry/number/health_threshold_crit
	default = -50

/// Level of health at which a mob becomes dead.
/datum/config_entry/number/health_threshold_dead
	default = -100


//! ## Organs
/// Enable to have organs decay when someone's dead.
/datum/config_entry/flag/organ_decay
	default = TRUE

/// Organ decay multiplier.
/datum/config_entry/number/organ_decay_multiplier
	default = 1

/// Multiplier which enables organs to take more damage before bones breaking or limbs being destroyed.
/datum/config_entry/number/organ_health_multiplier
	default = 100

/// Multiplier which influences how fast organs regenerate naturally.
/datum/config_entry/number/organ_regeneration_multiplier
	default = 75

/// Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
/// so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
/datum/config_entry/number/organ_damage_spillover_multiplier
	default = 0.5



//! ### Revival ### !//
/// Amount of time (in hundredths of seconds) for which a brain retains the "spark of life" after the person's death (set to -1 for infinite)
/datum/config_entry/number/revival_brain_life
	default = -1

/// Whether cloning tubes work or not.
/datum/config_entry/flag/revival_cloning
	default = TRUE
