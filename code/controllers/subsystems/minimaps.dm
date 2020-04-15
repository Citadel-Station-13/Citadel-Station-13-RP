SUBSYSTEM_DEF(minimaps)
	name = "Minimaps"
	flags = SS_NO_FIRE
	var/list/station_minimaps
	var/datum/minimap_group/station_minimap

/datum/controller/subsystem/minimaps/Initialize()
	if(!CONFIG_GET(flag/minimaps_enabled))
		to_chat(world, "<span class='boldwarning'>Minimaps disabled! Skipping init.</span>")
		return ..()
	build_minimaps()
	return ..()

/datum/controller/subsystem/minimaps/proc/build_minimaps()
	station_minimaps = list()
/*
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
*/
	for(var/z in GLOB.using_map.station_levels)
		/*
		var/datum/space_level/SL = SSmapping.get_level(z)
		var/name = (SL.name == initial(SL.name))? "[z] - Station" : "[z] - [SL.name]"
		*/
		var/name = "[z] - Station"
		station_minimaps += new /datum/minimap(z, name = name)
	station_minimap = new(station_minimaps, "Station")
