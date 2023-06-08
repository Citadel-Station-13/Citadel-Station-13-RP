/datum/map_template
	/// abstract type
	abstract_type = /datum/map_template

	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	/// If this is set, no more than one template in the same group will be spawned, per submap seeding.
	var/template_group = null
	/// If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.
	var/annihilate = FALSE

	/// The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until
	/// it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc.
	/// Set to -1 to force the submap to always be made.
	var/cost = null
	/// If false, only one map template will be spawned by the game. Doesn't affect admins spawning then manually.
	var/allow_duplicates = FALSE
	/// If non-zero, there is a chance that the map seeding algorithm will skip this template when selecting potential templates to use.
	var/discard_prob = 0
	// For ruins
	var/fixed_orientation = FALSE

	//* file
	/// path to the map
	var/map_path

	//* cached data
	/// cached map
	var/datum/dmm_parsed/parsed
	/// keep cached map
	var/cache_parsed_map = FALSE
	/// cached width
	var/width = 0
	/// cached height
	var/height = 0

	//* loading
	/// times loaded this round, excluding new zlevel loads
	var/loaded = 0

	//* loading as its own level
	/// traits to have if loaded as standalone level
	var/list/level_traits
	/// attributes to have if loaded as standalone level
	var/list/level_attributes
	/// id to have if loaded as standalone level
	var/level_id

/datum/map_template/New(path, name)
	if(!isnull(name))
		src.name = name
	if(!isnull(path))
		src.map_path = path
	preload()

/datum/map_template/proc/preload()
	if(isnull(map_path))
		return
	var/datum/dmm_parsed/parsing = parse_map(map_path)
	#warn impl

/datum/map_template/proc/load_new_z(var/centered = FALSE, var/orientation = SOUTH, list/traits = src.ztraits || list(ZTRAIT_AWAY = TRUE))
	var/x = 1
	var/y = 1

	if(centered)
		x = round((world.maxx - width)/2)
		y = round((world.maxy - height)/2)

	#warn conform
	var/list/bounds = maploader.load_map(file(map_path), x, y, no_changeturf = TRUE, orientation=orientation)
	if(!bounds)
		return FALSE
	SSmapping.add_new_zlevel(name, traits)

	repopulate_sorted_areas()

	// Initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")
	on_map_loaded(world.maxz)
	return TRUE

/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = SOUTH)
	var/old_T = T
	if(centered)
		T = locate(T.x - round(((orientation & NORTH|SOUTH) ? width : height)/2) , T.y - round(((orientation & NORTH|SOUTH) ? height : width)/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered, orientation)

	#warn conform
	var/list/bounds = maploader.load_map(file(map_path), T.x, T.y, T.z, cropMap=TRUE, orientation = orientation)
	if(!bounds)
		return

//	if(!SSmapping.loading_ruins)	// Will be done manually during mapping ss init
	if(SSmapping.initialized)
		repopulate_sorted_areas()

	// Initialize things that are normally initialized after map load
	initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE, orientation = SOUTH)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(((orientation & NORTH|SOUTH) ? width : height)/2), placement.y - round(((orientation & NORTH|SOUTH) ? height : width)/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+((orientation & NORTH|SOUTH) ? width : height)-1, placement.y+((orientation & NORTH|SOUTH) ? height : width)-1, placement.z))

/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE, orientation = SOUTH)
	var/deleted_atoms = 0
	log_debug(SPAN_DEBUG("Annihilating objects in submap loading locatation."))
	var/list/turfs_to_clean = get_affected_turfs(origin, centered, orientation)
	if(turfs_to_clean.len)
		for(var/turf/T in turfs_to_clean)
			for(var/atom/movable/AM in T)
				++deleted_atoms
				qdel(AM)
	log_debug(SPAN_DEBUG("Annihilated [deleted_atoms] objects."))

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return	// Let proper initialisation handle it later

	var/prev_shuttle_queue_state = SSshuttle.block_init_queue
	SSshuttle.block_init_queue = TRUE

	var/list/atom/atoms = list()
	var/list/area/areas = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/turf/turfs = block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   			locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	for(var/L in turfs)
		var/turf/B = L
		B.queue_zone_update()
		QUEUE_SMOOTH(B)
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
			else if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	atoms |= areas

	admin_notice("<span class='danger'>Initializing newly created atom(s) in submap.</span>", R_DEBUG)
	SSatoms.InitializeAtoms(atoms)

	admin_notice("<span class='danger'>Initializing atmos pipenets and machinery in submap.</span>", R_DEBUG)
	SSmachines.setup_atmos_machinery(atmos_machines)

	admin_notice("<span class='danger'>Rebuilding powernets due to submap creation.</span>", R_DEBUG)
	SSmachines.setup_powernets_for_cables(cables)

	// Ensure all machines in loaded areas get notified of power status
	for(var/I in areas)
		var/area/A = I
		A.power_change()

	SSshuttle.block_init_queue = prev_shuttle_queue_state
	SSshuttle.process_init_queues()	// We will flush the queue unless there were other blockers, in which case they will do it.

	admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)

// For your ever biggening badminnery kevinz000
// ❤ - Cyberboss
// <3 cyberboss you are epic
/proc/__load_raw_level(path, orientation = SOUTH, center = TRUE)
	#warn impl

/**
 * called when normally loaded
 *
 * @params
 * * bounds - map bounds of load. use defines like MAP_MINX/MAP_MINY/etc to access.
 * * late_generation - callbacks to fire after ruin seeding. if this is being spawned standalone, it fires immediately.
 */
/datum/map_template/proc/on_normal_load(list/bounds, list/datum/callback/late_generation)

/**
 * called when loaded as a new zlevel
 *
 * @params
 * * z_index - zlevel we loaded onto
 * * late_generation - callbacks to fire after z groups / other templates have loaded, but before the other templates fire their late generations. if this is being loaded standalone, it fires immediately.
 */
