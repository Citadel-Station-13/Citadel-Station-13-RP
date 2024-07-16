//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Armor - Only run against armor. *//

/**
 * An override of /atom/proc/run_armorcalls(), with zone filter capability.
 *
 * This is what you should override, instead of the check/run procs.
 *
 * * At current moment, due to expensiveness reasons, not providing filter_zone will result in only SHIELDCALL_ARG_DAMAGE being modified.
 *
 * @params
 * * shieldcall_args - passed in shieldcall args list to modify
 * * fake_attack - are we just checking armor?
 * * filter_zone - confine to a certain hit zone. this is **required** for full processing, otherwise we just check overall damage.
 */
/mob/run_armorcalls(list/shieldcall_args, fake_attack, filter_zone)
	..() // perform default /atom level

/**
 * Generic, low-level armor check for inbound attacks
 *
 * * This will filter armor by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_armor(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE, hit_zone) // by default, use atom/var/armor on ourselves

/**
 * Generic, low-level armor processing for inbound attacks
 *
 * * This will filter armor by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_armor(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE, hit_zone) // by default, use atom/var/armor on ourselves

/**
 * Checks the average armor for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_overall_armor(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE) // by default, use atom/var/armor on ourselves

/**
 * Checks the average armor for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_overall_armor(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE) // by default, use atom/var/armor on ourselves

//* Defense - Run against armor, as well as shieldcalls *//

/**
 * Generic, low-level defense check for inbound attacks
 *
 * * This will filter defense by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_defense(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE, hit_zone) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, TRUE)

/**
 * Generic, low-level defense processing for inbound attacks
 *
 * * This will filter defense by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_defense(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE, hit_zone) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, FALSE)

/**
 * Checks the average defense for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_overall_defense(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, TRUE)

/**
 * Checks the average defense for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_overall_defense(damage, damtype, tier, flag, mode, attack_type, datum/weapon, flags, hit_zone, list/additional)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, FALSE)
