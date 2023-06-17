/obj/effect/step_trigger/teleporter/to_mining
	map_level_target = /datum/map_level/tether/mine

/obj/effect/step_trigger/teleporter/to_mining/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = 2

/obj/effect/step_trigger/teleporter/from_mining
	map_level_target = /datum/map_level/tether/station/surface_low

/obj/effect/step_trigger/teleporter/from_mining/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = world.maxy - 1

/obj/effect/step_trigger/teleporter/to_solars
	map_level_target = /datum/map_level/tether/solars

/obj/effect/step_trigger/teleporter/to_solars/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = src.y

/obj/effect/step_trigger/teleporter/from_solars
	map_level_target = /datum/map_level/tether/station/surface_low

/obj/effect/step_trigger/teleporter/from_solars/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = src.y

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
	map_level_target = /datum/map_level/tether/underdark

/obj/effect/step_trigger/teleporter/to_underdark/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = y

/obj/effect/step_trigger/teleporter/from_underdark
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
	map_level_target = /datum/map_level/tether/mine

/obj/effect/step_trigger/teleporter/from_underdark/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = y

/obj/effect/step_trigger/teleporter/to_plains
	map_level_target = /datum/map_level/tether/plains

/obj/effect/step_trigger/teleporter/to_plains/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = world.maxy - 1

/obj/effect/step_trigger/teleporter/from_plains
	map_level_target = /datum/map_level/tether/station/surface_low


/obj/effect/step_trigger/teleporter/from_plains/Initialize(mapload)
	. = ..()
	teleport_x = src.x
	teleport_y = 2

/obj/effect/step_trigger/teleporter/planetary_fall/virgo3b
	planet_path = /datum/planet/virgo3b
