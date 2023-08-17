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
	/// available power in network accumulated for the next tick
	var/accumulated = 0
	/// available power in network at start of powernet reset
	var/supply = 0
	/// available power left in the current reset cycle
	var/available = 0
	/// extra power spilled over in last tick - used by machinery wanting to restore some power supplied
	var/spillover = 0
	/// spillover percent - used by machinery wanting to restore some power applied but only need to track last input on their end
	var/spillover_ratio = 0

	/// current power load - regardless of if usage was actually successful. this lets us perform network readings/whatever.
	var/load = 0
	/// amount of power that was drawn from non-balancing sources.
	var/flat_load = 0
	/// amount of power that was drawn from balancing sources, regardless of if it succeeded.
	var/dynamic_load = EMPTY_POWER_BALANCING_LIST
	/// calculated utilization allowed for a given load balancing tier
	var/dynamic_factor = EMPTY_POWER_BALANCING_LIST

	/// last load - used for viewing
	var/last_load = 0
	/// last flat load - used for viewing
	var/last_flat_load = 0

	#warn finish

/datum/wirenet/power/New()
	..()
	GLOB.powernets += src

/datum/wirenet/power/Destroy()
	GLOB.powernets -= src
	return ..()

#warn handle power stuff on merge

/datum/wirenet/power/proc/supply(kw)
	accumulated += kw

/datum/wirenet/power/proc/flat_draw(kw)
	flat_load += kw
	load += kw
	. = min(available, kw)
	if(!.)
		return
	available -= .

/datum/wirenet/power/proc/dynamic_draw(kw, tier)

	#warn impl

/**
 * called every SSmachines cycle to do powernet processing
 */
/datum/wirenet/power/proc/reset()
	spillover = available
	spillover_ratio = available / supply
	supply = available = accumulated
	last_load = load
	last_flat_load = flat_load
	load = 0
	flat_load = 0
	accumulated = 0

	for(var/i in 1 to POWER_BALANCING_TIER_TOTAL)

	#warn impl


#warn impl all

/datum/powernet


	var/problem = 0				// If this is not 0 there is some sort of issue in the powernet. Monitors will display warnings.


//Returns the amount of excess power (before refunding to SMESs) from last tick.
//This is for machines that might adjust their power consumption using this data.
/datum/powernet/proc/last_surplus()
	return max(avail - load, 0)

// Triggers warning for certain amount of ticks
/datum/powernet/proc/trigger_warning(var/duration_ticks = 20)
	problem = max(duration_ticks, problem)

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

/datum/powernet/proc/drain_energy_handler(datum/actor, amount, flags)
	// amount is in kj so no conversion needed
	. = draw_power(amount)
	if(flags & ENERGY_DRAIN_SURGE)
		trigger_warning()
