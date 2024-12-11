//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/controller/subsystem/persistence/proc/acquire_world_mutex(timeout = 10 SECONDS)
	var/expire_at = world.time + timeout
	UNTIL(!world_serialization_mutex || world.time > expire_at)
	if(world_serialization_mutex)
		. = FALSE
		CRASH("failed to obtain world mutex")
	return TRUE

/datum/controller/subsystem/persistence/proc/load_the_world()
	if(!acquire_world_mutex())
		return

	if(world_loaded)
		CRASH("cannot load world twice or bad shit happens")
	world_loaded = TRUE

	var/start_time
	var/end_time

	var/complete_start_time
	var/complete_end_time

	subsystem_log("world-load: starting")

	complete_start_time = REALTIMEOFDAY

	start_time = REALTIMEOFDAY
	var/list/datum/map_level_persistence/ordered_level_metadata = spatial_metadata_get_ordered_levels()
	end_time = REALTIMEOFDAY
	subsystem_log("world-load: level metadata acquire took [round((end_time - start_time) * 0.1, 0.01)]s")

	// handle bulk entities
	for(var/datum/bulk_entity_persistence/bulk_serializer as anything in subtypesof(/datum/bulk_entity_persistence))
		if(initial(bulk_serializer.abstract_type) == bulk_serializer)
			continue

		bulk_serializer = new bulk_serializer
		if(!bulk_serializer.is_enabled())
			continue

		subsystem_log("world-load: [bulk_serializer.id] start")

		for(var/z_index in 1 to world.maxz)
			var/datum/map_level_persistence/level_metadata = ordered_level_metadata[z_index]

			if(!level_metadata.persistence_allowed)
				subsystem_log("world-load: z-[z_index] for [bulk_serializer.id] skipped (persistence not allowed)")
				continue

			subsystem_log("world-load: z-[z_index] for [bulk_serializer.id] start")

			start_time = REALTIMEOFDAY
			var/list/datum/bulk_entity_chunk/level_chunks = bulk_entity_load_chunks_on_level(bulk_serializer.id, level_metadata.level_id, level_metadata.generation, level_metadata)
			end_time = REALTIMEOFDAY
			subsystem_log("world-load: z-[z_index] for [bulk_serializer.id] read took [round((end_time - start_time) * 0.1, 0.01)]s")

			start_time = REALTIMEOFDAY
			bulk_serializer.load_chunks(level_chunks)
			end_time = REALTIMEOFDAY
			subsystem_log("world-load: z-[z_index] for [bulk_serializer.id] load took [round((end_time - start_time) * 0.1, 0.01)]s")

	// handle objects
	start_time = REALTIMEOFDAY
	var/list/obj/static_entities = level_objects_gather_world_static()
	end_time = REALTIMEOFDAY
	subsystem_log("world-load: static gather took [round((end_time - start_time) * 0.1, 0.01)]s")

	start_time = REALTIMEOFDAY
	var/list/obj/static_entities_by_zlevel = entity_group_by_zlevel(static_entities)
	end_time = REALTIMEOFDAY
	subsystem_log("world-load: static group by level took [round((end_time - start_time) * 0.1, 0.01)]s")

	for(var/z_index in 1 to world.maxz)
		var/datum/map_level_persistence/level_metadata = ordered_level_metadata[z_index]

		if(!level_metadata.persistence_allowed)
			subsystem_log("world-load: z-[z_index] skipped (persistence not allowed)")
			continue

		subsystem_log("world-load: z-[z_index] ([level_metadata.level_id]) start")

		start_time = REALTIMEOFDAY
		level_objects_load_static(level_metadata, static_entities_by_zlevel[z_index])
		end_time = REALTIMEOFDAY
		subsystem_log("world-load: z-[z_index] ([level_metadata.level_id]) static took [round((end_time - start_time) * 0.1, 0.01)]s")

		start_time = REALTIMEOFDAY
		level_objects_load_dynamic(level_metadata, z_index)
		end_time = REALTIMEOFDAY
		subsystem_log("world-load: z-[z_index] ([level_metadata.level_id]) dynamic took [round((end_time - start_time) * 0.1, 0.01)]s")

	complete_end_time = REALTIMEOFDAY
	subsystem_log("world-load: world loaded in [round((complete_end_time - complete_start_time) * 0.1, 0.01)]s")

