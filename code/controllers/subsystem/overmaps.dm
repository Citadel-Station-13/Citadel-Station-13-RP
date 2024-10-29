SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS

	/// overmap by id
	//  todo: recover
	var/static/list/datum/overmap/overmap_by_id = list()

	/// im so sorry bros dont hurt me please--
	/// (eventually we'll have proper bindings but for now, uh, this is how it is!)
	var/const/default_overmap_id = "main"

	//*                    Global Tuning                       *//
	//* Balance tuning goes in here; not sim                   *//
	//* Example: 'thrust mult' is balance, 'sim speed' is sim. *//
	/// applied to all ship thrust
	var/global_thrust_multiplier = 2

	//* Level System *//

	/// Z-level ownership lookup
	///
	/// * This is an indexed list, with the entry being the owning /datum/overmap_location of a level, if any.
	/// * This is the owning locations of levels.
	/// * Non-owning locations aren't in here.
	/// * A level can only be owned by one location at a time.
	/// * Automatically managed by /datum/overmap_location registration
	/// * Attempting to lock a level already locked by another level is an immediate runtime error.
	///
	/// todo: should locations be registered in global list when 'active'?
	///       this would let us abstract handling away from entity entirely.
	///
	/// These axioms must be true at all times:
	/// * A level is locked (registered here) if it's enclosed by an overmaps entity.
	/// * A level is not locked if it's enclosed by no overmaps entity.
	/// * A level is locked / unlocked as a location is assigned / un-assigned from an entity.
	var/static/list/datum/overmap_location/location_enclosed_levels = list()
	/// Active overmap locations; ergo the ones with locks on [location_enclosed_levels].
	var/static/list/datum/overmap_location/active_overmap_locations = list()

/datum/controller/subsystem/overmaps/Initialize()
	make_default_overmap()
	rebuild_helm_computers()
	return ..()

/datum/controller/subsystem/overmaps/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	if(length(location_enclosed_levels) < new_z_count)
		location_enclosed_levels.len = new_z_count

//! legacy code below

/datum/controller/subsystem/overmaps/proc/rebuild_helm_computers()
	for(var/obj/machinery/computer/ship/helm/H in GLOB.machines)
		H.get_known_sectors()

/datum/controller/subsystem/overmaps/proc/queue_helm_computer_rebuild()
	if(!initialized)
		return
	addtimer(CALLBACK(src, PROC_REF(rebuild_helm_computers)), 0, TIMER_UNIQUE)

/*
/client/proc/overmap_upload()
	set name = "Instantiate Overmap"
	set category = "Debug"

	var/are_you_sure = alert(
		src,
		"Instantiating overmaps is an advanced feature. \
		The uploaded file is placed and instantiated as an overmap; only overmap tiles, overmap entities, and overmap tile entities \
		should exist in the file, or you may have funny things happen and the server explode. \
		Are you sure you know what you are doing?",
		"Upload Overmap",
		"No",
		"Yes",
	)
	if(are_you_sure != "Yes")
		return

	var/map = input(src, "Select overmap .dmm", "Instantiate Overmap") as file|null
	if(!map)
		return

	var/datum/dmm_parsed/parsed_map = parse_map(map)

	if(!parsed_map.parsed)
		alert(src, "Failed to parse map.", "Parse Error")
		return

	var/max_x = world.maxx - TURF_CHUNK_RESOLUTION * 2
	var/max_y = world.maxy - TURF_CHUNK_RESOLUTION * 2

	if(parsed_map.width >= max_x || parsed_map.height >= max_y)
		alert(src, "Your map is too big for the current world size. Maximum: [max_x]x[max_y]", "Improper Dimensions")
		return

	// welcome to hell
	// allocate turf reservation and load at offset
	// from this point on, if we crash, we don't warn the user, because it shouldn't be possible to crash
	var/datum/overmap_template/template = new
	template.width = parsed_map.width
	template.height = parsed_map.height
	var/datum/overmap/creating = new("loaded-[rand(1, 1000000)]", template)
	creating.initialize()
	// loaded, load the map template in there
	var/datum/dmm_context/loaded_context = parsed_map.load(
		creating.reservation.bottom_left_coords[1],
		creating.reservation.bottom_left_coords[2],
		creating.reservation.bottom_left_coords[3],
	)
	// initialize
	SSatoms.init_map_bounds(loaded_context)
	var/llx = loaded_context.loaded_bounds[MAP_MINX]
	var/lly = loaded_context.loaded_bounds[MAP_MINY]
	var/llz = loaded_context.loaded_bounds[MAP_MINZ]
	// announce
	log_and_message_admins("overmap [creating.id] with dimensions [creating.width]x[creating.height] loaded at LL-bounds [llx], [lly], [llz]")
*/

