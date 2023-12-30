/datum/game_location/entity/overmap_entity

/datum/game_location/entity/overmap_entity/entity_is_inside(datum/game_entity/entity)
	. = entity.special_in_location(src)
	if(!isnull(.))
		return
	var/atom/movable/potential = entity.resolve()
	if(!istype(potential))
		return
	var/obj/overmap/entity/our_entity = target
	var/turf/where_they_are = get_turf(potential)
	// todo: ugh
	return get_overmap_sector(where_they_are) == our_entity

/datum/game_location/entity/overmap_entity/explain(detailed)
	if(isnull(target))
		return "at an unknown location (uh oh!)"
	return "on \the [target]"

#warn entity_distance
