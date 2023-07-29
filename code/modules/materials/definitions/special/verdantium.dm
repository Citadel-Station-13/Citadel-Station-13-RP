/datum/material/verdantium
	name = MAT_VERDANTIUM
	id = "verdantium"
	stack_type = /obj/item/stack/material/verdantium
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#4FE95A"
	shard_type = SHARD_SHARD
	negation = 15
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

	relative_integrity = 0.8
	relative_density = 2.5
	relative_weight = 0.5
	relative_conductivity = 0.7
	relative_permeability = 0
	relative_reactivity = 2.5
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_MODERATE