/datum/controller/subsystem/persistence/proc/save_the_world()
	if(!acquire_world_mutex())
		return

	++world_saved_count

	var/start_time
	var/end_time

	var/complete_start_time
	var/complete_end_time

	subsystem_log("world-save: starting")

	complete_start_time = REALTIMEOFDAY

	start_time = REALTIMEOFDAY
	var/list/datum/map_level_persistence/ordered_level_metadata = spatial_metadata_get_ordered_levels()
	end_time = REALTIMEOFDAY
	subsystem_log("world-save: level metadata acquire took [round((end_time - start_time) * 0.1, 0.01)]s")

	// handle objects
	start_time = REALTIMEOFDAY
	var/list/obj/level_entities = level_objects_gather_world()
	end_time = REALTIMEOFDAY
	subsystem_log("world-save: gather took [round((end_time - start_time) * 0.1, 0.01)]s")

	start_time = REALTIMEOFDAY
	var/list/static_entities_by_zlevel = entity_group_by_zlevel(level_entities[1])
	var/list/dynamic_entities_by_zlevel = entity_group_by_zlevel(level_entities[2])
	end_time = REALTIMEOFDAY
	subsystem_log("world-save: group by level took [round((end_time - start_time) * 0.1, 0.01)]s")

	for(var/z_index in 1 to world.maxz)
		var/datum/map_level_persistence/level_metadata = ordered_level_metadata[z_index]

		if(!level_metadata.persistence_allowed)
			subsystem_log("world-save: z-[z_index] skipped (persistence not allowed)")
			continue

		subsystem_log("world-save: z-[z_index] ([level_metadata.level_id]) start")

		start_time = REALTIMEOFDAY
		level_objects_store_static(static_entities_by_zlevel[z_index], level_metadata.generation + 1, level_metadata.level_id, level_metadata.map_id)
		end_time = REALTIMEOFDAY
		subsystem_log("world-save: z-[z_index] ([level_metadata.level_id]) static took [round((end_time - start_time) * 0.1, 0.01)]s")

		start_time = REALTIMEOFDAY
		level_objects_store_dynamic(dynamic_entities_by_zlevel[z_index], level_metadata.generation + 1, level_metadata.level_id)
		end_time = REALTIMEOFDAY
		subsystem_log("world-save: z-[z_index] ([level_metadata.level_id]) dynamic took [round((end_time - start_time) * 0.1, 0.01)]s")

	// handle bulk entities
	for(var/datum/bulk_entity_persistence/bulk_serializer as anything in subtypesof(/datum/bulk_entity_persistence))
		if(initial(bulk_serializer.abstract_type) == bulk_serializer)
			continue

		bulk_serializer = new bulk_serializer
		if(!bulk_serializer.is_enabled())
			continue

		subsystem_log("world-save: [bulk_serializer.id] start")

		start_time = REALTIMEOFDAY
		var/list/atom/movable/bulk_entities = bulk_serializer.gather_all()
		bulk_entities = entity_filter_out_non_persisting_levels(bulk_entities, SSmapping.ordered_levels)
		end_time = REALTIMEOFDAY
		subsystem_log("world-save: [bulk_serializer.id] gather-filter took [round((end_time - start_time) * 0.1, 0.01)]s")

		start_time = REALTIMEOFDAY
		var/list/filtered_entities = bulk_serializer.perform_global_filter(bulk_entities)
		end_time = REALTIMEOFDAY
		subsystem_log("world-save: [bulk_serializer.id] global filter took [round((end_time - start_time) * 0.1, 0.01)]s")

		start_time = REALTIMEOFDAY
		var/list/bulk_entities_by_zlevel = entity_group_by_zlevel(filtered_entities)
		end_time = REALTIMEOFDAY
		subsystem_log("world-save: [bulk_serializer.id] group by level took [round((end_time - start_time) * 0.1, 0.01)]s")


		for(var/z_index in 1 to world.maxz)
			var/datum/map_level/level_data = SSmapping.ordered_levels[z_index]
			var/datum/map_level_persistence/level_metadata = ordered_level_metadata[z_index]
			start_time = REALTIMEOFDAY
			bulk_entities_by_zlevel[z_index] = bulk_serializer.perform_level_filter(bulk_entities_by_zlevel[z_index], level_data)
			end_time = REALTIMEOFDAY
			subsystem_log("world-save: [bulk_serializer.id] z-[z_index] level filter took [round((end_time - start_time) * 0.1, 0.01)]s")

			start_time = REALTIMEOFDAY
			var/list/datum/bulk_entity_chunk/chunks = bulk_serializer.serialize_entities_into_chunks(bulk_entities_by_zlevel[z_index], level_data, level_metadata)
			end_time = REALTIMEOFDAY
			subsystem_log("world-save: [bulk_serializer.id] z-[z_index] serialize took [round((end_time - start_time) * 0.1, 0.01)]s")

			// we manually handle chunk generations
			for(var/datum/bulk_entity_chunk/chunk as anything in chunks)
				chunk.generation = level_metadata.generation + 1
				chunk.persistence_key = bulk_serializer.id

			start_time = REALTIMEOFDAY
			bulk_entity_save_chunks(chunks)
			end_time = REALTIMEOFDAY
			subsystem_log("world-save: [bulk_serializer.id] z-[z_index] write took [round((end_time - start_time) * 0.1, 0.01)]s")

	// increment everything
	subsystem_log("world-save: incrementing generations...")
	// todo: this is *NOT* atomic!
	for(var/z_index in 1 to world.maxz)
		var/datum/map_level_persistence/level_metadata = ordered_level_metadata[z_index]
		if(!level_metadata.persistence_allowed)
			continue
		level_metadata.mark_serialized_to_generation(level_metadata.generation + 1)
	subsystem_log("world-save: generations incremented.")

	complete_end_time = REALTIMEOFDAY
	subsystem_log("world-save: world saved in [round((complete_end_time - complete_start_time) * 0.1, 0.01)]s")

	// cleanup
	// todo: start autocleaning someday when we have more persistence
	// start_time = REALTIMEOFDAY
	// clean_the_world()
	// end_time = REALTIMEOFDAY
	// subsystem_log("world-save: clean took [round((end_time - start_time) * 0.1, 0.01)]s")


