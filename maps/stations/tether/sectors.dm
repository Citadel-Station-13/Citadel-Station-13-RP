
/datum/atmosphere/planet/virgo3b
	base = list(
		/datum/gas/nitrogen = 0.36,
		/datum/gas/phoron = 0.52,
		/datum/gas/carbon_dioxide = 0.12,
	)
	pressure_low = 82.4
	pressure_high = 82.4
	temperature_low = 234
	temperature_high = 234

/obj/overmap/entity/visitable/sector/virgo3b
	name = "Virgo 3B"
	desc = "Full of phoron, and home to the NSB Adephagia, where you can dock and refuel your craft."
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), Nanotrasen IFF
[b]Notice[/b]: Nanotrasen Base, authorized personnel only"}
	icon_state = "globe"
	color = "#d35b5b"
	initial_generic_waypoints = list(
		"tether_dockarm_d2a", //Top left
		"tether_dockarm_d2b", //Bottom left,
		"tether_dockarm_d2r", //Right,
		"tether_dockarm_d2l", //End of arm,
		"tether_space_SE", //station1, bottom right of space,
		"tether_space_SE", //station1, bottom right of space,
		"tether_space_NE", //station1, top right of space,
		"tether_space_SW", //station2, bottom left of space,
		"tether_excursion_hangar", //Excursion shuttle hangar,
		"tether_medivac_dock", //Medical shuttle dock,
		"tourbus_dock" //Surface large hangar
		)

/obj/overmap/entity/visitable/sector/virgo3b
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
		var/datum/map_level/level
		if(ispath(path))
			level = SSmapping.keyed_levels[initial(path.id)]
		else if(istext(path))
			level = SSmapping.keyed_levels[path]
		if(isnull(level))
			STACK_TRACE("failed to resolve [id] [path]")
			continue
		actual_snowflake_space_levels += level.z_index

/obj/overmap/entity/visitable/sector/virgo3b/get_space_zlevels()
	return actual_snowflake_space_levels.Copy()
