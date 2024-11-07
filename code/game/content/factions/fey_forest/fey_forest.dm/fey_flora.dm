/datum/prototype/material/alienalloy/denseforest
	id = "denseforest"
	name = "denseforest"

	// Becomes "[display_name] wall" in the UI.
	display_name = "Dense Forest"

	icon_base = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_jungle_walls.dmi'
	icon_colour = "#37a52d"
	wall_stripe_icon = null // leave null

/turf/simulated/wall/fey/forest_wall
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_jungle_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/denseforest
	name = "Dense Forest"
	desc = "Hundreds of thousand years of unkempt forest growth has forged this impenetrable wall of roots, leaves, bark and other materials. Good luck getting through that."
	description_info = "No way you can get past this..."
	block_tele = TRUE
	integrity_enabled = 0


/obj/structure/flora/fey/large_trees
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_trees.dmi'
	bounds = "16,16"
	name = "Large Tree"
	desc = "A large tree that extends into the sky, joining with the gargantuan canopy. Looks too thick to reasonably cut down."
	integrity_max = 1000
	integrity = 1000

/obj/structure/flora/fey/large_trees/tree1
	icon_state = "tree_complete"

/obj/structure/flora/fey/large_trees/tree2
	icon_state = "tree1_complete"

/obj/structure/flora/fey/large_trees/tree3
	icon_state = "tree2_complete"

/obj/structure/flora/fey/large_trees/tree4
	icon_state = "tree3_complete"

/obj/structure/flora/fey/large_trees/tree5
	icon_state = "tree4_complete"

/obj/structure/flora/fey/large_trees/tree6
	icon_state = "tree5_complete"

/obj/structure/flora/fey/large_trees/tree7
	icon_state = "tree6_complete"

/obj/structure/flora/fey/small_trees
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_trees_small.dmi'
	bounds = "16,16"
	name = "Small Tree"
	desc = "A small tree, compared to the others atleast. Despite its height, its trunk is far too thick to cut down."
	integrity_max = 600
	integrity = 600

/obj/structure/flora/fey/small_trees/tree1
	icon_state = "tree1complet"

/obj/structure/flora/fey/small_trees/tree2
	icon_state = "tree2complet"

/obj/structure/flora/fey/small_trees/tree3
	icon_state = "tree3complet"

/obj/structure/flora/fey/small_trees/tree4
	icon_state = "tree4complet"

/obj/structure/flora/fey/small_trees/tree5
	icon_state = "tree5complet"

/obj/structure/flora/fey/small_trees/tree6
	icon_state = "tree6complet"

/obj/structure/flora/fey/small_trees/tree7
	icon_state = "treecomplet"

/turf/simulated/floor/fey/forest_grass
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_flora.dmi'
	icon_state = "forest_floor"
	name = "Forest Floor"
	desc = "The hardy forest floor, you can see the occasional root sticking out along with a variety of rocks and twigs."
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))