/**
 * called to clean out unused data from the database.
 *
 * todo: doesn't clean global objects
 * todo: doesn't clean map objects
 */
/datum/controller/subsystem/persistence/proc/clean_the_world(list/datum/map_level_persistence/ordered_level_metadata = spatial_metadata_get_ordered_levels())
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	for(var/datum/map_level_persistence/level_metadata as anything in ordered_level_metadata)
		SSdbcore.RunQuery(
			"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_bulk_entity")] WHERE level_id = :level, generation != :generation",
			list(
				"level" = level_metadata.level_id,
				"generation" = level_metadata.generation,
			),
		)
		SSdbcore.RunQuery(
			"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_static_level_objects")] WHERE level_id = :level, generation != :generation",
			list(
				"level" = level_metadata.level_id,
				"generation" = level_metadata.generation,
			),
		)
		SSdbcore.RunQuery(
			"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_dynamic_objects")] WHERE level_id = :level, generation != :generation",
			list(
				"level" = level_metadata.level_id,
				"generation" = level_metadata.generation,
			),
		)

	usr = intentionally_allow_admin_proccall

	return TRUE

/**
 * separate from world for performance; gathering entities is often slower if done one by one.
 */
/datum/controller/subsystem/persistence/proc/load_specific_level(z)

/**
 * separate from world for performance; gathering entities is often slower if done one by one.
 */
/datum/controller/subsystem/persistence/proc/save_specific_level(z)
