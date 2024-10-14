// todo: re-review this file; ensure generation / ACID is being enforced.

/**
 * somewhat expensive
 *
 * runtimes if anything isn't on a turf
 *
 * @return list(list(areapath, turfpath) = list(entities))
 */
/datum/controller/subsystem/persistence/proc/entity_group_by_area_and_turf(list/atom/movable/entities)
	var/list/hash = list()
	var/list/split = list()
	for(var/atom/movable/entity as anything in entities)
		var/turf_type = entity.loc.type
		var/area_type = entity.loc.loc.type
		if(isnull(hash[area_type]))
			hash[area_type] = list()
		if(isnull(hash[area_type][turf_type]))
			hash[area_type][turf_type] = list()
		hash[area_type][turf_type] += entity
	for(var/area_type in hash)
		var/list/turf_types = hash[area_type]
		for(var/turf_type in turf_types)
			split[list(area_type, turf_type)] = turf_types[turf_type]
	return split

/**
 * runtimes if anything isn't on a turf.
 *
 * @return list(list(entities), ...) --> length = world.maxz
 */
/datum/controller/subsystem/persistence/proc/entity_group_by_zlevel(list/atom/movable/entities)
	var/list/split = new /list(world.maxz)
	for(var/i in 1 to world.maxz)
		split[i] = list()
	for(var/atom/movable/entity as anything in entities)
		split[entity.z] += entity
	return split

/**
 * @return list(list(entity, ...), ...)
 */
/datum/controller/subsystem/persistence/proc/entity_split_by_amount(list/atom/movable/entities, amount)
	if(length(entities) <= amount)
		return list(entities.Copy())
	var/index = 1
	var/list/split = list()
	for(index in 1 to length(entities) step amount)
		split[++split.len] = entities.Copy(index, min(index + amount, length(entities) + 1))
	return split

/**
 * drops all entities not on persisting zlevels
 */
/datum/controller/subsystem/persistence/proc/entity_filter_out_non_persisting_levels(list/atom/movable/entities, list/datum/map_level/ordered_level_data)
	. = list()
	for(var/atom/movable/entity as anything in entities)
		if(!entity.z)
			continue
		if(!ordered_level_data[entity.z].persistence_allowed)
			continue
		. += entity

/**
 * drops all entities in eroding turfs
 *
 * unsimulated turfs are always eroding for now.
 */
/datum/controller/subsystem/persistence/proc/entity_filter_out_eroding_turfs(list/atom/movable/entities)
	. = list()
	var/outdoors_will_erode = CONFIG_GET(flag/persistent_outdoors_will_erode)
	for(var/atom/movable/entity as anything in entities)
		var/turf/simulated/simulated_turf = entity.loc
		if(!istype(simulated_turf))
			continue
		if(outdoors_will_erode && simulated_turf.outdoors)
			continue
		if(simulated_turf.turf_flags & TURF_FLAG_ERODING)
			continue
		var/area/belonging_to_area = simulated_turf.loc
		if(belonging_to_area?.area_flags & AREA_FLAG_ERODING)
			continue
		. += entity

/**
 * drops specifically /objs marked to not persist
 */
/datum/controller/subsystem/persistence/proc/entity_filter_out_non_persisting_objs(list/obj/objs)
	. = list()
	for(var/obj/obj as anything in objs)
		if(obj.obj_persist_status & OBJ_PERSIST_STATUS_NO_THANK_YOU)
			continue
		. += obj
