//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * bulk entity storage module
 *
 * handles things like debris
 */
/datum/controller/subsystem/persistence

/datum/controller/subsystem/persistence/proc/bulk_entity_save_chunks(list/datum/bulk_entity_chunk/chunks)
	if(!SSdbcore.Connect())
		return FALSE
	if(!length(chunks))
		return

	var/intentionally_allow_admin_proccall = usr
	usr = null

	for(var/datum/bulk_entity_chunk/chunk as anything in chunks)
		var/datum/db_query/query = SSdbcore.NewQuery(
			"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_bulk_entity")] \
				(generation, persistence_key, level_id, data, round_id) \
				VALUES (:generation, :persistence, :level, :data, :round)",
			list(
				"generation" = chunk.generation,
				"level" = chunk.level_id,
				"round" = GLOB.round_number,
				"data" = json_encode(chunk.data),
				"persistence" = chunk.persistence_key,
			),
		)
		query.warn_execute()
		QDEL_NULL(query)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/bulk_entity_load_chunks_on_level(persistence_key, level_id, generation, datum/map_level_persistence/level_data)
	if(!SSdbcore.Connect())
		return FALSE

	var/list/datum/bulk_entity_chunk/chunks = list()

	var/intentionally_allow_admin_proccall = usr
	usr = null

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT data FROM [DB_PREFIX_TABLE_NAME("persistence_bulk_entity")] \
			WHERE generation = :generation AND persistence_key = :persistence AND level_id = :level",
		list(
			"generation" = generation,
			"persistence" = persistence_key,
			"level" = level_id,
		),
	)
	query.warn_execute()

	while(query.NextRow())
		var/encoded_data = query.item[1]

		var/datum/bulk_entity_chunk/chunk = new
		chunk.generation = generation
		chunk.persistence_key = persistence_key
		chunk.data = json_decode(encoded_data)
		chunk.level_id = level_id
		chunk.round_id_saved = level_data.round_id_saved
		chunk.rounds_since_saved = level_data.rounds_since_saved
		chunk.hours_since_saved = level_data.hours_since_saved
		chunks += chunk

	QDEL_NULL(query)

	usr = intentionally_allow_admin_proccall

	return chunks

/datum/controller/subsystem/persistence/proc/bulk_entity_drop_chunks_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.dangerously_block_on_multiple_unsanitized_queries(
		list(
			"TRUNCATE TABLE [DB_PREFIX_TABLE_NAME("persistence_bulk_entity")]",
		),
	)

	usr = intentionally_allow_admin_proccall

/datum/controller/subsystem/persistence/proc/bulk_entity_drop_chunks_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_bulk_entity")] WHERE level_id = :level",
		list(
			"level" = level_id,
		),
	)

	usr = intentionally_allow_admin_proccall

/datum/bulk_entity_persistence
	abstract_type = /datum/bulk_entity_persistence
	/// id - must be unique
	var/id
	/// if sql data doesn't match revision, it's tossed out
	var/revision = 1
	/// split entities returned from gather procs to this amount per chunk
	var/auto_entity_chunk_split = 500

/datum/bulk_entity_persistence/proc/is_enabled()
	return TRUE

/datum/bulk_entity_persistence/proc/gather_all()
	return list()

/datum/bulk_entity_persistence/proc/gather_level(z)
	return list()

/**
 * perform global filtering on all entities
 *
 * input list can be modified
 *
 * this is for 'drop n entities through the whole world'; this is only called when the entire world is being
 * serialized, as opposed to a single level.
 *
 * @return filtered list
 */
/datum/bulk_entity_persistence/proc/perform_global_filter(list/atom/movable/entities)
	return entities

/**
 * perform level filtering
 */
/datum/bulk_entity_persistence/proc/perform_level_filter(list/atom/movable/entities, datum/map_level/level)

/**
 * serialize entities into chunks for a single level
 *
 * @return list(chunks)
 */
/datum/bulk_entity_persistence/proc/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level, datum/map_level_persistence/persistence)
	return list()

/**
 * @return list(count loaded, count dropped, count errored)
 */
/datum/bulk_entity_persistence/proc/load_chunks(list/datum/bulk_entity_chunk/chunks)
	return list(0, 0, 0)

/datum/bulk_entity_chunk
	//* Set by serialize_entities_into_chunks *//
	var/level_id
	var/list/data

	//* Set by serialization and deserialization, do not manually set. *//
	// todo: where should this be set? currently it's [code/controllers/subsystem/persistence/world.dm]
	/// our generation
	/// * set by load from DB
	/// * set on save by save proc before being sent into bulk_entity_save_chunks()
	var/generation
	/// bulk_entity_persistence key
	var/persistence_key

	//* Set by loader, do not manually set. *//
	/// round id we were saved on
	var/round_id_saved
	/// rounds since we were saved
	var/rounds_since_saved
	/// hours since we were saved
	var/hours_since_saved
