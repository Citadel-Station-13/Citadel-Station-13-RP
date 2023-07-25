/datum/material/carbon
	id = "carbon"
	name = MAT_CARBON
	stack_type = /obj/item/stack/material/carbon
	icon_colour = "#303030"
	shard_type = SHARD_SPLINTER
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_reinf_directionals = TRUE
	door_icon_base = "stone"
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

	// raw carbon is bad
	relative_integrity = 0.7
	relative_density = 0.8
	relative_conductivity = 0.05
	relative_reactivity = 1.5
	relative_permeability = 0.1
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE
