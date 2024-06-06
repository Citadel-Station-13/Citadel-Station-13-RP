/datum/game_location/specific_turf
	/// target turf
	var/turf/target
	/// allow being in the turf, nested
	var/allow_nested = TRUE

/datum/game_location/specific_turf/bind_to(to_where)
	. = FALSE
	ASSERT(isturf(to_where))
	target = to_where
	return TRUE

/datum/game_location/specific_turf/entity_is_inside(datum/game_entity/entity)
	. = entity.special_in_location(src)
	if(!isnull(.))
		return
	var/atom/movable/potential = entity.resolve()
	return istype(potential) && (allow_nested? get_turf(potential) == target : (potential in target))

/datum/game_location/specific_turf/explain(tracking_level)
	if(isnull(target))
		return "at an unknown location (uh oh!)"
	var/datum/map_level/their_level = SSmapping.ordered_levels[target.z]
	return "at coordinates [target.x], [target.y], in sector designation [their_level.display_name]"

/datum/game_location/specific_turf/entity_distance(datum/game_entity/entity)
	var/atom/movable/potential = entity.resolve()
	if(!istype(potential))
		return
	var/turf/where = get_turf(potential)
	if(where.z != target.z)
		return INFINITY
	return get_chebyshev_dist(where, target)
