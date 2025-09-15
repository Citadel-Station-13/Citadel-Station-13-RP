/datum/prototype/material/verdantium
	name = MAT_VERDANTIUM
	id = MAT_VERDANTIUM
	stack_type = /obj/item/stack/material/verdantium
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#4FE95A"
	shard_type = SHARD_SHARD
	negation = 15
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

	relative_integrity = 0.8
	density = 8 * 2.5
	weight_multiplier = 0.5
	relative_conductivity = 0.7
	relative_permeability = 0
	relative_reactivity = 2.5
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_MODERATE

	worth = 35

	material_constraints = MATERIAL_CONSTRAINT_RIGID
