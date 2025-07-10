//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * the ultimate 'fuck you' to military LARPers on a baycode server, and the
 * only thing making beginner heretic usable in such an environment, presumably.
 *
 * the 'warlock eldritch blast spam' is going to be real. if everyone on exploration gets
 * lasers, so does the heretic, and i can make my laser more obnoxious than theirs.
 *
 * fires a mostly-free hitscan beam. doesn't do a ton of damage but afflicts people
 * with nasty effects.
 *
 * ideally this is only significantly powerful in 1v1's, OR for crowd-control (not crowd-kill)
 * so that a heretic can escape.
 */
/datum/prototype/eldritch_ability/eldritch_blast
	ability_type = /datum/ability/eldritch_ability/eldritch_blast
	name = "Eldritch Blast"
	desc = "Discharge an offensive beam at your enemies."

/datum/ability/eldritch_ability/eldritch_blast
	name = "Eldritch Blast"
	desc = "Fire a powerful beam capable of warping reality."
	#warn sprite

	/// hard cooldown set to 3 seconds
	cooldown = 3 SECONDS

	/// last charge tick
	var/charge_last_update = 0
	/// charge recovery rate, as amount per second
	/// * defaults to 100 / 30, which means a full power blast every half minute and a quarter power every 7.5 seconds
	var/charge_recovery = 100 / 30
	/// charge
	var/charge = 100
	/// max charge
	var/charge_max = 100

#warn on_targeted_trigger
#warn impl - firing and click capturing/aiming

/datum/ability/eldritch_ability/eldritch_blast/proc/fire_standard(atom/movable/anchor, datum/event_args/actor/clickchain/clickchain)
	return fire(anchor, clickchain, 0.33)

/datum/ability/eldritch_ability/eldritch_blast/proc/fire_heavy(atom/movable/anchor, datum/event_args/actor/clickchain/clickchain)
	return fire(anchor, clickchain, 1)

/datum/ability/eldritch_ability/eldritch_blast/proc/fire(atom/movable/anchor, datum/event_args/actor/clickchain/clickchain, efficiency)
	var/obj/projectile/proj = new /obj/projectile/eldritch_blast(anchor.loc)
	proj.projectile_effect_multiplier = efficiency
	#warn impl

	proj.original_target = clickchain.target
	proj.def_zone = clickchain.legacy_get_target_zone()
	proj.firer = clickchain.performer
	if(eldritch)
		SEND_SIGNAL(eldritch, COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE, clickchain.performer, proj)
	proj.fire(clickchain.resolve_click_angle())

/**
 * beam used by eldritch blast ability from occultism module
 *
 * * damage is not used by the projectile internally other
 *   than `damage_force`. variables are set for other systems to approximate
 *   our actions.
 */
/obj/projectile/eldritch_blast
	name = "eldritch blast"

	hitscan = TRUE

	// 120 spread damage AoE'd via special handling at full power shot.
	// Standard shots do a fair bit less.
	damage_force = 120
	damage_flag = ARMOR_ENERGY
	damage_mode = NONE
	damage_tier = 4.5
	damage_type = DAMAGE_TYPE_SEARING

	// SFX to play
	var/eldritch_impact_sfx
	// SFX volume
	var/eldritch_impact_sfx_volume = 75

	// AoE range
	var/impact_radius = 3
	// exponential falloff at given distances
	// * default 0.75 = 120/40, 90/30, 75/25
	var/impact_falloff_step_exp = 0.75

#warn impl

/obj/projectile/eldritch_blast/pre_impact(atom/target, impact_flags, def_zone)
	// dear god don't actually process 120 near-unblockable damage as an actual damage frame!
	return ..() | PROJECTILE_IMPACT_SKIP_STANDARD_DAMAGE | PROJECTILE_IMPACT_SUPPRESS_MESSAGE | PROJECTILE_IMPACT_SUPPRESS_SOUND

/obj/projectile/eldritch_blast/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	#warn vfx
	perform_splash_damage(target, hit_zone, damage_force)
	#warn impl

/obj/projectile/eldritch_blast/proc/perform_splash_damage(atom/target, hit_zone, amount)
	var/turf/epicenter = get_turf(target)

/obj/projectile/eldritch_blast/proc/perform_spread_damage(atom/target, hit_zone, amount)

/obj/projectile/eldritch_blast/proc/perform_pinpoint_damage(atom/target, hit_zone, amount)


/obj/projectile/eldritch_blast/do_render_hitscan_muzzle(datum/point/location, angle)

/obj/projectile/eldritch_blast/do_render_hitscan_impact(datum/point/location, angle)

/obj/projectile/eldritch_blast/do_render_hitscan_beam(datum/point/point_a, datum/point/point_b)

#warn impl all
