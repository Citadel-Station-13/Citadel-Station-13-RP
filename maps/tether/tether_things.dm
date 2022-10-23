//Special map objects
/* // Moved to map/generic/map_data.dm
/obj/landmark/map_data/virgo3b
    height = 6
*/
/*
/obj/turbolift_map_holder/tether
	name = "Tether Climber"
	depth = 6
	lift_size_x = 3
	lift_size_y = 3
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/t_surface/level1,
		/area/turbolift/t_surface/level2,
		/area/turbolift/t_surface/level3,
		/area/turbolift/tether/transit,
		/area/turbolift/t_station/level1,
		/area/turbolift/t_station/level2
		)

/datum/turbolift
	music = list('sound/music/elevator1.ogg', 'sound/music/elevator2.ogg')  // Woo elevator music!
*/
//////////////////////////////////////////

/// Temporarilly adding this in here so if someone tick's tether's dm file virgo 2's shuttle will still function. Eventually just need to have virgo 2 on both triumph and tether
/// but this is a temporary fix to get triumph working. - Bloop
/datum/shuttle/autodock/ferry/aerostat
	name = "Aerostat Ferry"
	shuttle_area = /area/shuttle/aerostat
	warmup_time = 10	//want some warmup time so people can cancel.
	landmark_station = "aerostat_east"
	landmark_offsite = "aerostat_surface"



/////////////////////////////////////////

/obj/effect/step_trigger/teleporter/to_mining/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_MINE

/obj/effect/step_trigger/teleporter/from_mining/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/to_solars/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = src.y
	teleport_z = Z_LEVEL_SOLARS

/obj/effect/step_trigger/teleporter/from_solars/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = src.y
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/wild/Initialize(mapload)
	. = ..()

	//If starting on east/west edges.
	if (src.x == 1)
		teleport_x = world.maxx - 1
	else if (src.x == world.maxx)
		teleport_x = 2
	else
		teleport_x = src.x
	//If starting on north/south edges.
	if (src.y == 1)
		teleport_y = world.maxy - 1
	else if (src.y == world.maxy)
		teleport_y = 2
	else
		teleport_y = src.y

/obj/effect/step_trigger/teleporter/to_underdark
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
/obj/effect/step_trigger/teleporter/to_underdark/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in GLOB.using_map.zlevels)
		var/datum/map_z_level/Z = GLOB.using_map.zlevels[z_num]
		if(Z.name == "Underdark")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/from_underdark
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
/obj/effect/step_trigger/teleporter/from_underdark/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in GLOB.using_map.zlevels)
		var/datum/map_z_level/Z = GLOB.using_map.zlevels[z_num]
		if(Z.name == "Mining Outpost")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/to_plains/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_PLAINS

/obj/effect/step_trigger/teleporter/from_plains/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/planetary_fall/virgo3b/find_planet()
	planet = planet_virgo3b


// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)

