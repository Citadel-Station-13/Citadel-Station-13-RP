/datum/material/plastic
	name = "plastic"
	id = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/datum/material/plastic/generate_recipes()
	. = ..()

/datum/material/plastic/holographic
	name = "holoplastic"
	id = "plastic_holo"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE
