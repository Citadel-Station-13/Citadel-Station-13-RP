var/list/grass_types = list(

)

/turf/simulated/floor/grass
	name = "grass patch"
	desc = "You can't tell if this is real grass or just cheap plastic imitation."
	icon_state = "grass0"
	floor_tile = /obj/item/stack/tile/grass
	flags = NONE
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	// tiled_dirt = FALSE

/turf/simulated/floor/grass/setup_broken_states()
	return list("sand")

/turf/simulated/floor/grass/Initialize(mapload)
	. = ..()
	spawniconchange()
	AddComponent(/datum/component/diggable, /obj/item/ore/glass, 2, "uproot")

/turf/simulated/floor/grass/proc/spawniconchange()
	icon_state = "grass[rand(0,3)]"
/*
/turf/simulated/floor/grass/fairy //like grass but fae-er
	name = "fairygrass patch"
	desc = "Something about this grass makes you want to frolic. Or get high."
	icon_state = "fairygrass0"
	floor_tile = /obj/item/stack/tile/fairygrass
	light_range = 2
	light_power = 0.80
	light_color = COLOR_BLUE_LIGHT

/turf/simulated/floor/grass/fairy/spawniconchange()
	icon_state = "fairygrass[rand(0,3)]"
*/
/turf/simulated/floor/grass/outdoors
	name = "grass"
	desc = "A patch of grass."
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass0"
	base_icon_state = "grass"
	baseturfs = /turf/simulated/floor/outdoors/dirt
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_GRASS)
	layer = ABOVE_TURF_LAYER

	var/smooth_icon = 'icons/turf/floors/grass.dmi'
	var/grass_chance = 20
	var/list/grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass
		)

/turf/simulated/floor/grass/outdoors/break_tile()
	. = ..()
	icon_state = "damaged"

/turf/simulated/floor/grass/outdoors/Initialize(mapload)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-9, -9)
		transform = translation
		icon = smooth_icon

/turf/simulated/floor/grass/outdoors/Initialize(mapload)
	if(prob(50))
		icon_state = "[initial(icon_state)]2"
		//edge_blending_priority++

	if(grass_chance && prob(grass_chance) && !check_density())
		var/grass_type = pickweight(grass_types)
		new grass_type(src)
	. = ..()

/datum/category_item/catalogue/flora/sif_grass
	name = "Sivian Flora - Moss"
	desc = "A natural moss that has adapted to the sheer cold climate of Sif. \
	The moss came to rely partially on bioluminescent bacteria provided by the local tree populations. \
	As such, the moss often grows in large clusters in the denser forests of Sif. \
	The moss has evolved into it's distinctive blue hue thanks to it's reliance on bacteria that has a similar color."
	value = CATALOGUER_REWARD_TRIVIAL

/turf/simulated/floor/grass/outdoors/sif
	name = "growth"
	icon_state = "grass_sif"
	edge_blending_priority = 4
	grass_chance = 5
	var/tree_chance = 2

	grass_types = list(
		/obj/structure/flora/sif/eyes = 1,
		/obj/structure/flora/sif/tendrils = 10
		)

	catalogue_data = list(/datum/category_item/catalogue/flora/sif_grass)
	catalogue_delay = 2 SECONDS

/turf/simulated/floor/grass/outdoors/sif/Initialize(mapload)
	if(tree_chance && prob(tree_chance) && !check_density())
		new /obj/structure/flora/tree/sif(src)
	. = ..()

/turf/simulated/floor/grass/outdoors/forest
	name = "thick grass"
	icon_state = "grass-dark"
	grass_chance = 80
	//tree_chance = 20
	edge_blending_priority = 5

/turf/simulated/floor/grass/outdoors/sif/forest
	name = "thick growth"
	icon_state = "grass_sif_dark"
	edge_blending_priority = 5
	tree_chance = 10
	grass_chance = 0
