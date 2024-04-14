/datum/game_location/entity/movable_entity

/datum/game_location/entity/movable_entity/entity_is_inside(datum/game_entity/entity)
	. = entity.special_in_location(src)
	if(!isnull(.))
		return
	var/atom/movable/potential = entity.resolve()
	return istype(potential) && (target.is_in_nested_contents(potential))

/datum/game_location/entity/movable_entity/explain(tracking_level)
	if(isnull(target))
		return "at an unknown location (uh oh!)"
	var/turf/target_turf = get_turf(target)
	if(isnull(target_turf))
		return "inside [target]"
	if(!detailed)
		return "on, in, or being carried by (as applicable) [target]"
	var/datum/map_level/their_level = SSmapping.ordered_levels[target_turf.z]
	return "on, in, or being carried by (as applicable) [target], \
		currently at [target_turf.x], [target_turf.y], in sector designation [their_level.display_name]"

#warn entity distance
