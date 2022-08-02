/**
 * ! Location Mapped Persistence
 *
 * ? Requires SQL to be enabled.
 *
 * the cheapest form of persistence
 * uses singleton datums to handle all creation/destruction
 * things are stored by location and packed where possible
 *
 * low level helpers are available for those who know how to use them, but usually
 * it'll be stored by coordinates.
 */
/datum/controller/subsystem/persistence
	/// location mapped serializers/deserializers - these are ephemeral and WILL reset on crashes because they shouldn't really be runtime modified in the first place!
	var/list/datum/mass_persistence_handler/mass_persistence_handlers

/datum/controller/subsystem/persistence/InitPersistence()
	create_mass_persistence_handlers()
	return ..()

/datum/controller/subsystem/persistence/proc/create_mass_persistence_handlers()
	if(islist(mass_persistence_handlers))
		for(var/datum/mass_persistence_handler/handler in mass_persistence_handlers)
			qdel(handler)
	mass_persistence_handlers = list()
	for(var/path in subtypesof(/datum/mass_persistence_handler))
		var/datum/mass_persistence_handler/handler = path
		if(initial(handler.abstract_type) == path)
			continue
		handler = new path
		mass_persistence_handlers += handler

/datum/controller/subsystem/persistence/proc/load_location_mapped_objects()
	if(!SSdbcore.Connect())
		return

/datum/controller/subsystem/persistence/proc/save_location_mapped_objects()
	if(!SSdbcore.Connect())
		return

/**
 * singleton datum that handles save/loading of "mass persisted" objects
 * see [code/controllers/subssyetm/persistence/objects/location_mapped.dm] for more info
 */
/datum/mass_persistence_handler
	/// name
	var/name = "Unknown Handler"
	/// user friendly desc
	var/desc = "You shouldn't see this description."
	/// abstract type
	var/abstract_type = /datum/mass_persistence_handler

/**
 * grabs everything we need to serialize
 */
/datum/mass_persistence_handler/proc/collect_objects()
	RETURN_TYPE(/list)
	return list()

/**
 * loads a coordinate
 */
/datum/mass_persistence_handler/proc/load_coordinate(x, y, z, data)

/**
 *
 */
