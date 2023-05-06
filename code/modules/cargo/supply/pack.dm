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
	/// arbitrary category to group under
	var/category = "Unsorted"
	/// flags
	var/supply_pack_flags = NONE

	/// contains - typepath = amount
	var/list/contains
	/// contains x of contains rather than all, and contains is treated as a weight list
	var/contains_is_random = FALSE

	/// type of the container
	var/container_type = /obj/structure/closet/crate/plastic
	/// override name of container
	var/container_name
	/// override desc of container
	var/container_desc
	/// set access of container
	var/list/container_access
	/// set req one access of container
	var/list/container_one_access

/datum/supply_pack/New()
	if(isnull(cost))
		auto_set_price()

/datum/supply_pack/proc/instantiate_contents(atom/inside)
	RETURN_TYPE(/list)
	var/list/to_spawn = preprocess_contents_list()
	if(!LAZYLEN(to_spawn))
		return
	var/safety = 500
	for(var/path in to_spawn)
		var/amount = to_spawn[path] || 1
		for(var/i in 1 to amount)
			if(!--safety)
				// adminproofing
				// no, no admin would fuck this up but myself
				// hence, self-proofing
				// ~silicons
				CRASH("Ran out of safety during SpawnContents")
			instance_object(path, loc)

/datum/supply_pack/proc/instantiate_container(atom/where)
	RETURN_TYPE(/atom/movable)
	var/atom/movable/created = new container_type(where)
	. = created // runtime guard
	if(!isnull(container_name))
		created.name = container_name
	if(!isnull(ontainer_desc))
		created.desc = container_desc
	if(isobj(created))
		if(!isnull(container_access))
			created.req_access = container_access.Copy()
		if(!isnull(container_one_access))
			created.req_one_access = container_one_access.Copy()

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

/datum/supply_pack/proc/ui_data_list()
	var/list/assembled_contents = list()
	for(var/atom/movable/path as anything in contains)
		if(!ispath(path))
			continue
		assembled_contents[initial(path.name)] = contains[path]
	return list(
		"name" = name,
		"cost" = cost,
		"category" = category,
		"flags" = supply_pack_flags,
		"ref" = ref(src),
		"isRandom" = contains_is_random,
		"contains" = assembled_contents,
	)

/datum/supply_pack/proc/auto_set_price()
	var/list/paths = preprocess_contents_list()
	. = initial(cost)
	for(var/atom/path as anything in paths)
		if(!ispath(path, /atom))
			CRASH("invalid path: [path]")
		if(initial(path.worth_dynamic))
			continue
		. += get_worth_static(path, GET_WORTH_INTRINSIC | GET_WORTH_CONTAINING, TRUE)
	cost = .

/**
 * randomized supplypacks
 * only x items can be ever spawned
 * weighting is equal - the list of typepaths normally spawned is treated as a weight list
 *
 * maybe we should roll this into default functionality
 * question for another day, not like we aren't modular enough with this system now to do it easily.
 */
/datum/supply_pack/randomised
	contains_is_random = TRUE
	/// how many of our items at random to spawn
	var/num_contained = 1

/datum/supply_pack/randomised/auto_set_price()
	CRASH("attempted to auto set price of a random package")

/datum/supply_pack/randomised/preprocess_contents_list()
	var/list/L = list()
	// first, flatten list
	for(var/path in contains)
		L[path] = contains[path] || 1
	// pick
	. = list()
	for(var/i in 1 to num_contained)
		var/path = pickweight(L)
		.[path]++
