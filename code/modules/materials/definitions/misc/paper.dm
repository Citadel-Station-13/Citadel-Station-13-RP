/datum/material/cardboard
	id = "cardboard"
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#AAAAAA"
	conductive = 0
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	pass_stack_colors = TRUE

	relative_integrity = 0.25
	relative_weight = 1
	relative_density = 0.2
	relative_conductivity = 0.3
	relative_permeability = 0.45
	relative_reactivity = 1.7
	regex_this_hardness = MATERIAL_RESISTANCE_NONE
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE
