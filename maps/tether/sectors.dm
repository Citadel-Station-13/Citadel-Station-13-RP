/obj/overmap/entity/visitable/sector/virgo3b
	extra_z_levels = list(
		/datum/map_level/tether/mine,
		/datum/map_level/tether/solars,
		/datum/map_level/tether/plains,
		/datum/map_level/tether/underdark,
	)
	in_space = FALSE

	var/list/snowflake_space_levels = list(
		/datum/map_level/tether/station/space_high,
		/datum/map_level/tether/station/space_low,
	)
	var/list/actual_snowflake_space_levels

/obj/overmap/entity/visitable/sector/virgo3b/Initialize(mapload)
	. = ..()
	actual_snowflake_space_levels = list()
	for(var/datum/map_level/path as anything in snowflake_space_levels)
		var/id = initial(path.id)
		var/datum/map_level/resolved = SSmapping.keyed_levels[id]
		if(isnull(resolved))
			STACK_TRACE("failed to resolve [id] [path]")
			continue
		actual_snowflake_space_levels += resolved.z_index

/obj/overmap/entity/visitable/sector/virgo3b/get_space_zlevels()
	return actual_snowflake_space_levels.Copy()
