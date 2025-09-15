//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * objects module
 *
 * handles static and dynamic object persistence on given map levels
 */
/datum/controller/subsystem/persistence

/datum/controller/subsystem/persistence/proc/level_objects_store_static(list/obj/entities, generation, level_id, map_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	for(var/obj/entity as anything in entities)
		var/datum/db_query/query
		switch(entity.obj_persist_static_mode)
			if(OBJ_PERSIST_STATIC_MODE_LEVEL)
				query = SSdbcore.NewQuery(
					"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_static_level_objects")] (generation, object_id, level_id, data) \
						VALUES (:generation, :object_id, :level_id, :data) ON DUPLICATE KEY UPDATE \
						data = VALUES(data)",
					list(
						"generation" = generation,
						"object_id" = entity.obj_persist_static_id,
						"level_id" = entity.obj_persist_static_bound_id || level_id,
						"data" = safe_json_encode(entity.serialize()),
					),
				)
			if(OBJ_PERSIST_STATIC_MODE_MAP)
				query = SSdbcore.NewQuery(
					"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_static_map_objects")] (generation, object_id, map_id, data) \
						VALUES (:generation, :object_id, :map_id, :data) ON DUPLICATE KEY UPDATE \
						data = VALUES(data)",
					list(
						"generation" = generation,
						"object_id" = entity.obj_persist_static_id,
						"map_id" = entity.obj_persist_static_bound_id || map_id,
						"data" = safe_json_encode(entity.serialize()),
					),
				)
			if(OBJ_PERSIST_STATIC_MODE_GLOBAL)
				query = SSdbcore.NewQuery(
					"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_static_global_objects")] (generation, object_id, data) \
						VALUES (:generation, :object_id, :data) ON DUPLICATE KEY UPDATE \
						data = VALUES(data)",
					list(
						"generation" = generation,
						"object_id" = entity.obj_persist_static_id,
						"data" = safe_json_encode(entity.serialize()),
					),
				)
			else
				stack_trace("unrecognized mode [entity.obj_persist_static_mode]")
				continue
		query.warn_execute()
		QDEL_NULL(query)

		entity.obj_persist_status |= OBJ_PERSIST_STATUS_SAVED

	usr = intentionally_allow_admin_proccall

	return TRUE

/**
 * **warning** - does not dedupe. don't directly call unless you know what you're doing!
 */
/datum/controller/subsystem/persistence/proc/level_objects_store_dynamic(list/obj/entities, generation, level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	for(var/obj/entity as anything in entities)
		var/datum/db_query/query
		if(entity.obj_persist_dynamic_id != PERSISTENCE_DYNAMIC_ID_AUTOSET)
			query = SSdbcore.NewQuery(
				"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_dynamic_objects")] (id, generation, status, data, prototype_id, level_id, x, y) \
					VALUES (:status, :data, :prototype, :level, :x, :y) ON DUPLICATE KEY UPDATE \
					x = VALUES(x), y = VALUES(y), data = VALUES(data), prototype = VALUES(prototype), level = VALUES(level), \
					status = VALUES(status)",
				list(
					"id" = entity.obj_persist_dynamic_id,
					"generation" = generation,
					"status" = entity.obj_persist_dynamic_status,
					"data" = safe_json_encode(entity.serialize()),
					"prototype" = "[entity.type]",
					"level" = level_id,
					"x" = entity.x,
					"y" = entity.y,
				)
			)
			query.warn_execute()
		else
			query = SSdbcore.NewQuery(
				"INSERT INTO [DB_PREFIX_TABLE_NAME("persistence_dynamic_objects")] (status, data, prototype_id, level_id, x, y) \
					VALUES (:status, :data, :prototype, :level, :x, :y)",
				list(
					"status" = entity.obj_persist_dynamic_status,
					"data" = safe_json_encode(entity.serialize()),
					"prototype" = "[entity.type]",
					"level" = level_id,
					"x" = entity.x,
					"y" = entity.y,
				)
			)
			query.warn_execute()
			entity.obj_persist_dynamic_id = query.last_insert_id
			entity.obj_persist_status |= OBJ_PERSIST_STATUS_FIRST_GENERATION
		entity.obj_persist_status |= OBJ_PERSIST_STATUS_SAVED
		QDEL_NULL(query)

	usr = intentionally_allow_admin_proccall

	return TRUE

