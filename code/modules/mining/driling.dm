//! contains all turf interfaces
/turf
	/// null = non-instantiated, check planet, list = instantiated, check list, FALSE = none (forced). list(ore id = amount)
	var/list/has_resources

/**
 * returns a list of ore id to amount for ores, or null if this turf does not at all support underground resources
 */
/turf/proc/get_underground_resources()
	switch(has_resources)
		if(null)
			return SSmapping.get_initial_underground_ores(src)
		if(FALSE)
			return list()
		else
			return has_resources

/**
 * ensure has_resources is instantiated as list
 * do this if you're about to modify it
 */
/turf/proc/load_underground_resources()
	switch(has_resources)
		if(null)
			has_resources = SSmapping.get_initial_underground_ores(src)
		if(FALSE)
			has_resources = list()

/turf/proc/set_underground_resources(list/ores)
	has_resources = ores.Copy()

/turf/proc/adjust_underground_resources(list/ores)
	load_underground_resources()
	for(var/i in ores)
		has_resources[i] += ores[i]

/turf/proc/reset_underground_resources()
	has_resources = null

/turf/proc/clear_underground_resources()
	has_resources = FALSE

/**
 * digs up and drops on the ground a ratio of ores. efficiency is how much drops rather than is destroyed.
 */
/turf/proc/drop_percent_underground_resources(ratio = 1, efficiency = 1)
	var/list/taking = take_percent_underground_resources(ratio, efficiency)
	for(var/ore in taking)
		var/amount = taking[ore]
		SSmaterials.instantiate_ore(ore, src, amount)

/**
 * digs up and drops on the ground a ratio of ores. efficiency is how much drops rather than is destroyed.
 */
/turf/proc/drop_exact_underground_resources(total = 10, efficiency = 1)
	var/list/taking = take_exact_underground_resources(total, efficiency)
	for(var/ore in taking)
		var/amount = taking[ore]
		SSmaterials.instantiate_ore(ore, src, amount)

/**
 * returns a list of underground resources to take
 * for now, returns everything equally instead of doing randomization/stratum checking.
 *
 * @params
 * - ratio - percentage to take. rounds up.
 * - efficiency - percentage actually taken rather than destroyed. rounds up.
 */
/turf/proc/take_percent_underground_resources(ratio = 1, efficiency = 1)
	load_underground_resources()
	. = list()
	for(var/ore in has_resources)
		var/amount = has_resources[ore] * ratio
		amount = CEILING(amount, 1)
		has_resources[ore] -= amount
		amount *= efficiency
		.[ore] = CEILING(amount, 1)

/**
 * returns a list of underground resources to take
 * for now, returns everything equally instead of doing randomization/stratum checking.
 *
 * @params
 * - amount - amount to take
 * - efficiency - percentage actually taken rather than destroyed. rounds up.
 */
/turf/proc/take_exact_underground_resources(total = 1, efficiency = 1)
	load_underground_resources()
	. = list()
	var/left = total
	for(var/ore in has_resources)
		if(!left)
			break
		var/amount = min(left, has_resources[ore])
		left -= amount
		has_resources[ore] -= amount
		amount *= efficiency
		.[ore] = CEILING(amount, 1)

/proc/query_underground_ores_estimate(turf/center, range = 3)
	. = list()
	// todo: estimator to speed this up
	for(var/turf/T in RANGE_TURFS_OR_EMPTY(3, center))
		var/list/ores = T.get_underground_resources()
		for(var/ore in ores)
			.[ore] += ores[ore]
