//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Global balancing numbers; everything should derive off of these so we can adjust everything at once.
/// global default multiplier for falloff exponential
#define EXPLOSION_FALLOFF_BASE_EXPONENT 0.97
/// global default subtractor for falloff linear
#define EXPLOSION_FALLOFF_BASE_LINEAR 10

/// arbitrary value that's semi-equivalent of being in the middle of a 5/10/20 on old explosions
#define EXPLOSION_POWER_MAXCAP_EQUIVALENT 1000
/// arbitrary value that's semi-equivalent of being hit with sev 1 in old explosions
#define EXPLOSION_POWER_APPROXIMATE_DEVASTATE 1000
/// arbitrary value that's semi-equivalent of being hit with a severity 2 explosion on old explosions
#define EXPLOSION_POWER_APPROXIMATE_HEAVY 500
/// arbitrary value that's semi-equivalent of being hit with a sev 3 in old explosions
#define EXPLOSION_POWER_APPROXIMATE_LIGHT 250

/// below this explosions are considered so trivial we just drop the wave
#define EXPLOSION_POWER_DROPPED 50

//* balancing slop below *//

/// overall damage
#define EXPLOSION_POWER_TO_OBJ_DAMAGE(POWER, VARIANCE)
/// overall damage
#define EXPLOSION_POWER_TO_MOB_DAMAGE(POWER, VARIANCE)
/// modifier to how likely it is that a limb gets obliterated
#define EXPLOSION_POWER_TO_MOB_DISMEMBER_MULTIPLIER(POWER, VARIANCE)

// modified two-threshold inverse-quadratic
#define EXPLOSION_POWER_MOB_GIB_ALWAYS 850
#define EXPLOSION_POWER_MOB_GIB_LD50 750
#define EXPLOSION_POWER_MOB_GIB_MINIMUM 650
#define EXPLOSION_POWER_TO_MOB_GIB_CHANCE(POWER)

//* presets *//

/**
 * why is this in this file?
 * because honestly, for such a horrifically mathy system,
 * having all the balancing be in one file for easy referencing and adaptation
 * instead of requiring codebase-wise audits of function calls is good.
 */
/datum/explosion_preset
	var/power = 0
	var/falloff_lin = 0
	var/falloff_exp = 0
	var/falloff_exp_delay_cycles = 0

/datum/explosion_preset/telecube_implosion
	power = LERP(EXPLOSION_POWER_APPROXIMATE_HEAVY, EXPLOSION_POWER_APPROXIMATE_DEVASTATE, 0.5)
	falloff_exp_delay_cycles = 2
	falloff_exp = 0.88
	falloff_lin = EXPLOSION_POWER_APPROXIMATE_DEVASTATE / 12

/**
 * annihilation / maxcap
 */
/datum/explosion_preset/level_5

/**
 * halfcap / devastating
 */
/datum/explosion_preset/level_4

/**
 * minibomb devastation, large radius / major
 */
/datum/explosion_preset/level_3

/**
 * moderately sized explosion
 */
/datum/explosion_preset/level_2

/**
 * minibomb
 */
/datum/explosion_preset/level_1

/**
 * devastating backfire
 */
/datum/explosion_preset/item_backfire_3

/**
 * major backfire
 */
/datum/explosion_preset/item_backfire_2

/**
 * minor backfire
 */
/datum/explosion_preset/item_backfire_1

/**
 * massive radius / antigrain
 */
/datum/explosion_preset/grenade_5

/**
 * large radius / boosted
 */
/datum/explosion_preset/grenade_4

/**
 * medium / high explosive grenade
 */
/datum/explosion_preset/grenade_3

/**
 * small radius
 */
/datum/explosion_preset/grenade_2

/**
 * tiny / weak
 */
/datum/explosion_preset/grenade_1

/**
 * seismic charges
 */
/datum/explosive_preset/seismic_charge

/**
 * seismic charges - boosted
 */
/datum/explosive_preset/seismic_charge/boosted

/**
 * R-UST fusion rupture
 *
 * todo: this is awful
 */
/datum/explosive_preset/fusion_rupture_legacy
	#warn 0/5/5 before

/**
 * disperser beam collision with turf
 */
/datum/explosive_preset/disperser_beam_collision
	#warn 1/2/3 before

#warn impl all
