/**
 * supplypacks
 * these are the "bundle buys" of cargo
 * they usually ship in a crate and is used by the main
 * cargo system, as opposed to trading, but is perfectly usable
 * by anything using the spawn procs.
 */
/datum/supply_pack
	/// name
	var/name
	/// cost
	var/cost



#warn impl

/datum/supply_pack/proc/instantiate_contents(atom/inside)
	RETURN_TYPE(/list)

/datum/supply_pack/proc/instantiate_container(atom/where)
	RETURN_TYPE(/atom/movable)

/datum/supply_pack/proc/instantiate(atom/where)
	RETURN_TYPE(/atom/movable)
	. = instantiate_container(where)
	if(isnull(.))
		return
	instantiate_contents(.)

/datum/supply_pack/proc/instance_object(path, atom/loc, ...)
	RETURN_TYPE(/atom/movable)
	return new path(arglist(args.Copy(2)))

/**
 * used to preprocess the contained list for spawning
 */
/datum/supply_pack/proc/preprocess_contents_list()
	return contains.Copy()

/**
 * randomized supplypacks
 * only x items can be ever spawned
 * weighting is equal - the list of typepaths normally spawned is treated as pick-and-take-one-of.
 *
 * maybe we should roll this into default functionality
 * question for another day, not like we aren't modular enough with this system now to do it easily.
 */
/datum/supply_pack/randomised
	/// how many of our items at random to spawn
	var/num_contained = 1

/datum/supply_pack/randomised/preprocess_contents_list()
	var/list/L = list()
	// first, flatten list
	for(var/path in contains)
		L[path] = contains[path] || 1
	// pick and take
	. = list()
	for(var/i in 1 to num_contained)
		var/path = pickweight(L)
		.[path]++
