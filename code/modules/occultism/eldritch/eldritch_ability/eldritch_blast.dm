//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
	if(eldritch)
		SEND_SIGNAL(eldritch, COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE, clickchain.performer, proj)
	proj.fire(clickchain.resolve_click_angle())

/**
 * beam used by eldritch blast ability from occultism module
 */
/obj/projectile/eldritch_blast

#warn impl
