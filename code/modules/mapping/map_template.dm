/datum/map_template
	var/id = "default"
	var/abstract_type = /datum/map_template
	var/autoinit = FALSE			//init at load
	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	var/width = 0
	var/height = 0
	var/mappath
	var/loaded = 0 // Times loaded this round
	var/datum/parsed_map/cached_map
	var/keep_cached_map = FALSE
	var/default_annihilate = FALSE

/datum/map_template/New(path = null, rename = null, cache = FALSE)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath, cache)
	if(rename)
		name = rename

/datum/map_template/Destroy()
	QDEL_NULL(cached_map)
	return ..()

/datum/map_template/proc/preload_size(path, cache = FALSE)
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.bounds
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
		if(cache)
			cached_map = parsed
	return bounds

/datum/parsed_map/proc/initTemplateBounds()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()
	var/list/area/areas = list()

	var/list/turfs = block(	locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	var/list/border = block(locate(max(bounds[MAP_MINX]-1, 1),			max(bounds[MAP_MINY]-1, 1),			 bounds[MAP_MINZ]),
							locate(min(bounds[MAP_MAXX]+1, world.maxx),	min(bounds[MAP_MAXY]+1, world.maxy), bounds[MAP_MAXZ])) - turfs
	for(var/L in turfs)
		var/turf/B = L
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
				continue
			if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	for(var/L in border)
		var/turf/T = L
		T.air_update_turf(TRUE) //calculate adjacent turfs along the border to prevent runtimes

	SSmapping.reg_in_areas_in_z(areas)
	SSatoms.InitializeAtoms(atoms)
	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)			//SSair when?!

/datum/map_template/proc/load_new_z(orientation = 0)
	var/x = round((world.maxx - width)/2)
	var/y = round((world.maxy - height)/2)

	var/datum/space_level/level = SSmapping.add_new_zlevel(name, list(ZTRAIT_AWAY = TRUE))
	var/datum/parsed_map/parsed = load_map(file(mappath), x, y, level.z_value, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop = TRUE, orientation = orientation)
	var/list/bounds = parsed.bounds
	if(!bounds)
		return FALSE

	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	parsed.initTemplateBounds()
	smooth_zlevel(world.maxz)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")

	return level

//Override for custom behavior
/datum/map_template/proc/on_map_loaded(z, list/bounds)
	loaded++

/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = 0, annihilate = annihilate)
	var/old_T = T
	if(centered)
		T = locate(T.x - round(((orientation%180) ? height : width)/2) , T.y - round(((orientation%180) ? width : height)/2) , T.z) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered, orientation)

	// Accept cached maps, but don't save them automatically - we don't want
	// ruins clogging up memory for the whole round.
	var/datum/parsed_map/parsed = cached_map || new(file(mappath))
	cached_map = keep_cached_map ? parsed : null
	if(!parsed.load(T.x, T.y, T.z, cropMap=TRUE, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop=TRUE))
		return
	var/list/bounds = parsed.bounds
	if(!bounds)
		return

	if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
		repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	parsed.initTemplateBounds()

	on_map_loaded(T.z, parsed.bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	return bounds

//This, get_affected_turfs, and load() calculations for bounds/center can probably be optimized. Later.
/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE, orientation = 0)
	var/deleted_atoms = 0
	log_world("Annihilating objects in submap loading locatation.")
	var/list/turfs_to_clean = get_affected_turfs(origin, centered, orientation)
	if(turfs_to_clean.len)
		var/list/kill_these = list()
		for(var/i in turfs_to_clean)
			var/turf/T = i
			kill_these += T.contents
		for(var/i in kill_these)
			qdel(i)
			CHECK_TICK
			deleted_atoms++
	log_world("Annihilated [deleted_atoms] objects.")

//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(var/file, var/name, orientation)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE, orientation = 0)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(((orientation%180) ? height : width)/2), placement.y - round(((orientation%180) ? width : height)/2), placement.z) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+((orientation%180) ? height : width)-1, placement.y+((orientation%180) ? width : height)-1, placement.z))
