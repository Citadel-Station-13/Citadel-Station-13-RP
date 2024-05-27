//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * denotes somewhere to place starting gear, barotrauma style
 *
 * this is not a landmark because gear is spawned during map initialization, not during atom/Initialize().
 */
/obj/map_helper/gear_marker
	/// a list of tags to register as, from most specific to least specific
	/// e.g.
	/// list(
	///   "ranged-energy-weapon",
	///   "ranged-weapon",
	///   "weapon",
	/// )

	/// forbid 'spread mode'; use this for stuff like job lockers.
	var/no_spread_injection = FALSE

/obj/map_helper/gear_marker/preloading_instance(datum/maploader_context/context)

#warn impl all

/**
 * @params
 * * typepaths - list of (path = amount).
 */
/obj/map_helper/gear_marker/proc/inject(list/typepaths)
	ASSERT(isturf(loc))

	// todo: support for stuff like vendors?

	// anything below this: we are physically spawning objects

	// dump in closet
	var/obj/structure/closet/closet = locate() in loc
	if(!isnull(closet))
		inject_to_loc(closet, typepaths)
		return TRUE

	// dump on floor
	inject_to_loc(loc, typepaths)
	return TRUE

/obj/map_helper/gear_marker/proc/inject_to_loc(atom/where, list/typepaths)
	var/safety = 50 // i don't konw why you'd need to spawn more than 50 items in a single spot
	for(var/path in typepaths)
		var/amount = typepaths[path]
		for(var/i in 1 to amount)
			if(safety <= 0)
				CRASH("ran out of safety")
			if(ispath(path, /obj/item/stack))
				safety -= spawn_stacks_at(where, path, amount)
			else if(ispath(path, /datum/material))
				safety -= spawn_stacks_at(where, path, amount)
			else
				safety -= 1
				new path(where)
