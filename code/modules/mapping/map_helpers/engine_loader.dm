// Landmark for where to load in the engine on permament map
/obj/map_helper/engine_loader
	name = "Engine Loader"
	early = TRUE
	var/list/clean_turfs // A list of lists, where each list is (x, )
	// override for map, otherwise defaults to loaded station as we have no way of detecting what's being loaded right now
	var/for_map

/obj/map_helper/engine_loader/New()
	return ..()

/obj/map_helper/engine_loader/Initialize(mapload)
	return ..()

/obj/map_helper/engine_loader/map_initializations(list/bounds)
	. = ..()
	if(istext(clean_turfs))
		clean_turfs = safe_json_decode(clean_turfs)
	if(ispath(for_map))
		var/datum/map/map_path = for_map
		for_map = initial(map_path.id)
	if(isnull(for_map))
		for_map = SSmapping.loaded_station.id

	var/turf/T = get_turf(src)
	ASSERT(T)

	var/datum/map_template/engine/chosen
	var/list/probabilities = CONFIG_GET(keyed_list/engine_submap)

	var/list/potential_subtypes = subtypesof(/datum/map_template/engine)
	var/list/potential_filtered = list()

	for(var/datum/map_template/engine/path as anything in potential_subtypes)
		if(initial(path.abstract_type) == path)
			continue
		var/their_for_map = initial(path.for_map)
		if(ispath(their_for_map))
			var/datum/map/map_path = their_for_map
			their_for_map = initial(map_path.id)
		if(their_for_map != src.for_map)
			continue
		potential_filtered[path] = initial(path.name)

	if(length(probabilities))
		for(var/path in potential_filtered)
			potential_filtered[path] = probabilities[potential_filtered[path]] || 1

	var/picked_path = pickweightAllowZero(potential_filtered)

	if(isnull(picked_path))
		STACK_TRACE("no chosen engine")
		qdel(src)

	chosen = new picked_path

	SSmapping.subsystem_log("initializing engine [chosen.name] at [COORD(T)]")
	if(!SSmapping.initialized)
		to_chat(world, SPAN_DANGER("Engine loaded: [chosen.display_name]"))

	annihilate_bounds()
	chosen.load(T)

	qdel(src)


/obj/map_helper/engine_loader/proc/get_turfs_to_clean()
	. = list()
	if(clean_turfs)
		for(var/list/coords in clean_turfs)
			. += block(locate(coords[1], coords[2], src.z), locate(coords[3], coords[4], src.z))

/obj/map_helper/engine_loader/proc/annihilate_bounds()
	var/deleted_atoms = 0
	admin_notice("<span class='danger'>Annihilating objects in engine loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_turfs_to_clean()
	if(turfs_to_clean.len)
		for(var/x in 1 to 2) // Requires two passes to get everything.
			for(var/turf/T in turfs_to_clean)
				for(var/atom/movable/AM in T)
					++deleted_atoms
					qdel(AM)
	admin_notice("<span class='danger'>Annihilated [deleted_atoms] objects.</span>", R_DEBUG)

