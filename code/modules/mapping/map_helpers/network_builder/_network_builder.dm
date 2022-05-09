// Builds networks like power cables/atmos lines/etc
// Just a holder parent type for now..
/atom/movable/map_helper/network_builder
	icon = 'icons/mapping/helpers/mapping_helpers.dmi'
	late = TRUE
	/// what directions we know connections are in. flag. uses X_BIT defines!
	var/network_directions

/atom/movable/map_helper/network_builder/Initialize(mapload)
	. = ..()
	var/conflict = check_duplicates()
	if(conflict)
		stack_trace("WARNING: [type] network building helper found check_duplicates() conflict [conflict] in its location.!")
		return INITIALIZE_HINT_QDEL
	network_directions = scan_directions()
	if(!mapload && GLOB.Debug2)
		// late sets qdel in ..()
		late = FALSE
	return INITIALIZE_HINT_LATELOAD

/// How this works: On LateInitialize, detect all directions that this should be applicable to, and do what it needs to do, and then inform all network builders in said directions that it's been around since it won't be around afterwards.
/atom/movable/map_helper/network_builder/LateInitialize()
	if(late || !GLOB.Debug2)
		build_network()
		qdel(src)
	else if(GLOB.Debug2)
		for(var/atom/movable/map_helper/network_builder/NB in range(src, 1))
			NB.scan_directions()

/atom/movable/map_helper/network_builder/proc/check_duplicates()
	CRASH("Base abstract network builder tried to check duplicates.")

/atom/movable/map_helper/network_builder/proc/scan_directions()
	CRASH("Base abstract network builder tried to scan directions.")

/atom/movable/map_helper/network_builder/proc/build_network()
	CRASH("Base abstract network builder tried to build network.")
