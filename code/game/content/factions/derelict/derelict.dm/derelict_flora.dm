// Walls

/datum/prototype/material/alienalloy/hardenedstone
	id = "hardenedstone"
	name = "hardenedstone"

	// Becomes "[display_name] wall" in the UI.
	display_name = "hardened stone"

	icon_base = 'code/game/content/factions/derelict/derelict.dmi/cave_walls.dmi'
	icon_colour = "#422d0e"
	wall_stripe_icon = null // leave null

/turf/simulated/wall/event/cave_wall
	icon = 'code/game/content/factions/derelict/derelict.dmi/cave_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/hardenedstone
	name = "cave wall"
	desc = "A wall consisting of impenetrable rock. No way you're getting past this without heavy excavation equipment."
	description_info = "No way you can get past this..."
	block_tele = TRUE
	integrity_enabled = 0


// Floors

/turf/simulated/floor/event/grass
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/crystal_floor
	name = "crystal patch"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crystal_floor"
	integrity_enabled = 0

/turf/simulated/floor/event/grass/dirt1
	name = "dirt"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "dirt1"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/turf/simulated/floor/event/grass/dirt2
	name = "dirt"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "dirt2"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/turf/simulated/floor/event/cave1
	name = "cave floor"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "cave1"
	integrity_enabled = 0

/turf/simulated/floor/event/grass/grass1
	name = "grass"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "grass1"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/desert1
	name = "sand"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "desert1"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/desert2
	name = "sand"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "desert2"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/desert3
	name = "sand"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "desert3"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/crust1
	name = "rocky sand"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crust1"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/crust2
	name = "rocky sand"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crust2"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/crust3
	name = "rocky sand"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crust3"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/dirt1
	name = "dirt"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "desert_dirt1"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/dirt2
	name = "dirt"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "desert_dirt2"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/event/desert/dirt3
	name = "dirt"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "desert_dirt3"
	integrity_enabled = 0
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

// Decals

/obj/effect/decal/event/crystal_small
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crystal_small"
	integrity_enabled = 0

/obj/effect/decal/event/mound_small
	name = "small mound"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "mound_small"
	integrity_enabled = 0

/obj/effect/decal/event/mound_medium
	name = "chunky mound"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "mound_medium"
	integrity_enabled = 0

/obj/effect/decal/event/mound_large
	name = "large mound"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "mound_large"
	integrity_enabled = 0

// Rocks

/obj/stucture/flora/rock/crystal_medium
	name = "large crystal"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crystal_medium"
	integrity_enabled = 0
	light_power = 2
	light_range = 2
	light_color = "#9966cc"

/obj/stucture/flora/rock/crystal_large
	name = "hefty crystal"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "crystal_large"
	integrity_enabled = 0
	light_power = 3
	light_range = 4
	light_color = "#9966cc"

/obj/structure/flora/rock/rock1
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "rock1"

/obj/structure/flora/rock/rock2
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "rock2"

/obj/structure/flora/rock/rock3
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "rock3"

/obj/structure/flora/rock/rock4
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "rock4"

// Grass

/obj/structure/flora/grass/event
	name = "grass"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	anchored = 1
	density = 0
	opacity = 0

/obj/structure/flora/grass/event/sparse_grass1
	icon_state = "sparsegrass1"

/obj/structure/flora/grass/event/sparse_grass2
	icon_state = "sparsegrass2"

/obj/structure/flora/grass/event/sparse_grass3
	icon_state = "sparse_grass3"

/obj/structure/flora/grass/event/full_grass1
	icon_state = "fullgrass1"

/obj/structure/flora/grass/event/full_grass2
	icon_state = "fullgrass2"

/obj/structure/flora/grass/event/full_grass3
	icon_state = "fullgrass3"

/obj/structure/flora/grass/event/leafy_bush1
	icon_state = "leafybush1"

/obj/structure/flora/grass/event/leafy_bush2
	icon_state = "leafybush2"

/obj/structure/flora/grass/event/leafy_bush3
	icon_state = "leafy_bush3"

/obj/structure/flora/grass/event/grassy_bush1
	icon_state = "grassybush1"

/obj/structure/flora/grass/event/stalky_bush1
	icon_state = "stalkybush1"

/obj/structure/flora/grass/event/bush1
	icon_state = "bush1"

/obj/structure/flora/grass/event/reed_bush1
	icon_state = "reedbush1"

/obj/structure/flora/grass/event/ferny_bush1
	icon_state = "fernybush1"

/obj/structure/flora/grass/event/sunny_bush1
	icon_state = "sunnybush1"

/obj/structure/flora/grass/event/generic_bush1
	icon_state = "genericbush1"

/obj/structure/flora/grass/event/point_bush1
	icon_state = "pointybush1"

/obj/structure/flora/grass/event/lavender_grass1
	icon_state = "lavendergrass1"

/obj/structure/flora/grass/event/yellow_flowers1
	icon_state = "ywflowers1"

/obj/structure/flora/grass/event/bright_flowers1
	icon_state = "brflowers1"

/obj/structure/flora/grass/event/purple_flowers1
	icon_state = "ppflowers1"

/obj/structure/flora/grass/event/heavy_grass1
	icon_state = "heavygrass_1"

/obj/structure/flora/grass/event/heavy_grass2
	icon_state = "heavygrass_2"

/obj/structure/flora/grass/event/heavy_grass3
	icon_state = "heavygrass_3"

/obj/structure/flora/grass/event/heavy_grass4
	icon_state = "heavygrass_4"

/obj/structure/flora/grass/event/heavy_grass5
	icon_state = "heavygrass5"

/obj/structure/flora/grass/event/cactus1
	icon_state = "cactus_1"
	name = "cactus"

/obj/structure/flora/grass/event/cactus2
	icon_state = "cactus_2"
	name = "cactus"

/obj/structure/flora/grass/event/cactus3
	icon_state = "cactus_3"
	name = "cactus"

/obj/structure/flora/grass/event/cactus4
	icon_state = "cactus_4"
	name = "cactus"

/obj/structure/flora/grass/event/cactus5
	icon_state = "cactus_5"
	name = "cactus"

/obj/structure/flora/grass/event/cacti1
	icon_state = "cacti_1"
	name = "cacti"

/obj/structure/flora/grass/event/cacti2
	icon_state = "cacti_2"
	name = "cacti"

// Trees

/obj/structure/flora/tree/tree1
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/tree2
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "tree_2"

/obj/structure/flora/tree/tree3
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "tree_3"

/obj/structure/flora/tree/tree4
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_flora.dmi'
	icon_state = "tree_4"


