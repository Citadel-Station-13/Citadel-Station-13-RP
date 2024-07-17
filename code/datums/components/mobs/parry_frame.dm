//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * ## Active Parry
 *
 * Datastructure for active parry on mobs.
 *
 * * One, or more, may exist at a time; all of them will be shieldcall-registered, be very careful when doing this.
 * * Items should generally not allow adding another parry frame while one is active
 */
/datum/component/parry_frame
	registered_type = /datum/component/parry_frame

	/// active defensive data
	var/datum/active_parry/active_parry
	/// current number of processed hits
	var/hit_count = 0
	/// world.time of start
	var/start_time
	/// applied visual
	var/appearance/overlay_applied

#warn impl

/**
 * Datastructure for parry data, now far more simplified.
 *
 * * Please avoid anonymous typing this where possible, this is a heavy datum and caching helps a lot.
 *
 * todo: this should be a serializable prototype
 */
/datum/parry_frame
	/// shield arc, in both CW/CCW from user facing direction
	///
	/// * given RP doesn't have combat mode, you should really just keep this at 180
	/// * realistically the cutoffs are 45, 90, 135, and 180 for anything that's not a projectile as only those sim physics
	var/parry_arc = 180

	/// spinup time
	///
	/// * keep this at 0 in most cases
	var/parry_timing_start = 0 SECONDS
	/// perfect time
	var/parry_timing_perfect = 0 SECONDS
	/// no-falloff time
	var/parry_timing_active = 0 SECONDS
	/// falling off time
	///
	/// * efficiency linearly drops from active efficiency to 0 during this time
	var/parry_timing_drop = 0 SECONDS

	/// attack types we are allowed to parry
	var/parry_attack_types = NONE

	/// parry efficiency at perfect; [0, 1]
	///
	/// * parry efficiency is ratio of damage to block
	var/parry_efficiency_perfect = 1
	/// parry efficiency at active; [0, 1]
	///
	/// * parry efficiency is ratio of damage to block
	var/parry_efficiency_active = 1
	/// minimum efficiency to drop to
	var/parry_efficiency_floor = 0

	/// action-lock the defender while parrying
	var/parry_lock_defender = TRUE
	/// drop action-lock on defender when a parry succeeds
	var/parry_free_defender_on_success = TRUE
	/// immediately drop the parry after this many hits
	var/parry_drop_after_hits = 1

	/// maximum damage blocked per attack instance
	var/parry_damage_max = INFINITY

	/// counterattack on hit
	///
	/// * keep this off, this is a good exercise in 'just because you can doesn't mean you should'
	var/parry_counter_attack = FALSE
	/// status effects to apply on hit to attacker
	///
	/// supports:
	/// * normal status effects; associate to duration
	var/list/parry_counter_effects

	/// default handling: reflect attack types
	///
	/// * yeah you probably shouldn't put anything other than ATTACK_TYPE_PROJECTILE in here.
	var/parry_redirect_attack_types = NONE
	/// default handling: reflect attack back at attacker
	///
	/// * yeah you probably should leave this off
	var/parry_redirect_return_to_sender = FALSE
	/// redirection arc CW/CCW of angle of incidence
	///
	/// * if return_to_sender is off, this is the valid arc from attack source it can be reflected to
	/// * if return_to_sender is on, this is the arc in error from attack source we can reflect to
	var/parry_redirect_arc = 45
	/// perform a smart judgement call on if something is reasonable redirected back at sender
	///
	/// * this is a percentage chance, 100 = never fuck over attacker
	/// * tl;dr things like 'don't reflect hitscans directly at attacker as that isn't fun'
	var/parry_redirect_mystery_balancing_number = 85

	/// if 100% of damage is blocked, do we set SHIELDCALL_BLOCKED and similar flags?
	///
	/// * this means things like syringes would be blocked from injecting.
	var/parry_can_prevent_contact = FALSE
	/// always add BLOCKED, even if not 100% mitigated / transmuted
	var/parry_always_prevents_contact = FALSE

	/// ratio [0, INFINITY] of inbound damage to convert to another type
	var/parry_transmute = 0
	/// damage type to transmute to
	var/parry_transmute_type = HALLOSS
	/// damage flag the transmuted damage counts as; null = inherit from attack
	///
	/// * only used if parry_transmute_simulation is on
	var/parry_transmute_flag = null
	/// the transmuted damage is directly applied with full melee sim, instead of just a damage instance
	///
	/// * DO NOT TURN THIS ON WITHOUT GOOD REASON. Melee sim is several times more expensive than armor / low-level intercepts for damage instances.
	var/parry_transmute_simulation = FALSE

	/// hard cooldown to apply to parrying with the thing parrying wth
	var/parry_cooldown_tool = 2 SECONDS
	/// hard cooldown to apply to parrying at all as the mob
	var/parry_cooldown_user = 0 SECONDS
	/// is the parry cooldown ignored if a successful parry was made
	var/parry_cooldown_on_success = FALSE

	//* Passive Parrying *//

	/// parry chance for harmful melee: [0, 100]
	var/passive_parry_chance_melee = 0
	/// parry chance for (seemingly) benign melee: [0, 100]
	var/passive_parry_chance_touch = 0
	/// parry chance for inbound projectile: [0, 100]
	var/passive_parry_chance_projectile = 0
	/// parry chance for inbound throw
	var/passive_parry_chance_thrown = 0

	/// projectile types we autoparry on
	var/passive_parry_projectile_types = ALL
