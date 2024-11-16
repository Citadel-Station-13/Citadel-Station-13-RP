/**
 * Tracks and initializes world factions
 *
 * todo: can we rename this to something that doesn't coincide with 'world' aka byond worlds??
 */
SUBSYSTEM_DEF(game_world)
	name = "World"
	init_order = INIT_ORDER_GAME_WORLD
	subsystem_flags = SS_NO_FIRE

	/**
	 * all factions by id
	 *
	 * todo: RSworld_factions (repository)
	 */
	var/static/list/faction_lookup
	/**
	 * all locations by id
	 *
	 * todo: RSworld_locations (repository)
	 */
	var/static/list/location_lookup

	/**
	 * locations the main map is on
	 */
	var/static/list/active_location_lookup
	/**
	 * active faction list
	 */
	var/static/list/active_faction_lookup
	/// what faction is the main map?
	///
	/// while we engineer around a protagonist-agnostic world, this is still the major 'point of view'
	/// that the code algorithmically optimizes around.
	///
	/// this will be the faction storytellers uses to determine chaos / danger, for exmaple.
	var/datum/world_faction/main_faction

/datum/controller/subsystem/game_world/Initialize()
	initialize_locations()
	initialize_factions()
	initialize_map()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/game_world/proc/initialize_locations()
	location_lookup = list()
	for(var/datum/world_location/path as anything in subtypesof(/datum/world_location))
		if(path == initial(path.abstract_type))
			continue
		var/datum/world_location/instance = new path
		ASSERT(!location_lookup[instance.id])
		location_lookup[instance.id] = instance

/datum/controller/subsystem/game_world/proc/initialize_factions()
	faction_lookup = list()
	for(var/datum/world_faction/path as anything in subtypesof(/datum/world_faction))
		if(path == initial(path.abstract_type))
			continue
		var/datum/world_faction/instance = new path
		ASSERT(!faction_lookup[instance.id])
		faction_lookup[instance.id] = instance

/datum/controller/subsystem/game_world/proc/initialize_map()
	var/datum/map/station/the_protagonist = SSmapping.loaded_station
	main_faction = faction_lookup[the_protagonist.world_faction_id]

	active_location_lookup = list()
	for(var/id in the_protagonist.world_location_ids)
		var/datum/world_location/location = location_lookup[id]
		if(!location)
			stack_trace("couldn't find location")
			continue
		active_location_lookup[id] = location

	active_faction_lookup = list()
	for(var/id in faction_lookup)
		var/datum/world_faction/faction = faction_lookup[id]
		if(!length(faction.location_ids & active_location_lookup))
			continue
		active_faction_lookup[id] = faction
