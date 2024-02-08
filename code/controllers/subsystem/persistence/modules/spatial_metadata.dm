//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * map metadata module
 *
 * allows grabbing and caching persistence metadata for maps
 */
/datum/controller/subsystem/persistence

/datum/controller/subsystem/persistence/proc/spatial_metadata_get_level(datum/map_level/level)
	RETURN_TYPE(/datum/map_level_persistence)
	if(isnum(level))
		level = SSmapping.ordered_levels[level]
	if(!level.persistence_allowed)
		return null
	if(isnull(level.persistence))
		level.persistence = new
		level.persistence.level_id = level.persistence_id || level.id
		level.persistence.load_or_new()
	return level.persistence

/datum/controller/subsystem/persistence/proc/spatial_metadata_get_current_generation(datum/map_level/level)
	var/datum/map_level_persistence/persistence = spatial_metadata_get_level(level)
	return persistence?.generation

/datum/controller/subsystem/persistence/proc/spatial_metadata_get_next_generation(datum/map_level/level)
	var/datum/map_level_persistence/persistence = spatial_metadata_get_level(level)
	if(isnull(persistence))
		return
	return persistence.generation + 1

/datum/map_level_persistence
	/// level id
	var/level_id
	/// hours since we were serialized
	var/hours_since_saved = 0
	/// rounds since we were serialized
	var/rounds_since_saved = 0
	/// curent entity generation
	var/generation = 0
	/// the round ID we were saved on
	var/round_id_saved

/datum/map_level_persistence/proc/load_or_new()
	var/allow_admin_proc_call = usr
	usr = null

	#warn impl

	usr = allow_admin_proc_call

/datum/map_level_persistence/proc/mark_serialized()
	var/allow_admin_proc_call = usr
	usr = null

	#warn impl

	usr = allow_admin_proc_call