/**
 * @return list(count loaded, count dropped, count errored)
 */
/datum/controller/subsystem/persistence/proc/level_objects_load_dynamic(datum/map_level_persistence/level_data, z_index)
	if(!SSdbcore.Connect())
		return FALSE

	var/count_loaded = 0
	var/count_dropped = 0
	var/count_errored = 0

	var/generation = level_data.generation
	var/level_id = level_data.level_id

	// todo: anti-dupe system

	var/intentionally_allow_admin_proccall = usr
	usr = null

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT object_id, prototype_id, status, data, x, y \
			FROM [DB_PREFIX_TABLE_NAME("persistence_dynamic_objects")] \
			WHERE level_id = :level AND generation = :generation",
		list(
			"generation" = generation,
			"level" = level_id,
		)
	)
	query.warn_execute()

	while(query.NextRow())
		var/object_id = query.item[1]
		var/prototype_id = query.item[2]
		var/status = query.item[3]
		var/data_encoded = query.item[4]
		var/x = query.item[5]
		var/y = query.item[6]

		// resolve prototype
		var/object_type = text2path(prototype_id)
		if(isnull(object_type))
			count_dropped++
			continue

		var/obj/deserializing = new object_type(locate(x, y, z_index))
		deserializing.obj_persist_dynamic_id = object_id
		deserializing.obj_persist_dynamic_status = status
		deserializing.deserialize(json_decode(data_encoded))
		deserializing.decay_persisted(level_data.rounds_since_saved, level_data.hours_since_saved)
		deserializing.obj_persist_status |= OBJ_PERSIST_STATUS_LOADED
		count_loaded++

	QDEL_NULL(query)

	usr = intentionally_allow_admin_proccall

	return list(count_loaded, count_dropped, count_errored)

/**
 * @return list(count loaded, count dropped, count errored)
 */
