//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/ability/eldritch_ability/eldritch_blast
	name = "eldritch blast"
	desc = "Fire a powerful beam capable of warping reality."
	#warn category
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
#warn SIGNAL_ELDRITCH_HOLDER_FIRE_PROJECTILE

/datum/ability/eldritch_ability/eldritch_blast/proc/fire_standard(atom/movable/anchor, datum/event_args/actor/clickchain/clickchain)
	return fire(anchor, clickchain, 25)

/datum/ability/eldritch_ability/eldritch_blast/proc/fire_heavy(atom/movable/anchor, datum/event_args/actor/clickchain/clickchain)
	return fire(anchor, clickchain, 100)

/datum/ability/eldritch_ability/eldritch_blast/proc/fire(atom/movable/anchor, datum/event_args/actor/clickchain/clickchain, intensity)
	intensity = clamp(intensity, 0, 100)

/**
 * beam used by eldritch blast ability from occultism module
 */
/obj/projectile/eldritch_blast

#warn impl
