// Builds networks like power cables/atmos lines/etc
// Just a holder parent type for now..
/atom/movable/map_helper/network_builder
	icon = 'icons/mapping/helpers/mapping_helpers.dmi'
	late = TRUE
	invisibility = INVISIBILITY_MAXIMUM
	/// what directions we know connections are in. flag. uses X_BIT defines!
	var/network_directions
	/// adminspawned
	var/adminspawned = FALSE
	/// our base type
	var/base_type

/atom/movable/map_helper/network_builder/Initialize(mapload)
	. = ..()
	if(!mapload)
		/// if it isn't adminspawned i am going to come find you
		/// don't anyone dare use this in non mapping contexts
		/// "teardown and rebuild" behavior is garbage, don't use it.
		adminspawned = TRUE
		rebuild()
		return INITIALIZE_HINT_NORMAL
	var/conflict = length(duplicates())
	if(conflict)
		stack_trace("WARNING: [type] network building helper found check_duplicates() conflicts [english_list(conflict)] in its location.!")
		return INITIALIZE_HINT_QDEL
	network_directions = scan()
	return INITIALIZE_HINT_LATELOAD

/// How this works: On LateInitialize, detect all directions that this should be applicable to, and do what it needs to do, and then inform all network builders in said directions that it's been around since it won't be around afterwards.
/atom/movable/map_helper/network_builder/LateInitialize()
	build()
	qdel(src)

/atom/movable/map_helper/network_builder/proc/duplicates()
	CRASH("Base abstract network builder tried to check duplicates.")

/atom/movable/map_helper/network_builder/proc/scan()
	CRASH("Base abstract network builder tried to scan directions.")

/atom/movable/map_helper/network_builder/proc/build()
	CRASH("Base abstract network builder tried to build network.")

/atom/movable/map_helper/network_builder/proc/teardown()
	for(var/atom/movable/AM as anything in duplicates())
		ASSERT(istype(AM))
		qdel(AM)

/atom/movable/map_helper/network_builder/proc/rebuild(propagate = TRUE)
	teardown()
	if(propagate)
		for(var/d in GLOB.cardinal)
			var/atom/movable/map_helper/network_builder/NB = locate(base_type) in get_step(src, d)
			if(NB)
				NB.rebuild(FALSE)
	network_directions = scan()
	build()
