//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * ## Active Defensives
 *
 * Datastructure for active block on mobs.
 *
 * * One, or more, may exist at a time; all of them will be shieldcall-registered, be very careful when doing this.
 * * Items should generally not allow adding another packet while one is active
 */
/datum/component/active_block
	registered_type = /datum/component/active_block

	/// active defensive data

#warn impl

/**
 * Datastructure for block data, now far more simplified.
 *
 * * Please avoid anonymous typing this where possible, this is a heavy datum and caching helps a lot.
 *
 * todo: this should be a serializable prototype
 */
/datum/active_block
	/// shield arc, in both CW/CCW from user facing direction
	///
	/// * given RP doesn't have combat mode, you should really just keep this at 180
	/// * realistically the cutoffs are 45, 90, 135, and 180 for anything that's not a projectile as only those sim physics
	var/active_block_arc = 180
	/// maximum block per attack instance
	var/active_block_damage_max = INFINITY
	/// damage block % above minimum
	var/active_block_damage_ratio = 0
	/// damage block minimum
	var/active_block_damage_min = 0
	/// if set, use this armor datum for processing how much damage to block
	///
	/// * use this for tiered simulation
	/// * [active_block_damage_max] is the only other variable used for calculations if this is set, all others are on armor already
	/// * set to typepath or instance
	var/datum/armor/active_block_via_armor

	/// attack types we are allowed to parry
	var/active_block_attack_types = NONE

	/// if 100% of damage is blocked, do we set SHIELDCALL_BLOCKED and similar flags?
	///
	/// * this means things like syringes would be blocked from injecting.
	var/active_block_can_prevent_contact = FALSE
	/// always add BLOCKED, even if not 100% mitigated / transmuted
	var/active_block_always_prevents_contact = FALSE

	/// ratio [0, INFINITY] of inbound damage to convert to another type
	var/active_block_transmute = 0
	/// damage type to transmute to
	var/active_block_transmute_type = HALLOSS
	/// damage flag the transmuted damage counts as; null = inherit from attack
	///
	/// * only used if active_block_transmute_simulation is on
	var/active_block_transmute_flag = null
	/// the transmuted damage is directly applied with full melee sim, instead of just a damage instance
	///
	/// * DO NOT TURN THIS ON WITHOUT GOOD REASON. Melee sim is several times more expensive than armor / low-level intercepts for damage instances.
	var/active_block_transmute_simulation = FALSE
