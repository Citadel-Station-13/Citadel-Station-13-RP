/datum/material/plastic
	name = "plastic"
	id = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#CCCCCC"
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

	relative_integrity = 0.65
	relative_weight = 0.75
	relative_density = 1
	relative_conductivity = 0.5
	relative_permeability = 0
	relative_reactivity = 0.25
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

/datum/material/plastic/holographic
	name = "holoplastic"
	id = "plastic_holo"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE
