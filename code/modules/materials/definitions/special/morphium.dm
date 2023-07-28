/datum/material/morphium
	name = MAT_MORPHIUM
	id = "morphium"
	stack_type = /obj/item/stack/material/morphium
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#37115A"
	conductive = 0
	conductivity = 1.5
	shard_type = SHARD_SHARD
	negation = 25
	explosion_resistance = 85
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 8, TECH_PHORON = 6, TECH_BLUESPACE = 6, TECH_ARCANE = 3)

	relative_integrity = 3
	relative_weight = 0.75
	relative_density = 2.5
	relative_conductivity = 2
	relative_permeability = 0
	relative_reactivity = 0.2
	regex_this_hardness = MATERIAL_RESISTANCE_VERY_VULNERABLE
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_MODERATE

/datum/material/morphium/hull
	name = MAT_MORPHIUMHULL
	id = "morphium_hull"
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