//! end

//* Overmap Entity *//

/**
 * Gets entity owning a level.
 *
 * * Something on a space turf outside of a shuttle in a freeflight level has its level
 *   owned by the 'host' shuttle of that level.
 * * A landed shuttle has its level owned by, obviously, the entity owning that level.
 *
 * @params
 * * target - an /atom, or a z-index. atoms will be resolved to z-level.
 */
/datum/controller/subsystem/overmaps/proc/get_enclosing_overmap_entity(target) as /obj/overmap/entity
	if(isatom(target))
		target = get_turf(target)?:z
	if(!target)
		return
	return location_enclosed_levels[target].entity

/**
 * Gets entity the atom is physically on.
 *
 * * Something on a space turf outside of a shuttle in a shuttle interdiction / freeflight level
 *   is on no entity, because it's.. physically not on an entity!
 * * A landed shuttle has its contents owned by itself.
 *
 * @params
 * * target - an /atom
 */
/datum/controller/subsystem/overmaps/proc/get_overmap_entity(atom/target) as /obj/overmap/entity
	if(!get_turf(target))
		return
	var/area/their_area = get_area(target)
	if(!their_area)
		CRASH("couldn't get area?")
	if(istype(their_area, /area/shuttle))
		var/area/shuttle/their_shuttle_area = their_area
		if(istype(their_shuttle_area.shuttle, /datum/shuttle/autodock/overmap))
			var/datum/shuttle/autodock/overmap/i_hate_legacy_systems = their_shuttle_area.shuttle
			return i_hate_legacy_systems.myship
	var/their_z = get_z(target)
	var/datum/overmap_location/level_location = location_enclosed_levels[their_z]
	return level_location.is_physically_level(their_z) ? level_location.entity : null

// todo: entity round-persistent-compatible GUID

//* Overmap Management *//

/**
 * i don't know what to put here
 * this isn't a good long-term proc but for now it's fine
 */
/datum/controller/subsystem/overmaps/proc/get_or_load_default_overmap()
	if(overmap_by_id[default_overmap_id])
		return overmap_by_id[default_overmap_id]
	make_default_overmap()
	return overmap_by_id[default_overmap_id]


/datum/controller/subsystem/overmaps/proc/make_default_overmap()
	if(overmap_by_id[default_overmap_id])
		return
	var/datum/map/station/map_datum = SSmapping.loaded_station
	if(!map_datum.use_overmap)
		return
	var/datum/overmap_template/legacy_default/using_default_template = new(map_datum.overmap_size, map_datum.overmap_size, event_clouds = map_datum.overmap_event_areas)
	create_overmap_from_template(using_default_template, default_overmap_id)

/datum/controller/subsystem/overmaps/proc/create_overmap_from_template(datum/overmap_template/templatelike, use_id)
	if(ispath(templatelike))
		templatelike = new templatelike
	// make sure template is valid
	ASSERT(istype(templatelike))
	// get template into another var
	var/datum/overmap_template/template = templatelike
	// get id or generate
	var/id = use_id || generate_overmap_id()
	ASSERT(!overmap_by_id[id])
	// make overmap
	var/datum/overmap/creating = new(id, template)
	// instantiation
	creating.initialize()
	// done
	return creating

/datum/controller/subsystem/overmaps/proc/generate_overmap_id()
	var/potential
	var/safety = 1000
	do
		if(safety-- <= 0)
			CRASH("failed to generate overmap id - too many loops")
		potential = "[SSmapping.round_global_descriptor && "[SSmapping.round_global_descriptor]-"][copytext(md5("[rand(1, 1000000)]"), 1, 5)]"
	while(overmap_by_id[potential])
	return potential
