/datum/prototype/material/morphium
	name = MAT_MORPHIUM
	id = MAT_MORPHIUM
	stack_type = /obj/item/stack/material/morphium
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#37115A"
	shard_type = SHARD_SHARD
	negation = 25
	explosion_resistance = 85
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 8, TECH_PHORON = 6, TECH_BLUESPACE = 6, TECH_ARCANE = 3)

	relative_integrity = 3
	weight_multiplier = 0.75
	density = 8 * 2.5
	relative_conductivity = 2
	relative_permeability = 0
	relative_reactivity = 0.2
	hardness = MATERIAL_RESISTANCE_VERY_VULNERABLE
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_MODERATE

	worth = 100

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/morphium/hull
	name = MAT_MORPHIUMHULL
	id = "morphium_hull"
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
