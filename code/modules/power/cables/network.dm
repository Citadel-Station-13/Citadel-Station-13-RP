//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_EMPTY(powernets)

/**
 * power networks
 *
 * how this works:
 *
 * powernets are generic and make some assumptions:
 * - We **cannot** trust that machines have a particular processing order (e.g. suppliers before/after consumers)
 * - We **can** trust that we tick in sync with machinery. We **can** trust that off-tick machinery will compensate their usage/demands as needed.
 *
 * we make these assumptions because
 * - specific sorting / bracketing for machinery may not be available, and even if it is, it's usually too stiff to demand of implementations.
 * - we cannot actually compensate for machinery that tick "wrongly", without overcomplicating this by having power draw have an overengineered
 *       implementation that involves tracking the time period over which power is used and all sorts of nasty things that we really don't want
 *       to have to care about. all we can do is expect that people put in the correct values.
 *
 * all variables are in **kilowatts** unless otherwise stated.
 */
/datum/wirenet/power
	//* next tick
	/// available power in network accumulated for the next tick
	var/accumulated = 0

	//* current tick
	/// available power in network at start of powernet reset
	var/supply = 0
	/// available power left in the current reset cycle
	var/available = 0
	/// current power load - regardless of if usage was actually successful. this lets us perform network readings/whatever.
	var/load = 0
	/// amount of power that was drawn from non-balancing sources.
	var/flat_load = 0
	/// amount of power that was drawn from balancing sources, regardless of if it succeeded.
	var/dynamic_load = EMPTY_POWER_BALANCING_LIST
	/// calculated utilization allowed for a given load balancing tier
	var/dynamic_factor = EMPTY_POWER_BALANCING_LIST
	/// status flags
	var/powernet_status = NONE

	//* last tick
	/// last load - used for viewing
	var/last_load = 0
	/// last flat load - used for viewing
	var/last_flat_load = 0
	/// last supply - used for viewing
	var/last_supply = 0
	/// extra power spilled over in last tick - used by machinery wanting to restore some power supplied
	/// *this can be negative*
	var/last_excess = 0
	/// spillover percent - used by machinery wanting to restore some power applied but only need to track last input on their end
	/// e.g. 0.3 = 30% of power last tick was not consumed, and so a SMES outputting a balanced 1MW can take back 300KW of it.
	/// *this can be negative*
	var/last_excess_ratio = 0
	/// status flags
	var/last_powernet_status = NONE

/datum/wirenet/power/New()
	..()
	GLOB.powernets += src

/datum/wirenet/power/Destroy()
	GLOB.powernets -= src
	return ..()

/datum/wirenet/power/proc/observer_examine()
	. = list()
	. += SPAN_NOTICE("Powernet Status - Last Cycle:")
	. += "Total: [render_power(last_load, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_WATT)] / [render_power(last_supply, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_KILO)]"
	. += "Flat Load: [render_power(last_flat_load, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_WATT)]"

#warn handle power stuff on merge

/datum/wirenet/power/proc/supply(kw)
	accumulated += kw

/datum/wirenet/power/proc/flat_draw(kw)
	flat_load += kw
	load += kw
	. = min(available, kw)
	available -= .

/datum/wirenet/power/proc/dynamic_draw(kw, tier)
	load += kw
	dynamic_load[tier] += kw
	. = min(available, dynamic_factor[tier] * kw)
	available -= .

/**
 * called every SSmachines cycle to do powernet processing
 */
/datum/wirenet/power/proc/reset()
	last_load = load
	last_flat_load = flat_load
	last_supply = supply

	last_excess = supply - load
	last_excess_ratio = last_excess / supply

	last_powernet_status = powernet_status

	var/last_nonflat_available = last_supply - last_flat_load
	if(last_nonflat_available <= 0)
		for(var/i in 1 to POWER_BALANCING_TIER_TOTAL)
			dynamic_load[i] = 0
			dynamic_factor[i] = 0
	else
		// this algorithm allocates from high to low
		// on the first tier with only partial supply, it sets factor so machines only try to draw
		// their 'fair share' on their dynamic_draw
		// this depends on machines obeying the system and not calling dynamic_draw more than once per SSmachines process.
		for(var/i in 1 to POWER_BALANCING_TIER_TOTAL)
			dynamic_factor[i] = clamp(last_nonflat_available / dynamic_load[i], 0, 1)
			last_nonflat_available -= dynamic_load[i]
			dynamic_load[i] = 0

	supply = accumulated
	available = supply
	load = 0
	flat_load = 0
	accumulated = 0

/datum/wirenet/power/proc/drain_energy_handler(datum/actor, amount, flags)
	// no conversion needed, amount should be in kj
	. = flat_draw(amount)
	if(flags & ENERGY_DRAIN_SURGE)
		powernet_status |= POWERNET_STATUS_SURGE_DRAIN

#warn impl all

/datum/powernet/proc/get_electrocute_damage()
	switch(avail)
		if (1000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200 to 1000)
			return min(rand(25,80),rand(25,80))
		if (100 to 200)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50 to 100)
			return min(rand(15,40),rand(15,40))
		if (1 to 50)
			return min(rand(10,20),rand(10,20))
		else
			return 0

/**
 * shock a target, checking conductivity in the process
 */
/datum/wirenet/power/proc/external_electrocute(atom/movable/victim, atom/source, target_zone, relative_exposure = 1, suppress_fx)
	#warn impl - check siemens coefficient

/**
 * shock a target, ignoring conductivity like gloves
 */
/datum/wirenet/power/proc/direct_electrocute(atom/movable/victim, atom/source, target_zone, relative_exposure = 1, suppress_fx)
	#warn impl

	powernet_status |= POWERNET_STATUS_SURGE_FAULT

/**
 * shock damage for mobs
 */
/datum/wirenet/power/proc/electrocute_mob_damage(mob/victim)
	#warn impl

/**
 * shock damage for objs
 */
/datum/wirenet/power/proc/electrocute_obj_damage(obj/victim)

/*

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
			return 1
	return 0

*/
