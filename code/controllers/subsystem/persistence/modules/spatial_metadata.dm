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
	if(isnull(level.persistence))
		level.persistence = new
		level.persistence.persistence_allowed = level.persistence_allowed
		var/effective_level_id = level.persistence_id || level.id
		var/effective_map_id = level.parent_map?.persistence_id || level.parent_map?.id
		// level id required but not map id; if map id null, map persisting objects will simply use the level id
		if(level.persistence_allowed && effective_level_id)
			level.persistence.load_or_new(effective_level_id, effective_map_id || PERSISTENCE_MAP_ID_STANDALONE)
		else
			level.persistence_allowed = FALSE
	return level.persistence

/datum/controller/subsystem/persistence/proc/spatial_metadata_get_current_generation(datum/map_level/level)
	var/datum/map_level_persistence/persistence = spatial_metadata_get_level(level)
	return persistence?.generation

/datum/controller/subsystem/persistence/proc/spatial_metadata_get_next_generation(datum/map_level/level)
	var/datum/map_level_persistence/persistence = spatial_metadata_get_level(level)
	if(isnull(persistence))
		return
	return persistence.generation + 1

/datum/controller/subsystem/persistence/proc/spatial_metadata_get_ordered_levels()
	. = new /list(world.maxz)
	for(var/z_index in 1 to world.maxz)
		.[z_index] = spatial_metadata_get_level(z_index)

/datum/map_level_persistence
	/// level id
	var/level_id
	/// map id
	var/map_id
	/// persistence allowed?
	var/persistence_allowed
	/// hours since we were serialized
	var/hours_since_saved = 0
	/// rounds since we were serialized
	var/rounds_since_saved = 0
	/// curent entity generation
	var/generation = 0
	/// the round ID we were saved on
	var/round_id_saved
	/// arbitrary key-value data
	var/list/arbitrary_data

/datum/map_level_persistence/proc/load_or_new(level_id, map_id)
	var/allow_admin_proc_call = usr
	usr = null

	src.level_id = level_id
	src.map_id = map_id

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT TIMESTAMPDIFF(HOUR, saved, NOW()), saved_round_id, data, generation \
			FROM [DB_PREFIX_TABLE_NAME("persistence_level_metadata")] \
			WHERE level_id = :level",
		list(
			"level" = level_id,
		),
	)
	query.warn_execute(FALSE)

	if(query.NextRow())
		src.hours_since_saved = query.item[1]
		src.round_id_saved = query.item[2]
		src.arbitrary_data = json_decode(query.item[3])
		src.generation = query.item[4]

		src.rounds_since_saved = GLOB.round_number - src.round_id_saved
	else
		src.level_id = level_id
		src.hours_since_saved = 0
		src.rounds_since_saved = 0
		src.generation = 0
		src.round_id_saved = GLOB.round_number
		src.arbitrary_data = list()

	QDEL_NULL(query)

	usr = allow_admin_proc_call

/datum/map_level_persistence/proc/mark_serialized_to_generation(generation)
	var/allow_admin_proc_call = usr
	usr = null

	src.generation = generation
	src.hours_since_saved = 0
	src.rounds_since_saved = 0
	src.round_id_saved = GLOB.round_number

	SSdbcore.RunQuery(
		"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_level_metadata")] (saved, saved_round_id, level_id, data, generation) \
			VALUES (Now(), :round, :level, :data, :generation) ON DUPLICATE KEY UPDATE \
			data = VALUES(data), generation = VALUES(generation), saved_round_id = VALUES(saved_round_id), saved = VALUES(saved)",
		list(
			"generation" = generation,
			"round" = GLOB.round_number,
			"level" = level_id,
			"data" = json_encode(arbitrary_data),
		),
	)

	usr = allow_admin_proc_call
