/datum/prototype/material/alienalloy/denseforest
	id = "denseforest"
	name = "denseforest"

	// Becomes "[display_name] wall" in the UI.
	display_name = "Dense Forest"

	icon_base = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_jungle_walls.dmi'
	icon_colour = "#163313"
	wall_stripe_icon = null // leave null

/turf/simulated/wall/fey/forest_wall
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_jungle_walls.dmi'
	material_outer = /datum/prototype/material/alienalloy/denseforest
	name = "Dense Forest"
	desc = "Hundreds of thousand years of unkempt forest growth has forged this impenetrable wall of roots, leaves, bark and other materials. Good luck getting through that."
	description_info = "No way you can get past this..."
	block_tele = TRUE
	integrity_enabled = 0
