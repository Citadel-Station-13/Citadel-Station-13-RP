/datum/prototype/material/alienalloy/derelictalloy
	id = "derelictalloy"
	name = "derelictalloy"

	// Becomes "[display_name] wall" in the UI.
	display_name = "derelict alloy"

	icon_base = 'code/game/content/factions/derelict/derelict.dmi/derelict_walls.dmi'
	icon_colour = "#413c3c"
	wall_stripe_icon = null // leave null

	door_icon_base = "derelict" // For doors.

// Walls

/turf/simulated/wall/event/derelict_wall
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/derelictalloy
	name = "derelict wall"
	desc = "A wall made up of some sort of strange alloy... It has lots of pipes, tubes and other utility structure on full display."
	description_info = "Maybe it's best NOT to compromise a excavation site due to curiosity?"
	block_tele = TRUE
	integrity_enabled = 0

// Floors

/turf/simulated/floor/event/derelict_pillar
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_pillar_dir"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_hull
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_hull"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor1
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_1"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor2
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_2"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor3
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_3"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor4
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_4"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor5
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_5"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor6
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_6"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor7
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_7"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_floor_corner4
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_corner4"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_plating
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_plating"
	integrity_enabled = 0

/turf/simulated/floor/event/derelict_light
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_light"
	integrity_enabled = 0
	light_range = 5
	light_power = 0.5

/turf/simulated/floor/event/derelict_wall_floor
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_wall_floor"
	integrity_enabled = 0
	opacity = 1

// Doors

/obj/structure/simple_door/derelict
	material_parts = /datum/prototype/material/alienalloy/derelictalloy
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_doors.dmi'
	integrity_enabled = 0

//Decals

/obj/effect/decal/event/derelict_platform_corner
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_platform_corners"
	integrity_enabled = 0

/obj/effect/decal/event/derelict_floor_corner1
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_corner1"
	integrity_enabled = 0

/obj/effect/decal/event/derelict_floor_corner2
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_corner2"
	integrity_enabled = 0

/obj/effect/decal/event/derelict_floor_corner3
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_floor_corner3"
	integrity_enabled = 0


// Misc

/turf/simulated/floor/event/concrete
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "concrete"
	integrity_enabled = 0

/turf/simulated/floor/event/asphalt
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "asphalt"
	integrity_enabled = 0