/datum/controller/subsystem/persistence/proc/level_objects_load_static(datum/map_level_persistence/level_data, list/obj/entities)
	if(!SSdbcore.Connect())
		return FALSE

	var/count_loaded = 0
	var/count_dropped = 0
	var/count_errored = 0

	var/generation = level_data.generation
	var/level_id = level_data.level_id
	var/map_id = level_data.map_id

	var/intentionally_allow_admin_proccall = usr
	usr = null

	for(var/obj/entity as anything in entities)
		var/datum/db_query/query
		var/bind_id
		switch(entity.obj_persist_static_mode)
			if(OBJ_PERSIST_STATIC_MODE_GLOBAL)
				query = SSdbcore.NewQuery(
					"SELECT data FROM [DB_PREFIX_TABLE_NAME("persistence_static_global_objects")] \
						WHERE object_id = :object AND generation = :generation",
					list(
						"object" = entity.obj_persist_static_id,
						"generation" = generation,
					),
				)
			if(OBJ_PERSIST_STATIC_MODE_LEVEL)
				query = SSdbcore.NewQuery(
					"SELECT data FROM [DB_PREFIX_TABLE_NAME("persistence_static_level_objects")] \
						WHERE object_id = :object AND level_id = :level AND generation = :generation",
					list(
						"object" = entity.obj_persist_static_id,
						"level" = level_id,
						"generation" = generation,
					),
				)
				bind_id = level_id
			if(OBJ_PERSIST_STATIC_MODE_MAP)
				query = SSdbcore.NewQuery(
					"SELECT data FROM [DB_PREFIX_TABLE_NAME("persistence_static_map_objects")] \
						WHERE object_id = :object AND map_id = :map AND generation = :generation",
					list(
						"object" = entity.obj_persist_static_id,
						"map" = map_id,
						"generation" = generation,
					),
				)
				bind_id = map_id
			else
				stack_trace("unrecognized mode [entity.obj_persist_static_mode]")
				continue
		query.warn_execute(FALSE)
		if(!query.NextRow())
			continue
		var/json_data = query.item[1]
		entity.deserialize(json_decode(json_data))
		entity.decay_persisted(level_data.rounds_since_saved, level_data.hours_since_saved)
		entity.obj_persist_status |= OBJ_PERSIST_STATUS_LOADED
		if(!isnull(bind_id))
			entity.obj_persist_static_bound_id = bind_id
		count_loaded++
		CHECK_TICK
		QDEL_NULL(query)

	usr = intentionally_allow_admin_proccall

	return list(count_loaded, count_dropped, count_errored)

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.dangerously_block_on_multiple_unsanitized_queries(
		list(
			"TRUNCATE TABLE [DB_PREFIX_TABLE_NAME("persistence_static_map_objects")]",
			"TRUNCATE TABLE [DB_PREFIX_TABLE_NAME("persistence_static_level_objects")]",
			"TRUNCATE TABLE [DB_PREFIX_TABLE_NAME("persistence_static_global_objects")]",
		),
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_static_level_objects")] WHERE level_id = :level",
		list(
			"level" = level_id,
		),
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_map(map_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_static_map_objects")] WHERE map_id = :map",
		list(
			"map" = map_id,
		),
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_global()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_static_global_objects")]",
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_dynamic_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"TRUNCATE TABLE [DB_PREFIX_TABLE_NAME("persistence_dynamic_objects")]",
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_dynamic_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [DB_PREFIX_TABLE_NAME("persistence_dynamic_objects")] WHERE level_id = :level",
		list(
			"level" = level_id,
		),
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/**
 * @return list(static objects)
 */
/datum/controller/subsystem/persistence/proc/level_objects_gather_world_static()
	. = list()

	for(var/obj/thing in world)
		// don't lock up the server
		CHECK_TICK
		// we only care about things on turfs
		if(!isturf(thing.loc))
			continue
		// check flags
		if(thing.obj_persist_status & OBJ_PERSIST_STATUS_NO_THANK_YOU)
			continue
		// are they static?
		if(thing.obj_persist_static_id)
			. += thing

/**
 * @return list(static objects)
 */
/datum/controller/subsystem/persistence/proc/level_objects_gather_level_static(z)
	. = list()

	for(var/obj/thing in world)
		// don't lock up the server
		CHECK_TICK
		// we only care about things on turfs
		// and since if you're not on a turf, z is 0, this works anyways lol
		if(thing.z != z)
			continue
		// check flags
		if(thing.obj_persist_status & OBJ_PERSIST_STATUS_NO_THANK_YOU)
			continue
		// are they static?
		if(thing.obj_persist_static_id)
			. += thing

/**
 * @return list(list(static objects), list(dynamic objects))
 */
/datum/controller/subsystem/persistence/proc/level_objects_gather_world()
	var/list/static_objects = list()
	var/list/dynamic_objects = list()

	for(var/obj/thing in world)
		// don't lock up the server
		CHECK_TICK
		// we only care about things on turfs
		if(!isturf(thing.loc))
			continue
		// check flags
		if(thing.obj_persist_status & OBJ_PERSIST_STATUS_NO_THANK_YOU)
			continue
		// are they static?
		if(thing.obj_persist_static_id)
			static_objects += thing
		// are they dynamic?
		else if(thing.obj_persist_dynamic_id)
			dynamic_objects += thing

	return list(static_objects, dynamic_objects)

/**
 * @return list(list(static objects), list(dynamic objects))
 */
/datum/controller/subsystem/persistence/proc/level_objects_gather_level(z)
	var/list/static_objects = list()
	var/list/dynamic_objects = list()

	for(var/obj/thing in world)
		// don't lock up the server
		CHECK_TICK
		// we only care about things on turfs
		// and since if you're not on a turf, z is 0, this works anyways lol
		if(thing.z != z)
			continue
		// check flags
		if(thing.obj_persist_status & OBJ_PERSIST_STATUS_NO_THANK_YOU)
			continue
		// are they static?
		if(thing.obj_persist_static_id)
			static_objects += thing
		// are they dynamic?
		else if(thing.obj_persist_dynamic_id)
			dynamic_objects += thing

	return list(static_objects, dynamic_objects)
