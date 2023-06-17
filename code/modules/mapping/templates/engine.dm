/datum/map_template/engine
	name = "Engine Content"
	desc = "It would be boring to have the same engine every day, right?"

	/// announce name
	var/display_name
	/// map datum path or id of which map we're for. resolved to id immediately on New().
	var/for_map

/datum/map_template/engine/New()
	. = ..()
	if(isnull(display_name))
		display_name = name
	else if(islist(display_name))
		display_name = pick(display_name)
	if(ispath(for_map))
		var/datum/map/map = for_map
		for_map = initial(map.id)
