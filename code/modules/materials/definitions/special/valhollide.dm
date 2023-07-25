/datum/material/valhollide
	name = MAT_VALHOLLIDE
	id = "valhollide"
	stack_type = /obj/item/stack/material/valhollide
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	door_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "##FFF3B2"
	negation = 2
	conductive = 0
	conductivity = 5
	spatial_instability = 30
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_PHORON = 5, TECH_BLUESPACE = 5)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"

	// somewhat brittle, but well-formed crystals

	relative_integrity = 0.75
	relative_density = 0.5
	relative_conductivity = 0
	relative_permeability = 0
	relative_reactivity = 0.05
	regex_this_hardness = MATERIAL_RESISTANCE_EXTREME
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_HIGH
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_MODERATE
