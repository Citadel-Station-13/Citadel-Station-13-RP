/datum/prototype/material/alienalloy/derelictalloy
	id = "derelict-alloy"
	name = "derelict-alloy"

	// Becomes "[display_name] wall" in the UI.
	display_name = "derelict alloy"

	icon_base = 'code/game/content/factions/derelict/derelict.dmi/derelict_walls.dmi'
	icon_colour = "#413c3c"
	wall_stripe_icon = null // leave null

	door_icon_base = "derelict" // For doors.

/datum/prototype/material/alienalloy/derelictalloy/window
	id = "derelict-alloy-glass"
	name = "derelict-alloy-glass"

	// Becomes "[display_name] wall" in the UI.
	display_name = "derelict alloy"

	icon_base = 'code/game/content/factions/derelict/derelict.dmi/derelict_windows.dmi'
	icon_colour = "#413c3c"
	wall_stripe_icon = null // leave null

	door_icon_base = "derelict" // For doors.

// Walls

/turf/simulated/wall/event/derelict_wall
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/derelictalloy
	name = "derelict wall"
	desc = "A wall made up of some sort of strange alloy... It has lots of pipes, tubes and other utility structure on full display."
	block_tele = TRUE
	integrity_enabled = 0

// Windows

/turf/simulated/wall/event/derelict_window
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_windows.dmi'
	material_outer = /datum/prototype/material/alienalloy/derelictalloy/window
	name = "derelict window"
	desc = "A window, seemingly made out of some type of nigh indestructible material. Looks old."
	block_tele = TRUE
	integrity_enabled = 0
	opacity = 0

// Doors

/obj/machinery/door/airlock/derelict
	name = "Ancient Airlock"
	explosion_resistance = 20
	secured_wires = TRUE
	hackProof = TRUE
	opacity = 1
	door_color = "none"
	airlock_type = "standard"
	assembly_type = /obj/structure/door_assembly/voidcraft
	req_one_access = list(ACCESS_FACTION_ALIEN)
	open_sound_powered = 'sound/machines/door/scp1o.ogg'
	close_sound_powered = 'sound/machines/door/scp1c.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'
	icon = 'icons/obj/doors/derelict/door.dmi'
	icon_state = "closed"
	bolts_file = 'icons/obj/doors/derelict/lights_bolts.dmi'
	lights_file = 'icons/obj/doors/derelict/lights_green.dmi'
	panel_file = 'icons/obj/doors/derelict/panel.dmi'
	welded_file = 'icons/obj/doors/derelict/welded.dmi'
	emag_file = 'icons/obj/doors/hatch/emag.dmi'

// Floors

/turf/simulated/floor/event/derelict_pillar
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_tiles.dmi'
	icon_state = "derelict_pillar_dir"
	integrity_enabled = 0
	color = "#808080"

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
