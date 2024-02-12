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
					"INSERT INTO [format_table_name("persistence_static_level_objects")] (generation, object_id, level_id, data) \
						VALUES (:generation, :object_id, :level_id, :data) ON DUPLICATE KEY UPDATE \
						data = VALUES(data)",
					list(
						"generation" = generation,
						"object_id" = entity.obj_persist_static_id,
						"level_id" = level_id,
						"data" = entity.serialize(),
					),
				)
			if(OBJ_PERSIST_STATIC_MODE_MAP)
				query = SSdbcore.NewQuery(
					"INSERT INTO [format_table_name("persistence_static_mapl_objects")] (generation, object_id, map_id, data) \
						VALUES (:generation, :object_id, :map_id, :data) ON DUPLICATE KEY UPDATE \
						data = VALUES(data)",
					list(
						"generation" = generation,
						"object_id" = entity.obj_persist_static_id,
						"map_id" = map_id,
						"data" = entity.serialize(),
					),
				)
			if(OBJ_PERSIST_STATIC_MODE_GLOBAL)
				query = SSdbcore.NewQuery(
					"INSERT INTO [format_table_name("persistence_static_global_objects")] (generation, object_id, data) \
						VALUES (:generation, :object_id, :data) ON DUPLICATE KEY UPDATE \
						data = VALUES(data)",
					list(
						"generation" = generation,
						"object_id" = entity.obj_persist_static_id,
						"data" = entity.serialize(),
					),
				)
			else
				stack_trace("unrecognized mode [entity.obj_persist_static_mode]")
				continue
		query.Execute(FALSE)
		qdel(query)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_store_dynamic(list/obj/entities, generation, level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	for(var/obj/entity as anything in entities)
		var/datum/db_query/query
		if(entity.obj_persist_dynamic_id)
			query = SSdbcore.NewQuery(
				"INSERT INTO [format_table_name("persistence_dynamic_objects")] (id, generation, status, data, prototype_id, level_id, x, y) \
					VALUES (:status, :data, :prototype, :level, :x, :y) ON DUPLICATE KEY UPDATE \
					x = VALUES(x), y = VALUES(y), data = VALUES(data), prototype = VALUES(prototype), level = VALUES(level), \
					status = VALUES(status)",
				list(
					"id" = entity.obj_persist_dynamic_id,
					"generation" = generation,
					"status" = entity.obj_persist_dynamic_status,
					"data" = entity.serialize(),
					"prototype" = "[entity.type]",
					"level" = level_id,
					"x" = entity.x,
					"y" = entity.y,
				)
			)
			query.Execute(FALSE)
		else
			query = SSdbcore.NewQuery(
				"INSERT INTO [format_table_name("persistence_dynamic_objects")] (status, data, prototype_id, level_id, x, y) \
					VALUES (:status, :data, :prototype, :level, :x, :y)",
				list(
					"status" = entity.obj_persist_dynamic_status,
					"data" = entity.serialize(),
					"prototype" = "[entity.type]",
					"level" = level_id,
					"x" = entity.x,
					"y" = entity.y,
				)
			)
			query.Execute(FALSE)
			entity.obj_persist_dynamic_id = query.last_insert_id

	qdel(query)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_load_dynamic(generation, level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_load_static(list/obj/entities, generation, level_id, map_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.dangerously_block_on_multiple_unsanitized_queries(
		list(
			"TRUNCATE TABLE [format_table_name("persistence_static_map_objects")]",
			"TRUNCATE TABLE [format_table_name("persistence_static_level_objects")]",
			"TRUNCATE TABLE [format_table_name("persistence_static_global_objects")]",
		)
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [format_table_name("persistence_static_level_objects")] WHERE level_id = :level",
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
		"DELETE FROM [format_table_name("persistence_static_map_objects")] WHERE map_id = :map",
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
		"DELETE FROM [format_table_name("persistence_static_global_objects")]",
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_dynamic_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"TRUNCATE TABLE [format_table_name("persistence_dynamic_objects")]",
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_dynamic_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	SSdbcore.RunQuery(
		"DELETE FROM [format_table_name("persistence_dynamic_objects")] WHERE level_id = :level",
		list(
			"level" = level_id,
		),
	)

	usr = intentionally_allow_admin_proccall

	return TRUE

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
		// are they static?
		if(thing.obj_persist_static_id)
			static_objects += thing
		// are they dynamic?
		else if(thing.obj_persist_dynamic_id)
			dynamic_objects += thing

	return list(static_objects, dynamic_objects)
