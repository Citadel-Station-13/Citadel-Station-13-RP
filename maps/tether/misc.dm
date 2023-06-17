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
	for(var/z_num in (LEGACY_MAP_DATUM).zlevels)
		var/datum/map_level/Z = (LEGACY_MAP_DATUM).zlevels[z_num]
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
	for(var/z_num in (LEGACY_MAP_DATUM).zlevels)
		var/datum/map_level/Z = (LEGACY_MAP_DATUM).zlevels[z_num]
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

/obj/effect/step_trigger/teleporter/planetary_fall/virgo3b
	planet_path = /datum/planet/virgo3b
